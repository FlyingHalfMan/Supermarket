//
//  HomeHeaderViewModel.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <BaseWithRAC/BaseWithRAC.h>
#import "HeaderItemViewModel.h"
@interface HomeHeaderViewModel : BaseViewModel
@property(nonatomic,readonly)RACSubject* itemSelectedSignal;

-(HeaderItemViewModel*)getItemViewModelAtIndexPath:(NSInteger)index;
@end
