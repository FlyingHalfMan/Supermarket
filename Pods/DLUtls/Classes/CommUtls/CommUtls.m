
//
//  CommUtls.m
//  UtlBox
//
//  Created by cdel cyx on 12-7-10.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import "CommUtls.h"

#import  <dlfcn.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#import "RegexKitLite.h"
#import  <CommonCrypto/CommonCryptor.h>
#import <MD5Digest/NSString+MD5.h>
#import  <SystemConfiguration/SystemConfiguration.h>
#import <objc/runtime.h>
#include <sys/param.h>
#include <sys/mount.h>


// IP HEAD
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/ethernet.h>

@implementation CommUtls

/**
 *	@brief	通过字节获取文件大小
 *
 *	@param  number  字节数
 *
 *	@return	返回大小
 */
+ (NSString *)getSize:(NSNumber *)number
{
    long long size = [number longLongValue];
    if (size < 1024)
        return [NSString stringWithFormat:@"%lldB", size];
    else {
        long long size1 = size/1024;
        if (size1 < 1024) {
            return [NSString stringWithFormat:@"%lld.%lldKB", size1, (size-size1*1024)/10];
        } else {
            long long size2 = size1/1024;
            if (size2 < 1024)
                return [NSString stringWithFormat:@"%lld.%lldMB", size2, (size1-size2*1024)/10];
            else {
                long long size3 = size2/1024;
                return [NSString stringWithFormat:@"%lld.%lldGB", size3, (size2-size3*1024)/10];
            }
        }
    }
    return @"0B";
}

/**
 *	@brief	获取随即数
 *
 *	@param  min     最小数值
 *	@param  max     最大数值
 *
 *	@return	返回数值
 */
+ (NSInteger)getRandomNumber:(NSInteger)min maxNumber:(NSInteger)max
{
    NSInteger value = 0;
    if (min > 0)
        value = (arc4random() % (max-min+1)) + min;
    else
        value = arc4random() % max;
    return value;
}

/**
 *	@brief	获取颜色
 *
 *	@param  stringToConvert         取色数值
 *
 *	@return	返回颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

/**
 *	@brief	UILabel高度
 *
 *	@param  str     文字
 *	@param  front   字体
 *	@param  frontwidth      UILabel宽度
 *
 *	@return	返回高度
 */
