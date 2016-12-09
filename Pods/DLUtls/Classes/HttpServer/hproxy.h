
#ifndef hproxy_H
#define hproxy_H

int startHProxyD(const char * host);
int stopHProxyD();
int isRun();

int setKey(const char * pkey);
int addTryKey(const char * pkey);
int setSelfKey(int selfkey);
int setHost(const char * host);
int setLocal(int local);

int reEncodefile4zip(const char *srcfile,const char *keyfile,const char *srckey,const char*dstkey);
int reEncodefile4self(const char *srcfile,const char*dstkey);

int encodefile(const char * srcfile,const char *dstkey);
int decodefile(const char * srcfile,const char *dstkey);

int isEncode(const char * srcfile);

#endif