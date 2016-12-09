//
//  LoginService.h
//  Supermarket
//
//  Created by DL on 2016/11/15.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginClient.h"
@interface LoginService : NSObject
@property(nonatomic,strong)LoginClient* client;

-(CountType)getCountType:(NSString*)count;
-(BOOL)isRightMobile:(NSString*)mobile;
-(BOOL)isRightEmail:(NSString*)email;
-(BOOL)isCountRegisted:(NSString*)count;
-(RACSignal*)loginWithCount:(NSString*)count pwd:(NSString*)pwd;
-(RACSignal*)logOut;
@end
