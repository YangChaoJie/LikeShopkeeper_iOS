//
//  DefineModel.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/2.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BaseModel.h"

@interface DefineModel : BaseModel
@property(nonatomic,assign)NSInteger auto_flg;
@property(nonatomic,assign)NSInteger order_id;
@property(nonatomic,copy)NSString*  material_code;
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger yesterday_store_num;
@property(nonatomic,assign)NSInteger delete_flg;
@property(nonatomic,assign)NSInteger _id;
@property(nonatomic,copy)NSString*created;
@property(nonatomic,assign)NSInteger week_compare;
@property(nonatomic,assign)NSInteger recommend_num;
@property(nonatomic,assign)NSInteger apply_diff;
@property(nonatomic,assign)NSInteger add_num_comfirm;
@property(nonatomic,assign)NSInteger out_num;
@property(nonatomic,assign)NSInteger add_num;
@property(nonatomic,assign)NSInteger store_num;
@property(nonatomic,assign)NSInteger material_id;
@property(nonatomic,assign)NSInteger in_num;
@property(nonatomic,copy)NSString* modified;
@property(nonatomic,assign)NSInteger comfirm_num;
@property(nonatomic,copy)NSString* guid;//自己获得
@property(nonatomic,copy)NSString* material_name;
@property(nonatomic,assign)NSInteger created_id;
@property(nonatomic,assign)NSInteger modified_id;
@property(nonatomic,copy)NSString* unit;
@property(nonatomic,assign)float apply_num;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,copy)NSString* category_name;
@property(nonatomic,assign)NSInteger fix_num;
@end
/*
 "OrderDetail": {
 "auto_flg": 0,
 "order_id": 0,
 "material_code": "2009007",
 "id": 0,
 "yesterday_store_num": 0,
 "delete_flg": 0,
 "_id": 4,
 "created": "2014-09-17 11:25:40",
 "week_compare": 0,
 "recommend_num": 0,
 "apply_diff": 0,
 "add_num_comfirm": 0,
 "out_num": 0,
 "add_num": 0,
 "store_num": 0,
 "material_id": 443,
 "in_num": 0,
 "modified": "2014-09-17 11:25:40",
 "comfirm_num": 0,
 "guid": "bf3fcd91-8a49-486c-920d-54c60956f97d",
 "material_name": "调味料（混合油）",
 "created_id": 1507,
 "unit": "桶",
 "apply_num": 23,
 "price": 0,
 "modified_id": 1507,
 "category_name": "配料",
 "fix_num": 0
 
 */