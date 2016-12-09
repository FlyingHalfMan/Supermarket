//
//  CommUtls.h
//  UtlBox
//
//  Created by cdel cyx on 12-7-10.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

/*
 framework   UIKit  CoreGraphics SystemConfiguration
 */
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>




@interface CommUtls : NSObject

/**
 *  获取文件大小用KB MB G 显示
 *
 *  @param number 文件数字大小
 *
 *  @return 返回例如12KB
 */
+ (NSString *)getSize:(NSNumber *)number;

/**
 *  获取磁盘剩余空间
 *
 *  @return 剩余多少
 */
+ (NSNumber *)freeDiskSpace;

/**
 *  获取磁盘总大小
 *
 *  @return <#return value description#>
 */
+ (NSNumber *)totalDiskSpace;

/**
 *  获取随即数
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return <#return value description#>
 */
+ (NSInteger)getRandomNumber:(NSInteger)min maxNumber:(NSInteger)max;

/**
 *  获取颜色值
 *
 *  @param stringToConvert <#stringToConvert description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  获取UILabel高度
 *
 *  @param str        内容
 *  @param front      字体
 *  @param frontwidth 内容宽度
 *
 *  @return <#return value description#>
 */
+ (CGFloat)returnHeightFloat:(NSString *)str frontSize:(UIFont *)front frontWidth:(CGFloat)frontwidth;


/**
 *  图片压缩
 *
 *  @param image    <#image description#>
 *  @param viewsize <#viewsize description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)image:(UIImage *)image fitInsize:(CGSize)viewsize;

/**
 *  获取当前时间
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)systemTime:(NSString *)format;

/**
 *  过滤xml
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)specialCharForXML:(NSString *)str;

//根据info属性名赋值
+ (NSObject *)initPropertyWithClass:(NSObject *)infoObject fromDic:(NSDictionary *)jsonDic;

//计算文本的大小
+ (CGSize)getContentSize:(NSString *)content font:(UIFont *)font size:(CGSize)size;

/**
 *  获取软件显示版本号
 *
 *  @return <#return value description#>
 */
+ (NSString *)getSoftShowVersion;

/**
 *  获取软件内部版本号
 *
 *  @return <#return value description#>
 */
+ (NSString *)getSoftBuildVersion;



+ (NSString *)md5EncryptWithParams:(NSArray *)params;

/**
 *  根据text字段排序
 *
 *  @param array 数据源
 *  @param text  排序字段
 *  @param desc  是否降序
 *
 *  @return 排列后的数据
 */
+ (NSArray*)sequenceArray:(NSArray*)array text:(NSString*)text desc:(BOOL)desc;

/**
 *  根据text字段将fromArray数组的数据添加到toArray中字典的key字段里
 *
 *  @param fromArray 需要添加的数据源
 *  @param text      根据字段
 *  @param toArray   添加到的数据源
 *  @param key       添加到toArray中数据的key字段
 *
 *  @return 添加完成的数据源
 */
+ (NSArray*)packageArray:(NSArray*)fromArray text:(NSString*)text forArray:(NSArray*)toArray key:(NSString*)key;



/**
 *  获取持有当前UIView的UIViewController
 *
 *  @param sourceView 所包含的view
 *
 *  @return vc
 */
+ (UIViewController *)findViewController:(UIView *)sourceView;

@end
