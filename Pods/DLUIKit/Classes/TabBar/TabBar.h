//
//  TabBar.h
//  TabBar
//
//  Created by cdeledu on 14-10-29.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate;
@interface TabBar : UIView

@property (nonatomic, assign) id<TabBarDelegate> delegate;

/**
 * @brief 初始化方法
 *
 * @param backgroundNormalImages    背景常态图片名称, 没有则置nil
 * @param backgroundHighlightImages 背景选中图片名称, 没有则置nil
 * @param normalImages              图标常态图片名称, 没有则置nil
 * @param highlightImages           图标选中图片名称, 没有则置nil
 * @param titles                    标题, 没有则置nil
 * @param normalColor               标题常态颜色, 默认blackColor
 * @param highlightColor            标题选中颜色, 默认blackColor
 */
- (instancetype)initWithFrame:(CGRect)frame
       backgroundNormalImages:(NSArray *)backgroundNormalImages
    backgroundHighlightImages:(NSArray *)backgroundHighlightImages
                 NormalImages:(NSArray *)normalImages
              highlightImages:(NSArray *)highlightImages
                       titles:(NSArray *)titles
             titleNormalColor:(UIColor *)normalColor
          titleHighlightColor:(UIColor *)highlightColor;

/**
 * @brief 选中一个分栏
 *
 * @param index 分栏所在索引
 *
 */
- (void)selectItemAtIndex:(NSInteger)index;

/**
 * @brief 调整标题的字体
 */
- (void)configTitlesFont:(UIFont *)font;

/**
 * @brief 调整图标距离顶部的距离, 默认为5
 */
- (void)configIconDistanceToTop:(CGFloat)distance;

/**
 * @brief 调整标题距离图标的距离, 默认为5
 */
- (void)configTitleDistanceToIcon:(CGFloat)distance;

@end


@protocol TabBarDelegate <NSObject>

/** 分栏被选中时调用此方法 */
- (void)tabBar:(TabBar *)tabBar selectedIndex:(NSInteger)index;

@end




