//
//  DLiConsole.m
//  MobileClassPhone
//
//  Created by SL on 15/6/16.
//  Copyright (c) 2015年 CDEL. All rights reserved.
//

#import "DLiConsole.h"
#import <DLUtls/CommUtls+Time.h>
#import <MD5Digest/NSString+MD5.h>
#import <CommonCrypto/CommonDigest.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import "DLInterfaceCrypto.h"
#import "DLLogView.h"
#import "DLLog.h"
#import "DLHttpUtls.h"
#import "CommUtls+DeviceInfo.h"

#pragma mark - DLLogUploadHelper

@interface DLLogUploadHelper()

/**
 *  上传日志状态
 */
@property (nonatomic, assign) DL_Upload_Log_Status DLStatus;

@end

@implementation DLLogUploadHelper

#pragma mark 单例

static DLLogUploadHelper *singleInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        singleInstance = [[super allocWithZone:NULL] init];
        
        // 如果日志没打开，全局日志就关闭
        if(![DLLog sharedInstance].isUseLog)
            [DLLog sharedInstance].isGlobalLog = NO;
        
        singleInstance.openLog = (![DLLog sharedInstance].isUseLog && ![DLLog sharedInstance].isGlobalLog? NO : YES);
    });
    
    return singleInstance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
    return [DLLogUploadHelper sharedInstance];
}

+ (instancetype)copy
{
    return [DLLogUploadHelper sharedInstance];
}

#pragma mark - 私有方法
- (void)closeLog
{
    [DLLog sharedInstance].isUseLog = NO;
    [DLLog sharedInstance].isGlobalLog = NO;
}

- (NSString *)fetchLogMsg
{
    NSString *text = [NSString stringWithFormat:@"DLLog\n上传时间：%@\n设备名称：%@\n设备信息：%@\n系统版本号：%@\n软件版本号：%@\n--------------------------------------\n\n",
                      [CommUtls encodeTime:[NSDate date]],
                      [UIDevice currentDevice].name,
                      [CommUtls getModel],
                      [UIDevice currentDevice].systemVersion,
                      [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]
                      ];
    NSArray *log = [DLLog fetchLoggingMsg];
    if (log.count) {
        text = [text stringByAppendingString:[[log arrayByAddingObject:@">"] componentsJoinedByString:@"\n"]];
    }
    return text;
}

- (NSString *)md5_16:(NSString *)imagStr
{
    const char *cStr = [imagStr UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    NSString *returnStr =  [NSString stringWithFormat:
                            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
                            ];
    
    if ([returnStr length] > 15) {
        returnStr = [returnStr substringWithRange:NSMakeRange(8, 16)];
    }
    return returnStr;
}

- (void)uploadLog
{
    if (self.deviceId && self.appkey && self.DLStatus != DL_Upload_Log_Status_Doing) {
        self.DLStatus = DL_Upload_Log_Status_Doing;
        __weak DLLogUploadHelper *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *content = [self fetchUploadContent];
            if (content) {
                [weakSelf uploadRz:content
                           success:^(NSString *path) {
                               [weakSelf uploadStatisticsMsg:path
                                                     success:^{
                                                         weakSelf.DLStatus = DL_Upload_Log_Status_Success;
                                                         [DLLog clearLoggingMsg];
                                                     } fail:^{
                                                         weakSelf.DLStatus = DL_Upload_Log_Status_Fail;
                                                     }];
                           } fail:^{
                               weakSelf.DLStatus = DL_Upload_Log_Status_Fail;
                           }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.DLStatus = DL_Upload_Log_Status_None;
                });
            }
        });
    }
}

/**
 *  获取上传的内容，没有返回nil
 */
- (NSString *)fetchUploadContent {
    NSString *msg = [self fetchLogMsg];
    NSMutableArray *array = [NSMutableArray new];
    [[msg componentsSeparatedByString:@"\n"] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *txt = obj;
        if ([txt rangeOfString:@"CDEL"].location != NSNotFound) {
            NSArray *array1 = [txt componentsSeparatedByString:@"CDEL"];
#ifdef DEBUG
            NSLog(@"%@==%@",[array1 firstObject],[array1 lastObject]);
#endif
            txt = [NSString stringWithFormat:@"%@%@",[array1 firstObject],[DLInterfaceCrypto DL_DESDecrypt:[array1 lastObject] withKey:@"cdel0927"]];
        }
        if (txt) {
            [array addObject:txt];
        }
    }];
    if (array.count>11) {
        return [DLInterfaceCrypto DL_DESEncrypt:[array componentsJoinedByString:@"\n"]
                                        withKey:@"cdel0927"];
    }
    return nil;
}

/**
 *  上传文件到服务器
 */
