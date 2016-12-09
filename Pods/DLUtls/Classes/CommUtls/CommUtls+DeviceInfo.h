//
//  CommUtls+DeviceInfo.h
//  DL
//
//  Created by cyx on 14-9-19.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

/*
 framework  CoreTelephony  SystemConfiguration
 */

#import "CommUtls.h"

@interface CommUtls (DeviceInfo)

/**
 *  获取设备系统版本
 *
 *  @return 设备系统版本信息
 */
+ (NSString *)getSystemVersion;

/**
 *  获取设备唯一编码
 *
 *  @return 设备唯一编码
 */
+ (NSString *)getUniqueIdentifier;

/**
 *  获取设备运营商信息
 *
 *  @return 运营商名字
 */
+ (NSString *)getOperator;

/**
 *  获取设备屏幕分辨率
 *
 *  @return 屏幕分辨率
 */
+ (NSString *)getResolution;

/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
+ (NSString *)getModel;

/**
 *  获取设备网络状态
 *
 *  @return 设备网络状态
 */
+ (NSString *)getNetworkType;

/**
 *  同一家公司获取相同设备值,默认为正保远程教育
 *
 *  @return <#return value description#>
 */
+ (NSString *)getShareUniqueIdentifier;

/**
 *  同一家公司获取相同设备值
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getShareUniqueIdentifierForCompany:(NSString *)str;

/**
 *  获取截屏图片
 *
 *  @return 截屏图片
 */
+ (UIImage *)getScreenImage;

/**
 *	获取一个唯一码
 */
+ (NSString *)createUuidString;

/**
 *  获取平台号
 */
+ (NSString *)fetchPlatformValue;


/**
 *  获取登录时候的appname  规则取软件名首字母小写加上平台号
 *
 *  @return 返回appname
 */
+ (NSString *)appNameForLogin;

@end
