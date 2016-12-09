//
//  UserService.m
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "UserService.h"

@implementation UserService


-(instancetype)init{

    self = [super init];
    if (self) {
        _client = [[UserClient alloc]init];
    }
    return self;

}


-(BOOL)isLogin{

    return [_client isLogin];

}
-(RACSignal *)getUserImageHeight:(int)height Width:(int)width{
    return [_client getUserImageHeight:height Width:width];
}

-(RACSignal *)getHeadInfor{
    return [_client getUserInfor];
}

-(RACSignal *)uploadImage:(UIImage*)image{
    return [_client uploadImage:image];
}

-(RACSignal *)updateImage:(NSString *)image{

    return [_client updateImage:image];
}
@end
