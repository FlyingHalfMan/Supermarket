//
//  DLLoading.m
//  MobileClassPhone
//
//  Created by SL on 14/12/29.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "DLLoading.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define ALERT_SHOW_AFTER            .55

@interface DLLoading ()

@end

@implementation DLLoading{
    DLLoadingView *_loadingView;
}

+ (instancetype)sharedManager{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

+ (void)DLLoadingInWindow:(NSString *)title
                    close:(DLCloseLoadingView)close{
    DLLoadingView *loadingView = [[self sharedManager] getDLLoadingView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [loadingView showLoading:title close:close inView:window];
}

+ (void)DLToolTipInWindow:(NSString *)title{
    DLLoadingView *loadingView = [[self sharedManager] getDLLoadingView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [loadingView showToolTip:title interval:1.5 inView:window];
}

+ (void)DLHideInWindow{
    [[[self sharedManager] getDLLoadingView] removeFromSuperview];
}

+ (void)DLLoadingInWindowAlertAfter:(NSString *)title
                              close:(DLCloseLoadingView)close
                               show:(void(^)())show{
    [[[RACSignal interval:ALERT_SHOW_AFTER
              onScheduler:[RACScheduler currentScheduler]] take:1] subscribeNext:^(id x) {
        [DLLoading DLLoadingInWindow:title close:close];
        show();
    }];
}

+ (void)DLToolTipInWindowAlertAfter:(NSString *)title{
    [[[RACSignal interval:ALERT_SHOW_AFTER
              onScheduler:[RACScheduler currentScheduler]] take:1] subscribeNext:^(id x) {
        [DLLoading DLToolTipInWindow:title];
    }];
}

- (DLLoadingView *)getDLLoadingView{
    if (!_loadingView) {
        _loadingView = [DLLoadingView new];
    }
    return _loadingView;
}

@end
