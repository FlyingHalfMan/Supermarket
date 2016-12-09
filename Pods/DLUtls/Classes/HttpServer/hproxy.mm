#include <sys/types.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdarg.h>
#include <time.h>
#include <netdb.h>
#include <ctype.h>

//#define USEOPENSSL 1

//#define SUPPORTTHREAD  1
#if (defined SUPPORTTHREAD )||(defined DEBUG )
#include <pthread.h>
#endif

#define USEIOS  1

#ifdef USEIOS
#include <CommonCrypto/CommonCryptor.h>
#include "DLLog.h"
//#include <FileForhproxy.h>
#endif

#ifdef USEOPENSSL
#include <openssl/des.h>
#endif

#ifdef USESYSCRYPT
#include <rpc/des_crypt.h>
#endif

#include "hproxy.h"

#define MAXLINE 9000
#define MAXREADLINE 4096*2
#define MAXCONNECT 8
#define MAXTIMEOUT 100
#define ANALYSISTIMES 3



#define checkRfd(fd)	FD_ISSET(fd,&g_fdUtil.rset)
#define checkWfd(fd)	FD_ISSET(fd,&g_fdUtil.wset)

#define	logERROR 0
#define logWARM 1
#define	logINFO 2
#define logDEBUG 3
#define logDEBUG1 4
#define SECURELEN 1024
#define SECURELEN_EXT 1032

#ifndef LOGLEVEL
#define LOGLEVEL 2
#endif

static const char* arrLineEnd[2] = {"\n","\r\n"};
static const char* arrHeaderEnd[3] = {"\n\n","\r\n\r\n","\r\r\n\r\r\n"};

static const char *codes = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const unsigned char map[256] =
{
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 253, 255,255, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  62, 255, 255, 255,  63,
	52,  53,  54,  55,  56,  57,  58,  59,  60,  61, 255, 255, 255, 254, 255, 255, 255,   0,   1,   2,   3,   4,   5,   6,
	7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25, 255, 255, 255, 255, 255,
	255,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,
	49,  50,  51, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  255, 255, 255, 255
};

static int base64Encode(unsigned char *inbuf, int insize, unsigned char *outbuf, int outsize);

static int  g_local = 0;//access to backend server,1 means access to local file
static const char * g_header200="HTTP/1.1 200 Ok\n"
                                "Server:local proxy\n"
                                "Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0\n"
                                "Connection: Keep-Alive\n"
                                "Content-Length:%d\n\n";

static const char * g_header206="HTTP/1.1 206 Partial content\n"
                                "Server:local proxy\n"
                                "Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0\n"
                                "Connection: Keep-Alive\n"
                                "Content-Length:%d\n"
                                "Content-Range:%d-%d/%d\n\n";

static const char * g_header510="HTTP/1.1 510 Key error\n"
                                "Server:local proxy\n"
                                "Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0\n"
                                "Connection: Keep-Alive\n\n";



static int getRange(const char * pchBuff,long & lStart,long & lEnd,long & lTotal);

typedef struct _fdUtil
{
	int maxfd;
	fd_set rset;
	fd_set wset;
	fd_set allrset;
	fd_set allwset;
} FdUtil;

typedef struct _conndata
{
	int rfd;
	int wfd;
	char buff[MAXLINE+1];
	int start;
	int end;
	int status;
	long range_start;//this field is only useful for down to save orig request range
	long range_end;  //this field is only useful for down to save orig request range
} ConnData;

typedef struct _connItem
{
	ConnData up;
	ConnData down;
	time_t   lasttime;
} ConnItem;

typedef struct _connList
{
	ConnItem connlist[MAXCONNECT];
	int maxuse;
} ConnList;

typedef int (*Func)(ConnData &,ConnData &);
typedef int (*FuncDone)(ConnData &,ConnData &,long size);

///////////////////////////// static global //////
static char g_keylist[10][8] = {0};
static int  g_selfkey = 0;
static int  g_keynum = 0;
#ifdef SUPPORTTHREAD
static pthread_t  g_tid = -1;
#endif
static char g_host[64] = {0};
static int  g_port = 80;
static int g_listenfd = -1;
static FdUtil g_fdUtil;
static int g_stop = 1;
//ADD BY YRC isSupport hls default no support 2016 5 3
static int g_isHls = 0;
ConnList g_connlist;
//////////////////////////////////////
//FILE*fp=freopen("/mnt/sdcard/proxy.txt","wb",stdout);
static int createD(const char *host);
static void printfLog(int level,const char * fmt,...)
{
    if(level<=LOGLEVEL)
    {
#ifndef USEIOS
        va_list ap;
        va_start(ap, fmt);
        //vfprintf(fmt,ap);
        vprintf(fmt,ap);
        va_end(ap);
#endif
        
#ifdef USEIOS
        char sbuff[1024];
        va_list ap;
        va_start(ap, fmt);
        vsnprintf(sbuff,sizeof(sbuff),fmt,ap);
        va_end(ap);
        
        NSString *cString = [[NSString alloc] initWithCString:sbuff encoding:NSUTF8StringEncoding];
#ifdef DEBUG
        NSLog(@"加密----%@",cString);
#endif
        [DLLog info:@"加密----%@",cString];
#endif
    }
}

