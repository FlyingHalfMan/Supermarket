//
//  LMUHeadView.m
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHeadView.h"
@interface LMUHeadView ()
@property(nonatomic,weak)UILabel*nameLabel;
@property(nonatomic,weak)UILabel*genderLabel;
@property(nonatomic,weak)UIImageView* headImage;
@end
@implementation LMUHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
        [self loadData];
    }
    return self;
}

-(void)initView{
    
    // 头像
    UIImageView* headImage = [[UIImageView alloc]init];
    headImage.layer.cornerRadius = headImage.frame.size.width/2;
    headImage.image = [UIImage imageNamed:@"no_photo"];
    [self addSubview:headImage];
    self.headImage =headImage;
    
    
    @weakify(self);
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(headImage.mas_width);
    }];
    
    //名字'
    UILabel* name  = [[UILabel alloc]init];
    [self addSubview:name];
    [name setText:@"未登录"];
    [name setTextColor:[UIColor whiteColor]];
    [name setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20]];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(headImage.mas_bottom).offset(8);
        make.centerX.equalTo(self);
       // make.left.lessThanOrEqualTo(self.mas_left);
    }];
    self.nameLabel = name;
    
    // 性别
    
    UILabel* gender= [[UILabel alloc]init];
    [self addSubview:gender];
    [gender setText:@""];
    [gender setTextColor:[UIColor whiteColor]];
    self.genderLabel = gender;
    [gender mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(_nameLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
-(void)loadData{
    
    UserProfile* profile = [[NetworkManager sharedManager]myProfile];
    _nameLabel.text = profile.name;
    _genderLabel.text = profile.gender;
    [[NetworkManager sharedManager]getUploadImageWithName:profile.image completionHandler:^(long statusCode, NSData *data) {
        if (statusCode ==200) {
            _headImage.image = [UIImage imageWithData:data];
            if (_headImage.image == nil) {
                _headImage.image = [UIImage imageNamed:@"no_photo"];
            }
            
        }
        else {
            _headImage.image = [UIImage imageNamed:@"no_photo"];
        }
    }];

}



@end
