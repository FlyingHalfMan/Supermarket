//
//  LoginCountViewModel.h
//  Supermarket
//
//  Created by DL on 2016/11/19.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <BaseWithRAC/BaseWithRAC.h>

@interface LoginViewModel : BaseViewModel

@property(nonatomic,strong)NSString* count;
@property(nonatomic,strong)NSString* pwd;

-(BOOL)isRightMobile:(NSString*)mobile;
-(BOOL)isRightEmail:(NSString*)email;
-(BOOL)isCountRegisted:(NSString*)count;
-(void)login;
-(void)getLoginVerifyCode:(NSString*)count;
-(void)loginWithCount:(NSString*)count VerifyCode:(NSString*)verifyCode;
@end
