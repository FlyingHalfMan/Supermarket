//
//  CommUtls+DeviceInfo.m
//  DL
//
//  Created by cyx on 14-9-19.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls+DeviceInfo.h"


#define HEAD   @":"
#define END    @"Mobile Country Code"
#import <CommonCrypto/CommonDigest.h>
#import  <dlfcn.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#import  <CommonCrypto/CommonCryptor.h>
#import  <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <OpenUDID/OpenUDID.h>
#import <Reachability/Reachability.h>
#import <UICKeyChainStore/UICKeyChainStore.h>


@implementation CommUtls (DeviceInfo)



+ (NSString *)getSystemVersion
{
    NSString *system = nil;
    system = [[UIDevice currentDevice] systemVersion];
    if(system != nil)
    {
        if([system length]>3)
        {
            system = [system substringToIndex:3];
        }
    }
    return system;
}


+ (NSString *)getUniqueIdentifier
{
    return [OpenUDID value];
}


+ (NSString *)getOperator
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString * str = [carrier description];
    str = [str substringToIndex:[str rangeOfString:END].location];
    str = [str substringFromIndex:[str rangeOfString:HEAD].location+1];
    str = [str substringFromIndex:[str rangeOfString:@"["].location+1];
    str = [str substringToIndex:[str rangeOfString:@"]"].location];
    return str;
}


+ (NSString *)getResolution
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    NSString *resolution = [NSString stringWithFormat:@"%f*%f",size.width,size.height];
    return resolution;
}


+ (NSString *)getModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}


+ (NSString *)getNetworkType
{
    @try {
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if( status == ReachableViaWiFi)
        {
            return @"wifi";
        }
        else if( status == ReachableViaWWAN)
        {
            return @"wwan";
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    return @"";
}


+ (NSString *)getShareUniqueIdentifier
{
    return [CommUtls getShareUniqueIdentifierForCompany:@"898NAN8W82.com.cdeledu.share"];
}


+ (NSString *)getShareUniqueIdentifierForCompany:(NSString *)str
{
    NSString *deviceid = @"";
    UICKeyChainStore *keychainStoreShare = [UICKeyChainStore keyChainStoreWithService:@"com.cdeledu" accessGroup:str];
    deviceid = keychainStoreShare[@"deviceid"];
    if(nil == deviceid)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        deviceid = [defaults stringForKey:@"open_udid"];
        if(nil == deviceid)
        {
            deviceid = [defaults stringForKey:@"openudid"];
            if(nil == deviceid)
            {
                deviceid = [OpenUDID value];
                [defaults setValue:deviceid forKey:@"open_udid"];
                [defaults synchronize];
            }
        }
        keychainStoreShare[@"deviceid"] = deviceid;
    }
    return deviceid;
}

+ (UIImage *)getScreenImage
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+ (NSString *)createUuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (NSString *)fetchPlatformValue {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if ([infoDictionary[@"UIDeviceFamily"] isKindOfClass:[NSArray class]]) {
        if ([infoDictionary[@"UIDeviceFamily"] count] == 1) {
            NSInteger device = [[infoDictionary[@"UIDeviceFamily"] firstObject] integerValue];
            if (device == 1) {
                return @"0";
            } else if (device == 2) {
                return @"5";
            }
        }
    }
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad?@"5":@"0");
}



+ (NSString *)appNameForLogin
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app名称
    NSString *app_Name  = @"";
    @try {
        app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    } @catch (NSException *exception) {
        
    } @finally {
        app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    }
    
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:app_Name];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str lowercaseString];
    //获取并返回首字母
    NSMutableString * First = [NSMutableString stringWithString:pinYin];
    NSString * ABC =[[NSString alloc]init];
    BOOL insert = YES;
    for (int i = 0; i<First.length; i++) {
        unichar C = [First characterAtIndex:i];
        if(C<= 'z' && C>='a') {
            if(insert)
            {
                ABC = [ABC stringByAppendingFormat:@"%C",C];
                insert = NO;
            }
        }
        else if(C == ' ')
        {
            insert = YES;
        }
    }
    return [NSString stringWithFormat:@"%@%@",ABC,[CommUtls fetchPlatformValue]];
}

@end
