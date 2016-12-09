//
//  DLRotateView.h
//  MobileClassPhone
//
//  Created by SL on 15/11/27.
//  Copyright © 2015年 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  转屏显示view解决方案
 */
@interface DLRotateView : UIView

/**
 *  注册通知，好像一般执行了强制适配屏幕之后，就不用注册通知了
 *  除非你需要自动转屏，就注册通知
 */
- (void)registerForNotifications;

/**
 *  删除通知
 */
- (void)unregisterFromNotifications;

/**
 *  强制适配屏幕
 */
- (void)setTransformForCurrentOrientation;

@end
