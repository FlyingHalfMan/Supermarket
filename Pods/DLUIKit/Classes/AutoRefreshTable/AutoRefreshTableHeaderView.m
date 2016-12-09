

#import "AutoRefreshTableHeaderView.h"
#import "AutoTableConstant.h"
#import "LLARingSpinnerView.h"
#import "DLLoadingSetting.h"

//刷新所需高度
#define  RefreshViewHight 55.0
//执行动画时间
#define FLIP_ANIMATION_DURATION 0.18f
//上拉y坐标
#define  SCROLLVIEW_           (scrollView.contentSize.height < scrollView.frame.size.height ? scrollView.frame.size.height : scrollView.contentSize.height)

@interface AutoRefreshTableHeaderView ()
{
    //刷新状态
    UILabel *_statusLabel;
    //上次刷新时间
    UILabel *_lastUpdatedLabel;
//    //正在刷新加载框
//    LLARingSpinnerView *_activityView;
    //刷新标识图片
    UIImageView *_arrowImage;
    
    //刷新状态，默认-可刷新-正在刷新
    AutoPullRefreshState _state;
    
    //刷新类型，上拉或者下拉
    PullStateStyle _pullStateStyle;
    
    UIView *_contentView;
}
//设置刷新状态
-(void)setState:(AutoPullRefreshState)aState;
@end

@implementation AutoRefreshTableHeaderView

//自定义初始化方法
- (id)initWithFrame:(CGRect)frame state:(PullStateStyle)state
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //刷新类型，上拉或者下拉
        _pullStateStyle = state;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - RefreshViewHight, frame.size.width, RefreshViewHight)];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_contentView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _contentView.frame.size.height - 48.0f, _contentView.frame.size.width, 20.0f)];
        [_statusLabel setText:AT_REFRESH_DOWN_PULL];
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = AT_REFRESH_STATE_COLOR;
        _statusLabel.shadowColor =[UIColor colorWithWhite:0.9f alpha:1.0f];
        _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_statusLabel];
        
        if ([DLLoadingSetting sharedInstance].autoTableShowTime) {
            _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _contentView.frame.size.height - 30.0f, _contentView.frame.size.width, 20.0f)];
            _lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _lastUpdatedLabel.font = [UIFont systemFontOfSize:10.0f];
            _lastUpdatedLabel.textColor = AT_REFRESH_TIME_COLOR;
            _lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
            _lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
            _lastUpdatedLabel.backgroundColor = [UIColor clearColor];
            _lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:_lastUpdatedLabel];
        }
        
        if(_pullStateStyle == downPullState)
        {
            NSString *image_url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"DLUIKit.bundle/%@",AT_REFRESH_ARROWIMAGE_NAME]];
            _arrowImage = [UIImageView new];
            [_arrowImage setBackgroundColor:[UIColor clearColor]];
            [_arrowImage setImage:[UIImage imageWithContentsOfFile:image_url]];
            [_arrowImage sizeToFit];
            [_arrowImage setCenter:CGPointMake(30+_arrowImage.frame.size.width/2, _contentView.frame.size.height/2)];
            [_contentView addSubview:_arrowImage];
        }
        
        _activityView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activityView setCenter:_arrowImage.center];
        [_contentView addSubview:_activityView];
        //初始设置为默认状态
        [self setState:AutoPullRefreshNormal];
        
        [self refreshLastUpdatedDate];
    }
    
    return self;
}

-(void)setArrowImageName:(NSString *)arrowImageName
{
    [_arrowImage setImage:[UIImage imageNamed:arrowImageName]];
    [_arrowImage sizeToFit];
    
    [self refreshLastUpdatedDate];
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _activityView.circleColor = circleColor;
}

#pragma mark - Setters
//设置刷新时间
- (void)refreshLastUpdatedDate
{
    //super是否需要显示时间
    if ([(NSObject*)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated)] && [DLLoadingSetting sharedInstance].autoTableShowTime) {
        
        _lastUpdatedLabel.text = [_delegate egoRefreshTableHeaderDataSourceLastUpdated];
        
    } else {
        
        _lastUpdatedLabel.text = nil;
        [_statusLabel setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    }
    
    [self refreshLoadingLoc];
}

