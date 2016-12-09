//
//  BarItem.h
//  TabBar
//
//  Created by cdeledu on 14-10-29.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarItemDelegate;
@interface BarItem : UIView

@property (nonatomic, weak) id<BarItemDelegate> delegate;

@property (nonatomic, strong) UIColor *titleNormalColor;      
@property (nonatomic, strong) UIColor *titleHighlightColor;

- (id)initWithFrame:(CGRect)frame
      backgroundNormalImage:(NSString *)backgroundNormalImage
      backgroundHighlightImage:(NSString *)backgroundHighlightImage
      normalImageName:(NSString *)normalImageName
      highlightImageName:(NSString *)highlightImageName
      text:(NSString *)text;

- (id)initWithFrame:(CGRect)frame
      backgroundNormalImage:(NSString *)backgroundNormalImage
      backgroundHighlightImage:(NSString *)backgroundHighlightImage
      normalImageName:(NSString *)normalImageName
      highlightImageName:(NSString *)highlightImageName
      text:(NSString *)text
      offsetY:(CGFloat)offsetY
      vPadding:(CGFloat)vPadding;

- (void)configTitleFont:(UIFont *)font;
- (void)configIconDistanceToTop:(CGFloat)distance;
- (void)configTitleDistanceToIcon:(CGFloat)distance;

- (void)selected;
- (void)unSelected;

@end

@protocol BarItemDelegate <NSObject>

- (void)barItemTapped:(BarItem *)item;

@end