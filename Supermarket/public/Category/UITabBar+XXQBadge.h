//
//  UITabBar+XXQBadge.h
//  XXQ
//
//  Created by zln on 16/11/17.
//  Copyright © 2016年 LiningZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XXQBadge)

/** 显示红点 */
- (void)showBadgeAtIndex:(NSInteger)index;
/** 隐藏红点 */
- (void)hiddenBadgeAtIndex:(NSInteger)index;

@end
