//
//  DLAlertView.m
//  MobileClassPhone
//
//  Created by SL on 15/10/29.
//  Copyright © 2015年 CDEL. All rights reserved.
//

#import "DLAlertView.h"

#define DLAlertView_Width           270

@interface DLAlertView ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *alertView;

@property (nonatomic,strong) UIButton *otherButton;

@end

@implementation DLAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                          tip:(NSString *)tip
                       cancel:(NSString *)cancel
                        other:(NSString *)other
                        click:(void(^)(NSInteger index))click{
    
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
        
        UIView *alertView = [UIView new];
        [self addSubview:alertView];
        alertView.backgroundColor = [UIColor whiteColor];
        self.alertView = alertView;
        
        UIView *view1 = nil;
        if (title) {
            UILabel *label = [UILabel new];
            [alertView addSubview:label];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title;
            label.textColor = [CommUtls colorWithHexString:@"#222222"];
            label.font = [UIFont systemFontOfSize:16];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(13);
            }];
            
            UIView *lineView = [self fetchLine];
            [alertView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1./[UIScreen mainScreen].scale);
                make.top.mas_equalTo(label.mas_bottom).mas_equalTo(13);
            }];
            view1 = lineView;
        }
        
        if (message) {
            UILabel *label = [UILabel new];
            [alertView addSubview:label];
            label.numberOfLines = 0;
            label.text = message;
            label.textColor = [CommUtls colorWithHexString:@"#666666"];
            label.font = [UIFont systemFontOfSize:14];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                if (view1) {
                    make.top.mas_equalTo(view1.mas_bottom).mas_equalTo(10);
                }else{
                    make.top.mas_equalTo(23);
                }
            }];
            view1 = label;
        }
        
        if (tip && message) {
            UILabel *label = [UILabel new];
            [alertView addSubview:label];
            label.numberOfLines = 0;
            label.text = tip;
            label.textColor = [CommUtls colorWithHexString:@"#999999"];
            label.font = [UIFont systemFontOfSize:12];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(view1.mas_bottom).mas_equalTo(23);
            }];
            view1 = label;
        }
        
        if (message) {
            UIView *lineView = [self fetchLine];
            [alertView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1./[UIScreen mainScreen].scale);
                make.top.mas_equalTo(view1.mas_bottom).mas_equalTo((title||tip)?10:23);
            }];
            view1 = lineView;
        }
        
        @weakify(self);
        if (cancel) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [alertView addSubview:button];
            [button setTitle:cancel forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[CommUtls colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!other) {
                    make.right.mas_equalTo(0);
                }
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(45);
                make.top.mas_equalTo(view1.mas_bottom);
            }];
            button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                [self disappear];
                click(0);
                return [RACSignal empty];
            }];
            view1 = button;
        }
        
        if (other) {
            if (cancel) {
                UIView *lineView = [self fetchLine];
                [alertView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(view1);
                    make.width.mas_equalTo(1./[UIScreen mainScreen].scale);
                    make.left.mas_equalTo(view1.mas_right).mas_equalTo(0);
                }];
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [alertView addSubview:button];
            [button setTitle:other forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[CommUtls colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (cancel) {
                    make.left.mas_equalTo(view1.mas_right);
                    make.width.mas_equalTo(view1.mas_width);
                    make.top.mas_equalTo(view1.mas_top);
                }else{
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(view1.mas_bottom);
                }
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(45);
            }];
            button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                [self disappear];
                if (cancel) {
                    click(1);
                }else{
                    click(0);
                }
                return [RACSignal empty];
            }];
            view1 = button;
            self.otherButton = button;
        }
        
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(DLAlertView_Width);
            make.bottom.mas_equalTo(view1.mas_bottom);
        }];
    }
    return self;
}

- (void)show{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self registerForNotifications];
    [self setTransformForCurrentOrientation];
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView animateWithDuration:.3 animations:^{
        self.bgView.alpha = .8;
        self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}

- (void)disappear{
    [UIView animateWithDuration:.3 animations:^{
        self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
        self.alertView.alpha = 0;
        [self.bgView setAlpha:0];
    } completion:^(BOOL s){
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
        [self removeFromSuperview];
        [self unregisterFromNotifications];
    }];
}

- (UIView *)fetchLine{
    UIView *view = [UIView new];
    view.backgroundColor = [CommUtls colorWithHexString:@"#d0d0d0"];
    return view;
}

- (void)setIsOutside:(BOOL)isOutside{
    if (isOutside) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        @weakify(self);
        button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self disappear];
            return [RACSignal empty];
        }];
    }
}

@end
