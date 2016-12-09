//
//  CommorityTableViewCell.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "CommorityTableViewCell.h"


@interface CommorityTableViewCell ()

@end
@implementation CommorityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.label = [[UILabel alloc]init];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    self.label.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.label];
    @weakify(self)
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.left.right.top.bottom.equalTo(self);
    }];
}

@end
