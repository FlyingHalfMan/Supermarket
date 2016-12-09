//
//  LMUHomeView.m
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHomeView.h"
#import "LMUHomeCategoryView.h"
#import "LMUTableHeaderView.h"
#import "HomeViewModel.h"
#import "UIView+Loading.h"
@interface LMUHomeView()<UITableViewDelegate,UITableViewDataSource,CategoryViewDelegate>
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)LMUHomeCategoryView* categoryView;

@end
@implementation LMUHomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[HomeViewModel alloc]init];
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    // 添加tableView
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor lightTextColor];
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 320)];
    LMUTableHeaderView* headerView = [[LMUTableHeaderView alloc]init];
    headerView.categoryView.delegate = self;
    [tableView.tableHeaderView addSubview:headerView];
    @weakify(self)
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(tableView.tableHeaderView);
    }];
    [self addSubview:tableView];
    self.mainTable = tableView;
    self.autoDataArray = _viewModel.dataSource;
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.right.left.bottom.equalTo(self);
    }];
      [self setCurrentRefreshType:AT_ALL_REFRESH_STATE];
 
    [self getLoadingMoreTableData:^{
        @strongify(self);
        [self.viewModel loadMoreData];
    }];
    [self getRefreshTableData:^{
        @strongify(self);
        [self.viewModel loadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =@"hehe";
    return cell;
}

-(void)didSelectItemAtIndex:(NSInteger)index{
    [self.viewModel.itemSelectedSignal sendNext:[NSNumber numberWithInteger:index]];
}


@end
