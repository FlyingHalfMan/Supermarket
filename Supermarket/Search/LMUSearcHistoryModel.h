//
//  LMUSearcHistoryModel.h
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LMUSearcHistoryModel : JSONModel

@property(nonatomic,assign)NSDate*date;
@property(nonatomic,copy)NSString* content;
-(instancetype)initWithText:(NSString*)text;
@end

@protocol SearchResults <NSObject>
@end

@interface SearchResults : JSONModel
@property(nonatomic,assign)NSArray* results;
@end
