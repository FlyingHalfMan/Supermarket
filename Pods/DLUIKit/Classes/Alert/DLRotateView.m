//
//  DLRotateView.m
//  MobileClassPhone
//
//  Created by SL on 15/11/27.
//  Copyright © 2015年 CDEL. All rights reserved.
//

#import "DLRotateView.h"

@implementation DLRotateView

#pragma mark - Notifications

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

- (void)registerForNotifications {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        [self unregisterFromNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationDidChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
}

- (void)unregisterFromNotifications {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidChangeStatusBarOrientationNotification
                                                      object:nil];
    }
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else{
        [self setTransformForCurrentOrientation];
    }
}

- (void)setTransformForCurrentOrientation {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        return;
    }
    
    if (self.superview) {
        self.bounds = self.superview.bounds;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            radians = -(CGFloat)M_PI_2;
        }else {
            radians = (CGFloat)M_PI_2;
        }
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            radians = (CGFloat)M_PI;
        }else {
            radians = 0;
        }
    }
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
    [self setTransform:rotationTransform];
}

@end
