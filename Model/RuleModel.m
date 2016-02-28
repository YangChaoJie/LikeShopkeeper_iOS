//
//  RuleModel.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "RuleModel.h"

@implementation RuleModel
-(instancetype)init{
    self=[super init];
    if (self) {
        self.conditions=[[NSDictionary alloc]init];
        self.result=[[NSDictionary alloc]init];
        
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"conditions":[NSDictionary class]};
    
}
@end
