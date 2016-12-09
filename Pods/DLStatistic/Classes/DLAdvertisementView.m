//
//  AdvertisementView.m
//  TeacherEDU
//
//  Created by zln on 16/2/23.
//  Copyright © 2016年 cdeledu. All rights reserved.
//

#import "DLAdvertisementView.h"
#import <DLUtls/CommUtls+Time.h>
#import <DLUtls/CommUtls.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <MD5Digest/NSString+MD5.h>
#import "DLUtls/DLHttpUtls.h"
#import <Masonry/Masonry.h>



typedef NS_ENUM(NSInteger, adStatus) {
    adStatus_Loading = 0,          // 正在加载广告网页
    adStatus_Finished = 1          // 广告网页加载完成
};

@interface DLAdvertisementView()<UIWebViewDelegate>

@property (nonatomic, copy)adViewCloseBlock closeBlock;     // 广告页关闭后需要做的处理的Block
@property (nonatomic, assign)BOOL isClosed;                 // 广告页是否关闭

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *appkeyValue;        // 应用key
@property (nonatomic, strong) NSString *platformValue;      // 平台版本号
@property (nonatomic, strong) UIView *lauchImgView;


@end

@implementation DLAdvertisementView

{
    UILabel *_timeLB;               // 倒计时的显示控件
    UIButton *_outBtn;              // 跳过按钮
    
    
    NSTimer *_timer;                // 全局计时器
    NSInteger _webLoadTimeout;      // 网页开始加载的时间
    NSInteger _adLoadTimeout;       // 广告存在的时间
    adStatus _adStatus;             // 记录广告是否是加载中还是加载完成状态的枚举
    
}
/**
 *  初始化方法
 *
 *  @param appkeyValue   友盟统计Key
 *  @param platformValue 平台版本号
 *  @param imgName       加载界面显示的图片名字
 *
 */
- (instancetype)initSharedADViewWith:(NSString *)appkeyValue andPlatformValue:(NSString *)platformValue andLaunchImgName:(UIView *)launchView
{
    self = [super init];
    if (self) {
        _adStatus = adStatus_Loading;
        self.appkeyValue = appkeyValue;
        self.platformValue = platformValue;
        self.lauchImgView = launchView;
        _adLoadTimeout = 5;
        _webLoadTimeout = 10;
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
        
        
    }];
    
    [self addADWebView];
    [self addLaunchView];
    [self getData];
}

- (void)addADWebView
{
    _webView = [UIWebView new];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_webView];
    __weak DLAdvertisementView *_weakSelf = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_weakSelf);
    }];
}

/** 添加默认显示的页面 */
- (void)addLaunchView {
    
    [self addSubview:self.lauchImgView];
    __weak DLAdvertisementView *_weakSelf = self;
    [self.lauchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_weakSelf);
    }];
    
}





- (void)showWithUrl:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[CommUtls colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[CommUtls colorWithHexString:@"#EAEAEF"]];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:closeBtn];
    _outBtn = closeBtn;
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_webView.mas_top).offset(20);
        make.right.mas_equalTo(self->_webView.mas_right).offset(-20);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(54);
    }];
    _outBtn.hidden = YES;
    
    
    
    UILabel *timeLb = [UILabel new];
    _timeLB.backgroundColor = [CommUtls colorWithHexString:@"#EAEAEF"];
    _timeLB.textColor = [CommUtls colorWithHexString:@"#333333"];
    _timeLB.font = [UIFont systemFontOfSize:13];
    [_webView addSubview:timeLb];
    _timeLB = timeLb;
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_outBtn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self->_outBtn.mas_centerX);
    }];
}



-(void)adViewClose:(adViewCloseBlock)block
{
    self.closeBlock = block;
}

- (void)close
{
    if(self->_timer)
    {
        [self->_timer invalidate];
        self->_timer = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    __weak DLAdvertisementView *_weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        _weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if(self.superview)
        {
            [self removeFromSuperview];
            if (_weakSelf.closeBlock) {
                _weakSelf.closeBlock();
            }
        }
    }];
}

/** 广告页数据请求 */
- (void)getData {
    NSString *url = @"http://manage.mobile.cdeledu.com/analysisApi/getAdvertisePage.shtm";
    NSString *time = [CommUtls encodeTime:[NSDate date]];
    NSString *key = @"eiiskdui";
    NSString *appkey = self.appkeyValue;
    NSString *platformSource = self.platformValue;
    NSString *softVersion = [CommUtls getSoftShowVersion];
    NSString *pKey = [[NSString stringWithFormat:@"%@%@%@%@%@", appkey, platformSource, softVersion, time, key] MD5Digest];
    NSDictionary *params = @{ @"pkey": pKey, @"time":time, @"appkey":appkey, @"platformSource":platformSource, @"version":softVersion };
    __weak DLAdvertisementView *_weakSelf = self;
    [DLHttpUtls DLGetAsynchronous:url parameters:params locationFile:nil complete:^(NSString *str) {
        NSDictionary *dic = [str objectFromJSONString];
        NSLog(@"接口返回：%@",dic);
        if ([dic[@"code"] integerValue] == 1) {
            NSDictionary *info = [dic valueForKey:@"advertisePageInfo"];
            //            NSDictionary *info = @{@"url":@"http://www.tmall.com", @"stayTime":@"11"};
            if (info != nil && ![info isEqual:[NSNull null]]) {
                NSString *urlStr = [info objectForKey:@"url"];
                if ([urlStr isEqual:[NSNull null]] || [urlStr isEqualToString:@""] || urlStr == nil || info[@"stayTime"] == nil) {
                    [_weakSelf close];
                } else {
                    NSURL *url = [NSURL URLWithString:urlStr];
                    NSTimeInterval time;
                    if ([info[@"stayTime"] isEqual:[NSNull null]]) {
                        time = 0;
                    } else {
                        time = [info[@"stayTime"] integerValue];
                    }
                    self->_adLoadTimeout = time;
                    [_weakSelf showWithUrl:url];
                }
            } else {
                [_weakSelf close];
            }
        } else {
            [self close];
        }
    } fail:^(NSError *err) {
        [_weakSelf close];
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
}

- (void)function:(NSTimer *)timer {
    // 根据广告的加载状态对计时器记录时间变量进行处理
    if(_adStatus == adStatus_Loading)
    {
        if (_webLoadTimeout == 0) {
            [self close];
        } else {
            _webLoadTimeout--;
            NSLog(@"广告开始加载倒数第%ld秒",_webLoadTimeout);
        }
    }
    else if(_adStatus == adStatus_Finished) {
        if (_adLoadTimeout <  0) {
            [self close];
        }
        else {
            self->_timeLB.text = [NSString stringWithFormat:@"剩余 %ld 秒",_adLoadTimeout];
            _adLoadTimeout--;
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _adStatus = adStatus_Finished;
    [self.lauchImgView removeFromSuperview];
    
    _outBtn.hidden = NO;
    self->_timeLB.text = [NSString stringWithFormat:@"剩余 %ld 秒",_adLoadTimeout];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self close];
}

- (void)dealloc {
    NSLog(@"删除广告");
}

@end
