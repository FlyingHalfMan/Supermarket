//
//  GuideView.m
//  UILibrary
//
//  Created by cdeledu on 14-10-30.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import "GuideView.h"

@interface GuideView ()

@property (nonatomic, strong) UIScrollView    *scrollView;

@property (nonatomic, strong) NSArray         *images;
@property (nonatomic, copy)   NSString        *normalImage;
@property (nonatomic, copy)   NSString        *highlightImage;
@property (nonatomic, assign) BOOL            doesButtonShowInEveryPage;
@property (nonatomic, strong) NSMutableArray  *buttons;

@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
            buttonNormalImage:(NSString *)normalImage
         buttonHighlightImage:(NSString *)highlightImage
    doesButtonShowInEveryPage:(BOOL)doesButtonShowInEveryPage {
  if (self = [super initWithFrame:frame]) {
    _buttons = [[NSMutableArray alloc] init];
    _imageViews = [[NSMutableArray alloc] init];
    self.images = images;
    self.normalImage = normalImage;
    self.highlightImage = highlightImage;
    self.doesButtonShowInEveryPage = doesButtonShowInEveryPage;
    [self scrollViewConfigWithFrame:frame];
    [self pagesConfigWithFrame:frame];
  }
  return self;
}

- (void)scrollViewConfigWithFrame:(CGRect)frame {
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
  _scrollView.backgroundColor = [UIColor yellowColor];
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.pagingEnabled = YES;
  _scrollView.bounces = NO;
  [self addSubview:_scrollView];
}

- (void)pagesConfigWithFrame:(CGRect)frame {
  CGFloat width = _scrollView.frame.size.width;
  for (int i = 0; i < _images.count; i++) {
    UIImageView *aImageView = [[UIImageView alloc] init];
    aImageView.image = [UIImage imageNamed:[_images objectAtIndex:i]];
    
    aImageView.frame = CGRectMake(i*width, 0, width, _scrollView.frame.size.height);
    aImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:aImageView];
    
    if (_normalImage) {
      if (_doesButtonShowInEveryPage) {
        [self createOneButtonForView:aImageView];
      } else {
        if (i == _images.count-1) {
          [self createOneButtonForView:aImageView];
        }
      }
    }
    
    [_imageViews addObject:aImageView];
  }
  
  _scrollView.contentSize = CGSizeMake(_images.count*width, frame.size.height);
}

- (void)createOneButtonForView:(UIView *)aImageView {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:_normalImage] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:_highlightImage] forState:UIControlStateHighlighted];
  [button sizeToFit];
  button.center = CGPointMake(aImageView.frame.size.width/2., aImageView.frame.size.height-50-button.frame.size.height/2.);
  
  [button addTarget:self action:@selector(beginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [aImageView addSubview:button];
  [_buttons addObject:button];
}

- (void)configButtonDistanceToBottom:(CGFloat)distance {
  for (UIButton *aButton in _buttons) {
    CGPoint center = aButton.center;
    center.y += 50;
    center.y -= distance;
    aButton.center = center;
  }
}

- (void)beginButtonPressed {
  if (self.delegate &&
      [self.delegate respondsToSelector:@selector(guideViewBeginButtonPressed:)]) {
    [self.delegate guideViewBeginButtonPressed:self];
  }
}


@end
