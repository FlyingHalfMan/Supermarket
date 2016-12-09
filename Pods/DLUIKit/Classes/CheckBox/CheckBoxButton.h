//
//  CheckBoxButton.h
//  forum
//
//  Created by cyx on 12-7-26.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckBoxButtonDelegate <NSObject>

- (void)selectBox:(BOOL)tchecked button:(id)sender;

@end

@interface CheckBoxButton : UIButton

@property (nonatomic,assign) BOOL checked;
@property (nonatomic,assign) id<CheckBoxButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
      checkImgeWith:(UIImage *)tempselectImge
      checkedImgeWith:(UIImage *)tempselectedImge
      selectCheckedWith:(BOOL)tempChecked;


@end
