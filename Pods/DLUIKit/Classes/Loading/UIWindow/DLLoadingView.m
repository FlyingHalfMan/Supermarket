//
//  TKLoadingView.m
//  MobileSchool
//
//  Created by SL on 14/11/12.
//  Copyright (c) 2014年 feng zhanbo. All rights reserved.
//

#import "DLLoadingView.h"
#import <DLUIKit/LLARingSpinnerView.h>
#import <DLUtls/CommUtls.h>
#import "DLLoadingSetting.h"

#define VIEW_SX_GAP                         20              //上下间隔
#define VIEW_ZY_GAP                         20              //左右间隔
#define TITLE_GAP                           10              //文字与加载框间隔

#define CLOSE_BUTTON_OUTSIDE_GAP            5               //关闭按钮中心点与边框间隔

@interface DLLoadingView()
{
    UIView *_bgView;
    UIView *_contentView;
    UIView *_cirBgView;
    UILabel *_titleLabel;
    UIButton *_closeButton;
    
    LLARingSpinnerView *_loading;
}

@property (nonatomic,copy) DLCloseLoadingView closeBlock;

@end

@implementation DLLoadingView

- (void)dealloc{
    [self stopLoadingAnimating];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [_bgView setAlpha:0];
        [self addSubview:_bgView];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _cirBgView = [UIView new];
        [_contentView addSubview:_cirBgView];
        _cirBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_cirBgView.layer setCornerRadius:5];
        
        _loading = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loading.circleColor = [DLLoadingSetting sharedInstance].loadingColor;
        _loading.loadingStart = [DLLoadingSetting sharedInstance].loadingStart;
        [_loading addBezierPathBg:[DLLoadingSetting sharedInstance].bezierPathBgColor];
        [_contentView addSubview:_loading];
        
        NSString *image_url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"DLUIKit.bundle/%@",@"dl_kit_pop_close.png"]];
        UIImage *image = [UIImage imageWithContentsOfFile:image_url];
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:image forState:UIControlStateNormal];
        [_closeButton setFrame:CGRectMake(0, 0, 40, 40)];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_closeButton];
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [_contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)showTitleLabel:(NSString *)title{
    if (title) {
        CGFloat closeGap = _closeButton.frame.size.width/2-CLOSE_BUTTON_OUTSIDE_GAP;
        [_titleLabel setFrame:CGRectMake(0, 0, MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)-VIEW_ZY_GAP*4-closeGap*2, CGFLOAT_MIN)];
        [_titleLabel setText:title];
        [_titleLabel sizeToFit];
    }
}

