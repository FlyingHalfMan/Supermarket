//
//  CommUtls+OpenSystem.h
//  CdeleduUtls
//
//  Created by 陈轶翔 on 14-3-30.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls.h"

@interface CommUtls (OpenSystem)



//跳到短信页面
+ (void)goToSmsPage:(NSString*)phoneNumber;

//打开浏览器
+ (void)openBrowse:(NSString*)url;

//打开EMAIL
+ (void)openEmail:(NSString*)email;

/**
 *  去苹果电子市场评论页面
 *
 *  @param appid <#appid description#>
 */
+ (void)goToAppStoreHomePage:(NSInteger)appid;

/**
 *  去本地定位设置界面
 */
+ (void)goToLocationService;

/**
 *  去通知界面
 */
+ (void)goToNotificationService;


/**
 *  去时间设置界面
 */
+ (void)goToSetTimeService;



@end
