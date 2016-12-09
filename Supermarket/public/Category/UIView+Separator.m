//
//  UIView+Separator.m
//  MobileClassPhone
//
//  Created by Bryce on 14/12/20.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "UIView+Separator.h"

@implementation UIView (Separator)

- (UIView *)addTopLine
{
    UIColor *color = [UIColor colorWithRed:204./255. green:204./255. blue:204./255. alpha:1.];
    CGFloat lineHeight = 1.0 / [UIScreen mainScreen].scale;
    UIEdgeInsets padding = UIEdgeInsetsZero;
    return [self addTopLineWithColor:color height:lineHeight padding:padding];
}

- (UIView *)addBottomLine
{
    UIColor *color = [UIColor colorWithRed:204./255. green:204./255. blue:204./255. alpha:1.];
    CGFloat lineHeight = 1.0 / [UIScreen mainScreen].scale;
    UIEdgeInsets padding = UIEdgeInsetsZero;
    return [self addBottomLineWithColor:color height:lineHeight padding:padding];
}

- (UIView *)addTopLineWithColor:(UIColor *)color height:(CGFloat)height padding:(UIEdgeInsets)padding
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = color;
    [self addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.mas_left).offset(padding.left);
         make.right.equalTo(self.mas_right).offset(-padding.right);
         make.top.equalTo(self.mas_top);
         make.height.mas_equalTo(height);
     }];
    return line;
}

- (UIView *)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height padding:(UIEdgeInsets)padding
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = color;
    [self addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.mas_left).offset(padding.left);
         make.right.equalTo(self.mas_right).offset(-padding.right);
         make.bottom.equalTo(self.mas_bottom);
         make.height.mas_equalTo(height);
     }];

    return line;
}

- (UIView *)addBottomLineWithDefaultPaddingLeft
{
    UIColor *color = [UIColor colorWithRed:204./255. green:204./255. blue:204./255. alpha:1.];
    CGFloat lineHeight = 1.0 / [UIScreen mainScreen].scale;
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 15, 0, 0);
    return [self addBottomLineWithColor:color height:lineHeight padding:padding];
}

@end
