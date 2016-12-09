//
//  LMUHomeCategoryView.m
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHomeCategoryView.h"
#import "HomeCategoryCollectionViewCell.h"
@interface LMUHomeCategoryView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property(nonatomic,strong)UIButton* likeButton;
//@property(nonatomic,strong)UIButton* hotButton;
//@property(nonatomic,strong)UIButton* promotionButton;
//@property(nonatomic,strong)UIButton* categoryButton;
//@property(nonatomic,strong)UIButton* oftenButton;
//@property(nonatomic,strong)UIButton* watchmarketButton;
//@property(nonatomic,strong)UIButton* watchcommorityButton;
//@property(nonatomic,strong)UIButton* collectionButton;

@property(nonatomic,strong)UICollectionView* collectionView;
@end

@implementation LMUHomeCategoryView

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
        _viewModel =  [[HomeHeaderViewModel alloc]init];
        [self initUI];
        
    }
    return self;
}


// 每个 button 高度 默认高度为 100 宽度为屏幕的1/4
//-(void)initUI{
//    
//    [self setBackgroundColor:[UIColor lightGrayColor]];
//    // like button
//    
//    UIView* likeView = [[UIView alloc]init];
//    [likeView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:likeView];
//    
//    @weakify(self)
//    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.left.top.equalTo(self);
//    }];
//    
//    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
//    [likeView addSubview:_likeButton];
//    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.centerX.equalTo(likeView.mas_centerX);
//        make.top.equalTo(likeView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(self.likeButton.mas_width);
//    }];
//    
//    UILabel* likelabel = [[UILabel alloc]init];
//    likelabel.font = [UIFont systemFontOfSize:12];
//    [likelabel setText:@"我喜欢的"];
//    [likelabel setTextColor:[UIColor lightGrayColor]];
//    [likeView addSubview:likelabel];
//    
//    [likelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(likeView.mas_centerX);
//        make.top.equalTo(self.likeButton.mas_bottom).offset(10);
//    }];
//    
//    
//    
//    UIView* hotView =[[UIView alloc]init];
//    [hotView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:hotView];
//    
//    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self)
//            make.top.equalTo(self);
//            make.left.equalTo(likeView.mas_right).offset(1);
//            make.width.equalTo(likeView.mas_width);
//        }];
//    
//    _hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_hotButton setBackgroundImage:[UIImage imageNamed:@"热门"] forState:UIControlStateNormal];
//    [hotView addSubview:_hotButton];
//    
//    [_hotButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(hotView.mas_centerX);
//        make.top.equalTo(hotView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(self.likeButton.mas_width);
//    }];
//    UILabel* hotLabel = [[UILabel alloc]init];
//    [hotLabel setTextColor:[UIColor lightGrayColor]];
//    [hotLabel setText:@"热门商品"];
//    hotLabel.font  = [UIFont systemFontOfSize:12];
//    [hotView addSubview:hotLabel];
//    
//    [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(hotView.mas_centerX);
//        make.top.equalTo(_hotButton.mas_bottom).offset(10);
//    }];
//    
//    
//    UIView* promotionView =[[UIView alloc]init];
//    [promotionView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:promotionView];
//    
//    [promotionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.top.equalTo(self);
//        make.left.equalTo(hotView.mas_right).offset(1);
//        make.width.equalTo(hotView.mas_width);
//    }];
//    
//    _promotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_promotionButton setBackgroundImage:[UIImage imageNamed:@"促销"] forState:UIControlStateNormal];
//    [promotionView addSubview:_promotionButton];
//    [_promotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(promotionView.mas_centerX);
//        make.top.equalTo(promotionView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(_likeButton.mas_width);
//    }];
//    UILabel* promotionLabel = [[UILabel alloc]init];
//    [promotionLabel setTextColor:[UIColor lightGrayColor]];
//    [promotionLabel setText:@"促销商品"];
//    promotionLabel.font  = [UIFont systemFontOfSize:12];
//    [promotionView addSubview:promotionLabel];
//    
//    [promotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(promotionView.mas_centerX);
//        make.top.equalTo(_likeButton.mas_bottom).offset(10);
//    }];
//    
//    
//    UIView* categoryView =[[UIView alloc]init];
//    [categoryView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:categoryView];
//    
//    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.top.right.equalTo(self);
//        make.left.equalTo(promotionView.mas_right).offset(1);
//        make.width.equalTo(promotionView.mas_width);
//    }];
//    
//    _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_categoryButton setBackgroundImage:[UIImage imageNamed:@"分类"] forState:UIControlStateNormal];
//    [categoryView addSubview:_categoryButton];
//    [_categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(categoryView.mas_centerX);
//        make.top.equalTo(categoryView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(_likeButton.mas_width);
//    }];
//    UILabel* _categoryLabel = [[UILabel alloc]init];
//    [_categoryLabel setTextColor:[UIColor lightGrayColor]];
//    [_categoryLabel setText:@"分类"];
//    _categoryLabel.font  = [UIFont systemFontOfSize:12];
//    [categoryView addSubview:_categoryLabel];
//    
//    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(categoryView.mas_centerX);
//        make.top.equalTo(_categoryButton.mas_bottom).offset(10);
//    }];
//    
//    UIView* oftenView =[[UIView alloc]init];
//    [oftenView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:oftenView];
//    [oftenView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(likeView.mas_bottom).offset(1);
//        make.left.bottom.equalTo(self);
//        make.height.equalTo(likeView.mas_height);
//    }];
//    
//    _oftenButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_oftenButton setBackgroundImage:[UIImage imageNamed:@"买"] forState:UIControlStateNormal];
//    [_oftenButton setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:_oftenButton];
//    [_oftenButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(oftenView.mas_centerX);
//        make.top.equalTo(oftenView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(_likeButton.mas_width);
//    }];
//    UILabel* oftenLabel = [[UILabel alloc]init];
//    [oftenLabel setTextColor:[UIColor lightGrayColor]];
//    [oftenLabel setText:@"常买推荐"];
//    oftenLabel.font  = [UIFont systemFontOfSize:12];
//    [oftenView addSubview:oftenLabel];
//    
//    [oftenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(oftenView.mas_centerX);
//        make.top.equalTo(_oftenButton.mas_bottom).offset(10);
//    }];
////
//    UIView* watchmarketView =[[UIView alloc]init];
//    [watchmarketView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:watchmarketView];
//    [watchmarketView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(hotView.mas_bottom).offset(1);
//        make.bottom.equalTo(self);
//        make.left.equalTo(oftenView.mas_right).offset(1);
//        make.width.equalTo(oftenView.mas_width);
//        make.height.equalTo(hotView.mas_height);
//    }];
//    _watchmarketButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_watchmarketButton setBackgroundImage:[UIImage imageNamed:@"超市"] forState:UIControlStateNormal];
//    [watchmarketView addSubview:_watchmarketButton];
//    
//    [_watchmarketButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(watchmarketView.mas_centerX);
//        make.top.equalTo(watchmarketView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(_likeButton.mas_width);
//    }];
//    UILabel* watchmarketLabel = [[UILabel alloc]init];
//    [watchmarketLabel setTextColor:[UIColor lightGrayColor]];
//    [watchmarketLabel setText:@"常去超市"];
//    watchmarketLabel.font  = [UIFont systemFontOfSize:12];
//    [watchmarketView addSubview:watchmarketLabel];
//    
//    [watchmarketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(watchmarketView.mas_centerX);
//        make.top.equalTo(_watchmarketButton.mas_bottom).offset(10);
//    }];
////
//    UIView* watchcommorityView =[[UIView alloc]init];
//    [watchcommorityView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:watchcommorityView];
//    [watchcommorityView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(promotionView.mas_bottom).offset(1);
//        make.bottom.equalTo(self);
//        make.left.equalTo(watchmarketView.mas_right).offset(1);
//        make.width.equalTo(watchmarketView.mas_width);
//        make.height.equalTo(promotionView.mas_height);
//    }];
//    _watchcommorityButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_watchcommorityButton setBackgroundImage:[UIImage imageNamed:@"商品"] forState:UIControlStateNormal];
//    [watchcommorityView addSubview:_watchcommorityButton];
//    
//    [_watchcommorityButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(watchcommorityView.mas_centerX);
//        make.top.equalTo(watchcommorityView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(_watchcommorityButton.mas_width);
//    }];
//    
//    UILabel* watchcommorityLabel = [[UILabel alloc]init];
//    [watchcommorityLabel setTextColor:[UIColor lightGrayColor]];
//    [watchcommorityLabel setText:@"关注商品"];
//    watchcommorityLabel.font  = [UIFont systemFontOfSize:12];
//    [watchcommorityView addSubview:watchcommorityLabel];
//    
//    [watchcommorityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(watchcommorityView.mas_centerX);
//        make.top.equalTo(_watchcommorityButton.mas_bottom).offset(10);
//    }];
////
//    UIView* collectionView =[[UIView alloc]init];
//    [collectionView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(categoryView.mas_bottom).offset(1);
//        make.bottom.right.equalTo(self);
//        make.left.equalTo(watchcommorityView.mas_right).offset(1);
//        make.width.equalTo(watchcommorityView.mas_width);
//        make.height.equalTo(watchmarketView.mas_height);
//    }];
//    
//    _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_collectionButton setBackgroundImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
//    [collectionView addSubview:_collectionButton];
////
//    [_collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(collectionView.mas_centerX);
//        make.top.equalTo(collectionView.mas_top).offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH /8);
//        make.height.equalTo(_collectionButton.mas_width);
//    }];
//    
//    
//    UILabel* collectionLabel = [[UILabel alloc]init];
//    [collectionLabel setTextColor:[UIColor lightGrayColor]];
//    [collectionLabel setText:@"我的收藏"];
//    collectionLabel.font  = [UIFont systemFontOfSize:12];
//    [collectionView addSubview:collectionLabel];
//    
//    [collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(collectionView.mas_centerX);
//        make.top.equalTo(_collectionButton.mas_bottom).offset(10);
//    }];
////
//
//}

-(void)initUI{
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor =[UIColor lightTextColor];
    collectionView.scrollEnabled = NO;
    
    [self addSubview:collectionView];
    @weakify(self)
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.top.bottom.equalTo(self);
    }];
    self.collectionView  =collectionView;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 8;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((kMainScreenWidth -3)/4, 80);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(9, 0, 9, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.collectionView registerClass:[HomeCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    HomeCategoryCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.itemViewModel = [self.viewModel getItemViewModelAtIndexPath:indexPath.row];
    
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.row];
    }
}



@end
