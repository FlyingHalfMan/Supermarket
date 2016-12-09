//
//  Category.h
//  附近超市
//
//  Created by Cai.H.F on 9/29/16.
//  Copyright © 2016 cn.programingmonkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SecondCategory:JSONModel
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger fcId;
@property(nonatomic,copy)NSString* imageid;
@property(nonatomic,copy)NSString* name;

@end

@protocol SecondCategory <NSObject>

@end


@interface FirstCategory: JSONModel
@property(nonatomic,assign) NSInteger id;
@property(nonatomic,copy)NSString* name;
@end

@protocol FirstCategory <NSObject>

@end

@interface FirstCategories : JSONModel
@property(nonatomic) NSArray<FirstCategory>* firstCategoryList;
@end
@interface SecondCategories : JSONModel
@property(nonatomic) FirstCategory* firstCategory;
@property(nonatomic) NSArray<SecondCategory>* secondCategoryList;
@end


