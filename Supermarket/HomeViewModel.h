//
//  HomeViewModel.h
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUTableViewCellViewModel.h"
@interface HomeViewModel : BaseViewModel

@property(nonatomic,strong)RACSubject* itemSelectedSignal;
@property(nonatomic,strong)NSMutableArray* dataSource;

@property(nonatomic,strong)RACSubject* searchSignal;

-(void)loadMoreData;
-(void)loadData;
-(LMUTableViewCellViewModel*) getCellViewModelByIndex:(NSInteger)index;
@end