//设置刷新状态
- (void)setState:(AutoPullRefreshState)aState
{
    switch (aState) {
        case AutoPullRefreshPulling:
        {
            //可以刷新
            _statusLabel.text = AT_REFRESH_LOOSEN;
            if(_pullStateStyle == downPullState)
            {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CGAffineTransformRotate(_arrowImage.transform, M_PI);
                [CATransaction commit];
            }
        }
            break;
        case AutoPullRefreshNormal:
        {
            //初始状态
            if (_state == AutoPullRefreshPulling) {
                if(_pullStateStyle == downPullState)
                {
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    _arrowImage.transform = CGAffineTransformIdentity;
                    [CATransaction commit];
                }
            }
            
            //拉取状态 NSString
            NSString *_pullStateStyleString = nil;
            switch (_pullStateStyle) {
                case onPullState:
                    _pullStateStyleString = @"上拉加载更多...";
                    break;
                case downPullState:
                    _pullStateStyleString = AT_REFRESH_DOWN_PULL;
                    break;
                default:
                    break;
            }
            _statusLabel.text = NSLocalizedString(_pullStateStyleString, _pullStateStyleString);
            [_activityView setHidden:YES];
            [_activityView stopAnimating];
            if(_pullStateStyle == downPullState)
            {
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = NO;
                _arrowImage.transform = CGAffineTransformIdentity;
                [CATransaction commit];
            }
            
            [self refreshLastUpdatedDate];
        }
            break;
        case AutoPullRefreshLoading:
        {
            //正在刷新
            _statusLabel.text = AT_REFRESH_LOADING;
            [_activityView setHidden:NO];
            [_activityView startAnimating];
            if(_pullStateStyle == downPullState)
            {
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = YES;
                [CATransaction commit];
            }
        }
            break;
        default:
            break;
    }
    
    _state = aState;
}

