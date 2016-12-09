//
//  LMUSearchHistoryView.h
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "AutoTableView.h"
#import "LMUSearchHistoryViewModel.h"
@interface LMUSearchHistoryView : AutoTableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)LMUSearchHistoryViewModel* viewModel;
@end
