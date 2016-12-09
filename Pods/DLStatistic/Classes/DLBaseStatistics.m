//
//  BaseStatistics.m
//  DownLoadManger
//
//  Created by cyx on 12-10-9.
//  Copyright (c) 2012年 cyx. All rights reserved.
//

#import "DLBaseStatistics.h"
#import <UIKit/UIKit.h>
/******第三方******/
#import "JSONKit.h"

/******自定义******/
#import "CommUtls+DeviceInfo.h"
#import "CommUtls+OpenSystem.h"
#import "CommUtls+Time.h"
#import "CommUtls.h"
#import "DLHttpUtls.h"
#import "DLStaticDataBase.h"
#import "EDSemver.h"
#import "FeedBack.h"
#import "StatisticsPlist.h"
#import <GDataXML-HTML/GDataXMLNode.h>
#import "DLUpdateView.h"
#import <DLUIKit/DLAlertShowView.h>

static DLBaseStatistics *sharedObj = nil;

#define IOS_PLATFORM       @"0"

#define PERSON_KEY          @"eiiskdui"

#define UpdateTag   5000000

#define CommentTag  6000000

// 设备基本信息
#define DEVICE_INFO_URL  @"http://manage.mobile.cdeledu.com/analysisApi/uploadBaseInfo.shtm"
// 日志
#define LOG_INFO_URL     @"http://manage.mobile.cdeledu.com/analysisApi/uploadLog.shtm"
// 反馈
#define FEEDBACK_URL     @"http://manage.mobile.cdeledu.com/analysisApi/uploadFeedback.shtm"
// 用户使用时长
#define USE_TIME_URL     @"http://manage.mobile.cdeledu.com/analysisApi/uploadUseTime.shtm"
// 升级
#define UPDATE_URL       @"http://manage.mobile.cdeledu.com/analysisApi/getUpdateInfo.shtm"
// 上传push证书
#define UP_TOKEN_URL     @"http://manage.mobile.cdeledu.com/analysisApi/uploadToken.shtm"
// 是否开启收费用户功能
#define OPEN_FUCTION_URL @"http://manage.mobile.cdeledu.com/analysisApi/ios/openStatus.shtm"
// 离线统计
#define STATIC_URL       @"http://manage.mobile.cdeledu.com/analysisApi/batchUploadBaseInfo.shtm"

@interface DLBaseStatistics ()
<UIAlertViewDelegate>

@end

@implementation DLBaseStatistics

+ (void)submitBaseInfo:(NSString *)appkey
{
    [[self sharedInstance] submitBaseInfo:appkey];
}

+ (void)submitSuggestion:(FeedBack *)feedBack withAppKey:(NSString *)appkey
{
    [[self sharedInstance] submitSuggestion:feedBack AppKey:appkey];
}


