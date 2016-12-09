//
//  resetPasswordClient.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface resetPasswordClient : NSObject
-(RACSignal*)getResetPasswordVerifyCode:(NSString*)contact;
-(RACSignal*)resetPassword:(NSString*)contact verifyCode:(NSString*)verifyCode newPassword:(NSString*)password;
@end
