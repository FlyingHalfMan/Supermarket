//
//  DLiConsole.h
//  MobileClassPhone
//
//  Created by SL on 15/6/16.
//  Copyright (c) 2015年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DL_Upload_Log_Status) {
    DL_Upload_Log_Status_Init = 0,
    DL_Upload_Log_Status_Doing,
    DL_Upload_Log_Status_Success,
    DL_Upload_Log_Status_Fail,
    DL_Upload_Log_Status_None,
};

#pragma mark - DLLogUploadHelper

/**
 *  日志上传管理
 */
@interface DLLogUploadHelper : NSObject

/**
 *  设备ID
 */
@property (nonatomic, strong) NSString *deviceId;

/**
 *  应用唯一标识
 */
@property (nonatomic, strong) NSString *appkey;

/**
 *  是否打开日志
 */
@property (nonatomic, assign) BOOL openLog;

+ (instancetype)sharedInstance;

@end
