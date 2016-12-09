//
//  HttpNetworking.m
//  MobileClassPhone
//
//  Created by SL on 16/5/10.
//  Copyright © 2016年 CDEL. All rights reserved.
//

#import "HttpNetworking.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSInteger netWorking = 0;

@interface HttpNetworking ()

@property (atomic,strong) NSString *userAgentString;

@end

@implementation HttpNetworking

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

+ (instancetype)sharedInstance {
    static HttpNetworking *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HttpNetworking alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSURLSessionTask *)GET:(NSString *)URLString
               parameters:(id)parameters
                     host:(NSString *)host
        completionHandler:(HttpHandler)completionHandler {
    
    URLString = [self fetchNewUrl:URLString parameters:parameters];
    NSMutableURLRequest *mutableRequest = nil;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableString *string = [NSMutableString stringWithString:URLString];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [string appendFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",obj]];
        }];
#ifdef DEBUG
        NSLog(@"\n\nhttp--get--%@\n\n",string);
#endif
        mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else if ([parameters isKindOfClass:[NSData class]]) {
        mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
        mutableRequest.HTTPBody = parameters;
    }
    
    mutableRequest.HTTPMethod = @"GET";
    mutableRequest.timeoutInterval = 10;
    if (![mutableRequest allHTTPHeaderFields][@"Host"] && host) {
        [mutableRequest addValue:host forHTTPHeaderField:@"Host"];
    }
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:[self fetchNewRequest:mutableRequest]
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                         [self taskCompletionHandler:completionHandler
                                                                                                data:data
                                                                                            response:response
                                                                                               error:error
                                                                                                 url:URLString];
                                                                     }];
    if (completionHandler) {
        [self taskResume:dataTask];
    }
    
    return dataTask;
}

+ (NSURLSessionTask *)POST:(NSString *)URLString
                parameters:(id)parameters
                      host:(NSString *)host
         completionHandler:(HttpHandler)completionHandler {
    
    URLString = [self fetchNewUrl:URLString parameters:parameters];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableString *string = [NSMutableString stringWithFormat:@""];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [string appendFormat:([string isEqualToString:@""]?@"%@=%@":@"&%@=%@"),[self encodeURL:key],[self encodeURL:[NSString stringWithFormat:@"%@",obj]]];
        }];
#ifdef DEBUG
        NSLog(@"\n\nhttp--post--%@\n\n",[NSString stringWithFormat:@"%@&%@",URLString,string]);
#endif
        mutableRequest.HTTPBody = [string dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([parameters isKindOfClass:[NSData class]]) {
        mutableRequest.HTTPBody = parameters;
    }
    
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    mutableRequest.timeoutInterval = 30;
    if (![mutableRequest allHTTPHeaderFields][@"Host"] && host) {
        [mutableRequest addValue:host forHTTPHeaderField:@"Host"];
    }
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:[self fetchNewRequest:mutableRequest]
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                         [self taskCompletionHandler:completionHandler
                                                                                                data:data
                                                                                            response:response
                                                                                               error:error
                                                                                                 url:URLString];
                                                                     }];
    if (completionHandler) {
        [self taskResume:dataTask];
    }
    
    return dataTask;
}

+ (NSURLSessionTask *)UPLOAD:(NSString *)URLString
                  parameters:(id)parameters
                       files:(NSArray *)files
                    fileData:(NSData *)fileData
                    fileName:(NSString *)fileName
                        host:(NSString *)host
           completionHandler:(HttpHandler)completionHandler {
    
    //    URLString = [self fetchNewUrl:URLString];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [mutableRequest setTimeoutInterval:30];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    [mutableRequest addValue:[NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", stringBoundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    if (parameters) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *param1 = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",stringBoundary,key,obj,nil];
                [body appendData:[param1 dataUsingEncoding:NSUTF8StringEncoding]];
            }];
        } else if ([parameters isKindOfClass:[NSData class]]) {
            [body appendData:parameters];
        }
    }
    
    NSMutableArray *filesArray = [NSMutableArray new];
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [NSData dataWithContentsOfFile:obj];
        NSString *fileName = [obj lastPathComponent];
        [filesArray addObject:@{
                                @"data":data,
                                @"fileName":fileName,
                                }];
    }];
    if (fileData && fileName) {
        [filesArray addObject:@{
                                @"data":fileData,
                                @"fileName":fileName,
                                }];
    }
    [filesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj[@"fileName"];
        NSString *file1 = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",stringBoundary,[name stringByDeletingPathExtension],name,nil];
        [body appendData:[file1 dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:obj[@"data"]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    //body结束分割线
    NSString *endString = [NSString stringWithFormat:@"--%@--",stringBoundary];
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    mutableRequest.HTTPBody = body;
    
    if (![mutableRequest allHTTPHeaderFields][@"Host"] && host) {
        [mutableRequest addValue:host forHTTPHeaderField:@"Host"];
    }
    
    NSURLSessionDataTask *uploadtask = [[NSURLSession sharedSession] dataTaskWithRequest:[self fetchNewRequest:mutableRequest]
                                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                           [self taskCompletionHandler:completionHandler
                                                                                                  data:data
                                                                                              response:response
                                                                                                 error:error
                                                                                                   url:URLString];
                                                                       }];
    if (completionHandler) {
        [self taskResume:uploadtask];
    }
    return uploadtask;
}

+ (void)taskResume:(NSURLSessionTask *)task {
    netWorking++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [task resume];
}

+ (void)taskCompletionHandler:(HttpHandler)completionHandler
                         data:(NSData *)data
                     response:(NSURLResponse *)response
                        error:(NSError *)error
                          url:(NSString *)url {
    if (!error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
            //401公司授权业务处理（token失效http返回401）
            if (r.statusCode > 299 && r.statusCode != 401) {
                error = [NSError errorWithDomain:@"com.cdeledu.err"
                                            code:r.statusCode
                                        userInfo:@{@"errorInfo":[NSString stringWithFormat:@"Connection Fail,code = %d.",r.statusCode]}];
            }
        }
    } else if (error.code == -1001){
        error = [NSError errorWithDomain:@"com.cdeledu.err" code:-1001 userInfo:@{@"errorInfo":@"请求超时"}];
    }
    //-999是自动取消请求，-1001是超时
#ifdef DEBUG
    if (error) {
        NSLog(@"\n\nhttperror====%@====%@====%d\n\n",url,error,error.code);
    }
#endif
    if (completionHandler && error.code!=-999) {
        completionHandler(data,response,error);
    }
    netWorking--;
    if (netWorking<=0) {
        netWorking = 0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

/**
 *  拼接通用参数
 *
 *  @param oldParameters <#oldParameters description#>
 *
 *  @return <#return value description#>
 */
+ (id)fetchNewUrl:(id)oldUrl parameters:(id)parameters {
    if (oldUrl != nil && ![oldUrl isEqual:[NSNull null]]) {
        NSDictionary *oldDic = nil;
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            oldDic = (NSDictionary *)parameters;
        }
        
        NSMutableDictionary *info = [NSMutableDictionary new];
        info[@"_t"] = @(arc4random());
        if (!oldDic[@"version"]) {
            info[@"version"] = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        }
        if ([[self sharedInstance] appkey] && !oldDic[@"appkey"]) {
            info[@"appkey"] = [[self sharedInstance] appkey];
        }
        NSMutableString *string = [NSMutableString stringWithString:oldUrl];
        [info enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [string appendFormat:([string isEqualToString:oldUrl]?@"?%@=%@":@"&%@=%@"),key,[NSString stringWithFormat:@"%@",obj]];
        }];
        return string;
    }
    return oldUrl;
}

