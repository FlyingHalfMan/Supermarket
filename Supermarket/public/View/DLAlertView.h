//
//  DLAlertView.h
//  MobileClassPhone
//
//  Created by SL on 15/10/29.
//  Copyright © 2015年 CDEL. All rights reserved.
//

#import <DLUIKit/DLRotateView.h>

@interface DLAlertView : DLRotateView

/**
 *  自定义UIAlertView
 *
 *  @param title   标题
 *  @param message 说明信息，必传参数
 *  @param tip     小提示
 *  @param cancel  button按钮，和other必传一个
 *  @param other   button按钮，和cancel必传一个
 *  @param click   点击block
 *
 *  @return
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                          tip:(NSString *)tip
                       cancel:(NSString *)cancel
                        other:(NSString *)other
                        click:(void(^)(NSInteger index))click;

- (void)show;

- (void)disappear;

@property (nonatomic,readonly) UIButton *otherButton;

/**
 *  点击外围消失
 */
@property (nonatomic,assign) BOOL isOutside;

@end