+ (void)submitSuggestion:(FeedBack *)feedBack withAppKey:(NSString *)appkey Complete:(DLBaseStatisticsSumbitComplete)sumbitCompleteBlock
{
    NSMutableDictionary *detail = [[NSMutableDictionary alloc]initWithCapacity:10];
    NSString *time = [CommUtls encodeTime:[NSDate date]];
    [detail setValue:[CommUtls md5EncryptWithParams:@[time, PERSON_KEY]] forKey:@"pkey"];
    [detail setValue:time forKey:@"time"];
    [detail setValue:IOS_PLATFORM forKey:@"platform"];
    [detail setValue:appkey forKey:@"appkey"];
    if (feedBack.feedContent != nil)
        [detail setValue:feedBack.feedContent forKey:@"content"];
    if (feedBack.email != nil)
        [detail setValue:feedBack.email forKey:@"email"];
    if (feedBack.phone != nil)
        [detail setValue:feedBack.phone forKey:@"phone"];
    [detail setValue:[CommUtls getUniqueIdentifier] forKey:@"deviceid"];
    [detail setValue:[CommUtls getSoftShowVersion] forKey:@"version"];
    [DLHttpUtls DLGetAsynchronous:FEEDBACK_URL parameters:detail locationFile:nil complete:^(NSString *str){
        sumbitCompleteBlock();
    } fail:^(NSError *err){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"提交失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

+ (void)checkUpdate:(NSString *)appkey
{
    [[self sharedInstance] checkUpdate:appkey isAuto:NO];
}

+ (void)autoCheckUpdate:(NSString *)appkey
{
    [[self sharedInstance] checkUpdate:appkey isAuto:YES];
}

+ (void)submitGoodComment:(NSInteger)appID MaxStartCount:(NSInteger)count
{
    [[self sharedInstance] submitGoodComment:appID MaxStartCount:count];
}

+ (void)submitPreviousUseTime:(NSString *)appkey
{
    [[self sharedInstance] submitPreviousUseTime:appkey];
}

+ (void)recordStartTime
{
    [[self sharedInstance] recordStartTime];
}

+ (void)calculateTime
{
    [[self sharedInstance] calculateTime];
}

+ (BOOL)judgeToShowIntroduce
{
    return [StatisticsPlist judgeToShowIntroduce];
}

+ (void)thisVersionNeedShowNewIntroduce
{
    [StatisticsPlist thisVersionNeedShowNewIntroduce:[CommUtls getSoftShowVersion]];
}

+ (void)judgeAppStateWithCompleted:(void (^)(BOOL status))completed fail:(void (^)(NSError *error))fail
{
    if (![StatisticsPlist hasReleased]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:10];
        NSString *timeStr = [CommUtls encodeTime:[NSDate date]];
        NSString *pkey = [CommUtls md5EncryptWithParams:@[timeStr, PERSON_KEY]];
        NSString *version = [CommUtls getSoftShowVersion];
        NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *freeOpenVersion = [NSString stringWithFormat:@"%@_%@", bundleIdentifier, version];
        [dic setValue:pkey forKey:@"pkey"];
        [dic setValue:timeStr forKey:@"time"];
        [dic setValue:freeOpenVersion forKey:@"freeOpenVersion"];
        [DLHttpUtls DLGetAsynchronous:OPEN_FUCTION_URL parameters:dic locationFile:nil complete:^(NSString *str){
             GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:str error:nil];
             GDataXMLElement *root = [document rootElement];
             GDataXMLElement *status = [root elementsForName:@"status"].firstObject;
             NSString *statusStr = status.stringValue;
             [StatisticsPlist configAppState:statusStr];
             if (completed) {
                 completed([statusStr boolValue]);
             }
         } fail:^(NSError *err){
             if (fail) {
                 fail(err);
             }
         }];
    } else {
        if (completed) {
            completed(YES);
        }
    }
}

+ (BOOL)achiveAppState
{
    return [StatisticsPlist hasReleased];
}

- (NSMutableDictionary *)baseInfo
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithCapacity:10];
    NSString *time = [CommUtls encodeTime:[NSDate date]];
    [info setValue:[CommUtls md5EncryptWithParams:@[time, PERSON_KEY]] forKey:@"pkey"];
    [info setValue:time forKey:@"time"];
    [info setValue:IOS_PLATFORM forKey:@"platform"];
    return info;
}

/**	提交用户信息，启动应用时候调用 */
- (void)submitBaseInfo:(NSString *)appkey
{
    NSMutableDictionary *dic = [self baseInfo];
    [dic setValue:appkey forKey:@"appkey"];

    NSMutableDictionary *apprun = [[NSMutableDictionary alloc]initWithCapacity:10];
    [apprun setValue:[CommUtls encodeTime:[NSDate date]] forKey:@"runtime"];
    [apprun setValue:[CommUtls getNetworkType] forKey:@"network"];
    [apprun setValue:[CommUtls getSoftShowVersion] forKey:@"appversion"];
    if ([CommUtls getOperator] != nil) {
        [apprun setValue:[CommUtls getOperator] forKey:@"operatorer"];
    } else {
        [apprun setValue:@"" forKey:@"operatorer"];
    }

    NSMutableDictionary *phone = [[NSMutableDictionary alloc]initWithCapacity:10];
    [phone setValue:[CommUtls getUniqueIdentifier] forKey:@"deviceid"];
    [phone setValue:IOS_PLATFORM forKey:@"platform"];
    [phone setValue:[CommUtls getSystemVersion] forKey:@"version"];
    [phone setValue:[CommUtls getModel] forKey:@"brand"];
    [phone setValue:[CommUtls getResolution] forKey:@"resolution"];


    NSMutableDictionary *content = [[NSMutableDictionary alloc]initWithCapacity:10];
    [content setValue:phone forKey:@"phone"];
    [content setValue:apprun forKey:@"apprun"];
    [dic setValue:[content JSONString] forKey:@"content"];
    [DLHttpUtls DLGetAsynchronous:DEVICE_INFO_URL parameters:dic locationFile:nil complete:^(NSString *str){ } fail:^(NSError *err){}];
}