/**
 *  HTTPHeader
 *
 *  @param request <#request description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLRequest *)fetchNewRequest:(NSMutableURLRequest *)request {
    if ([[self sharedInstance] appkey]) {
        //        if (![request allHTTPHeaderFields][@"Authorization"]) {
        //            [request addValue:[NSString stringWithFormat:@"%@|%@",[[self sharedInstance] appkey],[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"Authorization"];
        //        }
        [request addValue:[NSString stringWithFormat:@"%@|%@",[[self sharedInstance] appkey],[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"Authorization"];
    }else {
#ifdef DEBUG
        NSLog(@"%@\nHttp未设置appkey应用唯一标识\nHttp未设置appkey应用唯一标识\nHttp未设置appkey应用唯一标识\nHttp未设置appkey应用唯一标识\nHttp未设置appkey应用唯一标识",self.class);
#endif
    }
    
    if (![request allHTTPHeaderFields][@"User-Agent"]) {
        if (![[self sharedInstance] userAgentString]) {
            [[self sharedInstance] setUserAgentString:[self defaultUserAgentString]];
        }
        if ([[self sharedInstance] userAgentString]) {
            [request addValue:[[self sharedInstance] userAgentString] forHTTPHeaderField:@"User-Agent"];
        }
    }
    
    if (![request allHTTPHeaderFields][@"Content-Type"]) {
        [request addValue:@"*/*" forHTTPHeaderField:@"Content-Type"];
    }
    return request;
}

/**
 *  默认的User-Agent
 *
 *  @return <#return value description#>
 */
+ (NSString *)defaultUserAgentString {
    @synchronized (self) {
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        // Attempt to find a name for this application
        NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (!appName) {
            appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
        }
        
        NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
        appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
        
        // If we couldn't find one, we'll give up (and ASIHTTPRequest will use the standard CFNetwork user agent)
        if (!appName) {
            return nil;
        }
        
        NSString *appVersion = nil;
        NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
        if (marketingVersionNumber && developmentVersionNumber) {
            if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
                appVersion = marketingVersionNumber;
            } else {
                appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
            }
        } else {
            appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
        }
        
        NSString *deviceName;
        NSString *OSName;
        NSString *OSVersion;
        NSString *locale = [[NSLocale currentLocale] localeIdentifier];
        
#if TARGET_OS_IPHONE
        UIDevice *device = [UIDevice currentDevice];
        deviceName = [device model];
        OSName = [device systemName];
        OSVersion = [device systemVersion];
        
#else
        deviceName = @"Macintosh";
        OSName = @"Mac OS X";
        
        // From http://www.cocoadev.com/index.pl?DeterminingOSVersion
        // We won't bother to check for systems prior to 10.4, since ASIHTTPRequest only works on 10.5+
        OSErr err;
        SInt32 versionMajor, versionMinor, versionBugFix;
        err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
        if (err != noErr) return nil;
        err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
        if (err != noErr) return nil;
        err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
        if (err != noErr) return nil;
        OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
#endif
        
        // Takes the form "My Application 1.0 (Macintosh; Mac OS X 10.5.7; en_GB)"
        return [NSString stringWithFormat:@"%@ %@ (%@; %@ %@; %@)", appName, appVersion, deviceName, OSName, OSVersion, locale];
    }
    return nil;
}

/**
 *  获取本地文件类型
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)fetchTypeForFileAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return CFBridgingRelease(MIMEType);
    //    return NSMakeCollectable(MIMEType);
}

+ (NSString *)encodeURL:(NSString *)string {
    if (string != nil && ![string isEqual:[NSNull null]]) {
        NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[NSString stringWithFormat:@"%@",string], nil, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
        if (newString) {
            return newString;
        }
    }
    return @"";
}

@end
