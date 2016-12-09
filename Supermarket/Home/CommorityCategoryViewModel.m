//
//  CommorityCategoryViewModel.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "CommorityCategoryViewModel.h"
#import "Models.h"
#import "Category.h"
#import "LMUHomeService.h"
@interface CommorityCategoryViewModel  ()
@property(nonatomic,strong)NSMutableArray* dataSource;
@property(nonatomic,strong)LMUHomeService* service;
@end
@implementation CommorityCategoryViewModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        _service = [[LMUHomeService alloc]init];
        _dataSource = [[NSMutableArray alloc]initWithCapacity:10];
        [self loadData];
    }
    return self;
}


-(void)loadData{
    
    [[NetworkManager sharedManager]getDataWithUrl:@"" completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            NSError* error;
            FirstCategories* firstCategory = [[FirstCategories alloc]initWithData:data error:&error];
            if (error == nil) {
                [self handleData:firstCategory.firstCategoryList];
                [self.updatedContentSignal sendNext:self.dataSource];
            }
            else{
                [self.errorSignal sendNext:error];
            }
        }
        else {
            [self.errorSignal sendNext:errorMessage];
        }
    }];

}
-(void)handleData:(NSArray*)array{
    
    for(FirstCategory* category in array){
        [_dataSource addObject:category.name];
    }
}
@end
