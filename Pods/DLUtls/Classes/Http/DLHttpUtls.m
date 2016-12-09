//
//  HttpUtls.m
//  DL
//
//  Created by cyx on 14-9-17.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls.h"
#import "DLHttpUtls.h"
#import <JSONKit-NoWarning/JSONKit.h>
#import <MD5Digest/NSString+MD5.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <DLUtls/DLLog.h>
#import "DLInterfaceCrypto.h"
#import "HttpNetworking.h"

@implementation DLHttpUtls

+ (DLCancelBolck)DLGetAsynchronous:(NSString *)url
                        parameters:(id)params
                      locationFile:(NSString *)file
                          complete:(DLCompleteBlock)aCompletionBlock
                              fail:(DLFailBlock)aFailBlock {
    __block NSURLSessionTask *_request = nil;
    __block NSURLSessionTask *_request1 = nil;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        _request = [HttpNetworking GET:url
                            parameters:params
                                  host:nil
                     completionHandler:^(NSData *data1, NSURLResponse *response1, NSError *error1) {
                         if (error1) {
                             _request1 = [HttpNetworking GET:[self fetchNewUrl:url]
                                                  parameters:params
                                                        host:[[NSURL URLWithString:url] host]
                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                               [self dealData:data
                                                     response:response
                                                        error:error
                                                          url:url
                                                   parameters:params
                                                     complete:aCompletionBlock
                                                         fail:aFailBlock];
                                           }];
                         }else {
                             [self dealData:data1
                                   response:response1
                                      error:error1
                                        url:url
                                 parameters:params
                                   complete:aCompletionBlock
                                       fail:aFailBlock];
                         }
                     }];
    }];
    return ^{
        if (_request) {
            [_request cancel];
        }
        if (_request1) {
            [_request1 cancel];
        }
        [queue cancelAllOperations];
    };
}

+ (id)DLGetSynchronous:(NSString *)url
            parameters:(id)params
          locationFile:(NSString *)file {
    __block NSString *responseStr = nil;
    __block NSError *err = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [HttpNetworking GET:url
             parameters:params
                   host:nil
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          if (error) {
              err = error;
          } else {
              responseStr = [self parseNetData:data response:response];
          }
          dispatch_semaphore_signal(semaphore);
      }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (responseStr) {
        return responseStr;
    } else {
        [HttpNetworking GET:[self fetchNewUrl:url]
                 parameters:params
                       host:[[NSURL URLWithString:url] host]
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              if (error) {
                  err = error;
              } else {
                  responseStr = [self parseNetData:data response:response];
              }
              dispatch_semaphore_signal(semaphore);
          }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (responseStr) {
            return responseStr;
        } else if (err){
            return err;
        }
    }
    return nil;
}

+ (DLCancelBolck)DLPostAsynchronous:(NSString *)url
                         parameters:(id)params
                       locationFile:(NSString *)file
                           complete:(DLCompleteBlock)aCompletionBlock
                               fail:(DLFailBlock)aFailBlock {
    __block NSURLSessionTask *_request = nil;
    __block NSURLSessionTask *_request1 = nil;
    
    //循环调用ok
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        _request = [HttpNetworking POST:url
                             parameters:params
                                   host:nil
                      completionHandler:^(NSData *data1, NSURLResponse *response1, NSError *error1) {
                          if (error1) {
                              _request1 = [HttpNetworking POST:[self fetchNewUrl:url]
                                                    parameters:params
                                                          host:[[NSURL URLWithString:url] host]
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 [self dealData:data
                                                       response:response
                                                          error:error
                                                            url:url
                                                     parameters:params
                                                       complete:aCompletionBlock
                                                           fail:aFailBlock];
                                             }];
                          }else {
                              [self dealData:data1
                                    response:response1
                                       error:error1
                                         url:url
                                  parameters:params
                                    complete:aCompletionBlock
                                        fail:aFailBlock];
                          }
                      }];
    }];
    return ^{
        if (_request) {
            [_request cancel];
        }
        if (_request1) {
            [_request1 cancel];
        }
        [queue cancelAllOperations];
    };
}

