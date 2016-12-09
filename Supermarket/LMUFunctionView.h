//
//  LMUFunctionView.h
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Function_Cell_Width [UIScrren mainScreen].bounds.size.width/4;
@interface LMUFunctionView : UIView

@property(nonatomic,strong)UIButton* collectionButton; // 我的收藏
@property(nonatomic,strong)UIButton* shoppinghistoryButton; // 购物记录
@property(nonatomic,strong)UIButton* settingButton;  //设置按钮
@property(nonatomic,strong)UIButton* searchCommorityButton; // 商品信息查询
@end
