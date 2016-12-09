//
//  LMULoginView.m
//  Supermarket
//
//  Created by DL on 2016/11/14.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMULoginView.h"

@implementation LMULoginView

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
        
    }
    return self;
}

-(void)initUI{
    
    self.backgroundColor = [UIColor lightGrayColor];
    UIButton* countButton = [[UIButton alloc]init];
    [countButton setTitle:@"帐号登陆" forState:UIControlStateNormal];
    // 未选择时的文字颜色
    [countButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //button被选中时的颜色
    [countButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [countButton setSelected: YES];
    [self addSubview:countButton];
    @weakify(self);
    [countButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(.5f);
        make.height.equalTo(self.mas_height).multipliedBy(.25f);
    }];
    _countLoginButton = countButton;

    UIButton* verifyButton = [[UIButton alloc]init];
    [verifyButton setTitle:@"VerifyCode" forState:UIControlStateNormal];
    [verifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //button被选中时的颜色
    [verifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _verifyCodeLoginButton = verifyButton;
    [self addSubview:verifyButton];
    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.equalTo(self);
        make.left.equalTo(countButton.mas_left).offset(1);
        make.width.equalTo(countButton.mas_width);
        make.height.equalTo(self.mas_height).multipliedBy(.25f);
    }];
    
    UIView* indecate = [[UIView alloc]init];
    indecate.backgroundColor = [UIColor blackColor];
    [self addSubview:indecate];
    [indecate mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(countButton.mas_bottom);
        make.left.equalTo(self);
        make.height.equalTo(@3);
    }];
    _indecate = indecate;
    
    UIScrollView* scrollView = [[UIScrollView alloc]init];
    [scrollView setBackgroundColor:[UIColor lightGrayColor]];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(indecate);
        make.left.right.equalTo(self);
    }];
    _scrollView = scrollView;
    
    /*
        init countloginView
     */
    _countLoginView = [[CountLoginView alloc]init];
    [scrollView addSubview:_countLoginView];
    
    [_countLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(scrollView);
        make.height.equalTo(self.mas_top);
        make.width.equalTo(scrollView.mas_width);
    }];
    
    
    UIButton* loginButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor greenColor]];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(scrollView.mas_bottom).offset(8);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-8);
    }];
    _loginButton = loginButton;
}

-(void)bindSignal{

}


@end
