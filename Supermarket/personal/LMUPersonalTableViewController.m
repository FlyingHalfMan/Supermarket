//
//  LMUPersonalTableViewController.m
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUPersonalTableViewController.h"
#import "LMUHeadView.h"
#import "LMUPersonalUpdateTableViewController.h"
#import "LMUFunctionView.h"
@interface LMUPersonalTableViewController ()
@property(nonatomic,strong)LMUHeadView* headView;
@end

@implementation LMUPersonalTableViewController


// 初始化界面  initUI
// 绑定信号    bindSignal
// 获取数据    loadData;

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        
        // 初始化viewModel
        self.personalViewModel = [[LMUPersonalViewModel alloc]init];
        _OrderCategoryView = [[LMUOrderlCategoryView alloc]init];
        _service = [[UserService alloc]init]; 
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if ([_personalViewModel isLogin]) {
        
    }
}

-(void)initUI{
    NSLog(@"%@",self.navigationController);
    self.navigationItem.title = @"个人主页";
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    
    UIImageView* view  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_back_image"]];
    //[view setBackgroundColor:[UIColor redColor]];
     _headView = [[LMUHeadView alloc]init];
    

    self.tableView.tableHeaderView =nil;
    self.tableView.tableHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEITH/3)];
    [self.tableView.tableHeaderView addSubview:view];
    [self.tableView.tableHeaderView addSubview: self.headView];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom);
        make.width.equalTo(view.mas_width).multipliedBy(.5f);
        make.height.equalTo(view.mas_height);
    }];
    //为headView 添加一个手势
    UITapGestureRecognizer* tapGuesture = [[UITapGestureRecognizer alloc]init];
    self.headView.userInteractionEnabled = YES;
    [self.headView addGestureRecognizer:tapGuesture];
    [[tapGuesture rac_gestureSignal]subscribeNext:^(id x) {
        NSLog(@"tap tao");
        if (![_personalViewModel isLogin]) {
            CLog(@"not login yet");
            UIStoryboard* loginStroryBoard = [UIStoryboard storyboardWithName:@"LoginRegist" bundle:nil];
            [self presentViewController:loginStroryBoard.instantiateInitialViewController animated:YES completion:nil];
        }
        else {
        
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
            LMUPersonalUpdateTableViewController* updateVC =storyBoard.instantiateInitialViewController;
            [self.navigationController pushViewController:updateVC animated:YES];
            
        }
        
    }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"personal_back_image"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}
-(void)bindSignal{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 2;

            
        default:
            return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //不同cell 设置不同的属性
    //第一个cell 显示
    //先判断section
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text =@"我的订单";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.textColor = [UIColor blackColor];
                }
                    break;
                    
                default:{
                    [cell addSubview:_OrderCategoryView];
                    [_OrderCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.equalTo(cell);
                        make.right.equalTo(cell).offset(-8);
                        make.left.equalTo(cell).offset(8);
                    }];
                    cell.userInteractionEnabled =NO;
                }
                    break;
            }
            break;
        case 1:{
            //显示常用工具
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"常用工具";
                    cell.userInteractionEnabled =NO;
                }
                    break;
                    
                default:{
                
                    LMUFunctionView* functionView  = [[NSBundle mainBundle]loadNibNamed:@"FunctionView" owner:self options:nil].firstObject;
                    [cell addSubview:functionView];
                    [functionView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.right.bottom.equalTo(cell);
                    }];
                    
                }
                    break;
            }
        
        
        }
            break;
            
        default:{
            cell.textLabel.text =@"关于我们";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        }
            break;
    }
    
 
    
    // Configure the cell...
  //  cell.textLabel.text =@"hehe";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 1:
                    return 80;
                    break;
                    
                default:
                    return 44;
                    break;
            }
            
        }
            break;
            
        default:{
            switch (indexPath.row) {
                case 1:
                    return 200;
                    break;
                    
                default:
                    return 44;
                    break;
            }
        }
            break;
    }


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
            // 点击订单
            
        case 0:
            CLog(@"进入查看全部订单");
            break;
            
        default:
            break;
    }



}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
