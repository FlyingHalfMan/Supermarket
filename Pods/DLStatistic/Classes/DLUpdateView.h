//
//  DLUpdateView.h
//  MobileClassPhone
//
//  Created by chenyixiang on 16/6/16.
//  Copyright © 2016年 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, updateViewStatus) {
    forecUpdate,
    SelectUpdate,
    newVersionUpdate
};


@interface DLUpdateView : UIView

@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *ignoreButton;
@property (nonatomic, assign) updateViewStatus status;
@property (nonatomic, strong) UITextView *updateContentView;
@property (nonatomic, strong) UILabel *versionLabel;

@end
