//
//  LMUHomeClient.m
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHomeClient.h"

@implementation LMUHomeClient

-(RACSignal *)loadDataWithUrl:(NSString *)url offset:(NSInteger)offset limit:(NSInteger)limit{
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@""];
    
    // 向网络请求数据
    return subject;
}

@end