/**	提交用户反馈 */
- (void)submitSuggestion:(FeedBack *)feedBack AppKey:(NSString *)appkey
{
    NSMutableDictionary *detail = [self baseInfo];
    [detail setValue:appkey forKey:@"appkey"];
    if (feedBack.feedContent != nil)
        [detail setValue:feedBack.feedContent forKey:@"content"];
    if (feedBack.email != nil)
        [detail setValue:feedBack.email forKey:@"email"];
    if (feedBack.phone != nil)
        [detail setValue:feedBack.phone forKey:@"phone"];
    [detail setValue:[CommUtls getUniqueIdentifier] forKey:@"deviceid"];
    [detail setValue:[CommUtls getSoftShowVersion] forKey:@"version"];
    [DLHttpUtls DLGetAsynchronous:FEEDBACK_URL parameters:detail locationFile:nil complete:^(NSString *str){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"提交成功"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
         [alert show];
     } fail:^(NSError *err){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"提交失败"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}





/** 检查升级 */
- (void)checkUpdate:(NSString *)appkey isAuto:(BOOL)isAuto
{
    NSMutableDictionary *detail = [self baseInfo];
    [detail setValue:appkey forKey:@"appkey"];
    [DLHttpUtls DLGetAsynchronous:UPDATE_URL parameters:detail locationFile:nil complete:^(NSString *str){
         NSDictionary *dictionary = [str objectFromJSONString];
         if (dictionary != nil) {
             if ([[dictionary valueForKey:@"code"] integerValue] == 1) {
                 self.update = dictionary;
                 NSString *serverVersion = [self.update valueForKey:@"vername"];
                 NSString *localVersion = [CommUtls getSoftShowVersion];
                 EDSemver *sv = [[EDSemver alloc] initWithString:serverVersion];
                 EDSemver *lv = [[EDSemver alloc] initWithString:localVersion];

                 if ([sv isGreaterThan:lv]) {
                     if (isAuto) {
                         if ([[self.update valueForKey:@"forceupdate"] integerValue] == 0) {
                             [self judgeAndAlertToUpdateWithVersion:serverVersion];
                         } else {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本(%@)", serverVersion]
                                                                             message:[self.update valueForKey:@"info"]
                                                                            delegate:self
                                                                   cancelButtonTitle:@"马上升级"
                                                                   otherButtonTitles:nil];
                             alert.tag = UpdateTag;
                             [alert show];
                         }
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本(%@)", serverVersion]
                                                                         message:[self.update valueForKey:@"info"]
                                                                        delegate:self
                                                               cancelButtonTitle:@"不再提示"
                                                               otherButtonTitles:@"马上升级", @"以后再说", nil];
                         alert.tag = UpdateTag;
                         [alert show];
                     }
                 } else {
                     if (!isAuto) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"当前是最新版本"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                         [alert show];
                     }
                 }
             }
         }
     } fail:^(NSError *err){}];

}

- (void)judgeAndAlertToUpdateWithVersion:(NSString *)version
{
    NSString *ignore = [StatisticsPlist ignoreUpdate];
    if (ignore) {
        EDSemver *serverver = [[EDSemver alloc] initWithString:version];
        EDSemver *ignorever = [[EDSemver alloc] initWithString:ignore];
        if (![ignorever isEqualTo:serverver]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本(%@)", version]
                                                            message:[self.update valueForKey:@"info"]
                                                           delegate:self
                                                  cancelButtonTitle:@"不再提示"
                                                  otherButtonTitles:@"马上升级", @"以后再说", nil];
            alert.tag = UpdateTag;
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本(%@)", version]
                                                        message:[self.update valueForKey:@"info"]
                                                       delegate:self
                                              cancelButtonTitle:@"不再提示"
                                              otherButtonTitles:@"马上升级", @"以后再说", nil];
        alert.tag = UpdateTag;
        [alert show];
    }

}

/** 好评框 */
- (void)submitGoodComment:(NSInteger)appID MaxStartCount:(NSInteger)count
{
    appid = appID;
    NSInteger tempCount = [StatisticsPlist startCount];
    tempCount++;
    [StatisticsPlist recordStartCount:tempCount];
    NSString *appver = [StatisticsPlist comment];
    if (appver) {
        if (![appver isEqualToString:[CommUtls getSoftShowVersion]]) {
            if ([StatisticsPlist startCount] > count) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"不再提示"
                                                     otherButtonTitles:@"给个好评", nil];
                alert.tag = CommentTag;
                [alert show];
            }
        }
    } else {
        if ([StatisticsPlist startCount] > count) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"不再提示"
                                                 otherButtonTitles:@"给个好评", nil];
            alert.tag = CommentTag;
            [alert show];
        }
    }
}

