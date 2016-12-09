//
//  LJCNameTextField.m
//  LJCTextFiled
//
//  Created by 刘建成 on 14-3-31.
//  Copyright (c) 2014年 刘建成. All rights reserved.
//

#import "CDELNameTextField.h"

@interface NameDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, assign) id<CDELNameTextFieldDelegate> CDELDelegate;
@property (nonatomic, assign) CDELNameTextField *delegateField;
@property (nonatomic, assign) NSInteger maxLength;

@end

@implementation NameDelegate
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:nil];
}

-(instancetype)init
{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
    }
    return self;
}

-(void)textFiledEditChanged{
    UITextField *textField = _delegateField;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _maxLength) {
                textField.text = [toBeString substringToIndex:_maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _maxLength) {
            textField.text = [toBeString substringToIndex:_maxLength];
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    if (![toBeString isEqualToString:@""] && [toBeString rangeOfString:@" "].length == 0) {
//        [self.CDELDelegate userName:YES];
//        self.delegateField.isTrue = YES;
//    } else {
//        [self.CDELDelegate userName:NO];
//        self.delegateField.isTrue = NO;
//    }
//
//    if ([toBeString length] > 6 && ![string isEqualToString:@""]) {
//        return NO;
//    } else {
//        if ([self.CDELDelegate respondsToSelector:@selector(nameTextField:shouldChangeCharactersInRange:replacementString:)]) {
//            return [self.CDELDelegate nameTextField:textField
//                      shouldChangeCharactersInRange:range
//                                  replacementString:string];
//        }
//    }
//
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""] && [textField.text  rangeOfString:@" "].length == 0) {
        [self.CDELDelegate userName:YES];
        self.delegateField.isTrue = YES;
    } else {
        [self.CDELDelegate userName:NO];
        self.delegateField.isTrue = NO;
    }
}

@end

@interface CDELNameTextField ()
{
    NameDelegate *_name;
}
@end

@implementation CDELNameTextField

- (void)setDel:(id<CDELNameTextFieldDelegate>)del
{
    _name = [[NameDelegate alloc] init];
    self.delegate = _name;
    _name.CDELDelegate = del;
    _name.delegateField = self;
    _name.maxLength=6;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = [[NameDelegate alloc] init];
        self.delegate = _name;
        _name.delegateField = self;
        _name.maxLength=6;
    }
    return self;
}
-(instancetype)initWithMaxLength:(NSInteger)length
{
    self = [super init];
    if (self) {
        _name = [[NameDelegate alloc] init];
        self.delegate = _name;
        _name.delegateField = self;
        _name.maxLength=length;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andWithImage:(NSString *)imageStr andWithPlaceholder:(NSString *)plaStr delegate:(id<CDELNameTextFieldDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _name = [[NameDelegate alloc] init];
        self.delegate = _name;
        _name.CDELDelegate = delegate;
        _name.delegateField = self;
        _name.maxLength=6;

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
        self.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return self;
}

@end
