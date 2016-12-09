//
//  LMUSearchHistoryViewModel.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSearchHistoryViewModel.h"
#import "LMUSearchHistoryViewService.h"

@interface LMUSearchHistoryViewModel ()
@property(nonatomic,strong)LMUSearchHistoryViewService* service;

@end
@implementation LMUSearchHistoryViewModel
-(instancetype)init{

    self = [super init];
    if (self) {
        _service = [[LMUSearchHistoryViewService alloc]init];
        _dataSource = [[NSMutableArray alloc]initWithCapacity:10];
        _searchType =SearchTypeCommority;
    }
    return self;
}

-(NSInteger)numberofSectionInTableView{
    return 1;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section{

    return _dataSource ==nil||_dataSource.count <1?1:_dataSource.count;
}

-(void)loadData{
    RACSignal* subject = [_service loadData];
    [subject subscribeNext:^(NSArray* x) {
        NSLog(@"数据加载完成");
        _dataSource = [NSMutableArray arrayWithArray:x];
        [self.updatedContentSignal sendNext:_dataSource];
    }completed:^{
        CLog(@"data load complete");
    }];
    
    [subject subscribeError:^(NSError *error) {
        NSLog(@"error");
        [self.errorSignal sendNext:error];
    }];
}
-(NSString *)getTextAtIndexPath:(NSInteger)index{
    return _dataSource[index];
}
// 开始搜索
-(void)searchWithText:(NSString*)text  {
    RACSignal* signal = [_service searchWithText:text andType:_searchType];
    [signal subscribeNext:^(NSArray* x) {
        NSLog(@"查询完成");
        [self.updatedContentSignal sendNext:x];
    }];
}
@end
