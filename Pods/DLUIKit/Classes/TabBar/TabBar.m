//
//  TabBar.m
//  TabBar
//
//  Created by cdeledu on 14-10-29.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "TabBar.h"
#import "BarItem.h"

@interface TabBar ()
<BarItemDelegate,
UIScrollViewDelegate>
{
  NSInteger _selectedIndex;
  CGFloat _buttonWidth;
}

@property (nonatomic, strong) NSMutableArray  *items;
@property (nonatomic, strong) UIScrollView    *scrollView;

@end

@implementation TabBar

- (instancetype)initWithFrame:(CGRect)frame
       backgroundNormalImages:(NSArray *)backgroundNormalImages
    backgroundHighlightImages:(NSArray *)backgroundHighlightImages
                 NormalImages:(NSArray *)normalImages
              highlightImages:(NSArray *)highlightImages
                       titles:(NSArray *)titles
             titleNormalColor:(UIColor *)normalColor
          titleHighlightColor:(UIColor *)highlightColor {
  if (self = [super initWithFrame:frame]) {
    
    self.backgroundColor = [UIColor clearColor];

    _items = [[NSMutableArray alloc] init];
    _selectedIndex = -1;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    NSInteger count = normalImages.count;
    if (count > 5) {
      _buttonWidth = frame.size.width / 5;
      _scrollView.contentSize = CGSizeMake(count*_buttonWidth, frame.size.height);
      count = 5;
    } else {
      _buttonWidth = frame.size.width / count;
    }
    
    for (int i = 0; i < normalImages.count; i++) {
      
      BarItem *aItem = [[BarItem alloc] initWithFrame:CGRectMake(i*_buttonWidth, 0, _buttonWidth, frame.size.height) backgroundNormalImage:[backgroundNormalImages objectAtIndex:i] backgroundHighlightImage:[backgroundHighlightImages objectAtIndex:i] normalImageName:[normalImages objectAtIndex:i] highlightImageName:[highlightImages objectAtIndex:i] text:[titles objectAtIndex:i]];
      aItem.delegate = self;
      if (normalColor) {
        aItem.titleNormalColor = normalColor;
        aItem.titleHighlightColor = highlightColor;
      }
      
      [_scrollView addSubview:aItem];
      [_items addObject:aItem];
    }
  }
  
  return self;
}

- (void)configIconDistanceToTop:(CGFloat)distance {
  for (BarItem *item in _items) {
    [item configIconDistanceToTop:distance];
  }
}

- (void)configTitleDistanceToIcon:(CGFloat)distance {
  for (BarItem *item in _items) {
    [item configTitleDistanceToIcon:distance];
  }
}

- (void)selectItemAtIndex:(NSInteger)index {
  if (index == _selectedIndex) {
    return;
  }
  for (int i = 0; i < _items.count; i++) {
  BarItem *aItem = [_items objectAtIndex:i];
    if (i == index) {
      [aItem selected];
      _selectedIndex = index;
    } else {
      [aItem unSelected];
    }
  }
  
  if (self.delegate &&
      [self.delegate respondsToSelector:@selector(tabBar:selectedIndex:)]) {
    [self.delegate tabBar:self selectedIndex:index];
  }
}

- (void)selectItem:(BarItem *)item {
  NSInteger index = [_items indexOfObject:item];
  if (index == _selectedIndex) {
    return;
  }
  
  [self selectItemAtIndex:index];
 
//  for (int i = 0; i < _items.count; i++) {
//    BarItem *aItem = [_items objectAtIndex:i];
//    if (i == index) {
//      [aItem selected];
//      _selectedIndex = index;
//    } else {
//      [aItem unSelected];
//    }
//  }
}

- (void)barItemTapped:(BarItem *)item {
  [self selectItem:item];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self adjugeScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self adjugeScrollView];
}

- (void)configTitlesFont:(UIFont *)font {
  for (BarItem *item in _items) {
    [item configTitleFont:font];
  }
}

- (void)adjugeScrollView {
  CGPoint pos = _scrollView.contentOffset;
  if (pos.x >= _buttonWidth/2.) {
    pos.x = _buttonWidth;
  } else {
    pos.x = 0;
  }
  [_scrollView setContentOffset:pos animated:YES];
}

@end
