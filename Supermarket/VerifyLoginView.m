//
//  VerifyLoginView.m
//  Supermarket
//
//  Created by DL on 2016/11/15.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "VerifyLoginView.h"

@implementation VerifyLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initUI{
    _countFeild = [[UITextField alloc]init];
    _countFeild.placeholder = @"please enter a mobile or email";
    _countFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self addSubview:_countFeild];
    @weakify(self);
    [_countFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
    }];

    _verifyCodeField = [[UITextField alloc]init];
    _verifyCodeField.placeholder = @"verifyCode";
    [self addSubview:_verifyCodeField];
    [_verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(8);
        make.top.equalTo(_countFeild).offset(8);
    }];
    _getVerifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeButton setBackgroundColor:[UIColor lightGrayColor]];
    [_getVerifyCodeButton setEnabled:NO];
    [self addSubview:_getVerifyCodeButton];
    [_getVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countFeild.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-8);
    }];
}

-(void)bindSignal{

    /*
        用户输入帐号
        1. 先判断帐号格式 是不是规定的手机或者邮箱格式
        2. 向网络请求 判断帐号是不是注册过，如果没有 返回错误，否则 getverifybutton enable 设置为true
     */
    [_countFeild.rac_textSignal subscribeNext:^(UITextField* x) {
        if (x.text.length <6) {
            CLog(@"error count length");
        }
        
    }];



}
/* 判断输入是否为有效手机号*/
-(BOOL)isRightMobile:(NSString*)mobile{

    return YES;



}
/* 判断输入是否为有效邮箱*/
-(BOOL)isRightEmail:(NSString*)email{

    return YES;
}

/* 判断帐号是否注册过*/
-(BOOL)isCountRegisted:(NSString*)count{
    return NO;


}


@end
