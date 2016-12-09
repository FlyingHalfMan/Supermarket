//
//  LMUSupermaretHomeViewController.h
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "DLSquareNavigationController.h"

@interface LMUSupermaretHomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


-(instancetype)initWithName:(NSString*)name Address:(NSString*)address;
@end
