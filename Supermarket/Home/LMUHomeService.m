//
//  LMUHomeService.m
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHomeService.h"
#import "LMUHomeClient.h"
@interface  LMUHomeService()
@property(nonatomic,strong)LMUHomeClient* client;
@end
@implementation LMUHomeService

-(instancetype)init{

    self= [super init];
    if (self) {
        _client = [[LMUHomeClient alloc]init];
    }
    return self;
}

-(RACSignal *)loadDataWithUrl:(NSString *)url offset:(NSInteger)offset limit:(NSInteger)limit{

    return [_client loadDataWithUrl:url offset:offset limit:limit];
}
@end
