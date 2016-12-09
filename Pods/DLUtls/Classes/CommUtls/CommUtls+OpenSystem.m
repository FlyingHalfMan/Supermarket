//
//  CommUtls+OpenSystem.m
//  CdeleduUtls
//
//  Created by 陈轶翔 on 14-3-30.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls+OpenSystem.h"

@implementation CommUtls (OpenSystem)



/**
 *	@brief	发短信
 *
 *	@param 	phoneNumber 	手机号码
 */
+ (void)goToSmsPage:(NSString*)phoneNumber

{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNumber]]];
}

/**
 *	@brief	打开网页
 *
 *	@param 	url 	网页地址
 */
+ (void)openBrowse:(NSString*)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/**
 *	@brief	发送邮件
 *
 *	@param 	email 	email地址
 */
+ (void)openEmail:(NSString*)email;

{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",email]]];
}


+ (void)goToAppStoreHomePage:(NSInteger)appid
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%ld&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appid];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


+ (void)goToLocationService
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
}


+ (void)goToNotificationService
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"]];
}


+ (void)goToSetTimeService
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=DATE_AND_TIME"]];
}

@end
