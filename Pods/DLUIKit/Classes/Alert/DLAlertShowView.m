//
//  DLAlertShowView.m
//  Pods
//
//  Created by SL on 16/6/16.
//
//

#import "DLAlertShowView.h"
#import <Masonry/Masonry.h>

@interface DLAlertShowView ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *alertView;

@end

@implementation DLAlertShowView

+ (instancetype)sharedInstance {
    static DLAlertShowView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DLAlertShowView alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        self.bgView = bgView;
    }
    return self;
}

+ (void)showInView:(UIView *)view {
    DLAlertShowView *sView = [self sharedInstance];

    if (sView.alertView) {
        [sView.alertView removeFromSuperview];
        sView.alertView = nil;
    }
    if (sView.superview) {
        [sView removeFromSuperview];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:sView];
    [sView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];

    sView.alertView = view;
    [sView addSubview:sView.alertView];
    [sView.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sView.mas_centerX);
        make.centerY.mas_equalTo(sView.mas_centerY);
        make.width.mas_equalTo(sView.alertView.frame.size.width);
        make.height.mas_equalTo(sView.alertView.frame.size.height);
    }];
    
    [sView registerForNotifications];
    [sView setTransformForCurrentOrientation];
    
    window.userInteractionEnabled = NO;
    sView.alertView.alpha = 0;
    sView.bgView.alpha = 0;
    sView.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    
    [UIView animateWithDuration:.3 animations:^{
        sView.bgView.alpha = .8;
        sView.alertView.alpha = 1;
        sView.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

+ (void)disappear {
    DLAlertShowView *sView = [self sharedInstance];
    [UIView animateWithDuration:.3 animations:^{
        sView.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
        sView.alertView.alpha = 0;
        sView.bgView.alpha = 0;
    } completion:^(BOOL s){
        [sView.alertView removeFromSuperview];
        sView.alertView = nil;
        [sView removeFromSuperview];
        [sView unregisterFromNotifications];
    }];
}

@end
