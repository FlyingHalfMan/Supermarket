//
//  DLSquareNavigationController.m
//  XXQ
//
//  Created by DL on 2016/11/16.
//  Copyright © 2016年 LiningZhang. All rights reserved.
//

#import "DLSquareNavigationController.h"
#import "Masonry.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface DLSquareNavigationController ()

@end

@implementation DLSquareNavigationController

- (instancetype)init{
    self = [super init];
    if (self) {
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _navigationBarView = [[DLSquareNavigationView alloc]initLeftButtonPicNormal:[UIImage imageNamed:@""] leftButtonPicHighlight:nil rightButtonPicNormal:[UIImage imageNamed:@""] rightButtonPicHighlight:[UIImage imageNamed:@""] fontColor:[UIColor whiteColor]];
    _navigationBarView.backGroundImgeView.image = nil;
    _navigationBarView.backgroundColor = [CommUtls colorWithHexString:APP_MainColor];
    //_navigationBarView.backgroundColor = [UIColor whiteColor];
    _navigationBarView.navagationBarStyle = Left_right_button_show;
    _navigationBarView.delegate = self;
    
    [self.view addSubview:_navigationBarView];
    @weakify(self)
    [_navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(NAVIGATIONBAR_HEIGHT);
    }];

}

- (void)nearByNavigationBarView:(UIView *)tView isShowBottom:(BOOL)bottom
{
    @weakify(self)
    [tView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(_navigationBarView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if(IsIOS7)
        {
            if(bottom)
                make.bottom.equalTo(self.view.mas_bottom).offset(-TABLE_BAR_HEIGHT);
            else
                make.bottom.equalTo(self.view.mas_bottom);
        }
        else
        {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.closeIQKeyboardManager) {
        [[IQKeyboardManager sharedManager] setEnable:NO];
    }
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.closeIQKeyboardManager) {
        [[IQKeyboardManager sharedManager] setEnable:YES];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (IsIOS7) {
        if (self.closeInteractiveGesture) {
            CLog(@"该页面不支持ios7手势NO===%@",self.class);
        }else{
            CLog(@"该页面支持ios7手势YES====%@",self.class);
        }
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.closeInteractiveGesture;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick
{
}
-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleDefault;
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
