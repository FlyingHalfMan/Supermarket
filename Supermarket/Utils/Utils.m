//
//  Utils.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/5.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString *)currentDate{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+(NSInteger)getDateDuration:(NSDate *)date{
    
    NSDate* currentDate = [NSDate date];
   return  [date timeIntervalSinceDate:currentDate];
}

+(NSDate *)parseStringToDate:(NSString*)dateString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateString];
}
+(NSString *)parseDateToString:(NSDate *)date{
   
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
@end
