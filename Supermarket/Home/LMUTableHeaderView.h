//
//  LMUTableHeaderView.h
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMUHomeCategoryView.h"
@interface LMUTableHeaderView : UIView
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)LMUHomeCategoryView* categoryView;
@end

