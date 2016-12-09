//
//  ResetPasswordService.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "ResetPasswordService.h"
#import "resetPasswordClient.h"
@interface ResetPasswordService ()
@property(nonatomic,strong)resetPasswordClient* client;

@end
@implementation ResetPasswordService

-(instancetype)init{
    
    self = [super init];
    if (self) {
        _client = [[resetPasswordClient alloc]init];
    }
    return self;
}
-(RACSignal *)getResetPasswordVerifyCode:(NSString *)contact{

    return [_client getResetPasswordVerifyCode:contact];
}



@end
