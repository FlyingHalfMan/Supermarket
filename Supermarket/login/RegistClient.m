//
//  RegistClient.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "RegistClient.h"

@implementation RegistClient

-(RACSignal *)getRegistVerifyCode:(NSString *)contact{
    verifyCodeUrl = [verifyCodeUrl stringByAppendingPathComponent:contact];
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"regist"];
    [[NetworkManager sharedManager]getDataWithUrl:verifyCodeUrl completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            NSError* error;
            Message* message = [[Message alloc]initWithData:data
                                                      error:&error];
            if (error ==nil) {
                [subject sendNext:message.message];
            }
            else{
                [subject sendError:error];
            }
        }
        else {
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}

-(RACSignal *)regitWithContact:(NSString *)contact andVerifyCode:(NSString*)verifyCode{

    CountVerifyCode* countVerifycode = [[CountVerifyCode alloc]init];
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"regist"];
    [[NetworkManager sharedManager]putDataWithUrl:registURL data:[countVerifycode toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            // 加载个人信息文;
            NSError* error;
            SecurityToken*token = [[SecurityToken alloc]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setToken:token];
                [self loadUserProfile:subject];
                [subject sendNext:@"注册成功"];
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
-(void)loadUserProfile:(RACSubject*)subject{
    
    [[NetworkManager sharedManager]getDataWithUrl:userProfileUrl completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            NSLog(@"信息获取成功");
            NSError* error;
            UserProfile* profile = [[UserProfile alloc]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"用户信息获取成功"];
            }
            else {
                NSLog(@"用户信息获取失败");
                [subject sendError:error];
            }
        }
        else {
            NSLog(@"获取用户信息失败");
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
}
@end