#pragma mark 记录软件使用时长
/**
 *	@brief	开启软件时调用，或者从后台切到前台调用
 */
- (void)recordStartTime
{
    [StatisticsPlist recordStartTime:[NSDate date]];
}

/**
 *	@brief	结束软件或者退到后台调用
 */
- (void)calculateTime
{
    [StatisticsPlist recordAppUsedTime:[NSDate date]];
}

/**
 *	@brief	提交用户上次使用时长
 *
 *	@param  appkey
 */
- (void)submitPreviousUseTime:(NSString *)appkey
{
    NSMutableDictionary *info = [StatisticsPlist statisticsInfo];
    NSString *app_user_time = [info valueForKey:@"app_use_time"];
    if (app_user_time != nil) {
        NSMutableDictionary *detail = [self baseInfo];
        [detail setValue:appkey forKey:@"appkey"];
        [detail setValue:[CommUtls getUniqueIdentifier] forKey:@"deviceid"];
        [detail setValue:app_user_time forKey:@"totaltime"];
        [DLHttpUtls DLGetAsynchronous:USE_TIME_URL parameters:detail locationFile:nil complete:^(NSString *str){ } fail:^(NSError *err){}];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == UpdateTag) {
        if ([[self.update valueForKey:@"forceupdate"] integerValue] == 0) {
            if (buttonIndex == 0) {
                [StatisticsPlist setIgnoreUpdate:[self.update valueForKey:@"vername"]];
            } else if (buttonIndex == 1) {
                [StatisticsPlist setIgnoreUpdate:[self.update valueForKey:@"vername"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.update valueForKey:@"downloadpath"]]];
            }
        } else {
            if (buttonIndex == 0) {
                [StatisticsPlist setIgnoreUpdate:[self.update valueForKey:@"vername"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.update valueForKey:@"downloadpath"]]];
            }
        }
    } else if (alertView.tag == CommentTag) {
        if (buttonIndex == 1) {
            [StatisticsPlist setComment:[CommUtls getSoftShowVersion]];
            [StatisticsPlist recordStartCount:0];
            [CommUtls goToAppStoreHomePage:appid];
        } else if (buttonIndex == 0) {
            [StatisticsPlist recordStartCount:0];
        }
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
}

+ (void)recodLaunchInfo
{
    // 时间
    NSString *time = [CommUtls encodeTime:[NSDate date]];

    // 版本
    NSString *version = [CommUtls getSoftShowVersion];

    // 网络状态
    NSString *network = [CommUtls getNetworkType];

    // 操作系统版本
    NSString *operatorer = [CommUtls getOperator];
    [[DLStaticDataBase defaultStaticDB] addOneStaticWithTime:time version:version network:network operatorer:operatorer];
}

+ (void)uploadLaunchInfoWithAppKey:(NSString *)appKey
{
    NSMutableDictionary *allStatics = [[DLStaticDataBase defaultStaticDB] achiveAllStatics];

    if (allStatics && allStatics.count > 0) {
        NSAssert(appKey != nil, @"appKey 不能为空");

        NSString *nowDate = [CommUtls encodeTime:[NSDate date]];
        NSString *pKey = [CommUtls md5EncryptWithParams:@[nowDate, @"eiiskdui"]];

        NSDictionary *uploadContent = @{@"content"  :   [allStatics JSONString],
                                        @"pkey"     :   pKey,
                                        @"time"     :   nowDate,
                                        @"appkey"   :   appKey};

        //        [[DLHttpUtls DLGetAsynchronous:STATIC_URL parameters:uploadContent locationFile:nil] subscribeNext:^(id x) {
        //            [[DLStaticDataBase defaultStaticDB] resetTableOfStatics];
        //        } error:^(NSError *error) {
        //            [[DLStaticDataBase defaultStaticDB] judgeToRemoveStaticOfOutOfTime];
        //        }];

        [DLHttpUtls DLGetAsynchronous:STATIC_URL parameters:uploadContent locationFile:nil complete:^(NSString *str){  [[DLStaticDataBase defaultStaticDB] resetTableOfStatics]; } fail:^(NSError *err){[[DLStaticDataBase defaultStaticDB] judgeToRemoveStaticOfOutOfTime]; }];
    }
}


