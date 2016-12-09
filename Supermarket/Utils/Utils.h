//
//  Utils.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/5.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

// 获取当前系统时间
+(NSString*)currentDate;
// 计算指定时间到现在时间到时间差
+(NSInteger)getDateDuration:(NSDate*)date;
//格式化时间
+(NSString*)parseDateToString:(NSDate*)date;

+(NSDate*)parseStringToDate:(NSString*)dateString;
@end
