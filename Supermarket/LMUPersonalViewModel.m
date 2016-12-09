//
//  LMUPersonalViewModel.m
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUPersonalViewModel.h"
#import "UserService.h"
@interface LMUPersonalViewModel()
@property(nonatomic,strong)UserService* userService;

@end


@implementation LMUPersonalViewModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        _userService = [[UserService alloc]init];
        _imageUpdateSignal = [[RACSubject subject]setNameWithFormat:@"image update"];
    }
    return self;
}

-(BOOL)isLogin{
    
    return [_userService isLogin];

}
-(void)loadData{
    UserProfile* profile =[[NetworkManager sharedManager]myProfile];
    
    _name = profile.name;
    _registDate = [Utils parseDateToString:profile.registDate];
    [[NetworkManager sharedManager]getUploadImageWithName:profile.image completionHandler:^(long statusCode, NSData *data) {
        if (statusCode ==200) {
            _image = [UIImage imageWithData:data];
            if (_image ==nil) {
                _image =[UIImage imageNamed:@"no_photo"];
            }
        }
        else {
            _image =[UIImage imageNamed:@"no_photo"];
            
        }
        [self.imageUpdateSignal sendNext:_image];
    }];
    _gender = profile.gender;
    _occupation = profile.occupation==nil?@"未设置":profile.occupation;
    _mobile  = profile.mobile ==nil?@"未设置":profile.mobile;
    _email  = profile.email == nil?@"未设置":profile.email;
    _homeAddress = profile.homeAddress ==nil?@"未添加":profile.homeAddress;
    _workAddress =profile.workAddress==nil?@"未添加":profile.workAddress;
    [self.updatedContentSignal sendNext:@"update"];
}
-(void)uploadImage:(UIImage *)image{

    RACSignal* signal = [self.userService uploadImage:image ];
    [signal subscribeNext:^(NSString* x) {
        [self.imageUpdateSignal sendNext:x];
    }error:^(NSError *error) {
        NSLog(@"error %@",error);
        [self.errorSignal sendNext:[error description]];
    }];
}

-(void)updateImage:(NSString *)imageName{

    RACSignal* signal = [self.userService updateImage:imageName];
    [signal subscribeNext:^(id x) {
        [self.updatedContentSignal sendNext:@"update profile"];
    }error:^(NSError *error) {
        [self.errorSignal sendNext:[error description]];
    }];
    
}
@end
