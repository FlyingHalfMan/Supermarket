//
//  LMULoginView.h
//  Supermarket
//
//  Created by DL on 2016/11/14.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountLoginView.h"
@interface LMULoginView : UIView
@property(nonatomic,strong)UIButton* countLoginButton;
@property(nonatomic,strong)UIButton* verifyCodeLoginButton;
@property(nonatomic,strong)UITextField*countFeild;
@property(nonatomic,strong)UITextField*passwordFeild;
@property(nonatomic,strong)UIView* indecate;
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)UIButton*loginButton;

@property(nonatomic,strong)CountLoginView* countLoginView;
@end
