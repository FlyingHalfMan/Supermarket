//
//  DLTokenHelper.h
//  Pods
//
//  Created by SL on 16/8/5.
//
//

#import <Foundation/Foundation.h>

@interface DLTokenInfo : NSObject

@property (nonatomic,readonly) long long longtime;
@property (nonatomic,readonly) NSString *token;
@property (nonatomic,readonly) NSInteger timeout;

@end

@class RACSignal;

@interface TokenHelper : NSObject

/**
 *  token信息
 */
@property (atomic,strong) DLTokenInfo *tokenInfo;

/**
 *  请求地址
 */
@property (nonatomic,strong) NSString *netUrl;

/**
 *  是否不是移动课堂（为掌上高校添加的字段）
 */
@property (nonatomic,assign) BOOL notMobileClass;

+ (TokenHelper *)sharedInstance;

/**
 *  同步获取密钥
 */
- (void)getSynchronousToken;

/**
 *  异步获取秘钥
 */
- (void)getASynchronousToken;

/**
 *  获取token信号，有些上传接口需要先获取token再上传
 */
- (RACSignal *)fetchToken;

@end
