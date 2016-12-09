//
//  Enum.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#ifndef Enum_h
#define Enum_h
typedef enum {
    InVentory_Full,
    Inventory_normal,
    InVentory_tension
}Inventory_Status;

typedef enum {
    HomeCategoryItem_Like,
    HomeCategoryItem_Hot,
    HomeCategoryItem_Sales,
    HomeCategoryItem_Category,
    HomeCategoryItem_Often,
    HomeCategoryItem_Market,
    HomeCategoryItem_Watch,
    HomeCategoryItem_Collection
}HomeCategoryItem;

#endif /* Enum_h */
