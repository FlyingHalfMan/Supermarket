//
//  LJCPassWordTextField.m
//  LJCTextFiled
//
//  Created by 刘建成 on 14-3-31.
//  Copyright (c) 2014年 刘建成. All rights reserved.
//

#import "CDELPassWordTextField.h"

@interface PassWordDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, assign) id<CDELPassWordTextFieldDelegate> CDELDelegate;
@property (nonatomic, assign) CDELPassWordTextField *delegateField;

@end

@implementation PassWordDelegate


#pragma mark 控制字符数量
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if (![pred evaluateWithObject:string]) {
        NSLog(@"您的密码格式有误");
    }

    if (textField.text.length < 5) {
        NSLog(@"您输入的密码过短");
    }

    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"====%@", toBeString);
    NSError *error = NULL;
    NSRegularExpression *regexx = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regexx numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, toBeString.length)];
    if (numberOfMatches == toBeString.length && toBeString.length > 5 && [toBeString length] <= 15) {
        [self.CDELDelegate userPassWord:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userPassWord:NO];
        self.delegateField.isTrue = NO;
    }

    if ([self.CDELDelegate respondsToSelector:@selector(passWordTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.CDELDelegate passWordTextField:textField
                      shouldChangeCharactersInRange:range
                                  replacementString:string];
    }
    return YES;
}

#pragma mark 编辑完成判断格式
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length)];
    if (numberOfMatches == textField.text.length && textField.text.length > 5) {
        [self.CDELDelegate userPassWord:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userPassWord:NO];
        self.delegateField.isTrue = NO;

    }
}

@end

@interface CDELPassWordTextField ()
{
    PassWordDelegate *_passWord;
}
@end

@implementation CDELPassWordTextField

- (void)setDel:(id<CDELPassWordTextFieldDelegate>)del
{
    _passWord = [[PassWordDelegate alloc] init];
    self.delegate = _passWord;
    _passWord.CDELDelegate = del;
    _passWord.delegateField = self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _passWord = [[PassWordDelegate alloc] init];
        self.delegate = _passWord;
        _passWord.delegateField = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andWithImage:(NSString *)imageStr andWithPlaceholder:(NSString *)plaStr delegate:(id<CDELPassWordTextFieldDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _passWord = [[PassWordDelegate alloc] init];
        self.delegate = _passWord;
        _passWord.CDELDelegate = delegate;
        _passWord.delegateField = self;

        self.frame = frame;
        //设置背景图片
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageStr]];
        //设置边框风格
        self.borderStyle = UITextBorderStyleLine;
        //密码不显示
        self.secureTextEntry = YES;
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
        //键盘样式
        self.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return self;
}

@end
