//
//  HttpUtls.h
//  DL
//
//  Created by cyx on 14-9-17.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DLCompleteBlock)(NSString *str);

typedef void (^DLFailBlock)(NSError *err);

typedef void (^DLCancelBolck)(void);

@interface DLHttpUtls : NSObject


/**
 *  此函数为异步http get请求函数，封装了公司对劫持域名的处理逻辑
 *
 *  @param url    请求地址
 *  @param params 请求参数
 *  @param file   本地测试数据文件名都以.txt结尾 nil 为从网络请求数据
 *
 *  @return 返回信号
 */
+ (DLCancelBolck)DLGetAsynchronous:(NSString *)url
                        parameters:(id)params
                      locationFile:(NSString *)file
                          complete:(DLCompleteBlock)aCompletionBlock
                              fail:(DLFailBlock)aFailBlock;

/**
 *  get同步请求方式
 *
 *  @param url    <#url description#>
 *  @param params <#params description#>
 *  @param file   <#file description#>
 *
 *  @return <#return value description#>
 */
+ (id)DLGetSynchronous:(NSString *)url
            parameters:(id)params
          locationFile:(NSString *)file;

/**
 *  post 异步请求方式
 *
 *  @param url              <#url description#>
 *  @param params           <#params description#>
 *  @param file             <#file description#>
 *  @param aCompletionBlock <#aCompletionBlock description#>
 *  @param aFailBlock       <#aFailBlock description#>
 *
 *  @return <#return value description#>
 */
+ (DLCancelBolck)DLPostAsynchronous:(NSString *)url
                         parameters:(id)params
                       locationFile:(NSString *)file
                           complete:(DLCompleteBlock)aCompletionBlock
                               fail:(DLFailBlock)aFailBlock;

/**
 *  上传文件
 *
 *  @param URLString        上传地址
 *  @param parameters       参数
 *  @param files            上传文件本地路径（带后缀的NSString数组）
 *  @param fileData         上传数据NSData
 *  @param fileName         上传文件名称（带后缀）
 *  @param file             <#aCompletionBlock description#>
 *  @param aCompletionBlock <#aCompletionBlock description#>
 *  @param aFailBlock       <#aFailBlock description#>
 *
 *  @return <#return value description#>
 */
+ (DLCancelBolck)DLUploadAsynchronous:(NSString *)URLString
                           parameters:(id)parameters
                                files:(NSArray *)files
                             fileData:(NSData *)fileData
                             fileName:(NSString *)fileName
                         locationFile:(NSString *)file
                             complete:(DLCompleteBlock)aCompletionBlock
                                 fail:(DLFailBlock)aFailBlock;

/**
 *  加密的get请求
 *
 *  @param url              请求地址
 *  @param params           请求参数
 *  @param file
 *  @param aCompletionBlock 成功
 *  @param aFailBlock       失败
 *  @param cryptoKey        加密整个参数的key
 *  @param desKey           des加密的key
 *
 *  @return
 */
+ (DLCancelBolck)DLCryptoGetAsynchronous:(NSString *)url
                              parameters:(id)params
                            locationFile:(NSString *)file
                                complete:(DLCompleteBlock)aCompletionBlock
                                    fail:(DLFailBlock)aFailBlock
                               cryptoKey:(NSString *)cryptoKey
                                  desKey:(NSString *)desKey;

+ (DLCancelBolck)DLCryptoPostAsynchronous:(NSString *)url
                               parameters:(id)params
                             locationFile:(NSString *)file
                                 complete:(DLCompleteBlock)aCompletionBlock
                                     fail:(DLFailBlock)aFailBlock
                                cryptoKey:(NSString *)cryptoKey
                                   desKey:(NSString *)desKey;

@end
