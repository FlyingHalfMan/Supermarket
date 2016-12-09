//
//  AutoRefreshTableView.h
//  SafePeriod
//  自动刷新的UITableView
//  Created by Sheng long on 13-6-5.
//  Copyright (c) 2013年 cdeledu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoRefreshTableHeaderView.h"
#import "AutoLoadingMoreView.h"

//刷新状态
typedef enum
{
    //没有刷新
    AT_NO_REFRESH_STATE=2310,
    //刷新
    AT_REFRESH_STATE,
    //加载更多
    AT_LOADING_MORE_STATE,
    //上下刷新
    AT_ALL_REFRESH_STATE
}AT_TABEL_REFRESH_STATE;

@protocol AutoRefreshTableViewDelegate <NSObject>
@optional
/**
 *  刷新数据
 */
-(void)refreshTableData;

/**
 *  加载更多数据
 */
-(void)loadingMoreTableData;

@end

@interface AutoRefreshTableView : UIView<UITableViewDelegate,UITableViewDataSource>{
    //主页面
    UITableView *_mainTable;
    
    //下拉刷新
    AutoRefreshTableHeaderView *_refreshView;
    
    //加载更多
    AutoLoadingMoreView *_customLoadingDataView;
}

/**
 *  当前主页面UITableView
 */
@property (nonatomic,strong) UITableView *mainTable;

#pragma mark - 设置刷新类型和刷新方法
/**
 *  设置刷新类型
 */
@property (nonatomic,assign,setter=setCurrentRefreshType:) AT_TABEL_REFRESH_STATE currentRefreshType;

/**
 *  获取当前刷新状态
 */
@property (nonatomic,readonly) AT_TABEL_REFRESH_STATE currentRefreshState;

/**
 *  使用代理实现刷新的方法
 */
@property (nonatomic,assign) id<AutoRefreshTableViewDelegate>delegate;

/**
 *  刷新数据
 */
-(void)getRefreshTableData:(void(^)())block;

/**
 *  加载更多数据
 */
-(void)getLoadingMoreTableData:(void(^)())block;

#pragma mark - 自动更新刷新状态
/**
 *  每次获取数据数量，和数据源autoDataArray配合使用可自动设置显示状态
 */
@property (nonatomic,assign) NSInteger getDataNumber;

/**
 *  获取完数据之后设置此数据源（刷新和加载更多都可以使用，直接设置，只取个数配合显示）
 *  用此数据源可自动设置获取数据之后的显示状态，需设置getDataNumber配合使用
 */
@property (nonatomic,strong) NSArray *autoDataArray;

/**
 *  获取数据失败时必须调用此方法,可恢复之前显示状态
 *  不调用的情况下在加载更多的时候设置数据源autoDataArray为一样，则会判断为没有更多可加载
 */
-(void)recoverShowState;

#pragma mark - 可选配置参数和方法
/**
 *  刷新更多数据的方式
 *  NO自动刷新
 *  YES点击刷新
 *  默认自动刷新
 */
@property (nonatomic,assign) BOOL clickLoadingMore;

/**
 *  刷新更多数据之后是否不显示刷新完成
 *  NO显示完成
 *  YES不显示完成，但是没有加载更多选项
 *  默认显示加载完成
 */
@property (nonatomic,assign) BOOL noShowLoadingDone;

/**
 *  自动刷新数据，此时会显示下拉状态
 */
-(void)autoPullGetData;

/**
 *  完成获取数据调用此方法设置页面状态
 *  使用autoDataArray做为数据源时自动使用
 */
-(void)doneLoadingTableViewData;

/**
 *  当数据刚好为getDataNumber的整数倍时
 *  加载更多的时候没有更多数据
 *  调用此方法，将显示状态修改
 *  也可设置autoDataArray参数相同，修改显示状态
 */
-(void)loadingMoreNoData;

/**
 *  因为有需求，可以删除单个数据源
 *  而此时又不希望去自动联网去刷新数据，需要显示正常时调用此方法
 *  有加载更多但是没有超出显示范围是不显示加载更多的
 *  该方法默认删除一条数据的时候调用
 */
-(void)deleteDataAfterShow;

/**
 *  一次删除多个数据源
 *
 *  @param num 删除个数
 *  @param all 是否删除了全部数据源的回调
 */
-(void)deleteDataAfterShow:(NSInteger)num
                 deleteAll:(void(^)())all;

/**
 *  UIScrollViewDelegate代理
 *  一般在使用此类的时候外部调用需要集成此类
 *  而此时你不想继承的话，可以手动让此类执行以下代理的时候调用一下下列方法，即可正常使用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

@end
