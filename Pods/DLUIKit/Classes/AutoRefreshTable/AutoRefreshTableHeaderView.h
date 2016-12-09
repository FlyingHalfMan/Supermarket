

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LLARingSpinnerView.h"

typedef enum
{
    //上拉
    onPullState=1970,
    //下拉
    downPullState,
}PullStateStyle;

typedef enum
{
    AutoPullRefreshPulling = 210,       //可刷新状态
    AutoPullRefreshNormal,              //默认状态
    AutoPullRefreshLoading              //正在刷新
} AutoPullRefreshState;

@protocol ATRefreshTableHeaderDelegate;

@interface AutoRefreshTableHeaderView : UIView

/**
 *  加载框
 */
@property (nonatomic,readonly) LLARingSpinnerView *activityView;

@property (nonatomic,assign) id <ATRefreshTableHeaderDelegate> delegate;
@property (nonatomic,assign) NSString *arrowImageName;
@property (nonatomic,assign) UIColor *circleColor;

//自定义初始化方法
- (id)initWithFrame:(CGRect)frame state:(PullStateStyle)state;
//自动刷新数据
-(void)autoRefreshData:(UIScrollView*)scrollView;
//刷新上次刷新时间
- (void)refreshLastUpdatedDate;
//手指屏幕上不断拖动调用此方法
//一般在UIScrollView的代理scrollViewDidScroll方法中使用
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
//一般在UIScrollView的代理scrollViewDidEndDragging:willDecelerate:方法中使用
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
//当开发者页面页面刷新完毕调用此方法
//修改此页面状态和位置信息
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
//UIScrollView是否可以走scrollViewWillBeginDecelerating代理
-(BOOL)willBeginDecelerating:(UIScrollView*)scrollView;

@end

@protocol ATRefreshTableHeaderDelegate
//UI刷新完成，执行获取数据的方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(AutoRefreshTableHeaderView*)view;
//获取是否在刷新的状态
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(AutoRefreshTableHeaderView*)view;
@optional
//获取最后一次刷新时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated;

@end



