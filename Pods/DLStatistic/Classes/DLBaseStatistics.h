//
//  BaseStatistics.h
//  DownLoadManger
//
//  Created by cyx on 12-10-9.
//  Copyright (c) 2012年 cyx. All rights reserved.
//

#import <Foundation/Foundation.h>



@class FeedBack;
@class DLUpdateView;

typedef void (^DLBaseStatisticsSumbitComplete)(void);


@interface DLBaseStatistics : NSObject
{
    NSInteger appid;
}

@property (nonatomic, retain) NSDictionary *update;


/**
 *	@brief	提交用户基础信息：在applicationWillEnterForeground和didFinishLaunchingWithOptions调用
 *
 *	@param  appkey  公司后台对每个软件生成的key
 */
+ (void)submitBaseInfo:(NSString *)appkey;


/**
 *	@brief	提交反馈意见
 *
 *	@param  feedBack        包括邮件地址、电话、反馈内容
 *	@param  appkey  公司后台对每个软件生成的key
 */
+ (void)submitSuggestion:(FeedBack *)feedBack withAppKey:(NSString *)appkey;



/**
 *	@brief	提交反馈意见
 *
 *	@param  feedBack        包括邮件地址、电话、反馈内容
 *	@param  appkey  公司后台对每个软件生成的key
 */
+ (void)submitSuggestion:(FeedBack *)feedBack withAppKey:(NSString *)appkey Complete:(DLBaseStatisticsSumbitComplete)sumbitCompleteBlock;


/**
 *	@brief	自动检查当前是否为最新版本, 是否需要强制升级
 *
 *  在AppDelegate中调用
 *
 *	@param  appkey  公司后台对每个软件生成的key
 */
+ (void)autoCheckUpdate:(NSString *)appkey;


/**
 *	@brief	用户手动检查当前是否为最新版本
 *
 *	@param  appkey  公司后台对每个软件生成的key
 */
+ (void)checkUpdate:(NSString *)appkey;


/**
 *	@brief	好评框
 *
 *	@param  appID   苹果后台生成的软件ID
 *	@param  count   最大弹出次数
 */
+ (void)submitGoodComment:(NSInteger)appID MaxStartCount:(NSInteger)count;


/**
 *	@brief	提交上次软件的使用时间：在didFinishLaunchingWithOptions和applicationWillEnterForeground调用
 *
 *	@param  appkey  公司后台对每个软件生成的key
 */
+ (void)submitPreviousUseTime:(NSString *)appkey;


/**
 *	@brief	软件开启时间：在applicationWillEnterForeground和didFinishLaunchingWithOptions调用
 */
+ (void)recordStartTime;


/**
 *	@brief	记录软件使用时长：在applicationDidEnterBackground调用
 */
+ (void)calculateTime;


/**
 * @brief 获取是否需要展示引导页界面
 *
 * @return YES: 需要展示. NO:不需要展示.
 *
 */
+ (BOOL)judgeToShowIntroduce;


/**
 * @brief 当前更新版本如果需要展示新的引导图, 需在调用判断是否展示引导页函数
 *        [judgeToShowIntroduce] 之前调用此方法, 否则请撤销对本函数的调用.
 *        PS:需将工程version改为对应最新的版本号.
 */
+ (void)thisVersionNeedShowNewIntroduce;



/**
 * @brief 判断App是否通过审核, 在applicationDidEnterBackground中调用
 */
+ (void)judgeAppStateWithCompleted:(void (^)(BOOL status))completed fail:(void (^)(NSError *error))fail;


/**
 * @brief 获取App审核状态
 *
 * @return YES: 通过审核. NO: 未通过审核.
 *
 */
+ (BOOL)achiveAppState;


/**
 * @brief 记录用户登录信息
 */
+ (void)recodLaunchInfo;


/**
 * @brief 上传用户登录信息
 */
+ (void)uploadLaunchInfoWithAppKey:(NSString *)appKey;


/**
 *  手动自定义升级
 *
 *  @param view   自定义界面
 *  @param appKey 应用唯一标示
 */
+ (void)checkupdateWithView:(DLUpdateView *)view  withAppKey:(NSString *)appKey;


/**
 *  自动自定义升级
 *
 *  @param view   自定义界面
 *  @param appKey 应用唯一标示
 */
+ (void)autoCheckUpdateWithView:(DLUpdateView *)view withAppKey:(NSString *)appKey;

@end










