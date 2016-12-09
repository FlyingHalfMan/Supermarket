//
//  LJCPhoneTextField.h
//  LJCTextFiled
//
//  Created by 刘建成 on 14-3-31.
//  Copyright (c) 2014年 刘建成. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDELPhoneTextField;
@protocol CDELPhoneTextFieldDelegate <NSObject>

@optional
- (BOOL)phoneTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@required
- (void)userPhone:(BOOL)IsTrue;

@end

@interface CDELPhoneTextField : UITextField

/**description
 初始化函数
 @param
 frame:控件frame
 @param
 imageStr:图片名称
 @param
 plaStr:占位字符串
 @param
 delegate:代理
 */
- (id)initWithFrame:(CGRect)frame
       andWithImage:(NSString *)imageStr
 andWithPlaceholder:(NSString *)plaStr
           delegate:(id<CDELPhoneTextFieldDelegate>)delegate;

@property (nonatomic, copy) NSString * plaStr;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic, assign) id<CDELPhoneTextFieldDelegate> del;
@property (nonatomic, assign) BOOL isTrue;

@end
