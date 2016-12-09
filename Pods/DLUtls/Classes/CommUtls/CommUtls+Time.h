//
//  CommUtls+Time.h
//  CdeleduUtls
//
//  Created by 陈轶翔 on 14-3-30.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls.h"

@interface CommUtls (Time)

/*时间处理*/
//CST时间格式转换
+ (NSString *)convertDateFromCST:(NSString *)_date;

//转换NSDate格式为字符串"yyyy-MM-dd HH:mm:ss"
+ (NSString *)encodeTime:(NSDate *)date;

/**
 *	@brief	字符串格式化为时间格式
 *
 *	@param 	dateString 	格式yyyy-MM-dd HH:mm:ss 兼容 yyyy-MM-dd HH:mm:ss.SSS
 *
 *	@return	返回时间
 */
+ (NSDate *)dencodeTime:(NSString *)dateString;

//装换NSDate格式到NString
+ (NSString *)encodeTime:(NSDate *)date format:(NSString *)format;

//转换NString到NSdate
+ (NSDate *)dencodeTime:(NSString *)dateString format:(NSString *)format;

//从现在到某天的时间
+ (NSString *)timeSinceNow:(NSDate *)date;

//把秒转化为时间字符串显示，播放器常用
+ (NSString *)changeSecondsToString:(CGFloat)durartion;

/**
 *  将NSDate转换成中国时间，目前继续教育使用
 */
+ (NSString *)encodeTime_China:(NSDate *)date;
+ (NSString *)encodeTime_China:(NSDate *)date format:(NSString *)format;

/**
 *  将描述换换成00:00:00/00:00
 */
+ (NSString *)timeToHMS:(CGFloat)time;
+ (NSString *)timeToMS:(CGFloat)time;

/**
 *  将00:00:00的数据转换成秒数
 */
+ (NSInteger)hmsToTime:(NSString *)text;

@end
