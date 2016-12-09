//
//  NetworkManager.m
//  compuslifeAssistance
//
//  Created by Cai.H.F on 7/17/16.
//  Copyright © 2016 com.live.hf_kia. All rights reserved.
//

#import "NetworkManager.h"
//
static NSString* const kApiUrl = @"http://localhost:8080/supermarkets/webapi/";
//static NSString* const kApiUrl = @"http://139.129.48.197:8080/supermarkets/webapi/";

static NSString* const kImageUrl = @"http://supershopping.img-cn-shanghai.aliyuncs.com/supershopping";


@implementation NetworkManager
{
    NSURLSession* _dataSession;
    NSURLSession* _imageSession;
}
@synthesize myProfile = _myProfile;
@synthesize token = _token;
+(NetworkManager *)sharedManager{
    static NetworkManager* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc]init];
    });
    return sharedManager;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration* dataConfiguration =[ NSURLSessionConfiguration defaultSessionConfiguration];
        [dataConfiguration setTimeoutIntervalForRequest:30.f];
        [dataConfiguration setTimeoutIntervalForResource:60.f];
        _dataSession =[NSURLSession sessionWithConfiguration:dataConfiguration];
        
        
        //set  image configuration and session
        
        
        NSURLSessionConfiguration* imageConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        [imageConfiguration setTimeoutIntervalForResource:30.f];
        [imageConfiguration setTimeoutIntervalForResource:60.f];
        
        _imageSession = [NSURLSession sessionWithConfiguration:imageConfiguration];
    }
    return self;
}
-(BOOL)login{
    if ([self token] && [[self token]user_id] && [[self token]expiredDate] >[NSDate date]) {
        return YES;
    }
    else return NO;
}
-(void)logout{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"token"];
    [userDefaults setObject:nil forKey:@"myProfile"];
    [userDefaults synchronize];
}

- (void)setMyProfile:(UserProfile *)myProfile {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[myProfile toJSONString] forKey:@"myProfile"];
    [userDefaults synchronize];
    _myProfile = myProfile;
    NSLog(@"myprofile %@",myProfile);
}

- (UserProfile *)myProfile {
    if (_myProfile == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSError* error;
        _myProfile = [[UserProfile alloc] initWithString:[userDefaults objectForKey:@"myProfile"] error:&error] ;
        
//        NSLog(@"profile get %@",[userDefaults objectForKey:@"myProfile"]);
        NSLog(@"_myprofile %@",error);
    }
    return _myProfile;
}

- (void)setToken:(SecurityToken *)token {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[token toJSONString] forKey:@"token"];
    [userDefaults synchronize];
    _token = token;
}

- (SecurityToken *)token {
    if (_token == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _token = [[SecurityToken alloc] initWithString:[userDefaults objectForKey:@"token"] error:nil] ;
    }
    return _token;
}


