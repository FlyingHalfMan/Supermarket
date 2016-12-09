//
//  UIView+Loading.m
//  MobileClassPhone
//
//  Created by SL on 14/12/26.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "UIView+Loading.h"

@implementation UIView (Loading)

- (void)DLLoadingInSelf{
    [[self DLGetLoadingView] showCDELLoadingView:CDELLoading
                                           cycle:nil
                                           title:nil
                                     buttonTitle:nil
                                     customImage:nil];
}

- (void)DLLoadingHideInSelf{
    [[self DLGetLoadingView] showCDELLoadingView:CDELLoadingRemove
                                           cycle:nil
                                           title:nil
                                     buttonTitle:nil
                                     customImage:nil];
}

- (void)DLLoadingDoneInSelf:(CDELLoadingType)type
                     title:(NSString*)title{
    [[self DLGetLoadingView] showCDELLoadingView:type
                                           cycle:nil
                                           title:title
                                     buttonTitle:nil
                                     customImage:nil];
}

- (void)DLLoadingCycleInSelf:(CDELCycleLoading)cycle
                      title:(NSString*)title
                buttonTitle:(NSString*)buttonTitle{
    [[self DLGetLoadingView] showCDELLoadingView:CDELLoadingCycle
                                           cycle:cycle
                                           title:title
                                     buttonTitle:buttonTitle
                                     customImage:nil];
}

- (void)DLLoadingCustomInSelf:(NSString *)imageName
                        title:(NSString *)title
                        cycle:(CDELCycleLoading)cycle
                  buttonTitle:(NSString *)buttonTitle{
    [[self DLGetLoadingView] showCDELLoadingView:CDELLoadingCustom
                                           cycle:cycle
                                           title:title
                                     buttonTitle:buttonTitle
                                     customImage:imageName];
}

//获取加载框
- (CDELLoadingView *)DLGetLoadingView{
    __block CDELLoadingView *_loadingView = nil;
    [[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CDELLoadingView class]]) {
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
                [obj removeFromSuperview];
            } else {
                _loadingView = (CDELLoadingView*)obj;
            }
            *stop = YES;
        }
    }];
    
    if (!_loadingView) {
        _loadingView = [CDELLoadingView new];
        [_loadingView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_loadingView];
        [self bringSubviewToFront:_loadingView];
    }
    
    return _loadingView;
}

@end
