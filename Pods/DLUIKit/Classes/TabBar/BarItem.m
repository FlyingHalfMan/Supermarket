//
//  BarItem.m
//  TabBar
//
//  Created by cdeledu on 14-10-29.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "BarItem.h"

@interface BarItem ()
{
  CGFloat _offsetY;
  CGFloat _vPadding;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *normalImage;
@property (nonatomic, strong) NSString *highlightImage;

@end

@implementation BarItem

- (id)initWithFrame:(CGRect)frame
      backgroundNormalImage:(NSString *)backgroundNormalImage
      backgroundHighlightImage:(NSString *)backgroundHighlightImage
      normalImageName:(NSString *)normalImageName
      highlightImageName:(NSString *)highlightImageName
      text:(NSString *)text {

  return [self initWithFrame:frame
       backgroundNormalImage:backgroundNormalImage
    backgroundHighlightImage:backgroundHighlightImage
             normalImageName:normalImageName
          highlightImageName:highlightImageName
                        text:text
                     offsetY:5
                    vPadding:5];
}

- (id)initWithFrame:(CGRect)frame
      backgroundNormalImage:(NSString *)backgroundNormalImage
      backgroundHighlightImage:(NSString *)backgroundHighlightImage
      normalImageName:(NSString *)normalImageName
      highlightImageName:(NSString *)highlightImageName
      text:(NSString *)text
      offsetY:(CGFloat)offsetY
      vPadding:(CGFloat)vPadding {
  self = [super initWithFrame:frame];
  if (self) {
    _offsetY = offsetY;
    _vPadding = vPadding;
    self.normalImage = normalImageName;
    self.highlightImage = highlightImageName;
    
    if (backgroundNormalImage) {
      self.button = [UIButton buttonWithType:UIButtonTypeCustom];
      [_button setBackgroundImage:[UIImage imageNamed:backgroundNormalImage] forState:UIControlStateNormal];
      [_button setBackgroundImage:[UIImage imageNamed:backgroundHighlightImage] forState:UIControlStateHighlighted];
      [_button setBackgroundImage:[UIImage imageNamed:backgroundHighlightImage] forState:UIControlStateSelected];
      [_button addTarget:self action:@selector(tappedIt:) forControlEvents:UIControlEventTouchUpInside];
      _button.frame = self.bounds;
      [self addSubview:_button];
    }
    
    if (normalImageName) {
      _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:normalImageName]];
      [_imageView sizeToFit];
      _imageView.center = CGPointMake(frame.size.width/2., offsetY+_imageView.frame.size.height/2.);
      [self addSubview:_imageView];
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    _titleLabel.text = text;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.origin.x = 0;
    titleFrame.origin.y = _imageView.frame.origin.y + _imageView.frame.size.height + vPadding;
    _titleLabel.frame = titleFrame;
    [self addSubview:_titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedIt:)];
    [self addGestureRecognizer:tap];
  }
  return self;
}

- (void)configTitleFont:(UIFont *)font {
  _titleLabel.font = font;
}

- (void)configIconDistanceToTop:(CGFloat)distance {
  CGPoint center = _imageView.center;
  center.y -= _offsetY;
  center.y += distance;
  _imageView.center = center;
  _offsetY = distance;
}

- (void)configTitleDistanceToIcon:(CGFloat)distance {
  CGPoint center = _titleLabel.center;
  center.y -= _vPadding;
  center.y += distance;
  _titleLabel.center = center;
  _vPadding = distance;
}

- (void)tappedIt:(UITapGestureRecognizer *)tap {
  if (self.delegate &&
      [self.delegate respondsToSelector:@selector(barItemTapped:)]) {
    [self.delegate barItemTapped:self];
  }
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
  _titleNormalColor = titleNormalColor;
  _titleLabel.textColor = _titleNormalColor;
}

- (void)selected {
  _button.selected = YES;
  _imageView.image = [UIImage imageNamed:_highlightImage];
  _titleLabel.textColor = _titleHighlightColor;
}

- (void)unSelected {
  _button.selected = NO;
  _imageView.image = [UIImage imageNamed:_normalImage];
  _titleLabel.textColor = _titleNormalColor;
}

@end
