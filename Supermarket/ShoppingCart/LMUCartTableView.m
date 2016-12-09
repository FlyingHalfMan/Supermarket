//
//  LMUCartTableView.m
//  Supermarket
//
//  Created by DL on 2016/11/25.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUCartTableView.h"

@interface LMUCartTableView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation LMUCartTableView


-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)initUI{

    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.mainTable = tableView;
    @weakify(self)
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.top.left.right.bottom.equalTo(self);
    }];
    
    // 加载更多
    [self getLoadingMoreTableData:^{
        
    }];
    
    // 刷新数据
    [self getRefreshTableData:^{
        
    }];
    
}

@end