+ (CGFloat)returnHeightFloat:(NSString *)str frontSize:(UIFont *)front frontWidth:(CGFloat)frontwidth
{
    CGSize asize = CGSizeMake(frontwidth, 5000);
    CGSize labelsize = [str sizeWithFont:front constrainedToSize:asize lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize.height;
}



/**
 *	@brief	转换字符串编码
 *
 *	@param  s       字符串
 *
 *	@return	返回UTF-8的编码
 */
+ (NSString *)encode:(NSString *)s
{
    return [s stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
}

/**
 * @brief 图片压缩
 *  UIGraphicsGetImageFromCurrentImageContext函数完成图片存储大小的压缩
 * Detailed
 * @param[in] 源图片；指定的压缩size
 * @param[out] N/A
 * @return 压缩后的图片
 * @note
 */
+ (UIImage *)image:(UIImage *)image fitInsize:(CGSize)viewsize
{
    CGFloat scale;
    CGSize newsize = image.size;
    if (newsize.height && (newsize.height > viewsize.height)) {
        scale = viewsize.height/newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    if (newsize.width && (newsize.width >= viewsize.width)) {
        scale = viewsize.width /newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    UIGraphicsBeginImageContext(viewsize);
    
    float dwidth = (viewsize.width - newsize.width)/2.0f;
    float dheight = (viewsize.height - newsize.height)/2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, newsize.width, newsize.height);
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)systemTime:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [[NSDate date] timeIntervalSince1970];
    [formatter setDateFormat:format];
    NSString *returnTime = [formatter stringFromDate:date];
    return returnTime;
}

+ (NSString *)specialCharForXML:(NSString *)str
{
    if (str != nil) {
        str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        str = [str stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
        str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }
    return str;
}

/**
 *	@brief	转换字典对象,根据info属性名赋值
 *
 *	@param  infoObject      <#infoObject description#>
 *	@param  jsonDic         <#jsonDic description#>
 *
 *	@return	<#return value description#>
 */
+ (NSObject *)initPropertyWithClass:(NSObject *)infoObject fromDic:(NSDictionary *)jsonDic
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([infoObject class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if ([jsonDic valueForKey:propertyNameStr] != nil) {
            [infoObject setValue:[jsonDic valueForKey:propertyNameStr] forKey:propertyNameStr];
        }
    }
    free(properties);
    return infoObject;
}

+ (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

+ (NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

//计算文本的大小
+ (CGSize)getContentSize:(NSString *)content font:(UIFont *)font size:(CGSize)size
{
    BOOL IsIOS7 = ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ? YES : NO);
    CGSize cSize;
    if (IsIOS7) {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        cSize = [content boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    } else {
        cSize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return cSize;
}

+ (NSString *)getSoftShowVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getSoftBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}



+ (NSString *)md5EncryptWithParams:(NSArray *)params
{
    NSString *str = @"";
    for (int i = 0; i < params.count; i++) {
        str = [str stringByAppendingString:[params objectAtIndex:i]];
    }
    str = [str MD5Digest];
    return str;
}

/**
 *  根据text字段排序
 *
 *  @param array 数据源
 *  @param text  排序字段
 *  @param desc  是否降序
 *
 *  @return 排列后的数据
 */
+ (NSArray *)sequenceArray:(NSArray *)array text:(NSString *)text desc:(BOOL)desc
{
    if (array.count == 0) {
        return array;
    }
    
    //排序
    NSMutableArray *marray1 = [NSMutableArray arrayWithArray:array];
    
    for (int i = 0; i < marray1.count-1; i++) {
        for (int j = 0; j < marray1.count-1-i; j++) {
            NSDictionary *dic1 = [marray1 objectAtIndex:j];
            NSDictionary *dic2 = [marray1 objectAtIndex:(j+1)];
            
            BOOL change = NO;
            if (desc && [[dic2 objectForKey:text] intValue] > [[dic1 objectForKey:text] intValue]) {
                change = YES;
            } else if (!desc && [[dic2 objectForKey:text] intValue] < [[dic1 objectForKey:text] intValue]) {
                change = YES;
            }
            if (change) {
                [marray1 replaceObjectAtIndex:j withObject:dic2];
                [marray1 replaceObjectAtIndex:(j+1) withObject:dic1];
            }
        }
    }
    return marray1;
}

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
+ (NSArray *)packageArray:(NSArray *)fromArray text:(NSString *)text forArray:(NSArray *)toArray key:(NSString *)key
{
    if (toArray.count == 0) {
        return toArray;
    }
    
    //fromArray数据组装
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    for (NSDictionary *d1 in fromArray) {
        NSString *title = [NSString stringWithFormat:@"%@", [d1 objectForKey:text]];
        if (![dic objectForKey:title]) {
            [dic setObject:[NSMutableArray arrayWithCapacity:1] forKey:title];
        }
        NSMutableArray *array = [dic objectForKey:title];
        [array addObject:d1];
    }
    
    //组装数据
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < toArray.count; i++) {
        NSDictionary *d2 = [toArray objectAtIndex:i];
        NSString *title = [NSString stringWithFormat:@"%@", [d2 objectForKey:text]];
        
        NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithDictionary:d2];
        [array addObject:d3];
        if ([dic objectForKey:title]) {
            [d3 setObject:[dic objectForKey:title] forKey:key];
        }
    }
    
    return array;
}

+ (UIViewController *)findViewController:(UIView *)sourceView{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
