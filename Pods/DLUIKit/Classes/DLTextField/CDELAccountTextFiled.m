//
//  LJCAccountTextFiled.m
//  LJCTextFiled
//
//  Created by 刘建成 on 14-3-31.
//  Copyright (c) 2014年 刘建成. All rights reserved.
//

#import "CDELAccountTextFiled.h"

@interface AccountDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, assign) id<CDELAccountTextFiledDelegate> CDELDelegate;
@property (nonatomic, assign) CDELAccountTextFiled * delegateField;

@end

@implementation AccountDelegate


#pragma mark 控制字符数量
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *regex = @"^\\w+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject:string]) {
        NSLog(@"您的账号格式有误");
    }
    
    if (textField.text.length < 3) {
        NSLog(@"您输入的账号过短");
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [textField.text rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location == NSNotFound && toBeString.length > 3) {
        [self.CDELDelegate userAccount:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userAccount:NO];
        self.delegateField.isTrue = NO;
    }
    
    if ([toBeString length] > 20) {
        return NO;
    } else {
        if ([self.CDELDelegate respondsToSelector:@selector(accountTextField:shouldChangeCharactersInRange:replacementString:)]) {
            return [self.CDELDelegate accountTextField:textField
                        shouldChangeCharactersInRange:range
                                    replacementString:string];
        }
    }
    return YES;
}

#pragma mark 编辑完成判断格式
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [textField.text rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location == NSNotFound && textField.text.length > 3) {
        [self.CDELDelegate userAccount:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userAccount:NO];
        self.delegateField.isTrue = NO;
    }
}

@end

@interface CDELAccountTextFiled ()
{
    AccountDelegate * _account;
}
@end

@implementation CDELAccountTextFiled

- (void)setDel:(id<CDELAccountTextFiledDelegate>)del
{
    _account = [[AccountDelegate alloc] init];
    self.delegate = _account;
    _account.CDELDelegate = del;
    _account.delegateField = self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _account = [[AccountDelegate alloc] init];
        self.delegate = _account;
        _account.delegateField = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andWithImage:(NSString *)imageStr andWithPlaceholder:(NSString *)plaStr delegate:(id<CDELAccountTextFiledDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _account = [[AccountDelegate alloc] init];
        self.delegate = _account;
        _account.CDELDelegate = delegate;
        _account.delegateField = self;

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
        //键盘样式
        self.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return self;
}


@end
