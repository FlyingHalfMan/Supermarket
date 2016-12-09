//
//  resetPasswordClient.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "resetPasswordClient.h"
static NSString* resetPasswordVerifyCodeUrl =@"login/password/verify";
static NSString* resetPasswordURL =@"login/password/reset";
@implementation resetPasswordClient
-(RACSignal *)getResetPasswordVerifyCode:(NSString *)contact{
    
    resetPasswordVerifyCodeUrl =[resetPasswordVerifyCodeUrl stringByAppendingPathComponent:contact];
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"reset password verify"];
    [[NetworkManager sharedManager]getDataWithUrl:resetPasswordVerifyCodeUrl completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            Message* message = [[Message alloc]initWithData:data error:&error];
            if (error ==nil) {
                [subject sendNext:message.message];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}
-(RACSignal *)resetPassword:(NSString *)contact verifyCode:(NSString *)verifyCode newPassword:(NSString *)password{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"reset password"];
    ResetPasswordModel* model = [[ResetPasswordModel alloc]init];
    model.contact = contact;
    model.verifyCode = verifyCode;
    model.password = password;
    
    [[NetworkManager sharedManager]postDataWithUrl:resetPasswordURL data:[model toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
       
        if (statusCode ==200) {
            NSError* error;
            Message* message = [[Message alloc]initWithData:data error:&error];
            if (error ==nil) {
                [subject sendNext:message.message];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;

}
@end
