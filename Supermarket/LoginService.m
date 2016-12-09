//
//  LoginService.m
//  Supermarket
//
//  Created by DL on 2016/11/15.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService
-(instancetype)init{

    self = [super init];
    if (self) {
        _client = [[LoginClient alloc]init];
    }
    return self;

}
-(RACSignal*)loginWithCount:(NSString *)count pwd:(NSString *)pwd{
    return  [_client loginWithCount:count pwd:pwd];
}


-(RACSignal*)logOut{
   return  [_client logOut];
}
-(BOOL)isCountRegisted:(NSString *)count{
   return  [_client isCountRegisted:count];
}
-(BOOL)isRightEmail:(NSString *)email{
    return [_client isRightEmail:email];
}
-(CountType)getCountType:(NSString *)count{
   return  [_client getCountType:count];
}
-(BOOL)isRightMobile:(NSString *)mobile{

    return [_client isRightMobile:mobile];
}
@end
