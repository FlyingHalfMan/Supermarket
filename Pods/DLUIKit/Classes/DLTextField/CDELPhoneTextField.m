//
//  LJCPhoneTextField.m
//  LJCTextFiled
//
//  Created by 刘建成 on 14-3-31.
//  Copyright (c) 2014年 刘建成. All rights reserved.
//

#import "CDELPhoneTextField.h"

@interface PhoneDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, assign) id<CDELPhoneTextFieldDelegate> CDELDelegate;
@property (nonatomic, assign) CDELPhoneTextField * delegateField;
@end

@implementation PhoneDelegate
#pragma mark 控制字符数量
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:string]) {
        NSLog(@"您输入的手机号码格式有误");
    }
    
    if (textField.text.length < 10) {
        NSLog(@"您输入的手机号码过短");
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 11 && ![string isEqualToString:@""]) {
        return NO;
    } else {
        if ([self.CDELDelegate respondsToSelector:@selector(phoneTextField:shouldChangeCharactersInRange:replacementString:)]) {
            return [self.CDELDelegate phoneTextField:textField
                      shouldChangeCharactersInRange:range
                                  replacementString:string];
        }
    }
    NSString *regexx = @"^((13[0-9])|(17[0,0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *predd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexx];
    if ([predd evaluateWithObject:toBeString]) {
        [self.CDELDelegate userPhone:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userPhone:NO];
        self.delegateField.isTrue = NO;
    }
    return YES;
}

#pragma mark 编辑完成判断格式
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *regex = @"^((13[0-9])|(17[0,0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:textField.text]) {
        [self.CDELDelegate userPhone:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userPhone:NO];
        self.delegateField.isTrue = NO;
    }
}

@end

@interface CDELPhoneTextField ()
{
    PhoneDelegate * _phone;
}
@end

@implementation CDELPhoneTextField

- (void)setDel:(id<CDELPhoneTextFieldDelegate>)del
{
    _phone = [[PhoneDelegate alloc] init];
    self.delegate = _phone;
    _phone.CDELDelegate = del;
    _phone.delegateField = self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _phone = [[PhoneDelegate alloc] init];
        self.delegate = _phone;
        _phone.delegateField = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andWithImage:(NSString *)imageStr andWithPlaceholder:(NSString *)plaStr delegate:(id<CDELPhoneTextFieldDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _phone = [[PhoneDelegate alloc] init];
        self.delegate = _phone;
        _phone.CDELDelegate = delegate;
        _phone.delegateField = self;

        self.frame = frame;
        //设置背景图片
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageStr]];
        //设置边框风格
        self.borderStyle = UITextBorderStyleLine;
        //设置占位符
        self.placeholder = plaStr;
        //字符大写
        self.autocapitalizationType = UITextAutocapitalizationTypeWords;
        //单词检测
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        //对齐方式
        self.textAlignment = NSTextAlignmentLeft;
        //垂直对齐
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //水平对齐
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //键盘类型
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}


@end
