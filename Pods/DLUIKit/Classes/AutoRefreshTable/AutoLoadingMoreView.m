//
//  CustomLoadingDataView.m
//  SafePeriod
//
//  Created by Sheng long on 13-6-5.
//  Copyright (c) 2013年 cdeledu. All rights reserved.
//

#import "AutoLoadingMoreView.h"
#import "AutoTableConstant.h"

@interface AutoLoadingMoreView()
{
    //提示Label
    UILabel *tipLabel;
    
    //显示正在加载
    NSTimer *timer;
}

@end

@implementation AutoLoadingMoreView

@synthesize currentDataState,delegate;

-(void)dealloc
{
    if (tipLabel) {
        tipLabel = nil;
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    if (_activityView) {
        _activityView = nil;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        tipLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [tipLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [tipLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [tipLabel setTextColor:AT_LOADING_MORE_REFRESH_STATE_COLOR];
        [self addSubview:tipLabel];
        
//        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [self addSubview:activityView];
        
        _activityView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:_activityView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        [button setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:button];
        [button addTarget:self action:@selector(clickButt) forControlEvents:UIControlEventTouchUpInside];
        
//        //间隔线
//        UIView *gapView = [[UIView alloc]initWithFrame:CGRectMake(0.0,  frame.size.height-1, frame.size.width,0.5)];
//        [gapView setBackgroundColor:[UIColor lightTextColor]];
//        [self addSubview:gapView];
//        [gapView release];
//        UIView *gapView1 = [[UIView alloc]initWithFrame:CGRectMake(0.0,  frame.size.height-0.5, frame.size.width,0.5)];
//        [gapView1 setBackgroundColor:[UIColor whiteColor]];
//        [self addSubview:gapView1];
//        [gapView1 release];
        
        //默认设置加载更多状态
        [self setCurrentDataState:GetMoreDataState];
    }
    return self;
}

//获取更多方法
-(void)clickButt
{
    //当前状态是获取更多，执行点击方法
    if (currentDataState == GetMoreDataState || currentDataState == GetMoreDataExceptionState) {
        if ([(NSObject*)self.delegate respondsToSelector:@selector(loadingMoreData)]) {
            [self setCurrentDataState:LoadingDataState];
            [self.delegate loadingMoreData];
        }
    }
}

//设置刷新获取数据view
-(void)setCurrentDataState:(CurrentDataState)state
{
    currentDataState = state;
    
    BOOL isShow = NO;
    NSString *tipStr = nil;
    switch (currentDataState) {
        case LoadingDataState:
        {
            //正在加载
            isShow = YES;
            tipStr = AT_LOADING_MORE_LOADING;
        }
            break;
        case GetMoreDataState:
        {
            //加载更多
            tipStr = AT_LOADING_MORE_NORMAL;
        }
            break;
        case GetMoreDataExceptionState:
        {
            //加载状态异常
            tipStr = AT_LOADING_MORE_EXCEPTION;
        }
            break;
        case AlreadyLoadedState:
        {
            //已加载全部
            tipStr = AT_LOADING_MORE_DONE;
        }
            break;
        case AlreadyRefreshReloading:
        {
            //正在执行刷新操作
            tipStr = AT_LOADING_MORE_REFRESH;
        }
            break;
        default:
            break;
    }
    
    [tipLabel setText:tipStr];
    [tipLabel sizeToFit];
    
    if (isShow) {
        //间隔
        CGFloat gap = 5;
        [_activityView setHidden:NO];
        [_activityView startAnimating];
        _activityView.center = CGPointMake((self.frame.size.width-_activityView.frame.size.width-gap-tipLabel.frame.size.width)/2+_activityView.frame.size.width/2, self.frame.size.height/2);
        [tipLabel setCenter:CGPointMake(_activityView.frame.size.width+_activityView.frame.origin.x+gap+tipLabel.frame.size.width/2, self.frame.size.height/2)];
    }else{
        [_activityView setHidden:YES];
        [_activityView stopAnimating];
        [tipLabel setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
}

- (void)setCircleColor:(UIColor *)circleColor{
    _activityView.circleColor = circleColor;
}

@end
