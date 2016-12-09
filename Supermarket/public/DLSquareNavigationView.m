//
//  DLSquareNavigationView.m
//  XXQ
//
//  Created by DL on 2016/11/16.
//  Copyright © 2016年 LiningZhang. All rights reserved.
//

#import "DLSquareNavigationView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import <Masonry/Masonry.h>

const float navi_hight = 64.0;
const float navi_titleView_width = 200.0;
const float navi_button_width = 60;
const float navi_interval = 0;
const float navi_font = 14.0;


@interface DLSquareNavigationView()
{
    UIView * _titleView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIImageView *_backGroundImgeView;
    UILabel *_rightLabel;
    UILabel *_leftLabel;
    UIImage *leftButtonImageNormarl;
    UIImage *leftButtonImageHighlight;
    UIImage *rightButtonImageNormarl;
    UIImage *rightButtonImageHighlight;
}
@end
@implementation DLSquareNavigationView

-(id)initLeftButton:(UIButton *)leftButton rightButton:(UIButton *)rightButton titleView:(UIView *)titleView{
    _leftButton = leftButton;
    _rightButton = rightButton;
    _titleView = titleView;
    
    self = [super init];
    if (self) {
        NSInteger top = 0;
        if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            top = 20;
        
        if (leftButton != nil) {
            [self addSubview:_leftButton];
            
            [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(top);
                make.width.mas_equalTo(40);
                make.left.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }
        
        if (rightButton != nil) {
            [self addSubview:_rightButton];

            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(top + 8);
                make.width.mas_equalTo(40);
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(-8);
            }];
        }
        
        if (_titleView != nil) {
            [self addSubview:_titleView];
            
            [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(top);
                make.right.equalTo(_rightButton.mas_left).offset(-5);
                make.left.equalTo(_leftButton.mas_right).offset(5);
                make.bottom.equalTo(0);
            }];
        }
    }
    return self;
}

- (id)initLeftButtonPicNormal:(UIImage *)leftImageNormal
       leftButtonPicHighlight:(UIImage *)leftImageHighlight
         rightButtonPicNormal:(UIImage *)rightImageNormal
      rightButtonPicHighlight:(UIImage *)rightImageHighlight
                    fontColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        leftButtonImageNormarl = leftImageNormal;
        leftButtonImageHighlight = leftImageHighlight;
        rightButtonImageNormarl = rightImageNormal;
        rightButtonImageHighlight = rightImageHighlight;
        
        _backGroundImgeView = [[UIImageView alloc]init];
        [_backGroundImgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor clearColor];
        [_titleView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _leftButton = [[UIButton alloc]init];
        _leftButton.backgroundColor = [UIColor clearColor];
        [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [_leftButton addTarget:self action:@selector(navigationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_leftButton setTitle:@"" forState:UIControlStateNormal];
        
        _rightButton = [[UIButton alloc]init];
        _rightButton.backgroundColor=[UIColor clearColor];
        [_rightButton addTarget:self action:@selector(navigationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_rightButton setTitle:@"" forState:UIControlStateNormal];
        
        _leftLabel=[[UILabel alloc]init];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = [UIFont boldSystemFontOfSize:navi_font];
        _leftLabel.textColor = color;
        [_leftLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.font = [UIFont boldSystemFontOfSize:navi_font];
        _rightLabel.textColor = color;
        [_rightLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_backGroundImgeView];
        [self addSubview:_titleView];
        [self addSubview:_leftButton];
        [self addSubview:_rightButton];
        [self addSubview:_rightLabel];
        [self addSubview:_leftLabel];
        @weakify(self)
        [_backGroundImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.bottom.left.right.equalTo(self);
        }];
        
        NSInteger top = 0;
        if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            top = 20;
        
        
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(40);
            make.left.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(40);
            make.left.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(60);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(60);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.right.mas_equalTo(_rightButton.mas_left).offset(-10);
            make.left.mas_equalTo(_leftButton.mas_right).offset(10);
            make.bottom.equalTo(self);
            
        }];
        
    }
    return self;
}

- (void)navigationLeftButtonClick
{
    if([_delegate respondsToSelector:@selector(leftButtonClick)])
        [_delegate leftButtonClick];
}

- (void)navigationRightButtonClick
{
    if([_delegate respondsToSelector:@selector(rightButtonClick)])
        [_delegate rightButtonClick];
}

- (void)setNavagationBarStyle:(NavigationBarStyle)navagationBarStyle
{
    switch (navagationBarStyle) {
        case None_button_show:
        {
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
            
            [_leftLabel setHidden:YES];
            [_rightLabel setHidden:YES];
            
        }
            break;
        case Left_right_button_show:
        {
            [_leftButton setHidden:NO];
            [_rightButton setHidden:NO];
            [_leftLabel setHidden:NO];
            [_rightLabel setHidden:NO];
            
            [_leftButton setImage:leftButtonImageNormarl forState:UIControlStateNormal];
            [_leftButton setImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
            [_rightButton setImage:rightButtonImageNormarl forState:UIControlStateNormal];
            [_rightButton setImage:rightButtonImageHighlight forState:UIControlStateHighlighted];
        }
            break;
        case Left_button_Show:
        {
            [_rightButton setHidden:YES];
            [_leftButton setHidden:NO];
            [_rightLabel setHidden:YES];
            [_leftLabel setHidden:NO];
            
            [_leftButton setImage:leftButtonImageNormarl forState:UIControlStateNormal];
            [_leftButton setImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
        }
            break;
        case Right_button_show:
        {
            [_leftButton setHidden:YES];
            [_rightButton setHidden:NO];
            [_leftLabel setHidden:YES];
            [_rightLabel setHidden:NO];
            
            
            [_rightButton setImage:rightButtonImageNormarl forState:UIControlStateNormal];
            [_rightButton setImage:rightButtonImageHighlight forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
}
@end
