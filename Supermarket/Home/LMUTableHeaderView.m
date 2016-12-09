//
//  LMUTableHeaderView.m
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUTableHeaderView.h"
#import "LMUHomeCategoryView.h"
@interface LMUTableHeaderView()<UIScrollViewDelegate>
@end
@implementation LMUTableHeaderView

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
        [self initUI];
    }
    return self;
}

-(void)initUI{

    _scrollView = [[UIScrollView alloc]init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    //    [_scrollView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:_scrollView];
    @weakify(self)
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCREEN_HEITH/4);
    }];
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"促销1"]];
    [imageView setBackgroundColor:[UIColor redColor]];
    [_scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(_scrollView);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(_scrollView.mas_height);
    }];
    
    UIImageView*imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"促销2"]];
    [_scrollView addSubview:imageView2];
    [imageView2 setBackgroundColor:[UIColor greenColor]];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_scrollView);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(imageView.mas_right);
        make.height.equalTo(_scrollView.mas_height);
    }];
    
    UIImageView*imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"促销3"]];
    [imageView3 setBackgroundColor:[UIColor yellowColor]];
    [_scrollView addSubview:imageView3];
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_scrollView);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(imageView2.mas_right);
        make.height.equalTo(_scrollView.mas_height);
    }];
    
    LMUHomeCategoryView* categoryView = [[LMUHomeCategoryView alloc]init];
    [self addSubview:categoryView];
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(_scrollView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.categoryView = categoryView;
}

@end