- (NSURLSessionDataTask*)getDataWithUrl:(NSString *)url completionHandler:(void (^)(long, NSData *, NSString *))completionHandler {return [self requestDataWithUrl:url method:@"GET" data:nil completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)postDataWithUrl:(NSString *)url data:(NSData *)data completionHandler:(void (^)(long, NSData *, NSString *))completionHandler {
    return [self requestDataWithUrl:url method:@"POST" data:data completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)putDataWithUrl:(NSString *)url data:(NSData *)data completionHandler:(void (^)(long, NSData *, NSString *))completionHandler {
    return [self requestDataWithUrl:url method:@"PUT" data:data completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)deleteDataWithUrl:(NSString *)url data:(NSData *)data completionHandler:(void (^)(long, NSData *, NSString *))completionHandler {
    return [self requestDataWithUrl:url method:@"DELETE" data:data completionHandler:completionHandler];
}
- (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)url method:(NSString *)method data:(NSData *)data completionHandler:(void (^)(long, NSData *, NSString *))completionHandler {
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[kApiUrl stringByAppendingPathComponent:url]]];
    NSLog(@"url %@",[kApiUrl stringByAppendingPathComponent:url]);
    
    [request setHTTPMethod:method];
    
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"] || [method isEqualToString:@"DELETE"]) {
        [request setHTTPBody:data];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if ([self login]) {
        [request setValue:[_token user_id] forHTTPHeaderField:@"user-id"];
        NSLog(@"id %@",[_token user_id]);
        [request setValue:[_token user_securityToken] forHTTPHeaderField:@"security-token"];
        NSLog(@"sid %@",[_token user_securityToken]);
        
        [request setValue:[self deviceId] forHTTPHeaderField:@"device-id"];
        [request setValue:[self channel] forHTTPHeaderField:@"channel"];
        [request setValue:[self os] forHTTPHeaderField:@"os"];
        [request setValue:[self version] forHTTPHeaderField:@"client-version"];
        [request setValue:[self pushAgency] forHTTPHeaderField:@"push-agency"];
        [request setValue:[self pushToken] forHTTPHeaderField:@"push-token"];
    }
    
    NSURLSessionDataTask* dataTask = [_dataSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode;
        NSString *errorMessage;
        if (error == nil) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 400 || statusCode == 401) {
                if (data != nil) {
                    NSError *jsonError = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                    
                    if (jsonError == nil && [jsonObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                        errorMessage = [jsonDictionary objectForKey:@"message"];
                    }
                }
            } else {
                errorMessage = [NSString stringWithFormat:@"%ld", (long)statusCode];
            }
        } else {
            statusCode = error.code;
            errorMessage = error.localizedDescription;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(statusCode, data, errorMessage);
        });
    }];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url data:(NSData *)data completionHandler:(void (^)(long, NSData *, NSString *))completionHandler {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[kApiUrl stringByAppendingPathComponent:url]]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [[NSUUID UUID] UUIDString];
    // set Content-Type in HTTP header
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
    
    if ([self login]) {
        [request setValue:[_token user_id] forHTTPHeaderField:@"user-id"];
        [request setValue:[_token user_securityToken] forHTTPHeaderField:@"security-token"];
        
        [request setValue:[self deviceId] forHTTPHeaderField:@"device-id"];
        [request setValue:[self channel] forHTTPHeaderField:@"channel"];
        [request setValue:[self os] forHTTPHeaderField:@"os"];
        [request setValue:[self version] forHTTPHeaderField:@"client-version"];
        [request setValue:[self pushAgency] forHTTPHeaderField:@"push-agency"];
        [request setValue:[self pushToken] forHTTPHeaderField:@"push-token"];
    }
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"key"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"value"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"file", @"photo.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // body end
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    //NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLSessionDataTask* dataTask = [_dataSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        long statusCode;
        NSString *errorMessage;
        if (error == nil) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 400 || statusCode == 401) {
                if (data != nil) {
                    NSError *jsonError = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                    
                    if (jsonError == nil && [jsonObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                        errorMessage = [jsonDictionary objectForKey:@"message"];
                    }
                }
            } else {
                errorMessage = [NSString stringWithFormat:@"%ld", statusCode];
            }
        } else {
            statusCode = error.code;
            errorMessage = error.localizedDescription;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(statusCode, data, errorMessage);
        });
    }];
    [dataTask resume];
    return dataTask;
}



- (NSURLSessionDataTask *)getUploadImageWithName:(NSString *)name completionHandler:(void (^)(long, NSData *))completionHandler {
    NSString* url = [kImageUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"/upload/%@%@", name, @".jpg"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask* dataTask = [_imageSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode;
        if (error == nil) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
        } else {
            statusCode = error.code;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(statusCode, data);
        });
    }];
    [dataTask resume];
    return dataTask;
}


- (NSURLSessionDataTask *)getResizedImageWithName:(NSString *)name dimension:(int)dimension completionHandler:(void (^)(long, NSData *))completionHandler {
    NSString* url = [kImageUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"/resized/%@_%d%@", name, dimension, @".jpg"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask* dataTask = [_imageSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode;
        if (error == nil) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
        } else {
            statusCode = error.code;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(statusCode, data);
        });
    }];
    [dataTask resume];
    return dataTask;
}


- (NSString*)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString*)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString*)build {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

- (NSString*)channel {
    return @"app_store";
}

- (NSString*)os {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString*)pushAgency {
    return @"No";
}

- (NSString*)pushToken {
    return @"No";
}
- (NSURLSessionDataTask *)getResizedImageWithName:(NSString *)name extention:(NSString *)ext height:(int)height width:(int)width completionHandler:(void (^)(long, NSData *))completionHandler{
    NSString* url = [kImageUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.%@@%iw_%ih_90q", name,ext ,width,height]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask* dataTask = [_imageSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode;
        if (error == nil) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
        } else {
            statusCode = error.code;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(statusCode, data);
        });
    }];
    [dataTask resume];
    return dataTask;
}







@end
