//
//  CacheDB.h
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum _CacheStatus
{
    NoCacheDB = 0,//没缓存
    ValidCacheDB = 1,//有缓存
    InValidCacheDB = 2 //缓存过期
}CacheStatus;


@interface CacheDB : NSObject

+ (void)addCache:(NSString *)key;

+ (void)deleteAllCache;

+ (void)deleteCache:(NSString *)key;
/**
 *  获取缓存状态
 *
 *  @param key     <#key description#>
 *  @param seconds 秒为单位，如果为0会有默认缓存数值
 *
 *  @return <#return value description#>
 */
+ (CacheStatus)cacheStatus:(NSString *)key timeLong:(NSInteger)seconds;

+ (CacheStatus)cacheStatus:(NSString *)key;

+ (CacheStatus)cacheStatusNoInvalid:(NSString *)key;



@end
