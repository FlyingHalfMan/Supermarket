//
//  LMUSearchHistoryViewModel.h
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//
typedef enum {
    SearchTypeMarket,
    SearchTypeCommority
}SearchType;

#import <BaseWithRAC/BaseWithRAC.h>

@interface LMUSearchHistoryViewModel : BaseViewModel
@property(nonatomic,strong)NSMutableArray* dataSource;
@property(nonatomic,assign)SearchType searchType;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(NSInteger)numberofSectionInTableView;
-(void)loadData;
-(NSString*)getTextAtIndexPath:(NSInteger)index;
-(void)searchWithText:(NSString*)text;
@end
