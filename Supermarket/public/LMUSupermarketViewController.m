//
//  LMUSupermarketViewController.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSupermarketViewController.h"
#import "LMUSuperMarketCategoryView.h"
@interface LMUSupermarketViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

@implementation LMUSupermarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"personal_back_image"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new ]];
    NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"LMUSupermarketCategoryView" owner:self options:nil];
    LMUSuperMarketCategoryView* categoryView = [array firstObject];
    
    self.navigationItem.titleView =[[UIView alloc]initWithFrame:CGRectMake(20, 0, 150, 44)];
    [self.navigationItem.titleView addSubview:categoryView];
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.navigationItem.titleView);
    }];
    categoryView.detailButton.rac_command =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [categoryView.detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
              [categoryView.discussButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _scrollView.contentOffset =CGPointMake(0, 0);
        return [RACSignal empty];
    }];
    
    categoryView.discussButton.rac_command =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [categoryView.discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [categoryView.detailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _scrollView.contentOffset =CGPointMake(kMainScreenWidth, 0);
        return [RACSignal empty];
    }];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    


}
- (IBAction)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)shareAction:(id)sender {
    NSLog(@"share is not complete");
    
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
