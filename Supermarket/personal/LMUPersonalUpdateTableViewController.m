//
//  LMUPersonalUpdateTableViewController.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/4.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUPersonalUpdateTableViewController.h"
#import "TZImagePickerController.h"
#import "LMUPersonalViewModel.h"
@interface LMUPersonalUpdateTableViewController ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *registDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *workAddressLabel;
@property(nonatomic,strong) LMUPersonalViewModel* viewModel;


@end

@implementation LMUPersonalUpdateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel  =[[LMUPersonalViewModel alloc]init];
    [self bindSignal];

    [_viewModel loadData];
}

-(void)bindSignal{
    
    [[self.viewModel updatedContentSignal]subscribeNext:^(id x) {
        [self.view DLLoadingHideInSelf];
        [self.viewModel loadData];
    }];
    
    [self.viewModel.errorSignal subscribeNext:^(NSString* x) {
        [self.view DLLoadingHideInSelf];
        [self.view makeToast:x duration:3.f position:CSToastPositionCenter];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(void)loadData{
    _headImage.image = _viewModel.image ==nil?[UIImage imageNamed:@"no_photo"]:_viewModel.image;
    _nameLabel.text = _viewModel.name;
    _registDateLabel.text = _viewModel.registDate;
    _updateNameLabel.text = _viewModel.name;
    _genderLabel.text = _viewModel.gender;
    _occupationLabel.text = _viewModel.occupation;
    _mobileLabel.text = _viewModel.mobile;
    _emailLabel.text = _viewModel.email;
    _homeAddressLabel.text = _viewModel.homeAddress;
    _workAddressLabel.text = _viewModel.workAddress;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            TZImagePickerController* imagePicker =[[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePicker.sortAscendingByModificationDate =NO;
            imagePicker.allowPickingVideo =NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }

}
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [self.view DLLoadingInSelf];
    
    // 图片上传后的回调
   [self.viewModel.imageUpdateSignal subscribeNext:^(NSString* x) {
       [self.viewModel updateImage:x];
   }];
    [_viewModel uploadImage:photos[0]];
}


@end
