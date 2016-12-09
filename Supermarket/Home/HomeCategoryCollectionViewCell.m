//
//  HomeCategoryCollectionViewCell.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "HomeCategoryCollectionViewCell.h"

@interface HomeCategoryCollectionViewCell ()
@property(nonatomic,strong)UIImageView* image;
@property(nonatomic,strong)UILabel* label;

@end
@implementation HomeCategoryCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        _itemViewModel = [[HeaderItemViewModel alloc]init];
        [self initUI];
    }
    return self;
}

-(void)setItemViewModel:(HeaderItemViewModel *)itemViewModel{

    _itemViewModel = itemViewModel;
    self.image.image = [UIImage imageNamed:_itemViewModel.imageName];
    self.label.text = _itemViewModel.name;
}

-(void)initUI{
    
    self.layer.borderWidth = .1f;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self addSubview:imageView];
    
    @weakify(self)
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self)
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(imageView.mas_width);
    }];
    self.image = imageView;
    
    UILabel* label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(imageView.mas_bottom).offset(8);
        make.left.right.equalTo(self);
    }];
    self.label = label;
}
@end
