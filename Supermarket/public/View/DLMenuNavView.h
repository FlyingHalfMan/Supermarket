//
//  DLMenuNavView.h
//  WXTest
//
//  Created by SL on 15/1/4.
//  Copyright (c) 2015年 Sheng Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLMenuNavView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                    menuNames:(NSArray *)menuNames
                  normalColor:(UIColor *)normalColor
                selectedColor:(UIColor *)selectedColor
                         font:(UIFont *)font
                      showLoc:(void(^)(NSInteger index))showLoc;

/**
 *  指定选中的位置
 *
 *  @param index    位置
 *  @param animated 是否带有动画
 */
- (void)setSelected:(NSInteger)index animated:(BOOL)animated;

/**
 *  DLMenuScrollView执行scrollViewDidScroll时调用
 *
 *  @param gap       间隔
 *  @param movingLoc 移动到的位置
 */
- (void)moveLoc:(CGFloat)gap movingLoc:(CGFloat)movingLoc;

/**
 *  刷新数据源
 *
 *  @param menuNames   显示title
 */
- (void)reloadData:(NSArray *)menuNames;

/**
 *  菜单显示
 */
@property (nonatomic,readonly) UIScrollView *scrollView;

/**
 *  获取当前选中位置
 */
@property (nonatomic,readonly) NSInteger selectIndex;

@end
