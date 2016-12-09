//
//  DLLogView.m
//  MobileClassPhone
//
//  Created by ian on 15/9/16.
//  Copyright (c) 2015年 CDEL. All rights reserved.
//

#import "DLLogView.h"
#import "CommUtls.h"

#pragma mark - DLLogView

static NSString* const LogView_Sending = @"发送中";
static NSString* const LogView_Send_Success = @"成功";
static NSString* const LogView_Send_Failed = @"失败";
static NSString* const LogView_MainColor = @"#0099ff";
static CGFloat const LogView_Width = 60.;

@interface DLLogView()
{
    UILabel *_lblMsg;
    CALayer *_layerLoading;
    BOOL _isAnimating;
    CGPoint _defaultCenter;
    CGPoint _lastCenter;
    void(^_clickBlock)(void);
    void(^_longPressBlock)(void);
}

@end

@implementation DLLogView

#pragma mark 单例

static DLLogView *logViewInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        logViewInstance = [[super allocWithZone:NULL] init];
        logViewInstance.backgroundColor = [UIColor clearColor];
        logViewInstance.userInteractionEnabled = YES;
        logViewInstance->_isAnimating = NO;
        logViewInstance->_isLoading = NO;
        logViewInstance->_defaultCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2., 20 + LogView_Width / 2.);
        logViewInstance->_lastCenter = logViewInstance->_defaultCenter;
        [logViewInstance initMainView];
        [logViewInstance initLoadingLayer];
    });
    
    return logViewInstance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
    return [DLLogView sharedInstance];
}

+ (instancetype)copy
{
    return [DLLogView sharedInstance];
}

#pragma mark - 显示方法

+ (void)showInWindow
{
    if (![DLLogView sharedInstance].superview) {
        [[DLLogView sharedInstance] setShowFrame];

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:[DLLogView sharedInstance]];
        
        [[NSNotificationCenter defaultCenter] addObserver:logViewInstance selector:@selector(changeStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
}

+ (void)hide
{
    if ([DLLogView sharedInstance].superview) {
        [DLLogView sharedInstance].isLoading = NO;
        [DLLogView sharedInstance].message = @"点击上传";
        [[DLLogView sharedInstance] removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter] removeObserver:[DLLogView sharedInstance]];
    }
}

#pragma mark - 方法

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc DLLogView");
}

- (void)setClickBlock:(void(^)())clickBlock longPressBlock:(void(^)())longPressBlock
{
    _clickBlock = clickBlock;
    _longPressBlock = longPressBlock;
}

- (void)initMainView
{
    self.layer.cornerRadius = LogView_Width / 2.;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 2 / [UIScreen mainScreen].scale;
    self.clipsToBounds = YES;
    //
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LogView_Width, LogView_Width)];
//    imgView.image = [UIImage imageNamed:@"kefu_circle"];
    imgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [logViewInstance addSubview:imgView];

    // msg label
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LogView_Width, LogView_Width)];
    lblMsg.backgroundColor = [UIColor clearColor];
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.textColor = [UIColor blackColor];
    lblMsg.font = [UIFont systemFontOfSize:10.];
    lblMsg.text = @"点击上传";
    [logViewInstance addSubview:lblMsg];
    
    // 点击
    [logViewInstance addTarget:logViewInstance action:@selector(circleTouch:) forControlEvents:UIControlEventTouchUpInside];
    // 手势拖动
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:logViewInstance action:@selector(panRecognizerHandle:)];
    [logViewInstance addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    // 长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:logViewInstance action:@selector(btnLong:)];
    longPress.minimumPressDuration = 1.5;
    [logViewInstance addGestureRecognizer:longPress];
    
    _lblMsg = lblMsg;
}

- (void)changeStatusBarOrientation:(id)sender
{
    [self setDefaultFrame];
}

/**
 *  长按 隐藏
 */
- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (_longPressBlock) {
            _longPressBlock();
        }
        [DLLogView hide];
    }
}

- (void)initLoadingLayer
{
    CGFloat radius = LogView_Width / 2.;
    CGPoint arcCenter = CGPointMake(radius, radius);
    CGColorRef strokeColor = [CommUtls colorWithHexString:LogView_MainColor].CGColor;
    CGFloat lineWidth = 1.0 / [UIScreen mainScreen].scale;
    CALayer *layerLoading = [CAShapeLayer layer];
    layerLoading.frame = CGRectMake(0, 0, LogView_Width, LogView_Width);
    
    for (int i = 0; i < 8; i++ ) {
        CGFloat startAngle = (M_PI_4 * i) - (M_PI_4 / 3.);
        CGFloat endAngle = (M_PI_4 * i) + (M_PI_4 / 3.);
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                  radius:radius - 0.5
                                                              startAngle:startAngle
                                                                endAngle:endAngle
                                                               clockwise:YES];
        CAShapeLayer *layerSection = [CAShapeLayer layer];
        layerSection.path = circlePath.CGPath;
        layerSection.strokeColor = strokeColor;
        layerSection.lineWidth = lineWidth;
        layerSection.strokeEnd = 1.;

        [layerLoading addSublayer:layerSection];
    }
    
    [self.layer addSublayer:layerLoading];
    
    _layerLoading = layerLoading;
    _layerLoading.hidden = YES;
}

- (void)startRingAnimation
{
    [_layerLoading removeAllAnimations];
    
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.duration = 0.8f;
    [_layerLoading addAnimation:rotationAnimation forKey:@"loading_ring_rotation"];
    
    _isAnimating = YES;
}

- (void)stopRingAnimation
{
    [_layerLoading removeAllAnimations];
    _isAnimating = NO;
}

/**
 *  设置默认位置
 */
- (void)setDefaultFrame
{
    self.frame = CGRectMake(_defaultCenter.x - LogView_Width / 2., _defaultCenter.y - LogView_Width / 2., LogView_Width, LogView_Width);
}

/**
 *  设置位置
 */
- (void)setShowFrame
{
    self.frame = CGRectMake(_lastCenter.x - LogView_Width / 2., _lastCenter.y - LogView_Width / 2., LogView_Width, LogView_Width);
}

/**
 *  按钮点击动作
 */
- (void)circleTouch:(id)sender
{
    if (self.isLoading) {
        return;
    }
    else {
        [self startSendLog];
    }
}

/**
 *  按钮拖动手势
 */
- (void)panRecognizerHandle:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
    
    // 坐标校正（不能超出屏幕）
    float halfx = CGRectGetMidX(self.bounds);
    newCenter.x = MAX(halfx, newCenter.x);
    newCenter.x = MIN([UIScreen mainScreen].bounds.size.width - halfx, newCenter.x);
    float halfy = CGRectGetMidY(self.bounds);
    newCenter.y = MAX(halfy, newCenter.y);
    newCenter.y = MIN([UIScreen mainScreen].bounds.size.height - halfy, newCenter.y);
    
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    _lastCenter = self.center;
}

- (void)startSendLog
{
    if (_clickBlock) {
        _clickBlock();
    }
}

#pragma mark - getter and setter 

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    if (isLoading) {
        self.layer.borderWidth = 0;
        _layerLoading.hidden = NO;
        [self startRingAnimation];
    }
    else {
        [self stopRingAnimation];
        _layerLoading.hidden = YES;
        self.layer.borderWidth = 2 / [UIScreen mainScreen].scale;
    }
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    if (_lblMsg) {
        _lblMsg.text = message;
    }
}

@end
