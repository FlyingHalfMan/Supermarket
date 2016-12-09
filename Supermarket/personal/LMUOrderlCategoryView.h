//
//  LMUOrderlCategoryView.h
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMUOrderlCategoryView : UIView
//未付款订单
 @property(nonatomic,strong)UIButton* unPayedButton;
//未发货订单
@property(nonatomic,strong)UIButton* unDeliveButton;
//未收货订单
@property(nonatomic,strong)UIButton* unReceiptButton;
//未评价订单
@property(nonatomic,strong)UIButton* unEvaluateButton;
//售后订单
@property(nonatomic,strong)UIButton* serviceButton;

@end