/******     自动刷新数据      *****/
-(void)autoRefreshData:(UIScrollView*)scrollView
{
    //执行下拉动画
    [UIView animateWithDuration:.3 animations:^(void){
        [scrollView setContentOffset:CGPointMake(0.0, -RefreshViewHight)];
        scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0, 0, 0);
    } completion:^(BOOL ss){
        //设置正在加载状态
        [self setState:AutoPullRefreshLoading];
        //执行刷新方法获取数据
        if ([(NSObject*)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
    }];
}

#pragma mark - ScrollView Methods
//手指屏幕上不断拖动调用此方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.isDragging) {
        
        //是否正在刷新
        BOOL _loading = NO;
        if ([(NSObject*)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        switch (_pullStateStyle) {
            case onPullState:
            {
                //上拉
                if (_state == AutoPullRefreshPulling && (scrollView.contentOffset.y + (scrollView.frame.size.height)) < (SCROLLVIEW_ + RefreshViewHight) && scrollView.contentOffset.y > 0.0f && !_loading) {
                    //可刷新--初始状态
                    [self setState:AutoPullRefreshNormal];
                } else if (_state == AutoPullRefreshNormal && (scrollView.contentOffset.y + scrollView.frame.size.height) > (SCROLLVIEW_ + RefreshViewHight)  && !_loading) {
                    //初始状态--可刷新
                    [self setState:AutoPullRefreshPulling];
                }
            }
                break;
            case downPullState:
            {
                //下拉
                if (_state == AutoPullRefreshPulling && scrollView.contentOffset.y > -RefreshViewHight && scrollView.contentOffset.y < 0.0f && !_loading) {
                    //可刷新--初始状态
                    [self setState:AutoPullRefreshNormal];
                } else if (_state == AutoPullRefreshNormal && scrollView.contentOffset.y < -RefreshViewHight && !_loading) {
                    //初始状态--可刷新
                    [self setState:AutoPullRefreshPulling];
                }
            }
                break;
            default:
                break;
        }
        if (scrollView.contentInset.bottom != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
    
    [self refreshLoadingLoc];
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    //是否正在刷新
    BOOL _loading = NO;
    if ([(NSObject*)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    //当前不在刷新,在该拉取状态下是否达到允许刷新状态
    BOOL isBool = NO;
    switch (_pullStateStyle) {
        case onPullState:
        {
            //上拉
           	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > SCROLLVIEW_ + RefreshViewHight && !_loading) {
                isBool = YES;
            }
        }
            break;
        case downPullState:
        {
            //下拉
            if (scrollView.contentOffset.y <= - RefreshViewHight && !_loading) {
                isBool = YES;
            }
        }
            break;
        default:
            break;
    }
    
    //可以刷新
    if (YES == isBool) {
        //设置为Loading状态
        [self setState:AutoPullRefreshLoading];
        
        [UIView animateWithDuration:.5 animations:^(void){
            switch (_pullStateStyle) {
                case onPullState:
                {
                    //上拉
                    scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, (scrollView.contentSize.height < scrollView.frame.size.height ? scrollView.frame.size.height-scrollView.contentSize.height+RefreshViewHight : RefreshViewHight), 0.0f);
                }
                    break;
                case downPullState:
                {
                    //下拉
                    //                    scrollView.contentOffset = CGPointMake(0, -RefreshViewHight);
                    scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0.0f, 0.0f, 0.0f);
                }
                    break;
                default:
                    break;
            }
        } completion:^(BOOL ss){
            //super执行刷新方法
            if ([(NSObject*)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
            }
        }];
    }
}

//当开发者页面页面刷新完毕调用此方法
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:.3 animations:^(void){
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [scrollView setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL ss){
        //显示初始状态
        [self setState:AutoPullRefreshNormal];
        
//        if (scrollView.dragging) {
//        }
        //使用此方法是为了在刷新完毕之后用户的手指还在屏幕上拖动UIScrollView，
        //或者马上就去拖动UIScrollView而产生的问题
        [self egoRefreshScrollViewDidScroll:scrollView];
    }];
}

//UIScrollView是否可以走scrollViewWillBeginDecelerating代理
-(BOOL)willBeginDecelerating:(UIScrollView*)scrollView
{
    //是否正在刷新
    BOOL _loading = NO;
    if ([(NSObject*)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    //下拉
    if (scrollView.contentOffset.y <= - RefreshViewHight && !_loading) {
        return YES;
    }
    return NO;
}

#pragma mark - 重置页面位置，刷新和label一起
-(void)refreshLoadingLoc
{
    CGFloat gap = 10;
    
    CGRect rect = _contentView.frame;
    rect.size.width = MAX(_arrowImage.frame.size.width, _activityView.frame.size.width)+gap+_statusLabel.frame.size.width;
    rect.origin.x = (self.frame.size.width-rect.size.width)/2;
    [_contentView setFrame:rect];
    
    BOOL showTime = [DLLoadingSetting sharedInstance].autoTableShowTime;

    if (_lastUpdatedLabel.text.length && showTime) {
        [_lastUpdatedLabel sizeToFit];
        [_lastUpdatedLabel setCenter:CGPointMake(_contentView.frame.size.width/2., _contentView.frame.size.height-_lastUpdatedLabel.frame.size.height/2.-2)];
    }
    
    //
    _arrowImage.center = CGPointMake(MAX(_arrowImage.frame.size.width, _activityView.frame.size.width)/2, showTime?_lastUpdatedLabel.frame.origin.y-_arrowImage.frame.size.height/2.-5:_contentView.frame.size.height/2);
    
    [_statusLabel sizeToFit];
    [_statusLabel setCenter:CGPointMake(CGRectGetMaxX(_activityView.frame)+gap+_statusLabel.frame.size.width/2,_arrowImage.center.y)];
    
    [_activityView setCenter:_arrowImage.center];
}

@end
