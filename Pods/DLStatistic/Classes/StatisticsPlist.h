//
//  StatisticsPlist.h
//  DownLoadManger
//
//  Created by cyx on 12-10-9.
//  Copyright (c) 2012年 cyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsPlist : NSObject

/** 返回所有信息 */
+ (NSMutableDictionary *)statisticsInfo;


/** 记录软件使用时间 */
+ (void)recordAppUsedTime:(NSDate *)time;

/** 记录软件开始使用时间 */
+ (void)recordStartTime:(NSDate *)time;

/** 记录软件本版本是否忽略弹出升级框 */
+ (void)setIgnoreUpdate:(NSString *)version;

/** 升级框 */
+ (NSString *)ignoreUpdate;

/** 记录本版本评论框是否弹出 */
+ (void)setComment:(NSString *)comment;

/** 获取评论版本 */
+ (NSString *)comment;

/** 记录启动次数 */
+ (void)recordStartCount:(NSInteger)count;

/** 启动次数 */
+ (NSInteger)startCount;

/** 记录token */
+ (void)recordToken:(NSString *)token;

/** 返回token */
+ (NSString *)token;

/** 判断是否需要展示引导页 */
+ (BOOL)judgeToShowIntroduce;

/** 此版本需要展示引导页 */
+ (void)thisVersionNeedShowNewIntroduce:(NSString *)version;

/** 是否通过审核 */
+ (BOOL)hasReleased;

/** 配置审核状态 */
+ (void)configAppState:(NSString *)state;


@end
