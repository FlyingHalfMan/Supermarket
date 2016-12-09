//
//  LMUSearchHistoryViewService.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSearchHistoryViewService.h"
#import "LMUSearchHistoryViewClient.h"
@interface LMUSearchHistoryViewService ()
@property(nonatomic,strong)LMUSearchHistoryViewClient* client;

@end
@implementation LMUSearchHistoryViewService

-(instancetype)init{

    self = [super init];
    if (self) {
        _client = [[LMUSearchHistoryViewClient alloc]init];
    }
    return self;
}
-(RACSignal*)loadData{
    return [_client loadData];
}
-(RACSignal *)searchWithText:(NSString *)text andType:(NSInteger)type{

    return [_client searchWithText:text andType:type];
}
@end
