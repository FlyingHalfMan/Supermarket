//
//  AutoTableView.m
//  MobileClassPhone
//
//  Created by SL on 14/12/30.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "AutoTableView.h"
#import <DLUtls/CommUtls.h>

@implementation AutoTableView

//设置刷新获取数据view
-(void)setCurrentRefreshType:(AT_TABEL_REFRESH_STATE)type
{
    [super setCurrentRefreshType:type];

    [_refreshView setArrowImageName:@"refresh_pulldown.png"];
//    [_refreshView setCircleColor:[CommUtls colorWithHexString:@"#0099ff"]];
//    [_customLoadingDataView setCircleColor:[CommUtls colorWithHexString:@"#0099ff"]];
    [_refreshView setCircleColor:[CommUtls colorWithHexString:APP_MainColor]];
    [_customLoadingDataView setCircleColor:[CommUtls colorWithHexString:APP_MainColor]];
}

@end
