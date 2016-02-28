//
//  ShopInfoModel.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/26.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import "BaseModel.h"
#import <Foundation/Foundation.h>

@interface ShopInfoModel : BaseModel
@property(nonatomic,copy)NSString*shop_name;
@property(nonatomic,copy)NSString*shop_address;
@property(nonatomic,copy)NSString*shop_tel;
@end
