//
//  LoginCountViewModel.m
//  Supermarket
//
//  Created by DL on 2016/11/19.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginService.h"
#import "UserModels.h"
@interface LoginViewModel()
@property(nonatomic,strong)LoginService* service;

@end

@implementation LoginViewModel

-(instancetype)init{

    self = [super init];
    if (self) {
        _service = [[LoginService alloc]init];
    }
    return self;
}
-(BOOL)isRightEmail:(NSString *)email{

    return [_service isRightEmail:email];

}
-(BOOL)isRightMobile:(NSString *)mobile{
    
    return [_service isRightMobile:mobile];
}

-(BOOL)isCountRegisted:(NSString *)count{

    return [_service isCountRegisted:count];
}

-(void)login{

   RACSignal* signal =   [_service loginWithCount:_count pwd:_pwd];
    
    [signal subscribeNext:^(NSString* x) {
        [self.updatedContentSignal sendNext:x];
        
    }error:^(NSError *error) {
        [self.errorSignal sendNext:[error description]];
    }];

}
-(void)getLoginVerifyCode:(NSString *)count{

    getLoginVerifyCodeUrl = [getLoginVerifyCodeUrl stringByAppendingPathComponent:count];
    
    [[NetworkManager sharedManager]getDataWithUrl:getLoginVerifyCodeUrl completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode == 200) {
            Message* message = [[Message alloc]initWithData:data error:nil];
            [self.updatedContentSignal sendNext:message];
        }
        else{
            [self.errorSignal sendNext:errorMessage];
        }
        
    }];
}

-(void)loginWithCount:(NSString *)count VerifyCode:(NSString *)verifyCode{

    CountVerifyCode* countModel = [[CountVerifyCode alloc]init];
    countModel.contact = count;
    countModel.verifyCode = verifyCode;
    
    [[NetworkManager sharedManager]putDataWithUrl:loginwithVerifyCode data:[countModel toJSONData]  completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode == 200) {
            NSError* error;
            SecurityToken*securityToken = [[SecurityToken alloc]initWithData:data error:&error];
            if (error ==nil) {
                CLog(@"登陆成功");
                [[NetworkManager sharedManager]setToken:securityToken];
                [self loadUserProfile:self.updatedContentSignal];
            }
            else{
                [self.errorSignal sendNext:@"登陆失败"];
            }
        }
        else{
            [self.errorSignal sendNext:errorMessage];
        }
        
    }];
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
