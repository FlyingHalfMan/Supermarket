//
//  DLWebView.h
//  WKWebViewDeom
//
//  Created by yangjie on 16/8/24.
//  Copyright © 2016年 yangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class DLWebView;
typedef NS_ENUM(NSInteger, DLWebViewNavigationType) {
    DLWebViewNavigationTypeLinkClicked,
    DLWebViewNavigationTypeFormSubmitted,
    CDLWebViewNavigationTypeBackForward,
    DLWebViewNavigationTypeReload,
    DLWebViewNavigationTypeFormResubmitted,
    DLWebViewNavigationTypeOther
};

@protocol DLWebViewDelegate <NSObject>

@optional

- (BOOL)webView:(DLWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(DLWebViewNavigationType)navigationType;
- (void)webView:(DLWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webViewDidFinishLoad:(DLWebView *)webView;
- (void)webViewDidStartLoad:(DLWebView *)webView;

@end

@interface DLWebView : UIView

- (instancetype)initWithAppDomain:(NSString *)appDomain;
@property ( nonatomic, weak) id <DLWebViewDelegate> delegate;

@property (nonatomic, strong) UIColor * backgroundColor;
@property (nonatomic, assign) BOOL opaque;

@property ( nonatomic, readonly, copy) NSURL *URL;
@property ( nonatomic, readonly, copy) NSString *title;

@property ( nonatomic, readonly, strong) UIScrollView *scrollView NS_AVAILABLE_IOS(5_0);
@property ( nonatomic, readonly) BOOL canGoBack;
@property ( nonatomic, readonly) BOOL canGoForward;
@property ( nonatomic, readonly, getter=isLoading) BOOL loading;

/*! @abstract  WebView加载资源最常用的一种方式，直接给出URL进行加载
 */
- (void)loadRequest:(  NSURLRequest *)request;

/*! @abstract WebView加载资源第二种方式，将本地html文件内容嵌入到WebView.
 */
- (void)loadHTMLString:(  NSString *)string baseURL:(NSURL *)baseURL;

/*! @abstract WebView加载资源第三种方式 将本地数据转化为NSData嵌入到webView.
 */
- (void)loadData:(  NSData *)data MIMEType:(  NSString *)MIMEType textEncodingName:(  NSString *)textEncodingName baseURL:(  NSURL *)baseURL;


/*! @abstract 当前页面加载处理方法.
 */
- (void)reload;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@end