- (void)showLoading:(NSString *)title{
    CGFloat closeGap = 0;
    if (self.closeBlock) {
        closeGap = _closeButton.frame.size.width/2-CLOSE_BUTTON_OUTSIDE_GAP;
    }
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (title) {
        [self showTitleLabel:title];
        width = MAX(_titleLabel.frame.size.width, _loading.frame.size.width)+VIEW_ZY_GAP*2 + closeGap*2;
        height = _loading.frame.size.height + _titleLabel.frame.size.height + VIEW_SX_GAP*2 + TITLE_GAP + closeGap*2;
    }else{
        width = _loading.frame.size.width+VIEW_ZY_GAP*2+closeGap*2;
        height = _loading.frame.size.height+VIEW_SX_GAP*2+closeGap*2;
    }
    
    [_contentView setFrame:CGRectMake(0, 0, width, height)];
    [_contentView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [_cirBgView setFrame:CGRectMake(0, 0, width-closeGap*2, height-closeGap*2)];
    [_cirBgView setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    [_loading setCenter:CGPointMake(_contentView.frame.size.width/2, _loading.frame.size.height/2+VIEW_SX_GAP+closeGap)];
    
    if (title) {
        [_titleLabel setCenter:CGPointMake(_loading.center.x, CGRectGetMaxY(_loading.frame)+TITLE_GAP+_titleLabel.frame.size.height/2)];
    }
    
    if (self.closeBlock) {
        [_closeButton setCenter:CGPointMake(_contentView.frame.size.width-_closeButton.frame.size.width/2, _closeButton.frame.size.height/2)];
    }
}

- (void)close{
    if (self.closeBlock) {
        self.closeBlock();
    }
    
    [UIView animateWithDuration:.3 animations:^{
        _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
        [_contentView setAlpha:0];
        [_bgView setAlpha:0];
    } completion:^(BOOL s){
        [self removeFromSuperview];
        [_contentView setAlpha:1];
        _contentView.transform = CGAffineTransformIdentity;
        [self stopLoadingAnimating];
        
        [self unregisterFromNotifications];
        self.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 公共方法
- (void)showToolTip:(NSString*)title
           interval:(NSTimeInterval)time
             inView:(UIView *)view{
    //避免自动消失时执行上个block里面的方法
    self.closeBlock = nil;
    
    BOOL isHave = [self isHaveDLLoadingView:view];
    [_titleLabel setHidden:title?NO:YES];
    [_bgView setHidden:YES];
    [_loading setHidden:YES];
    [_closeButton setHidden:YES];
    [self stopLoadingAnimating];
    
    [self showTitleLabel:title];
    
    [_contentView setFrame:CGRectMake(0, 0, _titleLabel.frame.size.width+2*VIEW_ZY_GAP, _titleLabel.frame.size.height+2*VIEW_SX_GAP)];
    [_contentView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [_cirBgView setFrame:_contentView.bounds];
    [_cirBgView setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    [_titleLabel setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    
    [self performSelector:@selector(close) withObject:nil afterDelay:time];
    
    [_bgView setAlpha:0];
    if (!isHave) {
        [self startViewAnimating];
    }
    
    [self changeShowStyle:YES];
}

- (void)showLoading:(NSString *)title
              close:(DLCloseLoadingView)close
             inView:(UIView *)view{
    BOOL isHave = [self isHaveDLLoadingView:view];
    [_titleLabel setHidden:title?NO:YES];
    [_bgView setHidden:NO];
    [_loading setHidden:NO];
    [_closeButton setHidden:close?NO:YES];
    
    self.closeBlock = close;
    [self showLoading:title];
    
    if (isHave) {
        [_bgView setAlpha:.3];
    }else{
        [self startViewAnimating];
    }
    [self startLoadingAnimating];
    
    [self changeShowStyle:NO];
}

#pragma mark - 私有方法
//改变显示样式，tip是否属于提示信息
- (void)changeShowStyle:(BOOL)tip{
    UIColor *titleColor = nil;
    UIColor *contentColor = nil;
    CGFloat alpha = 0;
    if (tip) {
        titleColor = [CommUtls colorWithHexString:@"#f8f8f8"];
        contentColor = [UIColor blackColor];
        alpha = .95;
    }else{
        titleColor = [DLLoadingSetting sharedInstance].loadingColor;
        contentColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        alpha = 1;
    }
    
    [_cirBgView setBackgroundColor:contentColor];
    [_cirBgView setAlpha:alpha];
    _titleLabel.textColor = titleColor;
}

- (BOOL)isHaveDLLoadingView:(UIView *)view{
    __block BOOL isHave = NO;
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:self]) {
            isHave = YES;
            *stop = YES;
        }
    }];
    
    if (!isHave) {
        [view addSubview:self];
        self.frame = view.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self registerForNotifications];
        [self setTransformForCurrentOrientation];
    }
    
    return isHave;
}

#pragma mark - 动画效果
- (void)startViewAnimating{
    [_loading startAnimating];
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView animateWithDuration:.3 animations:^{
        [_bgView setAlpha:.3];
        _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}

#pragma mark - 定时器
- (void)startLoadingAnimating{
    [_loading startAnimating];
}

- (void)stopLoadingAnimating{
    [_loading stopAnimating];
}

@end
