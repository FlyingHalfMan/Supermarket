//
//  DLSquareNavigationController.h
//  XXQ
//
//  Created by DL on 2016/11/16.
//  Copyright © 2016年 LiningZhang. All rights reserved.
//

#import "BaseViewController.h"
#import "DLSquareNavigationView.h"
#import <UIKit/UIKit.h>

@interface DLSquareNavigationController : BaseViewController<NavigatonBarViewDelegate>
{
    DLSquareNavigationView *_navigationBarView;
}

@property (nonatomic, strong) DLSquareNavigationView *navigationBarView;

/**
 *  当前页面是否禁用ios7返回手势，默认不禁用
 */
@property (nonatomic, assign) BOOL closeInteractiveGesture;

/**
 *  当前页面是否禁用IQKeyboardManager，默认不禁用（一般禁用的话，还需要设置输入框的属性inputAccessoryView = [UIView new]）
 */
@property (nonatomic,assign) BOOL closeIQKeyboardManager;

- (void)nearByNavigationBarView:(UIView *)tView isShowBottom:(BOOL)bottom;

- (void)leftButtonClick;

- (void)rightButtonClick;
@end