void iosDecrypt(char * buff,int size,const char * g_key,char * iv,int encode)
{
#ifdef USEIOS
	char keyPtr[kCCKeySizeDES + 1];
	bzero(keyPtr, sizeof(keyPtr));

NSString *keyStr = [NSString stringWithCString:g_key encoding:NSUTF8StringEncoding];
[keyStr getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

	NSString *ivStr = @"fYfhHeDm";
	size_t numBytesDecrypted = 0;
	const void *initVec;
	initVec = (const void *) [ivStr UTF8String];

	CCCryptorStatus cryptStatus = CCCrypt(encode?kCCEncrypt:kCCDecrypt, kCCAlgorithmDES,
	                                      0x0000,
	                                      keyPtr, kCCKeySizeDES,
	                                      initVec,
	                                      buff, size,
	                                      buff, size,
	                                      &numBytesDecrypted);
    if (cryptStatus == kCCSuccess )
    {
#ifdef DEBUG
        NSLog(@"debug test ---");
#endif
    }
#endif
}

void initFd()
{
	g_fdUtil.maxfd = -1;
	FD_ZERO(&g_fdUtil.rset);
	FD_ZERO(&g_fdUtil.allrset);
	FD_ZERO(&g_fdUtil.wset);
	FD_ZERO(&g_fdUtil.allwset);
}

void addRfd(int fd)
{
	FD_SET(fd,&g_fdUtil.allrset);
	g_fdUtil.maxfd = g_fdUtil.maxfd>fd ? g_fdUtil.maxfd : fd;
}

void addWfd(int fd)
{
	FD_SET(fd,&g_fdUtil.allwset);
	g_fdUtil.maxfd = g_fdUtil.maxfd>fd ? g_fdUtil.maxfd : fd;
}

void clearRfd(int fd)
{
	if(fd != -1)
	{
		FD_CLR(fd,&g_fdUtil.allrset);
		FD_CLR(fd,&g_fdUtil.rset);
	}
}

void clearWfd(int fd)
{
	if(fd != -1)
	{
		FD_CLR(fd,&g_fdUtil.allwset);
		FD_CLR(fd,&g_fdUtil.wset);
	}
}

static void resetConnData(ConnData & cd,bool closeprev)
{
	if(closeprev && cd.rfd != -1)
	{
		shutdown(cd.rfd,SHUT_RDWR);
		close(cd.rfd);
	}
	if(closeprev && cd.wfd != -1)
	{
		shutdown(cd.wfd,SHUT_RDWR);
		close(cd.wfd);
	}

	cd.rfd = cd.wfd = -1;
	cd.status = 0;
	cd.start = cd.end =  0;
	cd.range_start = cd.range_end = 0;
}

static void initConnList(ConnList & connlist,bool closeprev)
{
	for(int i=0; i<MAXCONNECT; i++)
	{
		ConnData & up = connlist.connlist[i].up;
		resetConnData(up,closeprev);

		ConnData & down = connlist.connlist[i].down;
		resetConnData(down,closeprev);

	}
	connlist.maxuse = 0;
}

static int addConnList(ConnList & connlist,int fd)
{
	int i = 0;
	for(; i<MAXCONNECT; i++)
	{
		if(connlist.connlist[i].up.rfd==fd)
			printfLog(logERROR,"#### error #### %d \n",fd);

		if(connlist.connlist[i].up.rfd==-1 && connlist.connlist[i].down.wfd==-1
		        && connlist.connlist[i].up.wfd==-1 && connlist.connlist[i].down.rfd==-1 )
		{
			connlist.connlist[i].up.rfd = fd;
			connlist.connlist[i].down.wfd = fd;
			connlist.connlist[i].lasttime = time(NULL);
			if(i>=connlist.maxuse)
				connlist.maxuse++;
			return 0;
		}
	}
	printfLog(logERROR,"#### connection list is full,can not add into list\n");
	return -1;
}

static int connBkend(const char * host,int port,int timeout)
{
	int clntfd = socket(AF_INET,SOCK_STREAM,0);
	if(clntfd==-1)
	{
		printfLog(logERROR,"#### create socket to backend(%s:%d) error\n",host,port);
		return clntfd;
	}

	if(timeout==0)
	{
		int stat = fcntl(clntfd,F_GETFL,0);
		fcntl(clntfd,F_SETFL,stat | O_NONBLOCK);
	}

	struct sockaddr_in servaddr;
	bzero(&servaddr,sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	//servaddr.sin_addr.s_addr = inet_addr(host);
	inet_pton(AF_INET, host, &servaddr.sin_addr.s_addr);
	servaddr.sin_port = htons(port);

	if(timeout>0) alarm(timeout);
	while(connect(clntfd,(const struct sockaddr *)&servaddr,sizeof(servaddr)) ==-1 && errno != EINPROGRESS)
	{
		if(timeout>0)  alarm(0);
		printfLog(logERROR,"#### connect backend(%s:%d) error\n",host,port);
		close(clntfd);
		return -1;
	}
	printfLog(logINFO,"connect backend(%s:%d fd:%d) success\n",host,port,clntfd);
	if(timeout)  alarm(0);
	return clntfd;
}

static void upRClose(ConnData & cd1,ConnData & cd2)
{
	clearRfd(cd1.rfd);
	clearWfd(cd1.wfd);
	clearRfd(cd2.rfd);
	clearWfd(cd2.wfd);

	resetConnData(cd1,true);
	resetConnData(cd2,false);
}

static int checkLineEnd(const char * pchBuff)
{
	const char * pchEnd = strchr(pchBuff,'\n');
	if(!pchEnd) return -1;
	if(*(pchEnd-2)=='\r' && *(pchEnd-1)=='\r')
		return 2;
	else if(*(pchEnd-1)=='\r')
		return 1;
	else
		return 0;
}

static long getHeaderContentLength(const char * sLine)
{
	if(sLine == NULL) return -1;

	while(*sLine==' ') sLine++;
	long iRet = 0;

	while(*sLine>='0' && *sLine<='9')
	{
		iRet = iRet*10 + *sLine-'0';
		sLine++;
	}
	return iRet;
}

static int getHeader(ConnData & conn,const char * key,char * sValue,int size)
{
	int i = checkLineEnd(conn.buff+conn.start);
	if(i==-1)
		return -1;

	char * terminate = strstr(conn.buff+conn.start,arrHeaderEnd[i]);
	if(!terminate)
		return -1;

	char * line = strchr(conn.buff+conn.start,'\n');
	while(line && line<terminate && strncasecmp(line,key,strlen(key))!=0)
	{
		line = strchr(line+1,'\n');
	}

	const char * lineend = line;
	if(line && line<terminate)   //find it
	{
		lineend = strstr(line+1,arrLineEnd[i]);
		int len = lineend-line-strlen(key) >= size ? size-1 : lineend-line-strlen(key);
		memcpy(sValue,line+strlen(key),len);
		*(sValue+len) = 0;
		return 0;
	}
	return -1;

}

static int replaceHeader(ConnData & conn,const char * key,const char * val)
{
	int i = checkLineEnd(conn.buff+conn.start);
	if(i==-1)
		return 0;

	char * terminate = strstr(conn.buff+conn.start,arrHeaderEnd[i]);
	if(!terminate)
		return -1;

	char * line = strchr(conn.buff+conn.start,'\n');
	while(line && line<terminate && strncasecmp(line,key,strlen(key))!=0)
	{
		line = strchr(line+1,'\n');
	}

	const char * lineend = line;
	if(line && line<terminate)   //find it
	{
		lineend = strstr(line+1,arrLineEnd[i]);
	}
	else
	{
		line = terminate;
		lineend = terminate;
	}

	int  len = conn.end-(lineend-conn.buff);
	char * memTmp = (char *)malloc(len);
	memcpy(memTmp,lineend,len);
	int vallen = 0;
	if(val)
	{
		vallen = strlen(val);
		memcpy(line,val,vallen);
	}
	else
	{
	    const char* end = arrLineEnd[i];
	    int lineendLen = strlen(end);
	    vallen = 1 - lineendLen;
	}
	memcpy(line+vallen,memTmp,len);
	free(memTmp);
	conn.end = conn.end + vallen - (lineend-line);
	conn.buff[conn.end] = 0;
	return 0;

}


static int getRange(const char * pchBuff,long & lStart,long & lEnd,long & lTotal)
{
	char sStart[32],sEnd[32],sTotal[32];
	const char * pchTerminat = strchr(pchBuff,'\n');
	const char * pchStart = strchr(pchBuff,'-');

	lStart = -1;
	lEnd = -1;
	lTotal = -1;
	if(pchStart && (!pchTerminat || pchStart<pchTerminat))
	{
		const char * pchTmp = pchStart-1;
		while(*pchTmp>='0' && *pchTmp<='9')
			pchTmp = pchTmp - 1;
		memcpy(sStart,pchTmp+1,pchStart-pchTmp-1);
		sStart[pchStart-pchTmp-1]=0;
		if(pchStart-pchTmp-1>0)
			lStart = strtol(sStart,NULL,10);
	}

	if(pchStart && (!pchTerminat || pchStart<pchTerminat))
	{
		const char * pchTmp = pchStart+1;
		while(*pchTmp>='0' && *pchTmp<='9')
			pchTmp = pchTmp + 1;
		memcpy(sEnd,pchStart+1,pchTmp-pchStart-1);
		sEnd[pchTmp-pchStart-1]=0;
		if(pchTmp-pchStart-1>0)
			lEnd = strtol(sEnd,NULL,10);

		if(*pchTmp=='/')
		{
			pchTmp=pchTmp+1;
			pchStart = pchTmp;
			while(*pchTmp>='0' && *pchTmp<='9') pchTmp = pchTmp + 1;
			memcpy(sTotal,pchStart,pchTmp-pchStart);
			sTotal[pchTmp-pchStart]=0;
			if(pchTmp-pchStart>0)
				lTotal = strtol(sTotal,NULL,10);
		}
	}
	return 0;
}

static int cryptUtil(char * buff,int size,const char *pkey,int encode)
{
#ifdef USEIOS
	char iv[8] = {'f','Y','f','h','H','e','D','m'};
	char key[9]= {0};
	memcpy(key,pkey,8);
	iosDecrypt(buff, size, key, iv,encode);


	//    [HttpServer testFunction:buff Size:size G_KEY:pkey IV:iv];
#endif

#ifdef USESYSCRYPT
	char key[8];
	memcpy(key,pkey,8);
	des_setparity(key);
	char iv[8] = {'f','Y','f','h','H','e','D','m'};
	if(encode)
		cbc_crypt(key,buff,size,DES_ENCRYPT,iv);
	else
		cbc_crypt(key,buff,size,DES_DECRYPT,iv);

#endif
#ifdef USEOPENSSL
	DES_cblock key,iv;
	DES_key_schedule schedule;
	memcpy(&iv,"fYfhHeDm",8);
	memcpy(&key,pkey,8);
	DES_key_sched(&key,&schedule);
	if(encode)
		DES_cbc_encrypt((const unsigned char *)buff,(unsigned char *)buff,size,&schedule,&iv,1);
	else
		DES_cbc_encrypt((const unsigned char *)buff,(unsigned char *)buff,size,&schedule,&iv,0);
#endif
	return 0;
}

static int DecodeHeader(char * buff,int size)
{
	char * detbuff = (char *)malloc(size);
	memcpy(detbuff,buff,size);

	if(g_selfkey)
	{
		char key[8] = {0};
		char basekey[32] = {0};
		memcpy(key,buff+size,8);
		base64Encode((unsigned char *)key,8,(unsigned char *)basekey,sizeof(basekey));
		memcpy(g_keylist[0],basekey,8);
		g_keynum=1;
	}

	for(int i=0; i<g_keynum; i++)
	{
		cryptUtil(buff,size,g_keylist[i],0);
		if(strncmp(buff+4,"ftyp",4)==0)
			break;
		else if(i<g_keynum-1)
			memcpy(buff,detbuff,size);
	}
	free(detbuff);
	//if support mp4 2016 5 3 MODIFY BY YRC
	if(strncmp(buff+4,"ftyp",4)!=0 && g_isHls == 0 )
		printfLog(logINFO,"#### decrypt error ####\n");
	return 0;
}

//return:save ignore length from buff into oldStart and oldEnd
//       save real start and end into newStart and newEnd
static long getContentLength(long & oldStart,long & oldEnd,long & newStart,long & newEnd)
{
	long lRet = 0;
	if(oldStart == -1 && oldEnd != -1)   // Range: bytes=-x
	{
		lRet = newEnd-newStart+1>oldEnd ? oldEnd : newEnd-newStart + 1;
		oldEnd = 0;
		oldStart = newEnd-newStart+1-lRet;
	}
	else if(oldStart !=-1 && oldEnd != -1)     // Range:bytes=x-y
	{
		lRet = (newEnd>oldEnd?oldEnd:newEnd) - (newStart>oldStart?newStart:oldStart) +1;
		oldStart = oldStart-newStart > 0 ? (oldStart-newStart) : 0;
		oldEnd = oldEnd<newEnd ? newEnd-oldEnd : 0;
	}
	else if(oldStart !=-1 && oldEnd == -1)     //Range: bytes=x-
	{
		lRet = newEnd - (newStart>oldStart?newStart:oldStart) + 1;
		oldStart = oldStart - newStart;
		oldEnd = 0;
	}

	newStart = newStart+oldStart;
	newEnd = newEnd-oldEnd;
	return lRet;
}

static int ignoreExtData(ConnData & cd,int headerEndpos)
{
	if(cd.range_start>0 && cd.end-headerEndpos>cd.range_start)   // only need ignore once
	{
		char * pchTmp = (char *)malloc(headerEndpos-cd.start);
		memcpy(pchTmp,cd.buff+cd.start,headerEndpos-cd.start);
		memcpy(cd.buff+cd.start+cd.range_start,pchTmp,headerEndpos-cd.start);
		free(pchTmp);
		cd.start = cd.start+cd.range_start;
		cd.range_start = 0;
	}

	if(cd.range_start>0 && cd.end-headerEndpos <= cd.range_start)
	{
		cd.range_start = cd.range_start - (cd.end-headerEndpos);
		cd.end = headerEndpos;
	}

	if(cd.range_end>0)
	{
		//	cd.end = cd.end-cd.range_end; // ReadDown will do with this if need,so there not need
		cd.range_end = 0;
	}


	return 0;
}

static int setResponseCode(ConnData & cd,int code)
{
	if(code>999 || code<100) return -1;

	char * pchPos = cd.buff+cd.start;
	if(strncmp(pchPos,"HTTP/",5)==0)
	{
		char sCode[4] = {0};
		snprintf(sCode,sizeof(sCode),"%d",code);

		pchPos = pchPos + 5;
		while(*pchPos && *pchPos!=' ') pchPos++;
		while(*pchPos==' ') pchPos++;
		int i = 0;
		while(*pchPos >='0' && *pchPos<='9' && i<3)
		{
			*pchPos = sCode[i];
			pchPos++;
			i++;
		}
	}
	return -1;
}

static int getResponseCode(const char * pchLine)
{
	int code = 0;
	if(strncmp(pchLine,"HTTP/",5)==0)
	{
		const char * pchPos = pchLine+5;
		while(*pchPos && *pchPos!=' ') pchPos++;
		while(*pchPos==' ') pchPos++;
		while(*pchPos >='0' && *pchPos<='9')
		{
			code = code*10+ (*pchPos - '0');
			pchPos++;
		}
		return code;
	}
	return -1;
}
static int setHost1(const char *host,int len);
static int  getLocation(char* sLine ,char * sUrl)
{
	char * pchStart = sLine;
	const char * pchHost = NULL;
	const char* http_str = "http://";
	while(*pchStart==' ') pchStart++;
	
	if(strncmp(pchStart,http_str,7)==0)
	{
		pchHost =pchStart = pchStart+7;
		
		while(*pchStart && *pchStart!=':' && *pchStart !='/') pchStart++;
		setHost1(pchHost,pchStart-pchHost);		
		if(*pchStart==':') 
		{
			++pchStart;	
			g_port = 0;
			while(*pchStart && *pchStart!='/')
			{
				g_port = g_port*10+(*pchStart-'0');
				pchStart++;
			}			
		}
		if(*pchStart=='/')
			strcpy(sUrl,pchStart);			
		else
			*sUrl = '/';
	}
	else
		strcpy(sUrl,pchStart);
}
static int checkHeader(ConnData & cd)
{
	int i = checkLineEnd(cd.buff+cd.start);
	if(i==-1)
		return 0;

	int iCode = getResponseCode(cd.buff+cd.start);
	//ADD BY YRC SUPPORT 301 302 2016 5 26
	if(iCode == 302 || iCode == 301)
	{
		char sLine[1024]= {0};
		char *pchHeaderEnd = strstr(cd.buff+cd.start,arrHeaderEnd[i]);

		if(pchHeaderEnd)
		{
			if(getHeader(cd,"\nLocation:",sLine,sizeof(sLine))==0 )
			{
                //char sUrl[1024]={0};
                char* sUrl =(char*)malloc(1024);
                memset(sUrl,0,1024);
                getLocation(sLine,sUrl);
                snprintf(sLine,sizeof(sLine),"\nLocation:%s",sUrl);
                replaceHeader(cd,"\nLocation:",sLine);
                printfLog(logINFO,"need %d redirect\n",iCode);
                if(NULL != sUrl )
                {
                    free(sUrl);
                    sUrl=NULL;
                }
			}
			return -2;//not need decrypt,write all that be read
		}
		return 0;//header not be read complete,read continue
	}
	
	if(iCode > 299|| iCode<200)
		return -2;//not need decrypt,write all that be read

	char *pchHeaderEnd = strstr(cd.buff+cd.start,arrHeaderEnd[i]);
	if(pchHeaderEnd)
	{
		char sLine[128]= {0};
		int headerlen = pchHeaderEnd-cd.buff-cd.start+strlen(arrHeaderEnd[i]);

		if(LOGLEVEL>=logDEBUG)
		{
			unsigned char cEnd = *pchHeaderEnd;
			*pchHeaderEnd = '\0';
			printfLog(logDEBUG,"[---- response header cfd:%d bfd:%d\n%s\n]\n",cd.wfd,cd.rfd,cd.buff+cd.start);
			*pchHeaderEnd = cEnd;
		}

		long lStart,lEnd,lTotal,lContent;
		if(getHeader(cd,"\nContent-Length:",sLine,sizeof(sLine))==0 &&iCode==200)
		{
			lStart = 0;
			lTotal = lContent = getHeaderContentLength(sLine);
			lEnd = lTotal - 1;
		}

		if(getHeader(cd,"\nContent-Range:",sLine,sizeof(sLine))==0)   // if range out of file,200 return and content_range not exist
		{
			getRange(sLine,lStart,lEnd,lTotal);
			lContent = lEnd - lStart + 1;
		}


		if(cd.status !=-3 && (cd.range_start != 0 || cd.range_end != 0))
		{
			lContent = getContentLength(cd.range_start,cd.range_end,lStart,lEnd);

			char sLine[128] = {0};
			snprintf(sLine,sizeof(sLine),"\nContent-Length:%u",lContent);
			replaceHeader(cd,"\nContent-Length:",sLine);
			if(lContent<lTotal)
			{
				snprintf(sLine,sizeof(sLine),"\nContent-Range:bytes %u-%u/%u",lStart,lEnd,lTotal);
				replaceHeader(cd,"\nContent-Range:",sLine);
				setResponseCode(cd,206);
			}
			pchHeaderEnd = strstr(cd.buff+cd.start,arrHeaderEnd[i]);
			headerlen = pchHeaderEnd-cd.buff-cd.start+strlen(arrHeaderEnd[i]);
		}

		if(lStart<SECURELEN)   // need decrypt
		{
			if(cd.end-cd.start-headerlen>=SECURELEN_EXT)//can decrypt
				DecodeHeader(cd.buff+headerlen+cd.start,SECURELEN);
			else
				return  -3;// need more body
		}

		ignoreExtData(cd,headerlen+cd.start);

		printfLog(logDEBUG,"[--- last content cfd:%d bfd:%d headerlen=%d bodylen=%d end=%d start=%d %d]\n",
		          cd.wfd,cd.rfd,headerlen,lContent,cd.end,cd.start,headerlen+lContent-cd.end+cd.start);

		if(lContent+headerlen+cd.range_start-(cd.end-cd.start)>0)
			return lContent+headerlen+cd.range_start-(cd.end-cd.start);//need read bytes(include ignore data)
		else
		{
			cd.end = cd.start + lContent+headerlen;
			return -1; //not need read now ,end
		}
	}
	else
	{
		return 0;
		//header not be read complete,read continue
	}
}
static int domainOrIp( const char*);
static int analysisDomain( const char* domain,char* host,int );
static int openBkend(ConnData & conn,ConnData & down,const char * firstline)
{

	if(g_local)
	{
		char sfile[1024] = {0};
		const char * pchStart = NULL;
		const char * pchEnd = NULL;

		pchStart = strchr(firstline,' ');
		while(pchStart && *pchStart==' ') pchStart++;
		if(pchStart)	pchEnd = strchr(pchStart,' ');
		if(!pchStart || !pchEnd)
		{
			return -1;
		}

		memcpy(sfile,pchStart,pchEnd-pchStart);
		sfile[pchEnd-pchStart]=0;

		int fd = open(sfile,O_RDONLY);
		conn.wfd = fd;
		down.rfd = fd;
		return fd;
	}
	else
	{
		int backfd = -1;
		// connect to backend
		if( domainOrIp(g_host ) == 0 )
		{
			backfd = connBkend(g_host,g_port,30);
		}
		else
		{
			char host[64] = {0};

			for( int nTimes = 0; nTimes< ANALYSISTIMES; ++nTimes )
			{
				memset(host,0,sizeof( host ) );
				char* phost = host;
				if( 1 != analysisDomain( g_host,phost,64))
				{
					continue;
				}
				backfd = connBkend(host,g_port,30);
				if( -1 != backfd )
					break;
			}
		}

		conn.wfd = backfd;
		down.rfd = backfd;
		return backfd;
	}
}

static int addResponseHeader(ConnData & down,long start,long end)
{
	long filesize = lseek(down.rfd,0,SEEK_END);
	down.start = 0;

	if(start==-1 && end == -1)
	{
		//total
		down.end = snprintf(down.buff,MAXLINE,g_header200,filesize);
		lseek(down.rfd,0,SEEK_SET);
	}
	else
	{
		//range
		if(end==-1 && start>=0)
			end = filesize-1;
		if(start==-1 && end>=0)
			start = filesize - end;
		down.end = snprintf(down.buff,MAXLINE,g_header206,end-start+1,start,end,filesize);
		lseek(down.rfd,start,SEEK_SET);
	}
	return 0;
}

//#################################################

static int CbUpRBegin(ConnData & cd1,ConnData & cd2)
{
	return 0;
}

static int CbUpRDone(ConnData & conn,ConnData & down,long size)
{
	if(conn.status == 0)
		conn.status = -1;//reading

	if(conn.wfd != -1)
	{
		//clear prev connection //clearDown
		printfLog(logINFO,"a new connection --> close up.wfd(%d) down.rfd(%d) \n",conn.wfd,down.rfd);
		clearRfd(down.rfd);
		clearWfd(down.wfd);
		clearWfd(conn.wfd);
		down.status = 0;
		down.start = down.end = down.range_start = down.range_end = 0;

		shutdown(conn.wfd,SHUT_RDWR);
		close(conn.wfd);
		down.rfd = conn.wfd = -1;
	}

	//change host
	if(strstr(conn.buff+conn.start,"\r\n\r\n") || strstr(conn.buff+conn.start,"\n\n"))
	{
		char sHost[128] = {0};
		snprintf(sHost,sizeof(sHost),"\nhost:%s",g_host);
		printfLog(logDEBUG,"host is:%s :%s",sHost,g_host);
		replaceHeader(conn,"\nhost:",sHost);
		replaceHeader(conn,"\nAccept-Encoding:",NULL);//remove this for not receive zip and deflate
		char sLine[1024] = {0};
		long lStart = -1;
		long lEnd = -1;

		printfLog(logDEBUG,"[--orig header cfd:%d bfd:%d \n%s]\n",conn.rfd,conn.wfd,conn.buff+conn.start);
		if(getHeader(conn,"\nRange:",sLine,sizeof(sLine))==0)
		{
			long lTotal;
			getRange(sLine,down.range_start,down.range_end,lTotal);
			lStart = down.range_start;
			lEnd = down.range_end;

			if(down.range_end>0 && down.range_end<SECURELEN && down.range_start !=-1)
				lEnd = SECURELEN_EXT;
			if(down.range_start>0 && down.range_start<SECURELEN)
			{
				lStart = 0;
			}
			else if(down.range_start==-1 && down.range_end != -1)
			{
				lEnd += SECURELEN_EXT;
			}

			snprintf(sHost,sizeof(sHost),"\nRange:bytes=");
			if(lStart==-1)
				snprintf(sHost+strlen(sHost),sizeof(sHost),"-");
			else
				snprintf(sHost+strlen(sHost),sizeof(sHost),"%u-",lStart);
			if(lEnd!=-1)
				snprintf(sHost+strlen(sHost),sizeof(sHost),"%u",lEnd);
			replaceHeader(conn,"\nRange:",sHost);
			printfLog(logINFO,"up.rfd(%d)to back Range:%s\n",conn.rfd,sHost);
		}

		const char * pchEnd = strchr(conn.buff+conn.start,'\n');
		memcpy(sLine,conn.buff+conn.start,pchEnd - conn.buff - conn.start);
		sLine[pchEnd - conn.buff - conn.start] = 0;

		conn.status = 0;//a complete request, can process next request
		int iRet = openBkend(conn,down,sLine);
		if(iRet == -1)
		{
			clearRfd(conn.rfd);
			resetConnData(conn,true);
			resetConnData(down,false);
		}
		else if(g_local)
		{
			addResponseHeader(down,lStart,lEnd);
			addRfd(down.rfd);
		}
		else
		{
			printfLog(logDEBUG,"[--- to back cfd:%d bfd:%d \n%s]\n",conn.rfd,conn.wfd,conn.buff+conn.start);
			addWfd(conn.wfd);
		}
	}
	return 0;
}

static int CbUpRFinish(ConnData & cd1,ConnData & cd2)
{
	printfLog(logINFO,"up.rfd(%d) read end --> up.wfd(%d) close ,down.rfd(%d) and down.wfd(%d) close\n",
	          cd1.rfd,cd1.wfd,cd2.rfd,cd2.wfd);
	upRClose(cd1,cd2);
	return 0;
}

static int CbUpRExceptin(ConnData & cd1,ConnData & cd2)
{
	printfLog(logINFO,"up.rfd(%d) read error(errno:%d) --> up.wfd(%d) close ,down.rfd(%d) and down.wfd(%d) close\n",
	          cd1.rfd,errno,cd1.wfd,cd2.rfd,cd2.wfd);
	upRClose(cd1,cd2);
	return -1;
}

//#######################################
static int CbUpWBegin(ConnData & cd1,ConnData & cd2)
{
	return 0;
}

static int CbUpWDone(ConnData & cd1,ConnData & cd2,long size)
{
	if(cd1.start==cd1.end)
	{
		clearWfd(cd1.wfd);
		addRfd(cd2.rfd);
	}
	return 0;
}

static int CbUpWFinish(ConnData & cd1,ConnData & cd2)
{
	printfLog(logINFO,"up.wfd(%d) close --> shutdown up.rfd(%d)\n",cd1.wfd,cd1.rfd);

	clearWfd(cd1.wfd);
	clearRfd(cd1.rfd);
	shutdown(cd1.rfd,SHUT_RD);
	resetConnData(cd1,false);
	return 0;
}


//#############################################

static int CbDownRBegin(ConnData & cd1,ConnData & cd2)
{
	return 0;
}

static int CbDownRFinish(ConnData & cd1,ConnData & cd2);
static int CbDownRDone(ConnData & cd1,ConnData & cd2,long readsize)
{
	if(cd1.start<cd1.end)
	{
		if(cd1.status == 0 || cd1.status ==-3)   //need read more to decrypt
		{
			cd1.status = checkHeader(cd1);
			printfLog(logINFO,"status=%d end=%d,start=%d\n",cd1.status,cd1.end,cd1.start);
		}
		else if(cd1.status>0)     //need read cd1.status bytes data
		{
			if(readsize>=cd1.status)
			{
				int extlen = readsize - cd1.status;
				cd1.end  -= extlen;
				readsize -= extlen;
				cd1.status = -1;
			}
			else
				cd1.status = cd1.status - readsize;

			if(cd1.range_start>0)
			{
				int newDatapos = cd1.end - readsize;
				int usefulLen = readsize - cd1.range_start;
				if(usefulLen > 0)   // last ignore
				{
					char * usefulData = (char *)malloc(usefulLen);
					memcpy(usefulData,cd1.buff+newDatapos+cd1.range_start,usefulLen);
					memcpy(cd1.buff+newDatapos,usefulData,usefulLen);
					cd1.end -= cd1.range_start;
					free(usefulData);
					cd1.range_start = 0;
				}
				else
				{
					cd1.range_start = cd1.range_start - readsize;
					cd1.end = newDatapos;
				}
			}
		}
		else if(cd1.status ==-1)     //no need read more data
		{
			cd1.end = cd1.end - readsize;
			if(g_local)
				CbDownRFinish(cd1,cd2);
		}
		else if(cd1.status ==-2)     //write all that be read
		{
		}
		if((cd1.status > 0 || cd1.status==-1||cd1.status==-2) && cd1.end>cd1.start)   //some data need be write
		{
			clearRfd(cd1.rfd);
			addWfd(cd1.wfd);
		}
	}
	return 0;
}

static int CbDownRExceptin(ConnData & cd1,ConnData & cd2)
{
	printfLog(logINFO,"down.rfd(%d) exception --> down.rfd(%d) close,down.wfd(%d) close,up.rfd(%d) and up.wfd(%d) close\n",
	          cd1.rfd,cd1.rfd,cd1.wfd,cd2.rfd,cd2.wfd);

	clearRfd(cd1.rfd);
	clearWfd(cd1.wfd);
	clearRfd(cd2.rfd);
	clearWfd(cd2.wfd);
	resetConnData(cd1,true);
	resetConnData(cd2,false);
	return -1;
}

static int CbDownRFinish(ConnData & cd1,ConnData & cd2)
{
	if(cd1.start==cd1.end)
		printfLog(logINFO,"down.rfd(%d) finish --> down.status(%d) down.wfd(%d) close ,up.rfd(%d) and up.wfd(%d) close\n",
		          cd1.rfd,cd1.status,cd1.wfd,cd2.rfd,cd2.wfd);
	else
		printfLog(logINFO,"down.rfd(%d) finish --> down.status(%d) clear read from up.rfd,all will be closed while write all buffer\n",
		          cd1.rfd,cd1.status);

	if(cd1.start==cd1.end)
	{
		clearRfd(cd1.rfd);
		clearWfd(cd1.wfd);
		clearRfd(cd2.rfd);
		clearWfd(cd2.wfd);
		resetConnData(cd1,true);
		resetConnData(cd2,false);
	}
	else
	{
		clearRfd(cd1.rfd);
		cd1.rfd = -1;
	}
	return 0;
}

//############################################

static int CbDownWBegin(ConnData & cd1,ConnData & cd2)
{
	if((cd1.status > 0 || cd1.status==-1||cd1.status==-2) && cd1.end>cd1.start)
		return 0;

	printfLog(logINFO,"down write begin check failure(%d)\n",cd1.status);
	return  -1;
}

static int CbDownWFinish(ConnData & cd1,ConnData & cd2)
{
	printfLog(logINFO,"down.wfd(%d) close --> down.rfd(%d) ,up.rfd(%d) and up.wfd(%d) close\n",
	          cd1.wfd,cd1.rfd,cd2.rfd,cd2.wfd);
	clearWfd(cd1.wfd);
	clearRfd(cd1.rfd);
	clearWfd(cd2.wfd);
	clearRfd(cd2.rfd);
	close(cd1.rfd);
	close(cd1.wfd);
	cd1.rfd = cd1.wfd = cd2.rfd = cd2.wfd = -1;
	cd1.start = cd1.end = cd1.start = cd2.end = 0;
	cd1.status = cd2.status = 0;
	return 0;
}

static int CbDownWDone(ConnData & cd1,ConnData & cd2,long size)
{
	if(cd1.start==cd1.end)
	{
		clearWfd(cd1.wfd);
		if(cd1.rfd == -1 && cd1.wfd !=-1)   //read from backend finish
		{
			printfLog(logINFO,"down.wfd(%d) write all -> close up.rfd(%d) up.wfd(%d) down.rfd(%d)\n",cd1.wfd,cd2.rfd,cd2.wfd,cd1.rfd);
			clearRfd(cd2.rfd);
			clearWfd(cd2.wfd);
			resetConnData(cd2,true);
			resetConnData(cd1,false);
		}
	}
	if(cd1.rfd!=-1)
		addRfd(cd1.rfd);
	return 0;
}

//#######################

static int procRead(ConnData & cd1,ConnData & cd2,Func cbBegin,Func cbFinish,Func cbException,FuncDone cbDone)
{
	if(cd1.end>=MAXLINE)
	{
		clearRfd(cd1.rfd);
		printfLog(logDEBUG,"fd=%d up read buffer full\n",cd1.rfd);
	}
	else
	{
		int iRet =cbBegin(cd1,cd2);
		if(iRet)  return iRet;

		int len = read(cd1.rfd,cd1.buff+cd1.end,MAXREADLINE-cd1.end);
		if(len==0)
		{
			return cbFinish(cd1,cd2);
		}
		else if(len==-1 && errno==EINTR)
		{
		}
		else if(len==-1 && errno!=EAGAIN)
		{
			return cbException(cd1,cd2);
		}
		else if(len>0)
		{
			printfLog(logDEBUG1,"read from clnt(%d) len=%d\n",cd1.rfd,len);
			cd1.end += len;
			cd1.buff[cd1.end] = 0;
			return cbDone(cd1,cd2,len);
		}
		else
		{
			printfLog(logDEBUG,"read error,please again\n");
		}
	}
	return 0;
}
static int procWrite(ConnData & cd1,ConnData & cd2,Func cbBegin,Func cbFinish,FuncDone cbDone)
{
	if(cd1.end<=cd1.start)
	{
		clearWfd(cd1.wfd);// no need write,clear it,when read some data then it will be added again
	}
	else
	{
		int iRet = cbBegin(cd1,cd2);
		if(iRet)  return iRet;

		int len = write(cd1.wfd,cd1.buff+cd1.start,cd1.end-cd1.start);
		if(len>0)
		{
			printfLog(logDEBUG1,"write to clnt(%d) len=%d\n",cd1.wfd,len);
			cd1.start = cd1.start+len;
			if(cd1.start==cd1.end) cd1.start = cd1.end = 0;
			return cbDone(cd1,cd2,len);
		}
		else if(len==-1 && errno!=EAGAIN)
		{
			printfLog(logDEBUG,"write to clnt(%d) error(errno=%d)\n",cd1.wfd,errno);
			return cbFinish(cd1,cd2);
		}
	}
	return 0;
}

static int run(ConnList & connlist)
{
	time_t tNow = time(NULL);
	for(int i=0; i<connlist.maxuse; i++)
	{
		ConnItem & conn = connlist.connlist[i];

		if(conn.up.rfd!=-1 && checkRfd(conn.up.rfd))
		{
			conn.lasttime = tNow;
			procRead(conn.up,conn.down,CbUpRBegin,CbUpRFinish,CbUpRExceptin,CbUpRDone);
		}
		if(conn.up.wfd!=-1 && checkWfd(conn.up.wfd))
		{
			conn.lasttime = tNow;
			procWrite(conn.up,conn.down,CbUpWBegin,CbUpWFinish,CbUpWDone);
		}

		if(conn.down.rfd!=-1 && checkRfd(conn.down.rfd))
		{
			conn.lasttime = tNow;
			procRead(conn.down,conn.up,CbDownRBegin,CbDownRFinish,CbDownRExceptin,CbDownRDone);
		}
		if(conn.down.wfd!=-1 && checkWfd(conn.down.wfd))
		{
			conn.lasttime = tNow;
			procWrite(conn.down,conn.up,CbDownWBegin,CbDownWFinish,CbDownWDone);
		}
		if(tNow - conn.lasttime > MAXTIMEOUT && (conn.up.rfd!=-1||conn.up.wfd!=-1||conn.down.rfd!=-1||conn.down.wfd!=-1))
		{
			printfLog(logINFO,"timeout --> close up.rfd(%d) up.wfd(%d) down.rfd(%d) down.wfd(%d)\n",
			          conn.up.rfd,conn.up.wfd,conn.down.rfd,conn.down.wfd);
			clearRfd(conn.up.rfd);
			clearWfd(conn.up.wfd);
			clearRfd(conn.down.rfd);
			clearWfd(conn.down.wfd);

			resetConnData(conn.up,true);
			resetConnData(conn.down,false);
		}
	}
	return 0;
}
static void closeAll()
{
	if(g_listenfd > 0)
		close(g_listenfd);
	g_listenfd = -1;
	initConnList(g_connlist,true);
	g_stop = 1;

#ifdef SUPPORTTHREAD
	pthread_exit(NULL);
	g_tid = -1;
#endif
}

static void sigHandle(int sig)
{
	closeAll();
	printfLog(logERROR,"stop by signal\n");
}

static void printfSelectfd()
{
	char srLog[128]= {0};
	char swLog[128]= {0};

	int rPos = 0;
	int wPos = 0;
	for(int i=1; i<g_fdUtil.maxfd+1; i++)
	{
		if(FD_ISSET(i,&g_fdUtil.allrset))
			rPos += snprintf(srLog+rPos,sizeof(srLog)-rPos," %d",i);
		if(FD_ISSET(i,&g_fdUtil.allwset))
			wPos += snprintf(swLog+wPos,sizeof(swLog)-wPos," %d",i);
	}

	printfLog(logINFO,"select read[%s] write[%s] no ready\n",srLog,swLog);
}

//0 ip 1 domain
static int domainOrIp( const char* domain )
{
	int isIp = 0;
	for( int i = 0 ; i<sizeof( domain ); ++i )
	{
		if( '.' == domain[i] )
			continue;
		if( 0 !=  isalpha(domain[i]))
		{
			isIp = 1;
			break;
		}
	}
	return isIp;
}

static int analysisDomain( const char* domain, char* host,int len  )
{
	struct hostent *hptr;
	if( NULL == ( hptr = gethostbyname(domain) ) )
	{
		printfLog( logERROR,"gethostbyname error for host:%s\n",domain);
		return 0;
	}

	char **pptr;
	pptr=hptr->h_addr_list;
	if(  NULL != * pptr )
	{
		char* phost = (char*)malloc(len);
		inet_ntop( hptr->h_addrtype, *pptr, phost, len );
		strcpy( host,phost);
		free(phost);
	}

	if( NULL == host || strcmp( "",host ) == 0 )
	{
		printfLog( logINFO,"there is a NULL host by analysisiDomain:%s",domain );
		return -1;
	}

	return 1;
}

static int setHost1(const char *host,int len)
{
	if(len>=sizeof(g_host))
		len = sizeof(g_host) - 1;
	strncpy(g_host,host,len);
	g_host[len] = 0;
	return 0;
}

int setHost(const char * host)
{
	strncpy(g_host,host,sizeof(g_host));
	return 0;
}

int setLocal(int local)
{
	g_local = local;
	return 0;
}

int setKey(const char * key)
{
	memcpy(g_keylist[0],key,8);
	g_keynum = 1;
	return 0;
}

int setSelfKey(int selfkey)
{
	g_selfkey = selfkey;

	return 0;
}

int addTryKey(const char * key)
{
	memcpy(g_keylist[g_keynum],key,8);
	g_keynum++;
	return 0;
}

int setSupportHls(int isSupport)
{
	g_isHls = isSupport;
	return 0;
}

static void * thdRun(void * host)
{
	createD((const char *)host);
}

int startHProxyD(const char * host)
{
#ifdef SUPPORTTHREAD
	pthread_create(&g_tid,NULL,thdRun,(void *)host);
#endif

#ifndef SUPPORTTHREAD
	return createD(host);
#endif

}

static int createD(const char *host)
{
	socklen_t len;
	struct sockaddr_in servaddr,cliaddr;
	char buff[128];

	if(host)
	{
		//setHost( host );
		strncpy(g_host,host,sizeof(g_host));
	}


	signal(SIGPIPE,SIG_IGN);
	signal(SIGHUP,sigHandle);
	signal(SIGUSR1,sigHandle);
	signal(SIGALRM,sigHandle);
	signal(SIGCHLD,SIG_IGN);

	int listenfd = socket(AF_INET,SOCK_STREAM,0);
	g_stop = 0;
	printfLog(logDEBUG1,"create 1-(%d)\n",g_stop);
	if(listenfd==-1)
	{
		printfLog(logERROR,"create listenfd error (%d)\n",errno);
		return -1;
	}
	int reuse = 1;
	setsockopt(listenfd,SOL_SOCKET, SO_REUSEADDR,(const void *)&reuse,sizeof(int));

	memset(&servaddr,0,sizeof(servaddr));
	servaddr.sin_family = AF_INET;
#ifndef DEBUG
	//servaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
	inet_pton(AF_INET, "127.0.0.1", &servaddr.sin_addr.s_addr);
#endif
#ifdef DEBUG
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
#endif
	servaddr.sin_port = htons(11211);
	printfLog(logDEBUG1,"create 2-(%d)\n",g_stop);
	int ret = bind(listenfd,(const struct sockaddr *)&servaddr,sizeof(servaddr));
	if(ret != 0)
	{
		printfLog(logERROR,"bind 11211 error(%d) EACCES=%d EADDRINUSE=%d EINVAL=%d\n",
		          errno,EACCES,EADDRINUSE,EINVAL);
		return -1;
	}
	printfLog(logDEBUG1,"create 3-(%d)\n",g_stop);
	g_listenfd = listenfd;
	listen(g_listenfd,SOMAXCONN);

	initFd();
	addRfd(g_listenfd);
	//ConnList connlist;
	initConnList(g_connlist,false);
	printfLog(logDEBUG1,"create 4-(%d)\n",g_stop);
	for(;;)
	{
		printfLog(logDEBUG1,"create 5-(%d)\n",g_stop);
		if(g_stop)
		{
			printfLog(logINFO,"force stop server\n");
			closeAll();
			break;
		}

		struct timeval timeout;
		timeout.tv_sec = 30;
		timeout.tv_usec = 0;

		g_fdUtil.rset = g_fdUtil.allrset;
		g_fdUtil.wset = g_fdUtil.allwset;

		int nready = select(g_fdUtil.maxfd+1,&g_fdUtil.rset,&g_fdUtil.wset,NULL,&timeout);
		if(g_stop)
		{
			printfLog(logINFO,"force stop server\n");
			closeAll();
			break;
		}
		printfLog(logDEBUG1,"create 6-(%d)\n",g_stop);
		if(nready==0)
			printfSelectfd();

		if(checkRfd(g_listenfd))   // new connect
		{
			len = sizeof(cliaddr);
			int clntfd = accept(g_listenfd,(struct sockaddr *)&cliaddr,&len);
			printfLog(logINFO,"connect from %s port %d fd=%d\n",inet_ntop(AF_INET,&cliaddr.sin_addr,buff,sizeof(buff)),
			          ntohs(cliaddr.sin_port),clntfd);
			int stat = fcntl(clntfd,F_GETFL,0);
			fcntl(clntfd,F_SETFL,stat | O_NONBLOCK);

			addRfd(clntfd);
			if(addConnList(g_connlist,clntfd) == -1)
			{
				close(clntfd);
				clntfd = -1;
			}
			continue;
		}
		run(g_connlist);
	}
	initConnList(g_connlist,true);
	return 0;
}

int stopHProxyD()
{
#ifndef SUPPORTTHREAD
	g_stop = 1;
#endif

#ifdef SUPPORTTHREAD
	if(g_tid != -1)
	{
		pthread_kill(g_tid,SIGUSR1);
		pthread_join(g_tid,NULL);
		return pthread_kill(g_tid,0)==ESRCH;
	}
#endif
	return 0;
}

int isRun()
{
#ifdef SUPPORTTHREAD
	if(g_tid != -1)
	{
		return pthread_kill(g_tid,0)==ESRCH ? 0 : 1;
	}
	else
	{
		return 0;
	}
#endif
	return g_stop==1 ? 0 : 1;
}

static void encBase64(unsigned char *in, unsigned char *out)
{
	static const unsigned char encodeBase64Map[] =
	    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	out[0] = encodeBase64Map[(in[0] >> 2) & 0x3F];
	out[1] = encodeBase64Map[((in[0] << 4) & 0x30) | ((in[1] >> 4) & 0x0F)];
	out[2] = encodeBase64Map[((in[1] << 2) & 0x3C) | ((in[2] >> 6) & 0x03)];
	out[3] = encodeBase64Map[in[2] & 0x3F];
}

static int base64Encode(unsigned char *inbuf, int insize, unsigned char *outbuf, int outsize)
{
	int inpos = 0, outpos = 0;
	while(inpos != insize)
	{
		if(inpos + 3 <= insize)
		{
			if(outpos + 4 > outsize)
				return -1;
			encBase64(inbuf + inpos, outbuf + outpos);
			inpos += 3;
			outpos += 4;
		}

		if(insize - inpos == 2)
		{
			unsigned char tail[3] = {0};
			tail[0] = *(inbuf + inpos);
			tail[1] = *(inbuf + inpos + 1);
			encBase64(tail, outbuf + outpos);
			*(outbuf + outpos + 3) = '=';
			inpos += 2;
			outpos += 4;
		}
		if(insize - inpos == 1)
		{
			unsigned char tail[3] = {0};
			tail[0] = *(inbuf + inpos);
			encBase64(tail, outbuf + outpos);
			*(outbuf + outpos + 3) = '=';
			*(outbuf + outpos + 2) = '=';
			inpos += 1;
			outpos += 4;
		}
	}
	return outpos;
}

static int base64Decode(char * in,int inlen)
{
	unsigned char * out = (unsigned char *)malloc(inlen);
	unsigned long t, x, y, z;
	unsigned char c;
	int g = 3;

	for (x = y = z = t = 0; x<inlen;)
	{
		c = map[in[x++]];
		if (c == 255) return -1;
		if (c == 253) continue;
		if (c == 254)
		{
			c = 0;
			g--;
		}
		t = (t<<6)|c;
		if (++y == 4)
		{
			out[z++] = (unsigned char)((t>>16)&255);
			if (g > 1) out[z++] = (unsigned char)((t>>8)&255);
			if (g > 2) out[z++] = (unsigned char)(t&255);
			y = t = 0;
		}
	}
	memcpy(in,out,z);
	free(out);
	return z;
}

int reEncodefile4zip(const char *srcfile,const char *keyfile,const char *srckey,const char*dstkey)
{
	int keyfd = open(keyfile,O_RDONLY);
	if(keyfd == -1)
		return -1;
	int srcfd = open(srcfile,O_WRONLY);
	if(srcfd == -1)
	{
		close(keyfd);
		return -1;
	}

	char buff[SECURELEN*2];

	int len = read(keyfd,buff,sizeof(buff));
	if(len>0)
	{
		len = base64Decode(buff,len);
		cryptUtil(buff,len,srckey,0);
		len = base64Decode(buff,len);
		cryptUtil(buff,len,dstkey,1);
		write(srcfd,buff,len);
		close(srcfd);
		close(keyfd);
		return 0;
	}
	else
	{
		close(srcfd);
		close(keyfd);
		return -1;
	}
}

int encodefile(const char *srcfile,const char*dstkey)
{
	int srcfd = open(srcfile,O_RDWR);
	if(srcfd == -1)
		return -1;

	char buff[SECURELEN];
	int len = read(srcfd,buff,sizeof(buff));
	if(len == sizeof(buff))
	{
		char key[8];
		memcpy(key,dstkey,8);
		cryptUtil(buff,SECURELEN,key,1);
		lseek(srcfd,SEEK_SET,0l);
		write(srcfd,buff,SECURELEN);
		close(srcfd);
		return 0;
	}
	else
	{
		close(srcfd);
		return -1;
	}
}
int reEncodefile4self(const char *srcfile,const char*dstkey)
{
	int srcfd = open(srcfile,O_RDWR);
	if(srcfd == -1)
		return -1;

	char buff[SECURELEN_EXT];

	int len = read(srcfd,buff,sizeof(buff));
	if(len == sizeof(buff))
	{
		char key[8];
		char basekey[32] = {0};

		memcpy(key,buff+SECURELEN,8);
		base64Encode((unsigned char *)key,8,(unsigned char *)basekey,sizeof(basekey));
		memcpy(key,basekey,8);

		cryptUtil(buff,SECURELEN,key,0);
		cryptUtil(buff,SECURELEN,dstkey,1);
		lseek(srcfd,SEEK_SET,0l);
		write(srcfd,buff,SECURELEN_EXT);
		close(srcfd);
		return 0;
	}
	else
	{
		close(srcfd);
		return -1;
	}
}

int isEncode(const char * srcfile)
{
	char buff[128] = {0};
	int srcfd = open(srcfile,O_RDONLY);
	if(srcfd == -1)
	{
		return -1;
	}
	int len = read(srcfd,buff,sizeof(buff));
	close(srcfd);

	if(len == sizeof(buff))
	{
		if(strncmp(buff+4,"ftyp",4)==0)
			return 0;
		else
			return 1;
	}
	return -1;
}

int decodefile(const char * srcfile,const char * dstkey)
{
	int srcfd = open(srcfile,O_RDWR);
	if(srcfd == -1)
		return -1;

	char buff[SECURELEN];
	int len = read(srcfd,buff,sizeof(buff));
	if(len == sizeof(buff))
	{
		char key[8];
		memcpy(key,dstkey,8);
		cryptUtil(buff,SECURELEN,key,0);
		lseek(srcfd,SEEK_SET,0l);
		write(srcfd,buff,SECURELEN);
		close(srcfd);
		return 0;
	}
	else
	{
		close(srcfd);
		return -1;
	}
}

//#ifdef DEBUG
//int main(int argc,char ** argv)
//{
//	while(1)
//	{
//		int c = getchar();
//		if(c=='a')
//		{
//#ifdef SUPPORTTHREAD
//			pthread_t pid;
//			pthread_create(&pid,NULL,thdRun,NULL);
//			//setHost("223.202.30.28");
//			//setSelfKey(1);
//			//setHost("42.56.65.19");
//			//setHost("test.chnedu.com");
//			//setHost("218.60.13.207");
//			//setHost("mcdntest.chnedu.com");
//			//setSupportHls(1);
//			//setHost("192.168.190.11");
//			//setHost("mobile.chnedu.com");
//#endif
//
//#ifndef SUPPORTTHREAD
//			// startHProxyD("mobile.chnedu.com")
//			//startHProxyD("192.168.190.11");
//			//startHProxyD("223.202.30.28");
//			//setSelfKey(1);
//			//g_port = 8081;
//			//setHost("test.chnedu.com");
//			//setHost("42.56.65.19");
//			//setHost("mcdntest.chnedu.com");
//			//setSupportHls(1);
//			//startHProxyD("mcdntest.chnedu.com");
//			startHProxyD("124.193.230.11");
//			//startHProxyD("test.chnedu.com");
//			//startHProxy("27.152.191.13");
//#endif
//			setSelfKey(1);
//		}
//		else if(c=='q')
//		{
//			stopHProxyD();
//		}
//		else if(c=='c')
//		{
//			printf("is run %d\n",isRun());
//		}
//		//else
//		// break;
//	}
//
//	/* 	//setLocal(1);
//	setSelfKey(1);
//	//setKey("e4HD9h4D");
//	//addTryKey("E4HD9h4D");
//	//return startHProxyD("mobile.chnedu.com");
//	return startHProxyD("183.203.15.73");
//	return 0;*/
//}
//#endif

