//
//  CustomLoadingDataView.h
//  SafePeriod
//  自定义加载数据view
//  Created by Sheng long on 13-6-5.
//  Copyright (c) 2013年 cdeledu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLARingSpinnerView.h"

//数据状态
typedef enum
{
    //加载中
    LoadingDataState=5310,
    //获取更多
    GetMoreDataState,
    //已加载全部
    AlreadyLoadedState,
    //获取更多失败
    GetMoreDataExceptionState,
    //正在执行刷新操作
    AlreadyRefreshReloading,
}CurrentDataState;

@protocol AutoLoadingMoreViewDelegate
//加载更多
-(void)loadingMoreData;
@end

@interface AutoLoadingMoreView : UIView

/**
 *  代理事件
 */
@property (nonatomic,assign) id<AutoLoadingMoreViewDelegate> delegate;

/**
 *  设置加载框颜色
 */
@property (nonatomic,strong) UIColor *circleColor;

/**
 *  当前数据状态
 */
@property (nonatomic,assign) CurrentDataState currentDataState;

/**
 *  加载框
 */
@property (nonatomic,readonly) LLARingSpinnerView *activityView;

/**
 *  获取更多数据
 */
-(void)clickButt;

@end
