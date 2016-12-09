//
//  LoginClient.m
//  Supermarket
//
//  Created by DL on 2016/11/15.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LoginClient.h"
#import "UserModels.h"

@implementation LoginClient

/*判断邮箱格式是否正确*/
-(BOOL)isRightEmail:(NSString*)email{
    // 向网络发送验证请求
    return YES;
}
-(BOOL)isRightMobile:(NSString *)mobile{
    
    return YES;
}
-(RACSignal*)logOut{
    
    // 清除数据库中的个人信息和验证文件信息
    // 清除用户信息文件
    RACSubject* __block subject =[[RACSubject subject]setNameWithFormat:@"logOut"];
    [[NetworkManager sharedManager]getDataWithUrl:logoutUrl completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            [subject sendNext:@"logOut Complete"];
            [[NetworkManager sharedManager]logout];
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:400 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}
/*
 通过账号密码登陆
 */
-(RACSignal*)loginWithCount:(NSString *)count pwd:(NSString *)pwd{
    
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"login"];
    CountPassword* countPassword = [[CountPassword alloc]init];
    countPassword.contact =count;
    countPassword.password = pwd;
    [[NetworkManager sharedManager]putDataWithUrl:loginwithPasswordUrl data:[countPassword toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode == 200) {
            NSLog(@"登陆成功");
            NSError* error;
            SecurityToken* token = [[SecurityToken alloc]initWithData:data error:&error];
            if (error ==nil) {
                NSLog(@"登录成功");
                [[NetworkManager sharedManager]setToken:token];
                [self loadUserProfile:subject];
            }
            else{
                [subject sendError:error];
            }
        }
        else {
            NSLog(@"登录失败");
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}
/*
 获取用户信息文件
 */
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
/*
 判断账号是否已经注册
 */
-(BOOL)isCountRegisted:(NSString *)count{
    
    CountRegistUrl = [NSString stringWithFormat:@"%@/%@",CountRegistUrl,count];
    
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"login result"];
    __block NSError* error;
    [[NetworkManager sharedManager]getDataWithUrl:CountRegistUrl completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode == 200) {
            
            Message* message = [[Message alloc]initWithData:data error:&error];
            if (error == nil) {
                CLog(@"登录成功");
                // 发送登录成功信号
                [subject sendNext:message];
            }
            else{
                // 登录失败，解析数据失败,send error signal
                [subject sendError:error];
            }
        }
        else{
            // 登录失败 返回错误信息
            [error setValue:errorMessage forKey:@"message"];
            [subject sendError:error];
        }
    }];
    
    return subject;
}
-(CountType)getCountType:(NSString *)count{
    return 0;
}
-(RACSignal *)loginByCount:(NSString *)count VerifyCode:(NSString *)verifyCode{
    
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"login with verifycode"];
    CountVerifyCode* countVerifyCode = [[CountVerifyCode alloc]init];
    countVerifyCode.contact = count;
    countVerifyCode.verifyCode = verifyCode;
    [[NetworkManager sharedManager]putDataWithUrl:loginwithVerifyCode data:[countVerifyCode toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode == 200) {
            NSLog(@"登陆成功");
            NSError* error;
            SecurityToken* token = [[SecurityToken alloc]initWithData:data error:&error];
            if (error ==nil) {
                NSLog(@"登录成功");
                [[NetworkManager sharedManager]setToken:token];
                [self loadUserProfile:subject];
            }
            else{
                [subject sendError:error];
            }
        }
        else {
            NSLog(@"登录失败");
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}


@end
