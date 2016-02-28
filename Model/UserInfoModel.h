//
//  UserInfoModel.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/27.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel
@property(nonatomic,copy)NSString*login_user_id;
@property(nonatomic,copy)NSString*password;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*identification_num;
@property(nonatomic,copy)NSString*tel;
@end
