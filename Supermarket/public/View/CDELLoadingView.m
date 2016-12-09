//
//  CDELLoadingView.m
//  MobileClassPhone
//
//  Created by SL on 14-4-13.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import "CDELLoadingView.h"
#import <DLUIKit/LLARingSpinnerView.h>
#import <DLUtls/CommUtls.h>
#import <Masonry/Masonry.h>
#import <DLUIKit/DLLoadingSetting.h>

/**
 *  加载状态是否需要删除title
 */
#define LOADING_REMOVE_TITLE            0

#define LOADINGVIEW_GAP                 12
#define TITLE_GAP                       0
#define BUTTON_GAP                      15

@interface CDELLoadingView()
{
    UIView *contentView;
    
    //logo图片
    UIImageView *logoImage;
    
    //提示Label
    UILabel *titleLabel;
    
    //重试button
    UIButton *cycleButton;
    
    //
    LLARingSpinnerView *loading;
}

@property (nonatomic,copy) CDELCycleLoading cycleBlock;
@property (nonatomic,assign) CGFloat minWidth;

- (void)startAnimating;
- (void)stopAnimating;

@end

@implementation CDELLoadingView

- (void)dealloc {
    CLog(@"dealloc -- %@",self.class);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        contentView = [UIView new];
        [self addSubview:contentView];
        [contentView setBackgroundColor:[UIColor clearColor]];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];

        logoImage = [UIImageView new];
        [logoImage setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:logoImage];
        
        loading = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        loading.circleColor = [DLLoadingSetting sharedInstance].loadingColor;
        [contentView addSubview:loading];
        [loading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(contentView.mas_centerX);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(60);
        }];
        
        titleLabel = [UILabel new];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[CommUtls colorWithHexString:@"#6c6c6c"]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

//显示加载框
- (void)showCDELLoadingView:(CDELLoadingType)type
                      cycle:(CDELCycleLoading)cycle
                      title:(NSString *)title
                buttonTitle:(NSString *)buttonTitle
                customImage:(NSString *)customImage{
    if (!self.minWidth) {
        self.minWidth = MIN(MIN(self.superview.frame.size.width, self.superview.frame.size.height), MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height));
        //解决自动布局下superview的宽度高度为0
        if (!self.minWidth) {
            self.minWidth = MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        }
    }
    
    self.cycleBlock = cycle;
    [cycleButton setHidden:!(type==CDELLoadingCycle || cycle)];
    [self stopAnimating];

    NSString *imageName = nil;
    
    switch (type) {
        case CDELLoading:{
            //加载中
            imageName = @"refresh_logo.png";
        }
            break;
        case CDELLoadingCycle:{
          
        }
            break;
        case CDELLoadingDone:{
            //加载完成，没有数据显示，不需要重新加载，友好提示
            imageName = @"connection_failed2";
        }
            break;
        case CDELLoadingRemove:{
            [self removeFromSuperview];
            return;
        }
            break;
        default:
            break;
    }
    
    if (type == CDELLoadingCycle || cycle) {
        //加载失败，可重新加载
        imageName = @"connection_failed2";
        
        if (!cycleButton) {
            cycleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cycleButton setBackgroundColor:[UIColor whiteColor]];
            [cycleButton setTitleColor:[CommUtls colorWithHexString:@"#6c6c6c"] forState:UIControlStateNormal];
            [contentView addSubview:cycleButton];
            [cycleButton addTarget:self action:@selector(CycleLoading) forControlEvents:UIControlEventTouchUpInside];
        }
        [cycleButton setTitle:buttonTitle?buttonTitle:@"刷新" forState:UIControlStateNormal];
        [cycleButton.titleLabel setFont:[UIFont systemFontOfSize:14.5]];
        [cycleButton sizeToFit];
        [cycleButton setFrame:CGRectMake(0, 0, MAX(95, cycleButton.frame.size.width+20), 37)];
        [cycleButton.layer setCornerRadius:cycleButton.frame.size.height/2];
        [cycleButton.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor];
        [cycleButton.layer setBorderWidth:1];
    }
    
    if (type == CDELLoadingCustom) {
        imageName = customImage;
    }
    
    [logoImage setImage:[UIImage imageNamed:imageName]];
    [logoImage sizeToFit];
    
    [titleLabel setFrame:CGRectMake(0, 0, self.minWidth-40, CGFLOAT_MIN)];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    
    //整体内容高度
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat titleWidth = (title?titleLabel.frame.size.width+40:0);
    CGFloat titleHeight = (title?titleLabel.frame.size.height+TITLE_GAP:0);
    if (type==CDELLoading) {
        width = (LOADING_REMOVE_TITLE?loading.frame.size.width:MAX(loading.frame.size.width,titleWidth));
        height = (LOADING_REMOVE_TITLE?loading.frame.size.height:loading.frame.size.height+titleLabel.frame.size.height+5);
    }else if (type==CDELLoadingCycle){
        width = MAX(MAX(logoImage.frame.size.width, titleWidth), cycleButton.frame.size.width);
        height = logoImage.frame.size.height + titleHeight + (cycleButton.frame.size.height+BUTTON_GAP);
    }else{
        width = MAX(MAX(logoImage.frame.size.width, titleWidth), cycle?cycleButton.frame.size.width:0);
        height = logoImage.frame.size.height + titleHeight + (cycle?cycleButton.frame.size.height+BUTTON_GAP:0);
    }
    
    if (type==CDELLoading) {
        if (title) {
            if (LOADING_REMOVE_TITLE) {
                //加载框暂时不需要显示loading文字
                [titleLabel setText:nil];
            } else {
                [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(contentView.mas_centerX);
                    make.top.mas_equalTo(loading.mas_bottom).mas_equalTo(5);
                    make.width.mas_equalTo(titleLabel.frame.size.width);
                    make.height.mas_equalTo(titleLabel.frame.size.height);
                }];
            }
        }
        [self startAnimating];
        [logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(loading.mas_centerX);
            make.centerY.mas_equalTo(loading.mas_centerY);
        }];
    }else{
        [logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(contentView.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        if (title) {
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(contentView.mas_centerX);
                make.top.mas_equalTo(logoImage.mas_bottom).mas_equalTo(TITLE_GAP);
                make.width.mas_equalTo(titleLabel.frame.size.width);
                make.height.mas_equalTo(titleLabel.frame.size.height);
            }];
        }
        if (type == CDELLoadingCycle || cycle) {
            [cycleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(contentView.mas_centerX);
                make.top.mas_equalTo(title?titleLabel.mas_bottom:logoImage.mas_bottom).mas_equalTo(BUTTON_GAP);
                make.width.mas_equalTo(cycleButton.frame.size.width);
                make.height.mas_equalTo(cycleButton.frame.size.height);
            }];
        }
    }
    
    if (!([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0? YES : NO) && ([self.superview isKindOfClass:[UITableView class]] || [self.superview isKindOfClass:[UICollectionView class]])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.frame = CGRectMake(0, 0, width, height);
        [self setCenter:CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2)];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerX.mas_equalTo(self.superview.mas_centerX);
            make.centerY.mas_equalTo(self.superview.mas_centerY);
        }];
    }
}

//重新加载数据
- (void)CycleLoading{
    if (self.cycleBlock) {
        self.cycleBlock();
    }
}

#pragma mark - 定时器
- (void)startAnimating{
    [loading setHidden:NO];
    [loading startAnimating];
}

- (void)stopAnimating{
    [loading setHidden:YES];
    [loading stopAnimating];
}

@end
