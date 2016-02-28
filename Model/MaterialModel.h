//
//  MaterialModel.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/27.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BaseModel.h"
@class MaterialModel;

@interface MaterialModel : BaseModel
@property(nonatomic,copy)NSString* id;
@property(nonatomic,copy)NSString* material_code;//物料编号
@property(nonatomic,copy)NSString* material_name;//物料名称
@property(nonatomic,copy)NSString* category_code;//物料所属分类的编号
@property(nonatomic,copy)NSString* guid;//GUID
@property(nonatomic,copy)NSString* standard;
@property(nonatomic,copy)NSString* created;//创建时间
@property(nonatomic,copy)NSString* pinyin;//拼音简码
@property(nonatomic,copy)NSString* costmethod;//取整方法
@property(nonatomic,copy)NSString* supply_price;//供货价
@property(nonatomic,copy)NSString* unit_order;//订货单位
@property(nonatomic,copy)NSString* min_num;//最小订货数量

@property(nonatomic,copy)NSString*modified;

@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,weak)MaterialModel *vm;
@end
