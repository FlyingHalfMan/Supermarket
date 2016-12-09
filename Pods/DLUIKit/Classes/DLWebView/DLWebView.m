//
//  DLWebView.m
//  WKWebViewDeom
//
//  Created by yangjie on 16/8/24.
//  Copyright © 2016年 yangjie. All rights reserved.
//

#import "DLWebView.h"

#define DLWebIsIOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0? YES : NO)

#define MAS_SHORTHAND 
#define MAS_SHORTHAND_GLOBALS 
#import <Masonry/Masonry.h>

@interface DLWebView ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIView * webView;

/**
 *  跨域问题需要传APP_DOMAIN
 */
@property (nonatomic, strong) NSString * appDomain;

@end

@implementation DLWebView

- (instancetype)initWithAppDomain:(NSString *)appDomain{
    self = [super init];
    if (self) {
        if (DLWebIsIOS8) {
            self.appDomain = appDomain;
            
            WKWebView * wkWebView = [[WKWebView alloc] init];
            wkWebView.navigationDelegate = self;
            wkWebView.UIDelegate = self;
            wkWebView.scrollView.delegate = self;
            [self addSubview:wkWebView];
            self.webView = wkWebView;
            [wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        } else {
            UIWebView * webView = [[UIWebView alloc] init];
            webView.delegate = self;
            [self addSubview:webView];
            self.webView = webView;
            [webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
        
    }
    return self;
}

#pragma mark - setter方法
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView * webView = (WKWebView *)self.webView;
        webView.backgroundColor = backgroundColor;
    } else{
        UIWebView * webView = (UIWebView *)self.webView;
        webView.backgroundColor = backgroundColor;
    }
}

- (void)setOpaque:(BOOL)opaque{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView * webView = (WKWebView *)self.webView;
        webView.opaque = opaque;
    } else{
        UIWebView * webView = (UIWebView *)self.webView;
        webView.opaque = opaque;
    }
}

#pragma mark - 处理WKWebView兼容问题

//禁止WKWebView加载网页缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

//页面点击事件无效
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//WKWebView弹框效果
//确定面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIViewController *vc = [self fetchVC];
    
    if (vc) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler();
        }]];
        [vc presentViewController:alert animated:YES completion:NULL];
    }
}

//确定取消面板
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIViewController *vc = [self fetchVC];
    
    if (vc) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(YES);
        }]];
    }
}

#pragma mark - WKNavigationDelegate
/**
 *  是否允许加载网页 在发送请求之前，决定是否跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    BOOL decision = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        decision = [self.delegate webView:self shouldStartLoadWithRequest:navigationAction.request navigationType:(DLWebViewNavigationType)navigationAction.navigationType];
    }
    if (!decision) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    //根据APP_DOMAIN比对字符串判断跨域问题
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    NSRange range = [hostname rangeOfString:self.appDomain];
    
    if (navigationAction.navigationType == DLWebViewNavigationTypeLinkClicked
        && range.location == NSNotFound) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/**
 *   开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

/**
 *   结束加载
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
   
//    NSLog(@"%@",  [NSNumber numberWithBool:webView.configuration.preferences.javaScriptEnabled]);
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

/**
 *   加载失败
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if ( [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

#pragma mark - UIWebViewDelegate

/**
 *   UIWebView在发送请求之前，都会调用这个方法，如果返回NO，代表停止加载请求，返回YES，代表允许加载请求
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return  [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:(DLWebViewNavigationType)navigationType];
    }else{
        return YES;
    }
}

/**
 *   开始发送请求（加载数据）时调用这个方法
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

/**
 *   请求完毕（加载数据完毕）时调用这个方法
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        
        [self.delegate webViewDidFinishLoad:self];
        
    }
}

/**
 *   请求错误时调用这个方法
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ( [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

#pragma mark - 公共方法

/**
 *  ! @abstract  requested URL.
 */
- (void)loadRequest:(  NSURLRequest *)request{
    SEL selector = NSSelectorFromString(@"loadRequest:");
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL, NSURLRequest *) = (void *)imp;
            func(_webView, selector,request);
        });
        
    }
}

/**
 *  @abstract 设置网页内容和基本URL
 */
- (void)loadHTMLString:(  NSString *)string baseURL:(NSURL *)baseURL{
    SEL selector = NSSelectorFromString(@"loadHTMLString:baseURL:");
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL, NSString *,NSURL *) = (void *)imp;
            func(_webView, selector,string,baseURL);
        });
        
    }
}

/*
 *  ! @abstract Sets the webpage contents and base URL.
 */
- (void)loadData:(  NSData *)data MIMEType:(  NSString *)MIMEType textEncodingName:(  NSString *)textEncodingName baseURL:(  NSURL *)baseURL{
    SEL selector = NSSelectorFromString(@"loadData:MIMEType:textEncodingName:baseURL:");
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL, NSData *,NSString *,NSString *,NSURL *) = (void *)imp;
            func(_webView, selector,data,MIMEType,textEncodingName,baseURL);
        });
        
    }
}

/*! @abstract Reloads the current page.
 */

/**
 *   重新加载（刷新）
 */
- (void)reload{
    [self invokeName:@"reload"];
}

/**
 *   停止加载
 */
- (void)stopLoading{
    [self invokeName:@"stopLoading"];
}

/**
 *   回退
 */
- (void)goBack{
    [self invokeName:@"goBack"];
}

/**
 *   前进
 */
- (void)goForward{
    [self invokeName:@"goForward"];
}

- (void)invokeName:(NSString *)name{
    SEL selector = NSSelectorFromString(name);
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(_webView, selector);
        });
        
    }
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script{
    
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView * webView = (WKWebView *)self.webView;
        __block NSString* result = nil;
        __block BOOL isExecuted = NO;
        [(WKWebView*)webView evaluateJavaScript:script completionHandler:^(id obj, NSError *error) {
            result = obj;
            isExecuted = YES;
        }];
        
        while (isExecuted == NO) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return result;
        
    } else{
        UIWebView * webView = (UIWebView *)self.webView;
        return [webView stringByEvaluatingJavaScriptFromString:script];
    }
}

#pragma mark Private

- (UIViewController *)fetchVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(void)dealloc{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView * webView = (WKWebView *)self.webView;
        webView.scrollView.delegate = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
 - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
 #endif
 
 - (void)webView:(DLWebView *)webVie  updateProgress:(NSProgress *)progress;
 
*/

@end
