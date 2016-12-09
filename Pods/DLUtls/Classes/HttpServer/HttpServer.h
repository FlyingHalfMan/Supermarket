//
//  HttpServer.h
//  Pods
//
//  Created by cyx on 15/11/10.
//
//

#import <Foundation/Foundation.h>



@interface HttpServer : NSObject

////解密文件
//+ (void)testFunction:(char *)buff Size:(int)size G_KEY:(const char *)g_key IV:(char *)iv;

/**
 *  开启httpServer,启动播放器
 *
 *  @param host 在线播放传入播放IP 本地播放传入空字符串
 *
 *  @return 返回是否成功
 */
+ (BOOL)startHProxyD:(NSString *)host;


/**
 *  关闭httpServer
 *
 *  @return 返回是否成功
 */
+ (BOOL)stopHProxyD;


/**
 *  是否服务运行
 *
 *  @return 返回是否成功
 */
+ (BOOL)isRun;


/**
 *  设置本地解密秘钥
 *
 *  @param pkey 解密秘钥
 *
 *  @return 返回是否成功
 */
+ (void)setKey:(NSString *)pkey;


/**
 *  增加可以尝试的秘钥
 *
 *  @param pkey 解密秘钥
 *
 *  @return 返回是否成功
 */
+ (void)addTryKey:(NSString *)pkey;


/**
 *  设置是否需要本地秘钥，本地播放为YES，在线播放为NO
 *
 *  @param useSelfKey 是否需要本地秘钥
 *
 *  @return 返回是否成功
 */
+ (void)setSelfKey:(BOOL)useSelfKey;


/**
 *  设置轮换的IP
 *
 *  @param host IP地址
 *
 *  @return 返回是否成功
 */
+ (BOOL)setHost:(NSString *)host;


/**
 *  设置是否本地播放
 *
 *  @param local 本地播放参数
 *
 *  @return 返回是否成功
 */
+ (void)setLocal:(BOOL)local;


/**
 *  解密zip下载文件，并加密本地多媒体文件
 *
 *  @param srcFilePath 多媒体文件路径
 *  @param keyFilePath 加密文件路径
 *  @param srcKey      在线获取加密秘钥
 *  @param dstKey      本地加密秘钥
 *
 *  @return 返回是否成功
 */
+ (BOOL)reEncodefile4zip:(NSString *)srcFilePath
             KeyFilePath:(NSString *)keyFilePath
             withSrcKey:(NSString *)srcKey
             withDstKey:(NSString *)dstKey;

/**
 *  加密多媒体文件
 *
 *  @param srcFilePath 多媒体文件路径
 *  @param dstKey      本地加密秘钥
 *
 *  @return 返回是否成功
 */
+ (BOOL)reEncodefile4self:(NSString *)srcFilePath
               withDstKey:(NSString *)dstKey;


/**
 *  加密原本地文件
 *
 *  @param srcFilePath 多媒体文件路径
 *  @param dstKey      本地加密秘钥
 *
 *  @return 返回是否成功
 */
+ (BOOL)encodefile:(NSString *)srcFilePath
               withDstKey:(NSString *)dstKey;

/**
 *  解密原本地文件
 *
 *  @param srcFilePath 多媒体文件路径
 *  @param dstKey      本地加密秘钥
 *
 *  @return 返回是否成功
 */
+ (BOOL)decodefile:(NSString *)srcFilePath
        withDstKey:(NSString *)dstKey;

/**
 *  转换成加密ssec
 *
 *  @param oldUrl <#oldUrl description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)urlCov:(NSString *)oldUrl;

@end
