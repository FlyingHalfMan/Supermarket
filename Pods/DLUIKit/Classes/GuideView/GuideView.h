//
//  GuideView.h
//  UILibrary
//
//  Created by cdeledu on 14-10-30.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideViewDelegate;
@interface GuideView : UIView

/** 代理 */
@property (nonatomic, assign) id<GuideViewDelegate> delegate;
/** 存放展示视图的数组 */
@property (nonatomic, strong, readonly) NSMutableArray *imageViews;

/**
 * @brief 初始化方法
 *
 * @param images 图片名称数组
 * @param normalImage 按钮常态图片名称
 * @param highlightImage 按钮高亮图片名称
 * @param doesButtonShowInEveryPage 是否每页都展示按钮 YES:每页都展示. NO:最后一页展示
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
            buttonNormalImage:(NSString *)normalImage
         buttonHighlightImage:(NSString *)highlightImage
    doesButtonShowInEveryPage:(BOOL)doesButtonShowInEveryPage;

/**
 * @brief 调整按钮距离底部的距离
 *
 * @param distance 按钮距离底部的距离
 *
 */
- (void)configButtonDistanceToBottom:(CGFloat)distance;

@end


@protocol GuideViewDelegate <NSObject>

/** 按钮点击后调用此函数 */
- (void)guideViewBeginButtonPressed:(GuideView *)guideView;

@end