+ (DLCancelBolck)DLUploadAsynchronous:(NSString *)URLString
                           parameters:(id)parameters
                                files:(NSArray *)files
                             fileData:(NSData *)fileData
                             fileName:(NSString *)fileName
                         locationFile:(NSString *)file
                             complete:(DLCompleteBlock)aCompletionBlock
                                 fail:(DLFailBlock)aFailBlock {
    __block NSURLSessionTask *_request = nil;
    __block NSURLSessionTask *_request1 = nil;
    
    //循环调用ok
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        _request = [HttpNetworking UPLOAD:URLString
                               parameters:parameters
                                    files:files
                                 fileData:fileData
                                 fileName:fileName
                                     host:nil
                        completionHandler:^(NSData *data1, NSURLResponse *response1, NSError *error1) {
                            if (error1) {
                                _request1 = [HttpNetworking UPLOAD:[self fetchNewUrl:URLString]
                                                        parameters:parameters
                                                             files:files
                                                          fileData:fileData
                                                          fileName:fileName
                                                              host:[[NSURL URLWithString:URLString] host]
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     [self dealData:data
                                                           response:response
                                                              error:error
                                                                url:URLString
                                                         parameters:parameters
                                                           complete:aCompletionBlock
                                                               fail:aFailBlock];
                                                 }];
                            }else {
                                [self dealData:data1
                                      response:response1
                                         error:error1
                                           url:URLString
                                    parameters:parameters
                                      complete:aCompletionBlock
                                          fail:aFailBlock];
                            }
                        }];
    }];
    return ^{
        if (_request) {
            [_request cancel];
        }
        if (_request1) {
            [_request1 cancel];
        }
        [queue cancelAllOperations];
    };
}

+ (DLCancelBolck)DLCryptoGetAsynchronous:(NSString *)url
                              parameters:(id)params
                            locationFile:(NSString *)file
                                complete:(DLCompleteBlock)aCompletionBlock
                                    fail:(DLFailBlock)aFailBlock
                               cryptoKey:(NSString *)cryptoKey
                                  desKey:(NSString *)desKey {
    if (cryptoKey && params) {
        params = @{
                   cryptoKey:[DLInterfaceCrypto DL_DESEncrypt:[params JSONString]
                                                      withKey:desKey],
                   };
    }
    return [self DLGetAsynchronous:url
                        parameters:params
                      locationFile:file
                          complete:aCompletionBlock
                              fail:aFailBlock];
}

+ (DLCancelBolck)DLCryptoPostAsynchronous:(NSString *)url
                               parameters:(id)params
                             locationFile:(NSString *)file
                                 complete:(DLCompleteBlock)aCompletionBlock
                                     fail:(DLFailBlock)aFailBlock
                                cryptoKey:(NSString *)cryptoKey
                                   desKey:(NSString *)desKey {
    if (cryptoKey && params) {
        params = @{
                   cryptoKey:[DLInterfaceCrypto DL_DESEncrypt:[params JSONString]
                                                      withKey:desKey],
                   };
    }
    return [self DLPostAsynchronous:url
                         parameters:params
                       locationFile:file
                           complete:aCompletionBlock
                               fail:aFailBlock];
}

+ (NSString *)fetchNewUrl:(NSString *)url {
    NSURL *currentPlayUrl = [NSURL URLWithString:url];
    NSString *file = nil;
    NSString *host = currentPlayUrl.host;
    if (host) {
        if ([host rangeOfString:@"g12e"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"zikao365"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"chengkao365"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"cnedu"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"for68"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"estudychinese"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"ck100"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"chinalawedu"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"chinatat"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"itatedu"].location != NSNotFound) {
            file = @"";
        }else if ([host rangeOfString:@"chinapen"].location != NSNotFound) {
            file = @"";
        }
    }
    
    NSString *urlHost = file?@"59.151.113.48":@"211.157.0.5";
    NSString *httpUrl = [currentPlayUrl.absoluteString stringByReplacingOccurrencesOfString:currentPlayUrl.host withString:urlHost];
    return httpUrl;
}

+ (void)dealData:(NSData *)data
        response:(NSURLResponse *)response
           error:(NSError *)error
             url:(NSString *)url
      parameters:(id)params
        complete:(DLCompleteBlock)aCompletionBlock
            fail:(DLFailBlock)aFailBlock {
    NSError *err = nil;
    NSString *responseStr = nil;
    if (error) {
        err = error;
    } else {
        responseStr = [self parseNetData:data response:response];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (responseStr != nil) {
            if(aCompletionBlock) {
                [DLLog globalInfo:@"neturl ----->:%@ \n params ----->:%@ \n netdata ---->:%@",url,params,responseStr];
                aCompletionBlock(responseStr);
            }
        } else if(aFailBlock) {
            [DLLog globalInfo:@"neturl ----->:%@ \n params ----->:%@ \n neterror ---->:%@",url,params,err];
            aFailBlock(err);
        }
    }];
}

+ (NSString *)parseNetData:(NSData *)data response:(NSURLResponse *)response {
    if (data) {
        NSStringEncoding *stringEncoding = nil;
        NSString *textEncodingName = response.textEncodingName;
        if (textEncodingName != nil && ![textEncodingName isEqual:[NSNull null]]) {
            CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)textEncodingName);
            if (cfEncoding != kCFStringEncodingInvalidId) {
                stringEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
            }
        }
        if (stringEncoding) {
            return [[NSString alloc] initWithData:data encoding:stringEncoding];
        }
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
