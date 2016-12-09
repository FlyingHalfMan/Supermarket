//
//  LMUTableViewCellViewModel.h
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <BaseWithRAC/BaseWithRAC.h>

@interface LMUTableViewCellViewModel : BaseViewModel

@property(nonatomic,copy)NSString* id;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* price;
@property(nonatomic,copy)NSString* satusl;
@property(nonatomic)UIImage* image;
@end
