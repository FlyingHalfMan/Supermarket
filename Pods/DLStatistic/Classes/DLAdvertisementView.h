//
//  AdvertisementView.h
//  TeacherEDU
//
//  Created by zln on 16/2/23.
//  Copyright © 2016年 cdeledu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^adViewCloseBlock)(void);
typedef void (^DLCancelBolck)(void);




@interface DLAdvertisementView : UIView


/**
 *  广告页关闭时执行
 */
- (void)adViewClose:(adViewCloseBlock)block;
/**
 *  在某个视图上显示广告
 *
 *  @param view 承载广告页的父视图
 */
- (void)showInView:(UIView *)view;

- (instancetype)initSharedADViewWith:(NSString *)appkeyValue andPlatformValue:(NSString *)platformValue andLaunchImgName:(UIView *)launchView;

@end
