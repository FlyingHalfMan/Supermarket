//
//  LMULoginViewController.m
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMULoginViewController.h"
#import "LMUResetPasswordViewController.h"
@interface LMULoginViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginCountButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyLoginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LMULoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self bindSignal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces =NO;
    _scrollView.delegate =self;
    [_loginCountButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"personal_back_image"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new ]];

}
-(void)bindSignal{
    
    @weakify(self)
    [[_loginCountButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        @strongify(self)
        [UIView  animateWithDuration:.5f animations:^{
            @strongify(self)
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self.loginCountButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.verifyLoginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }];
        
    }];
    
    [[self.verifyLoginButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        @strongify(self)
        [UIView animateWithDuration:.5f animations:^{
            @strongify(self)
            self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            [self.verifyLoginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.loginCountButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }];
    }];
    
    
    self.navigationItem.rightBarButtonItem.rac_command =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"更多选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* fogotAction = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            @strongify(self)
            CLog(@"click forgot password");
            LMUResetPasswordViewController* resetPasswordVC = [[UIStoryboard storyboardWithName:@"LoginRegist" bundle:nil] instantiateViewControllerWithIdentifier:@"regist"];
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
            
        }];
        
        UIAlertAction* registAction = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }];
        
        UIAlertAction* cancelLoginAction = [UIAlertAction actionWithTitle:@"取消登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            CLog(@"click forgot password");
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            CLog(@"click forgot password");
        }];
        
        [alertVC addAction:fogotAction];
        [alertVC addAction:registAction];
        [alertVC addAction:cancelLoginAction];
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    
    // click cancel
    self.navigationItem.leftBarButtonItem.rac_command =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int index = scrollView.contentOffset.x /SCREEN_WIDTH;
    if (index == 0) {
        [_loginCountButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
          [_verifyLoginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else {
    
        [_verifyLoginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_loginCountButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

-(void)pushRegistViewController{

    UIStoryboard* storyBoard = self.storyboard;
    


}

-(void)pushResetPasswordViewController{

    LMUResetPasswordViewController* resetPwdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"regist"];
    [self.navigationController pushViewController:resetPwdVC animated:nil];


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
