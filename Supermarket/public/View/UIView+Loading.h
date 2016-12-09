//
//  UIView+Loading.h
//  MobileClassPhone
//
//  Created by SL on 14/12/26.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDELLoadingView.h"

@interface UIView (Loading)

/**
 *  显示view中的加载框，view中的加载框是不加title，加入也无效
 */
- (void)DLLoadingInSelf;

/**
 *  隐藏view的加载框
 */
- (void)DLLoadingHideInSelf;

/**
 *  加载完成时调用此方法
 *
 *  @param type  CDELLoadingDone/CDELLoadingRemove此两种类型调用
 *  @param title 提示语句
 */
- (void)DLLoadingDoneInSelf:(CDELLoadingType)type
                      title:(NSString *)title;

/**
 *  需要循环加载时调用此方法
 *
 *  @param cycle       点击循环加载的button调用此方法
 *  @param title       提示语句
 *  @param buttonTitle 重复加载button显示字体，默认为刷新
 */
- (void)DLLoadingCycleInSelf:(CDELCycleLoading)cycle
                       title:(NSString *)title
                 buttonTitle:(NSString *)buttonTitle;

/**
 *  自定义加载提示图片时调用此方法
 *
 *  @param imageName   自定义图片名称
 *  @param title       提示语句
 *  @param cycle       是否显示循环加载的button
 *  @param buttonTitle 重复加载button显示字体，默认为刷新，不需要循环加载为nil
 */
- (void)DLLoadingCustomInSelf:(NSString *)imageName
                        title:(NSString *)title
                        cycle:(CDELCycleLoading)cycle
                  buttonTitle:(NSString *)buttonTitle;

@end
