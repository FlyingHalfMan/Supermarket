//
//  CheckBoxButton.m
//  forum
//
//  Created by cyx on 12-7-26.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import "CheckBoxButton.h"

@interface CheckBoxButton()
{
    UIImage *_selectedImge;
    UIImage *_selectImge;
}
@end

@implementation CheckBoxButton



- (id)initWithFrame:(CGRect)frame checkImgeWith:(UIImage *)tempselectImge checkedImgeWith:(UIImage *)tempselectedImge selectCheckedWith:(BOOL)tempChecked
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checked = tempChecked;
        _selectedImge = tempselectedImge;
        _selectImge = tempselectImge;
     
        if(!self.checked)
        {
          [self setImage:_selectImge forState:UIControlStateNormal];
        }
        else {
          [self setImage:_selectedImge forState:UIControlStateNormal];
        }
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)buttonClick
{
    self.checked = !self.checked;
    [_delegate selectBox:self.checked button:self];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if(checked)
    {
        [self setImage:_selectedImge forState:UIControlStateNormal];
    }
    else {
        [self setImage:_selectImge  forState:UIControlStateNormal];
    }
}


@end
