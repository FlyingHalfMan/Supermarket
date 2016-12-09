//
//  DLHttpRACHelp.h
//  Pods
//
//  Created by SL on 16/7/26.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface DLHttpRACHelp : NSObject

/**
 *  get请求
 *
 *  @param url    地址
 *  @param params 参数
 *
 *  @return <#return value description#>
 */
+ (RACSignal *)GET:(NSString *)url params:(id)params;

/**
 *  post请求
 *
 *  @param url    地址
 *  @param params 参数
 *
 *  @return <#return value description#>
 */
+ (RACSignal *)POST:(NSString *)url params:(id)params;

/**
 *  上传文件
 *  files或者fileData、fileName传入有效
 *
 *  @param url      上传地址
 *  @param params   参数
 *  @param files    本地文件地址（带后缀的NSString数组）
 *  @param fileData 上传文件的数据
 *  @param fileName 上传的名称(带后缀)
 *
 *  @return <#return value description#>
 */
+ (RACSignal *)UPLOAD:(NSString *)url
               params:(id)params
                files:(NSArray *)files
             fileData:(NSData *)fileData
             fileName:(NSString *)fileName;

@end
