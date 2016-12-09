//
//  LMUHomeCategoryView.h
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeaderViewModel.h"


@protocol CategoryViewDelegate <NSObject>
-(void)didSelectItemAtIndex:(NSInteger)index;

@end
@interface LMUHomeCategoryView : UIView
@property(nonatomic,strong)HomeHeaderViewModel* viewModel;
@property(nonatomic,weak)id<CategoryViewDelegate> delegate;
@end
