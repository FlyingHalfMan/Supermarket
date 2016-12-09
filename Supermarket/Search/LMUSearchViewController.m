//
//  LMUSearchViewController.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSearchViewController.h"
#import "LMUSearchHistoryView.h"
@interface LMUSearchViewController ()
@property(nonatomic,strong)UITextField* searchField;
@property(nonatomic,strong)LMUSearchHistoryView* historyView;
@end

@implementation LMUSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets =NO;
    [self initUI];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    [self.navigationBarView.leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    
    [self.navigationBarView.rightButton setBackgroundColor:[CommUtls colorWithHexString:@"#00FF00"]];
    [self.navigationBarView.rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    
    _searchField = [[UITextField alloc]init];
    _searchField.placeholder =@"请输入搜索内容";
    [self.navigationBarView.titleView addSubview:_searchField];
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_navigationBarView.titleView);
    }];
    UIView* underLine = [[UIView alloc] init];
    [underLine setBackgroundColor:[UIColor blackColor]];
    [_navigationBarView.titleView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchField.mas_bottom);
        make.left.right.equalTo(_navigationBarView.titleView);
        make.bottom.equalTo(_navigationBarView.titleView).offset(-8);
        make.height.equalTo(@1);
    }];
    
    @weakify(self)
    [_navigationBarView.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(60);
        make.right.equalTo(self.navigationBarView).offset(-8);
        make.bottom.equalTo(self.navigationBarView).offset(-8);
    }];
    
     _historyView = [[LMUSearchHistoryView alloc]init];
    [self.view addSubview:_historyView];
    [self nearByNavigationBarView:_historyView isShowBottom:YES];
}

-(void)leftButtonClick{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonClick{

    [_historyView.viewModel searchWithText:_searchField.text];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
