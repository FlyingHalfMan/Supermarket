//
//  HomeViewModel.m
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "HomeViewModel.h"
#import "LMUHomeService.h"
@interface HomeViewModel()
@property(nonatomic,strong)LMUHomeService* service;

@end
static NSString* url = @"";
@implementation HomeViewModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        _itemSelectedSignal = [[RACSubject subject]setNameWithFormat:@"item selecet"];
        _service = [[LMUHomeService alloc]init];
    }
    return self;
}

-(void)loadData{
    
    [self loadDataWithUrl:url offset:0 limit:10];

}
-(void)loadMoreData{

    [self loadDataWithUrl:url offset:_dataSource.count limit:10];
}

-(void)loadDataWithUrl:(NSString*)url offset:(NSInteger)offset limit:(NSInteger)limit{
    RACSignal* signal =  [_service loadDataWithUrl:url offset:offset limit:limit];
    [signal subscribeNext:^(NSArray* x) {
        /*
         1.在这里将x 数组里的数据转化成cellViewModel
         2.通过updateSignal 将打包好后的   _datasource 发送出去
         */
        [self.updatedContentSignal sendNext:_dataSource];
    }error:^(NSError *error) {
        /*
         抛出一个错误信号到界面上
         */
        [self.errorSignal sendNext:@"数据加载错误"];
    }];
}
-(LMUTableViewCellViewModel *)getCellViewModelByIndex:(NSInteger)index{

    return nil;
}

@end