/**
 *  手动自定义升级
 *
 *  @param view   自定义界面
 *  @param appKey 应用唯一标示
 */
+ (void)checkupdateWithView:(DLUpdateView *)view  withAppKey:(NSString *)appKey
{
    [[self sharedInstance]checkupdateWithView:view withAppKey:appKey withAuto:NO];
}


/**
 *  自动自定义升级
 *
 *  @param view   自定义界面
 *  @param appKey 应用唯一标示
 */
+ (void)autoCheckUpdateWithView:(DLUpdateView *)view withAppKey:(NSString *)appKey
{
    [[self sharedInstance]checkupdateWithView:view withAppKey:appKey withAuto:YES];
}


- (void)checkupdateWithView:(DLUpdateView *)view withAppKey:(NSString *)appKey withAuto:(BOOL)isAuto
{
    NSMutableDictionary *detail = [self baseInfo];
    [detail setValue:appKey forKey:@"appkey"];
    [DLHttpUtls DLGetAsynchronous:UPDATE_URL parameters:detail locationFile:nil complete:^(NSString *str){
         __weak DLBaseStatistics *_weakSelf = self;
        NSDictionary *dictionary = [str objectFromJSONString];
        _weakSelf.update = dictionary;
        if (dictionary != nil) {
            if ([[dictionary valueForKey:@"code"] integerValue] == 1) {
                NSString *serverVersion = [dictionary valueForKey:@"vername"];
                NSString *localVersion = [CommUtls getSoftShowVersion];
                EDSemver *sv = [[EDSemver alloc] initWithString:serverVersion];
                EDSemver *lv = [[EDSemver alloc] initWithString:localVersion];
                if ([sv isGreaterThan:lv]) {
                    if (isAuto)
                    {
                        if ([[dictionary valueForKey:@"forceupdate"] integerValue] == 0)
                        {
                            NSString *ignore = [StatisticsPlist ignoreUpdate];
                            if (ignore) {
                                EDSemver *serverver = [[EDSemver alloc] initWithString:serverVersion];
                                EDSemver *ignorever = [[EDSemver alloc] initWithString:ignore];
                                if ([ignorever isEqualTo:serverver])
                                    return ;
                            }
                            //弹出选择升级框
                            view.status = SelectUpdate;
                            view.updateContentView.text = [dictionary valueForKey:@"info"];
                            view.versionLabel.text = [NSString stringWithFormat:@"V%@",serverVersion];
                            [DLAlertShowView showInView:view];
                        }
                        else
                        {
                            //弹出强制升级框
                            view.status = forecUpdate;
                            view.updateContentView.text = [dictionary valueForKey:@"info"];
                            view.versionLabel.text = [NSString stringWithFormat:@"V%@",serverVersion];;
                            [DLAlertShowView showInView:view];
                        }
                    }
                    else
                    {
                        //弹出选择升级框
                        view.status = SelectUpdate;
                        view.updateContentView.text = [dictionary valueForKey:@"info"];
                        view.versionLabel.text = [NSString stringWithFormat:@"V%@",serverVersion];;
                        [DLAlertShowView showInView:view];
                    }
                }
                else
                {
                    //当前是最新版本
                    if(!isAuto)
                    {
                        //手动点击检查更新需要弹出提示
                        //view.status = newVersionUpdate;
                        //view.updateContentView.text = [dictionary valueForKey:@"info"];
                        //view.versionLabel.text = [NSString stringWithFormat:@"V%@",serverVersion];;
                        //[DLAlertShowView showInView:view];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"当前是最新版本"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }
                if([view superview])
                {
                   
                    [view.cancelButton addTarget:_weakSelf action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    [view.updateButton addTarget:_weakSelf action:@selector(updateButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    [view.ignoreButton addTarget:_weakSelf action:@selector(ignoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }

    } fail:^(NSError *err) {
        
    }];

}

- (void)cancelButtonClick
{
    [DLAlertShowView disappear];
}

- (void)updateButtonClick
{
    [DLAlertShowView disappear];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.update valueForKey:@"downloadpath"]]];
}

- (void)ignoreButtonClick
{
  
    [StatisticsPlist setIgnoreUpdate:[self.update valueForKey:@"vername"]];
    [DLAlertShowView disappear];
}



+ (DLBaseStatistics *)sharedInstance
{
    @synchronized(self){
        if (sharedObj == nil) {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        return self;
    }
}

@end





