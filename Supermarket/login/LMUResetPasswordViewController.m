//
//  LMUResetPasswordViewController.m
//  Supermarket
//
//  Created by DL on 2016/11/19.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUResetPasswordViewController.h"
#import "LoginViewModel.h"
@interface LMUResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property(nonatomic,strong) LoginViewModel* viewModel;

@end

@implementation LMUResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contactTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
    _viewModel =[[LoginViewModel alloc]init];
    @weakify(self)
    [[_verifyCodeButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        @strongify(self)
        if (_contactTextField.text == nil || _contactTextField.text.length <1) {
            [self.view makeToast:@"请输入手机号" duration:3.f position:CSToastPositionCenter];
        }
        else{
            [self getResetPasswordVerifyCodeWithContact:self.contactTextField.text];
        }
    }];
    
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        
        @strongify(self)
        if (_contactTextField.text ==nil ) {
            [self.view makeToast:@"请输入手机号" duration:3.f position:CSToastPositionCenter];
        }
        else if( self.verifyCodeTextField.text ==nil || self.verifyCodeTextField.text){
        
            [self.view makeToast:@"请输入验证码，或者验证码格式错误" duration:3.f position:CSToastPositionCenter];
        }
        else{
        
            CLog(@"next step");
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getResetPasswordVerifyCodeWithContact:(NSString*)contact{

    updatePwdVerifyCodeURL = [updatePwdVerifyCodeURL stringByAppendingPathComponent:contact];
    @weakify(self)
    [[NetworkManager sharedManager]getDataWithUrl:updatePwdVerifyCodeURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        @strongify(self)
        if (statusCode == 200) {
            Message* message  = [[Message alloc]initWithData:data error:nil];
            [self.view makeToast:message.message duration:3.f position:CSToastPositionCenter];
        }
        else{
            [self.view makeToast:errorMessage duration:3.f position:CSToastPositionCenter];
        }
    }];
}

-(void)nextStep:(NSString*)count verifyCode:(NSString*)verifyCode{
    

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
