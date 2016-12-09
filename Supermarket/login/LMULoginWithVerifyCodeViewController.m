//
//  LMULoginWithVerifyCodeViewController.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/8.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMULoginWithVerifyCodeViewController.h"
#import "LoginViewModel.h"
@interface LMULoginWithVerifyCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property(nonatomic,strong)LoginViewModel* viewModel;
@end

@implementation LMULoginWithVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel =[[LoginViewModel alloc]init];
    // Do any additional setup after loading the view.
    [self bindSignal];
}


-(void)bindSignal{
    
    [self.viewModel.updatedContentSignal subscribeNext:^(NSString* x) {
        [self.view makeToast:x duration:3.f position:CSToastPositionCenter];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.viewModel.errorSignal subscribeNext:^(NSString* x) {
        [self.view makeToast:x duration:3.f position:CSToastPositionCenter];
    }];

    self.verifyCodeButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        if (self.contactTextField.text == nil && self.contactTextField.text.length <4) {
            UIAlertController* alerVC = [UIAlertController alertControllerWithTitle:@"警告" message:@"请先输入手机号／邮箱号" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alerVC addAction:alertAction];
            
            [self presentViewController:alerVC animated:YES completion:nil];
        }
        else {
            [self.viewModel getLoginVerifyCode:self.contactTextField.text];
                  }
        return [RACSignal empty];
    }];
    
    
    self.loginButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        if (self.verifyCodeTextField.text ==nil || self.verifyCodeTextField.text.length !=6) {
            [self.view makeToast:@"验证码错误，请检查验证码格式" duration:3.f position:CSToastPositionCenter];
        }else{
        
            [self.viewModel loginWithCount:self.contactTextField.text VerifyCode:self.verifyCodeTextField.text];
        }
        return [RACSignal empty];
    }];
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
