//
//  LMUHistoryCell.h
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMUHistoryCell : UITableViewCell
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UIButton* deleteButton;
@property(nonatomic,strong)RACSubject* deleteSignal;
@end
