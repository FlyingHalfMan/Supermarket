//
//  CommUtls+Time.m
//  CdeleduUtls
//
//  Created by 陈轶翔 on 14-3-30.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls+Time.h"

@implementation CommUtls (Time)

/**
 *	@brief	格式化时间为字符串
 *
 *	@param 	date 	NSDate系统时间类型
 *
 *	@return	返回默认格式yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)encodeTime:(NSDate *)date

{
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [formatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
    }
}

/**
 *	@brief	字符串格式化为时间格式
 *
 *	@param 	dateString 	默认格式yyyy-MM-dd HH:mm:ss 兼容 yyyy-MM-dd HH:mm:ss.SSS
 *
 *	@return	返回时间格式
 */
+ (NSDate *)dencodeTime:(NSString *)dateString
{
    @try {
        
        if (dateString && dateString.length > 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:dateString];
            if (!date) {
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                date =  [formatter dateFromString:dateString];
            }
            return date;
        }

        return nil;
    }
    @catch (NSException *exception)
    {

    }
    @finally {
    }
}

+ (NSString *)convertDateFromCST:(NSString *)_date
{
    if (_date == nil) {
        return nil;
    }
    //return nil;
    NSLog(@"_date==%@",_date);
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss 'CST' yyyy"];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    
    NSDate *formatterDate = [inputFormatter dateFromString:_date];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *newDateString = [outputFormatter stringFromDate:formatterDate];
    return newDateString;
}

/**
 *	@brief	离现在时间相差时间
 *
 *	@param 	date 	时间格式
 *
 *	@return	返回字符串
 */
/**
 *	@brief	离现在时间相差时间
 *
 *	@param 	date 	目标时间
 *
 *	@return	返回字符串
 */
+ (NSString *)timeSinceNow:(NSDate *)date
{
    @try {
        
        NSString *timeStr = @"";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        NSTimeInterval interval = 0 - [date timeIntervalSinceNow];
        
        // 几秒前
        if (interval < 60) {
            timeStr = @"1分钟内";
        }
        // 几分钟前
        else if (interval < (60 * 60)) {
            timeStr = [NSString stringWithFormat:@"%u分钟前", (int)(interval / 60)];
        }
        // 几小时前 （12小时内 返回几小时）
        else if (interval < (12 * 60 * 60)) {
            timeStr = [NSString stringWithFormat:@"%u小时前", (int)(interval / 60 / 60)];
        }
        else {
            NSDate *nowDate = [NSDate date];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *nowComps  = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:nowDate];
            
            NSDateComponents *tempComps = [[NSDateComponents alloc] init];
            [tempComps setHour:-nowComps.hour];
            [tempComps setMinute:-nowComps.minute];
            [tempComps setSecond:-nowComps.second];
            NSDate *todayZeroDate = [calendar dateByAddingComponents:tempComps toDate:nowDate options:0];
            
            //!注意 是从今天凌晨开始算往前24小时之内叫昨天 不是从当前时间开始算
            //获取 date 距离今天零点时刻的时间差 来计算 是否是昨天，前天，...
            NSTimeInterval intervalToZero = [todayZeroDate timeIntervalSinceDate:date];
            NSInteger days = intervalToZero / (24 * 60 * 60);
            
            // 昨天
            if (days < 1) {
                [formatter setDateFormat:@"昨天"];
                timeStr = [formatter stringFromDate:date];
            }
            // 前天
            else if (days < 2) {
                [formatter setDateFormat:@"前天"];
                timeStr = [formatter stringFromDate:date];
            }
            // 一星期内 返回几天前
            else if(days < 7) {
                timeStr = [NSString stringWithFormat:@"%ld天前", (long)days + 1];
            }
            // 返回具体时间字符串
            else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeStr = [formatter stringFromDate:date];
            }
        }
        
        return timeStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
    }
}
/**
 *	@brief	把秒转化为时间字符串显示，播放器常用
 *
 *	@param 	durartion 	传入参数
 *
 *	@return	播放器播放进度时间，比如
 */
+ (NSString *)changeSecondsToString:(CGFloat)durartion
{
//    int hh = durartion/(60 * 60);
//    int mm = hh > 0 ? (durartion - 60*60)/60 : durartion/60;
//    int ss = (int)durartion%60;
//    NSString *hhStr,*mmStr,*ssStr;
//    if (hh == 0) {
//        hhStr = @"00";
//    }else if (hh > 0 && hh < 10) {
//        hhStr = [NSString stringWithFormat:@"0%d",hh];
//    }else {
//        hhStr = [NSString stringWithFormat:@"%d",hh];
//    }
//    if (mm == 0) {
//        mmStr = @"00";
//    }else if (mm > 0 && mm < 10) {
//        mmStr = [NSString stringWithFormat:@"0%d",mm];
//    }else {
//        mmStr = [NSString stringWithFormat:@"%d",mm];
//    }
//    if (ss == 0) {
//        ssStr = @"00";
//    }else if (ss > 0 && ss < 10) {
//        ssStr = [NSString stringWithFormat:@"0%d",ss];
//    }else {
//        ssStr = [NSString stringWithFormat:@"%d",ss];
//    }
//    return [NSString stringWithFormat:@"%@:%@:%@",hhStr,mmStr,ssStr];
    return [self timeToHMS:durartion];
}

/**
 *	@brief	格式化时间为字符串
 *
 *	@param 	date 	时间
 *	@param 	format 	格式化字符串
 *
 *	@return	返回时间字符串
 */
+ (NSString *)encodeTime:(NSDate *)date format:(NSString *)format

{
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        return [formatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
    }
    
}

/**
 *	@brief  格式化成时间格式
 *
 *	@param 	dateString 	时间字符串
 *	@param 	format 	格式化字符串
 *
 *	@return	返回时间格式
 */
+ (NSDate *)dencodeTime:(NSString *)dateString format:(NSString *)format

{
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        return [formatter dateFromString:dateString];
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
    }
}

+ (NSString *)encodeTime_China:(NSDate *)date {
    return [self encodeTime_China:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)encodeTime_China:(NSDate *)date format:(NSString *)format {
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        return [formatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
    }
}

+ (NSString *)timeToHMS:(CGFloat)time{
    NSInteger hh = time/3600;
    NSInteger mm = (time-3600*hh)/60;
    NSInteger ss = (time-3600*hh-60*mm);
    
    NSString *hhStr = [NSString stringWithFormat:@"%@%d",hh<10?@"0":@"",hh];
    NSString *mmStr = [NSString stringWithFormat:@"%@%d",mm<10?@"0":@"",mm];
    NSString *ssStr = [NSString stringWithFormat:@"%@%d",ss<10?@"0":@"",ss];
    
    return [NSString stringWithFormat:@"%@:%@:%@",hhStr,mmStr,ssStr];
}

+ (NSString *)timeToMS:(CGFloat)time {
    NSInteger mm = time/60;
    NSInteger ss = (time-60*mm);
    
    NSString *mmStr = [NSString stringWithFormat:@"%@%d",mm<10?@"0":@"",mm];
    NSString *ssStr = [NSString stringWithFormat:@"%@%d",ss<10?@"0":@"",ss];
    
    return [NSString stringWithFormat:@"%@:%@",mmStr,ssStr];
}

+ (NSInteger)hmsToTime:(NSString *)text{
    NSInteger total = 0;
    NSArray *length = [text componentsSeparatedByString:@":"];
    for (NSInteger i = length.count; i>0; i--) {
        NSInteger c = [length[i-1] integerValue];
        total+=c*pow(60, length.count-i);
    }
    return total;
}

@end
