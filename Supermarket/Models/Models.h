//
//  Models.h
//  附近超市
//
//  Created by Cai.H.F on 9/29/16.
//  Copyright © 2016 cn.programingmonkey. All rights reserved.
//

#import "JSONModel.h"

@interface Models : JSONModel

@end

@interface ImageModel:JSONModel
@property(nonatomic,copy)NSString* id;
@property(nonatomic,copy)NSString* imageName;
@property(nonatomic,copy)NSString*extend;
@property(nonatomic,assign)float height;
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float size;
@property(nonatomic,copy)NSString* user_id;
@property(nonatomic)NSDate* uploadDate;
@end

@interface Province : JSONModel
@property(nonatomic,assign)long id;
@property(nonatomic,copy)NSString* name;
@end

@protocol Province <NSObject>
@end

@interface Provinces : JSONModel
@property(nonatomic,weak) NSArray<Province*>*provinceList;

@end


@interface City : JSONModel
@property(nonatomic,assign)long id;
@property(nonatomic,assign)long provinceId;
@property(nonatomic,copy)NSString* name;
@end

@protocol City <NSObject>
@end

@interface Cities : JSONModel
@property(nonatomic) Province* province;
@property(nonatomic,weak) NSArray<City*>*cities;
@end

@interface Area : JSONModel
@property(nonatomic,assign)long id;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)long cityid;
@end

@protocol Area  <NSObject>
@end

@interface Areas : JSONModel
@property(nonatomic)Province* province;
@property(nonatomic)City*city;
@property(nonatomic,weak) NSArray<Area*>*areas;
@end


@interface Supermarket : JSONModel
@property(nonatomic,assign) long id;
@property(nonatomic,copy)NSString* market_name;
@property(nonatomic,copy)NSString* market_image;
@property(nonatomic,copy)NSString* market_address;
@property(nonatomic,copy)NSString* market_owner;
@property(nonatomic,copy)NSString* market_mobile;
@property(nonatomic,copy)NSString* market_introduction;
@property(nonatomic,copy)NSString* market_business_lesence;
@property(nonatomic)BOOL market_isdeliveryAvaliable;
@property(nonatomic,assign)float* market_deliveryprice;
@property(nonatomic,copy)NSString* market_deliverytime;
@end

@interface Commodity : JSONModel
@property(nonatomic,assign) int commodity_id;
@property(nonatomic,assign) long market_id;
@property(nonatomic,copy)NSString<Optional>* commodity_image;
@property(nonatomic,copy)NSDate* commodity_producedate;
@property(nonatomic,copy)NSString* commodity_origion;
@property(nonatomic,copy)NSString* commodity_factory;
@property(nonatomic,copy)NSString* commodity_brands;
@property(nonatomic,copy)NSString* commodity_company;
@property(nonatomic,copy)NSString* commodity_guaranteeperiod;
@property(nonatomic,assign)float* commodity_price;
@property(nonatomic,copy)NSString* commodity_category;
@property(nonatomic)BOOL* commodity_isdiscount;
@property(nonatomic,assign)float commodity_discountprice;
@property(nonatomic,copy)NSString<Optional>* commodity_inventory;
@end

@protocol Commodity <NSObject>

@end

@interface Commodities : JSONModel
@property(nonatomic,weak)NSArray<Commodity>* commodityList;

@end

@interface ShoppingList : JSONModel
@property(nonatomic,assign) int id;
@property(nonatomic,assign) long market_id;
@property(nonatomic,copy)NSString* user_id;
@property(nonatomic,weak)NSArray<Commodity>*commodities;
@property(nonatomic,assign)long list_count;
@property(nonatomic,assign)float list_price;
@property(nonatomic,copy)NSString* deliverymethod;
@property(nonatomic,copy)NSString* paymentmethod;

@property(nonatomic,assign)float* deliveryprice;
@property(nonatomic,assign)float* totalprice;
@property(nonatomic,copy)NSString* deliveryaddress;
@property(nonatomic,copy)NSString* message;
@property(nonatomic,copy)NSString* status;
@end

@protocol ShoppingList <NSObject>
@end


@interface ShoppingLists : JSONModel
@property(nonatomic) NSString* user_id;
@property(nonatomic,weak) NSArray<ShoppingList>*lists;

@end














