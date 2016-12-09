//
//  DLSquareNavigationView.h
//  XXQ
//
//  Created by DL on 2016/11/16.
//  Copyright © 2016年 LiningZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigatonBarView.h"
@interface DLSquareNavigationView : UIView<NavigatonBarViewDelegate>

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIImageView *backGroundImgeView;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,assign) id<NavigatonBarViewDelegate>delegate;
@property (nonatomic,assign) NavigationBarStyle navagationBarStyle;

- (id)initLeftButton:(UIButton *)leftButton
         rightButton:(UIButton *)rightButton
           titleView:(UIView *)titleView;

- (id)initLeftButtonPicNormal:(UIImage *)leftImageNormal
       leftButtonPicHighlight:(UIImage *)leftImageHighlight
         rightButtonPicNormal:(UIImage *)rightImageNormal
      rightButtonPicHighlight:(UIImage *)rightImageHighlight
                    fontColor:(UIColor *)color;
@end
