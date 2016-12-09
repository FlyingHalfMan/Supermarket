//
//  LMUOrdersViewController.m
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUOrdersViewController.h"

@interface LMUOrdersViewController ()

@end

@implementation LMUOrdersViewController

-(instancetype)init{

    self = [super init];
    if (self) {
        _indexSignal = [[RACSubject subject]setNameWithFormat:@"显示的订单枚举"];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{

}


-(void)bindSignal{
    [self.indexSignal subscribeNext:^(NSNumber* x) {
        CLog(@"选择的页面index是%d",x.intValue);
    }];




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
