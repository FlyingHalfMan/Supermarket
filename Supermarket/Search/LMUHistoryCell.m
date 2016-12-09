//
//  LMUHistoryCell.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHistoryCell.h"

@implementation LMUHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{

    _nameLabel = [[UILabel alloc]init];
    [self addSubview:_nameLabel];
    @weakify(self)
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.left.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self).offset(8);
        make.right.bottom.equalTo(self).offset(-8);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    // Configure the view for the selected state
}

@end
