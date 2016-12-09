//
//  HomeHeaderViewModel.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "HomeHeaderViewModel.h"

@interface HomeHeaderViewModel ()
@property(nonatomic,strong)NSMutableArray* dataSources;
@property(nonatomic,strong)NSArray* itemNameArray;
@property(nonatomic,strong)NSArray* itemImageArray;
@end

@implementation HomeHeaderViewModel


-(instancetype)init{
    self = [super init];
    if (self) {
        _dataSources = [[NSMutableArray alloc]init];
        _itemSelectedSignal = [[RACSubject subject]setNameWithFormat:@"selectItem"];
        [self loadData];
    }
    return self;
}

-(HeaderItemViewModel *)getItemViewModelAtIndexPath:(NSInteger)index{

   return  self.dataSources[index];
}

-(void)loadData{
    
    self.itemNameArray = [NSArray arrayWithObjects:@"我喜欢的",@"热门商品",@"促销商品",@"商品分类",@"常买推荐",@"常去超市",@"关注商品",@"我的收藏", nil];
    self.itemImageArray = [NSArray arrayWithObjects:@"喜欢",@"热门",@"促销",@"分类",@"买",@"超市",@"商品",@"收藏", nil];
    
    for (int i=0; i<8; i++) {
        HeaderItemViewModel* model = [[HeaderItemViewModel alloc]initWithImage:self.itemImageArray[i] Name:self.itemNameArray[i]];
        [self.dataSources addObject:model];
    }
}
@end
