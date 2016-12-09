//
//  HttpNetworking.h
//  MobileClassPhone
//
//  Created by SL on 16/5/10.
//  Copyright © 2016年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface HttpNetworking : NSObject

+ (instancetype)sharedInstance;

/**
 *  应用唯一标识
 */
@property (atomic,strong) NSString *appkey;

+ (NSURLSessionTask *)GET:(NSString *)URLString
               parameters:(id)parameters
                     host:(NSString *)host
        completionHandler:(HttpHandler)completionHandler;

+ (NSURLSessionTask *)POST:(NSString *)URLString
                parameters:(id)parameters
                      host:(NSString *)host
         completionHandler:(HttpHandler)completionHandler;

/**
 *  上传
 *
 *  @param URLString         <#URLString description#>
 *  @param parameters        <#parameters description#>
 *  @param files             本地文件路径（带文件类型）
 *  @param fileData          文件流(NSData)
 *  @param fileName          带后缀的文件名称(a.txt)
 *  @param host              <#host description#>
 *  @param completionHandler <#completionHandler description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionTask *)UPLOAD:(NSString *)URLString
                  parameters:(id)parameters
                       files:(NSArray *)files
                    fileData:(NSData *)fileData
                    fileName:(NSString *)fileName
                        host:(NSString *)host
           completionHandler:(HttpHandler)completionHandler;

@end
