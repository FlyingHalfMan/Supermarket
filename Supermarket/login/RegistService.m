//
//  RegistService.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "RegistService.h"
#import "RegistClient.h"
@interface RegistService ()
@property(nonatomic,strong)RegistClient* client;
@end

@implementation RegistService
-(instancetype)init{

    self = [super init];
    if(self){
        _client = [[RegistClient alloc]init];
    }
    return self;
}
-(RACSignal *)regitWithContact:(NSString *)contact andVerifyCode:(NSString *)verifyCode
{
    return [_client regitWithContact:contact andVerifyCode:verifyCode];
}
-(RACSignal *)getRegistVerifyCode:(NSString *)contact{
    return [_client getRegistVerifyCode:contact];
}
@end
