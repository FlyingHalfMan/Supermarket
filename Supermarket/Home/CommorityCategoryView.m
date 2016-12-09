//
//  CommorityCategoryView.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "CommorityCategoryView.h"
#import "CommorityCategoryViewModel.h"

@interface CommorityCategoryView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)CommorityCategoryViewModel* viewModel;
@end
@implementation CommorityCategoryView

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.viewModel = [[CommorityCategoryViewModel alloc]init];
    }
    return self;
}

-(void)initUI{

    UITableView* tableView = [[UITableView alloc]init];
    tableView.dataSource = self;
    tableView.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}


@end
