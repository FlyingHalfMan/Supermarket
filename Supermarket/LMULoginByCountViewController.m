//
//  LMULoginByCountViewController.m
//  Supermarket
//
//  Created by DL on 2016/11/19.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMULoginByCountViewController.h"
#import "LoginViewModel.h"
#import "UIView+Loading.h"
@interface LMULoginByCountViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *countImage;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *seperateView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdImage;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *seperateView2;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property(nonatomic,strong)LoginViewModel* viewModel;

@end

@implementation LMULoginByCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    _viewModel = [[LoginViewModel alloc]init];
    [self bindSignal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    @weakify(self)
    [_countImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(8);
        make.width.equalTo(self.countImage.mas_height);
        
    }];
    [_countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.countImage.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.equalTo(self.countImage.mas_height);
    }];
    
    [_seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.countImage.mas_bottom);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    [_pwdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.seperateView).offset(20);
        make.left.equalTo(self.view).offset(8);
        make.width.equalTo(self.pwdImage.mas_height);
        
    }];
    _pwdTextField.secureTextEntry = YES;
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.seperateView).offset(20);
        make.left.equalTo(self.pwdImage.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.equalTo(self.pwdImage);
    }];
    
    [_seperateView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.pwdImage.mas_bottom);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(_seperateView2.mas_bottom).offset(25);
        make.centerX.equalTo(self.view.mas_centerX);
        make.right.equalTo(self.view.mas_right).offset(-SCREEN_WIDTH/6);
        make.height.equalTo(@40);
    }];
    _loginButton.layer.cornerRadius = 10.f;
    
    
}

-(void)bindSignal{
    
    [_viewModel.updatedContentSignal subscribeNext:^(id x) {
        // 刷新界面信号
        [self.view DLLoadingHideInSelf];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [_viewModel.errorSignal subscribeNext:^(NSString* x) {
        // 错误信号
        [self.view DLLoadingHideInSelf];
        [self.view makeToast:x duration:3.f position:CSToastPositionCenter];
    }];
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        
            if(_countTextField.text == nil && _pwdTextField.text == nil)
            {
                [self.view makeToast:@"请输入帐号密码" duration:3.f position:CSToastPositionCenter];
            }
            else if(_countTextField.text == nil || _countTextField.text.length <1){
                [self.view makeToast:@"请输入注册手机号码或者邮箱号码" duration:3.f position:CSToastPositionCenter];
            }
            else if(_pwdTextField ==nil || _pwdTextField.text.length <1) {
                [self.view makeToast:@"请输入密码" duration:3.f position:CSToastPositionCenter];
            }
            else{
                _viewModel.count = _countTextField.text;
                _viewModel.pwd = _pwdTextField.text;
                [self.view DLLoadingInSelf];
               [_viewModel login];
            }
    }];
}
@end
