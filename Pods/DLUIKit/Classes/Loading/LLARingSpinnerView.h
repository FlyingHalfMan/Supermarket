//
//  LLARingSpinnerView.h
//  LLARingSpinnerView
//
//  Created by Lukas Lipka on 05/04/14.
//  Copyright (c) 2014 Lukas Lipka. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface LLARingSpinnerView : UIView

#pragma mark - 加载方法
/**
 *  开始加载动画
 */
- (void)startAnimating;

/**
 *  停止加载动画
 */
- (void)stopAnimating;

#pragma mark - 可配置参数，按下面顺序依次设置
/**
 *  加载框起点，以时钟方向，最大值360，默认45
 */
@property (nonatomic,assign) CGFloat loadingStart;

/**
 *  设置loading颜色，默认白色
 */
@property (nonatomic,strong) UIColor *circleColor;

/**
 *  设置loading宽度，默认1.5
 */
@property (nonatomic,assign) CGFloat lineWidth;

/**
 *  添加加载框圆形背景
 */
- (void)addBezierPathBg:(UIColor *)bgColor;

@end
