//
//  LMUMainTabBarController.m
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUMainTabBarController.h"

@interface LMUMainTabBarController ()

@end

@implementation LMUMainTabBarController

-(instancetype)init{
    self = [super init];
    if (self) {
        _personalVC = [[LMUPersonalTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        _cartVC = [[LMUCartTableViewController alloc]init];
        _mapVC = [[LMUMapViewController alloc]init];
        _homeVC = [[LMUHomeViewController alloc]init];
    }
    return self;
}


    // 初始化界面
-(void)initUI{
    
     _personalVC = [[LMUPersonalTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController* peronalNAV = [[UINavigationController alloc]initWithRootViewController:_personalVC];
    // 设置 item
    UITabBarItem* item = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"tabBar_personal.png"] selectedImage:[UIImage imageNamed:@"tabBar_personal_selected.png"]];
    
    peronalNAV.tabBarItem = item;
    
    //设置购物车
    _cartVC = [[LMUCartTableViewController alloc]init];
    UINavigationController* cartNAV = [[UINavigationController alloc]initWithRootViewController:_cartVC];
    UITabBarItem* item2 = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[UIImage imageNamed:@"tabBar_shopping"] selectedImage:[UIImage imageNamed:@"tabBar_shopping_selected"]];
    cartNAV.tabBarItem = item2;
    
        // 地图
    _mapVC = [[LMUMapViewController alloc]init];
    UINavigationController* mapNAV = [[UINavigationController alloc]initWithRootViewController:_mapVC];
    UITabBarItem* item3 = [[UITabBarItem alloc]initWithTitle:@"附近超市" image:[UIImage imageNamed:@"tabBar_nearMe"] selectedImage:[UIImage imageNamed:@"tabBar_nearMe_selected"]];
    mapNAV.tabBarItem = item3;
    
    
    //首页
    _homeVC = [[LMUHomeViewController alloc]init];
    UINavigationController* homeNAV = [[UINavigationController alloc]initWithRootViewController:_homeVC];
    UITabBarItem* item4 = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tabBar_home"] selectedImage:[UIImage imageNamed:@"tabBar_home_selected"]];
    homeNAV.tabBarItem = item4;
    
    [self addChildViewController:homeNAV];
    [self addChildViewController:mapNAV];
    [self addChildViewController:cartNAV];
    [self addChildViewController:peronalNAV];
    
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
