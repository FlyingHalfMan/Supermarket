//
//  CDELLoadingView.h
//  MobileClassPhone
//  正保加载View
//  Created by SL on 14-4-13.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import <UIKit/UIKit.h>

//刷新类型
typedef enum{
    //加载中
    CDELLoading=8534,
    //加载失败，可重新加载
    CDELLoadingCycle,
    //加载完成，没有数据显示，不需要重新加载，友好提示
    CDELLoadingDone,
    //加载完成，不显示加载框
    CDELLoadingRemove,
    //自定义提示图片
    CDELLoadingCustom,
}CDELLoadingType;

typedef void (^CDELCycleLoading)();

@interface CDELLoadingView : UIView

//显示加载框，可重复加载
//title参数名称
//cycle可重复加载
- (void)showCDELLoadingView:(CDELLoadingType)type
                      cycle:(CDELCycleLoading)cycle
                      title:(NSString *)title
                buttonTitle:(NSString *)buttonTitle
                customImage:(NSString *)customImage;

@end
