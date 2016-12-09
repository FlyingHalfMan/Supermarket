//
//  TKLoadingView.h
//  MobileSchool
//
//  Created by SL on 14/11/12.
//  Copyright (c) 2014年 feng zhanbo. All rights reserved.
//

#import "DLRotateView.h"

typedef void(^DLCloseLoadingView)();

@interface DLLoadingView : DLRotateView

//
- (void)showToolTip:(NSString *)title
           interval:(NSTimeInterval)time
             inView:(UIView *)view;

//
- (void)showLoading:(NSString *)title
              close:(DLCloseLoadingView)close
             inView:(UIView *)view;

@end
