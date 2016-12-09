//
//  LJCEmailsTextFiled.m
//  LJCTextFiled
//
//  Created by 刘建成 on 14-3-31.
//  Copyright (c) 2014年 刘建成. All rights reserved.
//

#import "CDELEmailsTextFiled.h"

@interface EmailsDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, assign) id<CDELEmailsTextFieldDelegate> CDELDelegate;
@property (nonatomic, assign) CDELEmailsTextFiled * delegateField;
@end

@implementation EmailsDelegate

#pragma mark 控制字符数量
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z 0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:[textField.text stringByAppendingString:string]]) {
        NSLog(@"您输入的邮箱格式有误");
    }
    
    if ([emailTest evaluateWithObject:textField.text]) {
        [self.CDELDelegate userEmails:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userEmails:NO];
        self.delegateField.isTrue = NO;
    }
    
    if ([self.CDELDelegate respondsToSelector:@selector(emailsTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.CDELDelegate emailsTextField:textField
                   shouldChangeCharactersInRange:range
                               replacementString:string];
    }
    return YES;
}

#pragma mark 编辑完成判断格式
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:textField.text]) {
        [self.CDELDelegate userEmails:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userEmails:NO];
        self.delegateField.isTrue = NO;
    }
}

@end

@interface CDELEmailsTextFiled ()
{
    EmailsDelegate * _emails;
}

@end

@implementation CDELEmailsTextFiled

- (void)setDel:(id<CDELEmailsTextFieldDelegate>)del
{
    _emails = [[EmailsDelegate alloc] init];
    self.delegate = _emails;
    _emails.CDELDelegate = del;
    _emails.delegateField = self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _emails = [[EmailsDelegate alloc] init];
        self.delegate = _emails;
        _emails.delegateField = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andWithImage:(NSString *)imageStr andWithPlaceholder:(NSString *)plaStr delegate:(id<CDELEmailsTextFieldDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _emails = [[EmailsDelegate alloc] init];
        self.delegate = _emails;
        _emails.CDELDelegate = delegate;
        _emails.delegateField = self;

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
        self.keyboardType = UIKeyboardTypeASCIICapable;

    }
    return self;
}


@end
