//
//  RuleModel.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BaseModel.h"

@interface RuleModel : BaseModel
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSDictionary*conditions;
@property(nonatomic,strong)NSDictionary*result;
@end
