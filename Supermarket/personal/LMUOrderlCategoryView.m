//
//  LMUOrderlCategoryView.m
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUOrderlCategoryView.h"
#import "LMUOrdersViewController.h"
@implementation LMUOrderlCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{

    self = [super init];
    if (self) {
        [self initUI];
        [self bindSignal];
    }
    
    return self;
}


-(void)initUI{
    //未付款订单
    UIView* unpayedView = [[UIView alloc]init];
    UILabel* unpayedLabel = [[UILabel alloc]init];
    [unpayedLabel setText:@"未付款"];
    [unpayedLabel setTextColor:[UIColor blackColor]];
    [unpayedLabel setFont:[UIFont systemFontOfSize:12]];
    UIButton* unPayedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [unPayedButton setImage:[UIImage imageNamed:@"未付款"] forState:UIControlStateNormal];
    [unPayedButton setTitle:@"未付款" forState:UIControlStateNormal];
    unPayedButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:unpayedView];
    [unpayedView addSubview:unPayedButton];
    [unpayedView addSubview:unpayedLabel];
    _unPayedButton = unPayedButton;
    
    
    
    //未发货订单
    UIView* unDeliveView = [[UIView alloc]init];
    UILabel* unDeliveLabel = [[UILabel alloc]init];
    unDeliveLabel.text =@"未发货";
    unDeliveLabel.font = [UIFont systemFontOfSize:12];
    UIButton* unDeliveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unDeliveButton setImage:[UIImage imageNamed:@"未发货"] forState:UIControlStateNormal];
    [self addSubview:unDeliveView];
    [unDeliveView addSubview:unDeliveButton];
    [unDeliveView addSubview:unDeliveLabel];
    _unDeliveButton = unDeliveButton;
    
    //未收货订单
    UIView* unReceiptView = [[UIView alloc]init];
    UILabel* unReceiptLabel = [[UILabel alloc]init];
    unReceiptLabel.text =@"未收货";
    unReceiptLabel.font = [UIFont systemFontOfSize:12];
    
    UIButton* unReceiptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unReceiptButton setImage:[UIImage imageNamed:@"未收货"] forState:UIControlStateNormal];
    [self addSubview:unReceiptView];
    [unReceiptView addSubview:unReceiptLabel];
    [unReceiptView addSubview:unReceiptButton];
    _unReceiptButton = unReceiptButton;
    
    //未评价订单
    UIView* unEvaluateView = [[UIView alloc]init];
    UILabel* unEvaluateLabel = [[UILabel alloc]init];
    unEvaluateLabel.text =@"未评价";
    unEvaluateLabel.font = [UIFont systemFontOfSize:12];
    UIButton* unEvaluateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unEvaluateButton setImage:[UIImage imageNamed:@"评价"] forState:UIControlStateNormal];
    [self addSubview:unEvaluateView];
    [unEvaluateView addSubview:unEvaluateButton];
    [unEvaluateView addSubview:unEvaluateLabel];
    unEvaluateButton = unEvaluateButton;
    
    //售后订单
    UIView* serviceView = [[UIView alloc]init];
    UILabel* serviceLabel = [[UILabel alloc]init];
    serviceLabel.text =@"售后/退货";
    serviceLabel.font = [UIFont systemFontOfSize:12];
    UIButton* serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceButton setImage:[UIImage imageNamed:@"售后"] forState:UIControlStateNormal];
    [self addSubview:serviceView];
    [serviceView addSubview:serviceButton];
    [serviceView addSubview:serviceLabel];
    _serviceButton = serviceButton;
    
    // 设置constraint
    // 设置未付款按钮
    @weakify(self);
    [unpayedView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self);
    }];
    [unPayedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unpayedView.mas_centerX);
        make.top.equalTo(unpayedView.mas_top).offset(8);
        make.width.equalTo(@40);
        make.height.equalTo(unPayedButton.mas_width);
    }];
    [unpayedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(unpayedView.mas_centerX);
        make.bottom.equalTo(unpayedView.mas_bottom).offset(5);
        make.top.equalTo(unPayedButton.mas_bottom).offset(3);
    }];
    
    
    // 未发货设置
    [unDeliveView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(unpayedView.mas_right);
        make.width.equalTo(unpayedView.mas_width);
    }];
    [unDeliveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unDeliveView.mas_centerX);
        make.top.equalTo(unDeliveView.mas_top).offset(8);
        make.width.equalTo(@40);
        make.height.equalTo(unPayedButton.mas_width);
    }];
    [unDeliveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unDeliveView.mas_centerX);
        make.bottom.equalTo(unDeliveView.mas_bottom).offset(5);
        make.top.equalTo(unPayedButton.mas_bottom).offset(3);
    }];
    
    [unReceiptView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(unDeliveView.mas_right);
        make.width.equalTo(unDeliveView.mas_width);
    }];
    [unReceiptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unReceiptView.mas_centerX);
        make.top.equalTo(unReceiptView.mas_top).offset(8);
        make.width.equalTo(@40);
        make.height.equalTo(unReceiptButton.mas_width);
    }];
    [unReceiptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unReceiptView.mas_centerX);
        make.bottom.equalTo(unReceiptView.mas_bottom).offset(5);
        make.top.equalTo(unReceiptButton.mas_bottom).offset(3);
    }];
    
    [unEvaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(unReceiptView.mas_right);
        make.width.equalTo(unReceiptView.mas_width);
    }];
    [unEvaluateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unEvaluateView.mas_centerX);
        make.top.equalTo(unEvaluateView.mas_top).offset(8);
        make.width.equalTo(@40);
        make.height.equalTo(unEvaluateButton.mas_width);
    }];
    [unEvaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(unEvaluateView.mas_centerX);
        make.bottom.equalTo(unEvaluateView.mas_bottom).offset(5);
        make.top.equalTo(unEvaluateButton.mas_bottom).offset(3);
    }];
    
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(unEvaluateView.mas_right);
        make.width.equalTo(unEvaluateView.mas_width);
        make.right.equalTo(self);
    }];
    [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(serviceView.mas_centerX);
        make.top.equalTo(serviceView.mas_top).offset(8);
        make.width.equalTo(@40);
        make.height.equalTo(serviceButton.mas_width);
    }];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(serviceView.mas_centerX);
        make.bottom.equalTo(serviceView.mas_bottom).offset(5);
        make.top.equalTo(serviceButton.mas_bottom).offset(3);
    }];
    
    

}
-(void)bindSignal{
    
//    //点击不同的页面同时将点击按钮的枚举传递到下一个界面
//    
//    [[_unPayedButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
//        CLog(@"点击未付款页面");
//        
//        LMUOrdersViewController* ordersVC = [[LMUOrdersViewController alloc]init];
//        
//        //发送信号
//        [ordersVC.indexSignal sendNext:@(ORDERTYPEUNPAID)];
//        self.superview.inputAccessoryViewController
//    }];



}

@end
