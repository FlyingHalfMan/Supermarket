//
//  LMUSearchHistoryView.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSearchHistoryView.h"
#import "LMUHistoryCell.h"
@implementation LMUSearchHistoryView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addMaintable];
        _viewModel= [[LMUSearchHistoryViewModel alloc]init];
        [self bindSignal];
        [self.viewModel loadData];
    }
    return self;
}
-(void)addMaintable{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor = [UIColor lightTextColor];
    [self addSubview:tableView];
    self.mainTable = tableView;
    self.autoDataArray = _viewModel.dataSource;
    @weakify(self);
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.right.left.bottom.equalTo(self);
    }];
    [self setCurrentRefreshType:AT_NO_REFRESH_STATE];
}
-(void)bindSignal{
    [self.viewModel.updatedContentSignal subscribeNext:^(NSMutableArray* x) {
        self.autoDataArray =x;
        [self.mainTable reloadData];
    }];
    
    [self.viewModel.errorSignal subscribeNext:^(NSError* error) {
        [self makeToast:[NSString stringWithFormat:@"ERROR:%@",error] duration:3.f position:CSToastPositionCenter];
        [self.mainTable reloadData];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [_viewModel numberofSectionInTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_viewModel numberOfRowsInSection:0];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_viewModel.dataSource == nil || _viewModel.dataSource.count <1) {
        [self.mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        UITableViewCell*cell = [self.mainTable dequeueReusableCellWithIdentifier:@"cell"];
        if (cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"没有搜索记录";
        return cell;
    }else{
    LMUHistoryCell* cell = [self.mainTable dequeueReusableCellWithIdentifier:@"cell"];
    [self.mainTable registerClass:[LMUHistoryCell class] forCellReuseIdentifier:@"cell"];
    if (cell) {
        cell = [[LMUHistoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    [[cell.deleteButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        [_viewModel.dataSource removeObjectAtIndex:indexPath.row];
        [self.mainTable reloadData];
    }];
        cell.nameLabel.text = [_viewModel getTextAtIndexPath:indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清除查询记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth =.5f;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.width.equalTo(view.mas_width).multipliedBy(.5f);
        make.top.equalTo(view.mas_top).offset(8);
        make.bottom.equalTo(view.mas_bottom).offset(-8);

    }];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}
@end
