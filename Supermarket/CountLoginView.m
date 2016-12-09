//
//  CountLoginView.m
//  Supermarket
//
//  Created by DL on 2016/11/15.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "CountLoginView.h"

@implementation CountLoginView


-(void)initUI{

    UITextField* textField = [[UITextField alloc]init];
    textField.placeholder = @"Mobile/Email";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:textField];
    @weakify(self);
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(8);
    }];
    _countTextField = textField;
    
    UITextField* pwdField = [[UITextField alloc]init];
    pwdField.secureTextEntry = YES;
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdField.placeholder= @"please enter the password";
    [self addSubview:pwdField];
    [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-8);
    }];
    _passwordTextField = pwdField;
}

-(void)clearCountText{
    _countTextField.text = @"";
}
-(void)clearPwdText{
    _passwordTextField.text =@"";
}

@end
