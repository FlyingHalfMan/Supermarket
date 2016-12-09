//
//  StatisticsPlist.m
//  DownLoadManger
//
//  Created by cyx on 12-10-9.
//  Copyright (c) 2012年 cyx. All rights reserved.
//

#import "StatisticsPlist.h"
#import "CommUtls.h"


@implementation StatisticsPlist


+ (NSMutableDictionary *)statisticsInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:10];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *app_version = [defaults valueForKey:@"app_version"];
    NSString *app_use_time = [defaults valueForKey:@"app_use_time"];
    NSDate *app_start_time = (NSDate *)[defaults valueForKey:@"app_start_time"];
    [dic setValue:app_start_time forKey:@"app_use_time"];
    [dic setValue:app_version forKey:@"app_version"];
    [dic setValue:app_use_time forKey:@"app_use_time"];
    return dic;
}


+ (void)recordAppUsedTime:(NSDate *)time
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *app_start_time = (NSDate *)[defaults valueForKey:@"app_start_time"];
    NSInteger interval = [time timeIntervalSinceDate:app_start_time];
    [defaults setValue:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"app_use_time"];
    [defaults synchronize];
}


+ (void)recordStartTime:(NSDate *)time
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[CommUtls getSoftShowVersion] forKey:@"app_version"];
    [defaults setValue:time forKey:@"app_start_time"];
    [defaults synchronize];
}

+ (void)setIgnoreUpdate:(NSString *)version
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:version forKey:@"app_ignore_version"];
    [defaults synchronize];
}

+ (NSString *)ignoreUpdate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults valueForKey:@"app_ignore_version"];
}

+ (void)setComment:(NSString *)comment
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:comment forKey:@"app_comment"];
    [defaults synchronize];
}

+ (NSString *)comment
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults valueForKey:@"app_comment"];
}


+ (void)recordStartCount:(NSInteger)count
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithLong:count] forKey:@"app_start_count"];
    [defaults synchronize];
}

+ (NSInteger)startCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"app_start_count"];
}



+ (BOOL)judgeToShowIntroduce {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *judge = [defaults objectForKey:@"app_introduce"];
  if (judge.length == 0 || !judge) {
    [defaults setObject:[NSString stringWithFormat:@"%@/0", [CommUtls getSoftShowVersion]] forKey:@"app_introduce"];
    return YES;
  } else {
    BOOL doesShow = [[judge componentsSeparatedByString:@"/"].lastObject boolValue];
    if (doesShow) {
      [defaults setObject:[NSString stringWithFormat:@"%@/0", [CommUtls getSoftShowVersion]] forKey:@"app_introduce"];
    }
    return doesShow;
  }
}

+ (void)thisVersionNeedShowNewIntroduce:(NSString *)version {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *judge = [defaults objectForKey:@"app_introduce"];
  if (![judge hasPrefix:version]) {
    [defaults setObject:[NSString stringWithFormat:@"%@/1", version] forKey:@"app_introduce"];
  }
}

+ (BOOL)hasReleased {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *judge = [defaults objectForKey:@"app_release"];
  if (!judge || judge.length == 0) {
    return NO;
  } else {
    if ([judge hasPrefix:[CommUtls getSoftShowVersion]]) {
      BOOL isReleased = [[judge componentsSeparatedByString:@"/"].lastObject boolValue];
      return isReleased;
    } else {
      return NO;
    }
  }
}

+ (void)configAppState:(NSString *)state {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSString stringWithFormat:@"%@/%@", [CommUtls getSoftShowVersion], state] forKey:@"app_release"];
}

@end
