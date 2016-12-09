//
//  DLLoading.h
//  MobileClassPhone
//
//  Created by SL on 14/12/29.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLLoadingView.h"

@interface DLLoading : NSObject

/**
 *  弹出加载框
 *
 *  @param title 提示语句（可为nil）
 *  @param close 有值表示可以手动取消弹出框（里面可执行取消之后事件），否则调用   DLHide  方法关闭弹出框
 */
+ (void)DLLoadingInWindow:(NSString *)title
                    close:(DLCloseLoadingView)close;

/**
 *  提示框
 *
 *  @param title 提示语句，统一1.5s之后消失，如有特殊需求，再开发消失时间
 */
+ (void)DLToolTipInWindow:(NSString *)title;

/**
 *  提示框消失
 */
+ (void)DLHideInWindow;

/**
 *  在uialertview之后弹出加载框
 */
+ (void)DLLoadingInWindowAlertAfter:(NSString *)title
                              close:(DLCloseLoadingView)close
                               show:(void(^)())show;

/**
 *  在uialertview之后弹出提示框
 */
+ (void)DLToolTipInWindowAlertAfter:(NSString *)title;

@end
