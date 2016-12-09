//
//  LoginClient.h
//  Supermarket
//
//  Created by DL on 2016/11/15.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginClient : NSObject
    /*
     1.判断帐号类型
     2.判断是否符合邮箱规则
     3.判断是否符合手机规则
     4.帐号是否已经注册
     */

-(CountType)getCountType:(NSString*)count;
-(BOOL)isRightMobile:(NSString*)mobile;
-(BOOL)isRightEmail:(NSString*)email;
-(BOOL)isCountRegisted:(NSString*)count;

-(SecurityToken*)loginByCount:(NSString*)count VerifyCode:(NSString*)verifyCode;
-(void)loadUserProfile:(RACSubject*)subject;
-(RACSignal*)logOut;
-(RACSignal*)loginWithCount:(NSString*)count pwd:(NSString*)pwd;


@end
