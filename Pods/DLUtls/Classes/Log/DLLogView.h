//
//  DLLogView.h
//  MobileClassPhone
//
//  Created by ian on 15/9/16.
//  Copyright (c) 2015年 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - DLLogView

/**
 *  日志控件(可拖动位置)
 *  点击发送日志
 */
@interface DLLogView : UIControl

/**
 *  是否正在加载中
 */
@property (nonatomic, assign) BOOL isLoading;
/**
 *  消息
 */
@property (nonatomic, strong) NSString *message;

+ (instancetype)sharedInstance;

+ (void)showInWindow;

+ (void)hide;

/**
 *  设置点击的block
 *
 *  @param clickBlock      点击
 *  @param longPressBlock  长按
 */
- (void)setClickBlock:(void(^)())clickBlock longPressBlock:(void(^)())longPressBlock;

@end