- (void)uploadRz:(NSString *)content
         success:(void(^)(NSString *path))success
            fail:(void(^)())fail{
    NSString *time = [CommUtls encodeTime:[NSDate date]];
    NSString *pkey = [[NSString stringWithFormat:@"%@%@",
                       time,
                       @"eiiskdui"]MD5Digest];
    NSString *origin = @"YXFJ";
    NSString *securecode = [NSString stringWithFormat:@"tttKKK!#%%&333222%@%@",
                            origin,
                            time
                            ];
    
    NSDictionary *params = @{
                             @"time":time,
                             @"origin":origin,
                             @"securecode":[self md5_16:securecode],
                             };
    
    NSString *url = @"http://manage.mobile.cdeledu.com/analysisApi/upload/getUploadFile.shtm";
    url = [[url stringByAppendingFormat:@"?pkey=%@&time=%@",pkey,time] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc_path = [path objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[doc_path stringByAppendingPathComponent:@"rz"]
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    NSString *_filename = [doc_path stringByAppendingPathComponent:@"rz/a.txt"];
    if ([manager createFileAtPath:_filename contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
        CGFloat size = [[manager attributesOfItemAtPath:_filename error:nil] fileSize]/(1000.0*1000.0);
#ifdef DEBUG
        NSLog(@"日志文件大小==%f",size);
#endif
        if (size > 5) {
            [manager removeItemAtPath:_filename error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLLog clearLoggingMsg];
                fail();
            });
        }else {
            [DLHttpUtls DLUploadAsynchronous:url
                                  parameters:params
                                       files:@[_filename]
                                    fileData:nil
                                    fileName:nil
                                locationFile:nil
                                    complete:^(NSString *str) {
                                        NSDictionary *dic = [str objectFromJSONString];
                                        if ([dic[@"code"] integerValue] == 1) {
#ifdef DEBUG
                                            NSLog(@"上传日志文件成功==%@",dic);
#endif
                                            success(dic[@"result"]);
                                        }else{
                                            fail();
                                        }
                                    } fail:^(NSError *err) {
                                        fail();
                                    }];
        }
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail();
        });
    }
}

/**
 *  上传日志信息到统计系统
 *
 *  @param fileUrl 日志地址
 *
 */
- (void)uploadStatisticsMsg:(NSString *)fileUrl
                    success:(void(^)())success
                       fail:(void(^)())fail{
    NSString *time = [CommUtls encodeTime:[NSDate date]];
    NSString *pkey = [[NSString stringWithFormat:@"%@%@%@%@",
                       self.deviceId,
                       self.appkey,
                       time,
                       @"eiiskdui"]MD5Digest];
    NSDictionary *params = @{
                             @"pkey":pkey,
                             @"deviceid":self.deviceId,
                             @"versionname":[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"],
                             @"appkey":self.appkey,
                             @"content":fileUrl,
                             @"time":time,
                             };
    
    [DLHttpUtls DLGetAsynchronous:@"http://manage.mobile.cdeledu.com/analysisApi/log/insertLog.shtm"
                       parameters:params
                     locationFile:nil
                         complete:^(NSString *str) {
                             NSDictionary *dic = [str objectFromJSONString];
                             if ([dic[@"code"] integerValue] == 1) {
                                 success();
                             }else{
                                 fail();
                             }
                         }
                             fail:^(NSError *err) {
                                 fail();
                             }];
}

#pragma mark - getter and setter

- (void)setOpenLog:(BOOL)openLog
{
    _openLog = openLog;
    
    if (openLog) {
        __weak DLLogUploadHelper *wself = self;
        [[DLLogView sharedInstance] setClickBlock:^{
            [wself uploadLog];
        } longPressBlock:^{
            [wself closeLog];
        }];
        [DLLogView showInWindow];
    }
    else {
        [[DLLogView sharedInstance] setClickBlock:nil longPressBlock:nil];
        [DLLogView hide];
    }
}

- (void)setDLStatus:(DL_Upload_Log_Status)DLStatus {
    _DLStatus = DLStatus;
    switch (DLStatus) {
        case DL_Upload_Log_Status_Init: {
            [DLLogView sharedInstance].message = @"点击上传";
            [DLLogView sharedInstance].isLoading = NO;
            break;
        }
        case DL_Upload_Log_Status_Doing: {
            [DLLogView sharedInstance].message = @"上传中";
            [DLLogView sharedInstance].isLoading = YES;
            break;
        }
        case DL_Upload_Log_Status_Success: {
            [DLLogView sharedInstance].message = @"上传成功";
            [DLLogView sharedInstance].isLoading = NO;
            break;
        }
        case DL_Upload_Log_Status_Fail: {
            [DLLogView sharedInstance].message = @"上传失败";
            [DLLogView sharedInstance].isLoading = NO;
            break;
        }
        case DL_Upload_Log_Status_None: {
            [DLLogView sharedInstance].message = @"暂无信息";
            [DLLogView sharedInstance].isLoading = NO;
            break;
        }
    }
}

@end
