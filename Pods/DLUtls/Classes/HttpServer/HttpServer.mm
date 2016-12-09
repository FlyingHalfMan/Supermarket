//
//  HttpServer.m
//  Pods
//
//  Created by cyx on 15/11/10.
//
//

#import "HttpServer.h"
#include "hproxy.h"
#include <CommonCrypto/CommonCryptor.h>

@implementation HttpServer


+ (BOOL)startHProxyD:(NSString *)host
{
    if(host)
    {
    const char *temphost = [host UTF8String];
    startHProxyD(temphost);
    return YES;
    }
    return NO;
}


+ (BOOL)stopHProxyD
{
    if(stopHProxyD() == 0)
        return YES;
    return NO;
}


+ (BOOL)isRun
{
    return isRun();
}


+ (void)setKey:(NSString *)pkey
{
  const char *temPkey = [pkey UTF8String];
  setKey(temPkey);

}


+ (void)addTryKey:(NSString *)pkey
{
    const char *temPkey = [pkey UTF8String];
    addTryKey(temPkey);
}


+ (void)setSelfKey:(BOOL)useSelfKey
{
    int selfkey = (int)useSelfKey;
    setSelfKey(selfkey);
}


+ (BOOL)setHost:(NSString *)host
{
    if(host)
    {
        const char *temphost = [host UTF8String];
        if(setHost(temphost) == 0)
            return YES;
    }
    return NO;
}


+ (void)setLocal:(BOOL)local
{
    int tempLocal = (int)local;
    setLocal(tempLocal);
}



+ (BOOL)reEncodefile4zip:(NSString *)srcFilePath
             KeyFilePath:(NSString *)keyFilePath
              withSrcKey:(NSString *)srcKey
              withDstKey:(NSString *)dstKey
{
    if(srcFilePath&&keyFilePath&&srcKey&&dstKey)
    {
         if(reEncodefile4zip([srcFilePath UTF8String], [keyFilePath UTF8String], [srcKey UTF8String], [dstKey UTF8String]) == 0)
             return YES;
    }
    return NO;
}


+ (BOOL)reEncodefile4self:(NSString *)srcFilePath
               withDstKey:(NSString *)dstKey
{
    if(srcFilePath&&dstKey)
    {
         if(reEncodefile4self([srcFilePath UTF8String], [dstKey UTF8String]) == 0)
             return YES;
    }
    return NO;
}


+ (BOOL)encodefile:(NSString *)srcFilePath
        withDstKey:(NSString *)dstKey
{
    if(srcFilePath&&dstKey)
    {
        if(encodefile([srcFilePath UTF8String],[dstKey UTF8String]) == 0)
            return YES;
    }
    return NO;
}


+ (BOOL)decodefile:(NSString *)srcFilePath
        withDstKey:(NSString *)dstKey
{
    if(srcFilePath&&dstKey)
    {
        if(decodefile([srcFilePath UTF8String],[dstKey UTF8String]) == 0)
            return YES;
    }
    return NO;
}

+ (NSString *)urlCov:(NSString *)oldUrl {
    //开启加密服务，替换ssec，后续head请求直接使用ssec
    if (oldUrl.length > 0) {
        NSURL *url = [NSURL URLWithString:oldUrl];
        NSArray *array = [url.absoluteString componentsSeparatedByString:url.host];
        if (array.count == 2) {
            NSString *txt1 = array.lastObject;
            NSArray *array1 = [txt1 componentsSeparatedByString:@"/"];
            if (array1.count > 2) {
                NSString *txt2 = array1[1];
                if ([txt2 rangeOfString:@"sec"].location != NSNotFound) {
                    NSString *txt3 = [txt2 stringByReplacingOccurrencesOfString:@"sec" withString:@"ssec"];
                    url = [NSURL URLWithString:[url.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@/",txt2] withString:[NSString stringWithFormat:@"/%@/",txt3]]];
                }
            }
        }
        return url.absoluteString;
    }
    return nil;
}

@end
