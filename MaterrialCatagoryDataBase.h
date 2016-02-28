//
//  MaterrialCatagoryDataBase.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/16.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialCategoryMedol.h"
@interface MaterrialCatagoryDataBase : NSObject
/*
 *非标准单例
 */
+(instancetype)defaultDatabase;

/*
 *增加一个数据
 */
-(void)insertModel:(MaterialCategoryMedol*)model;
/*
 *增加多个记录 是否开启事务
 */

- (void)insertMoreModels:(NSArray *)modelArr isBegineTransaction:(BOOL)isBegine;

//根据id 删除记录
- (void)deleteDataWithUid:(NSString *)uid;
//删除所有的
- (void)deleteAllData;


//查询所有的数据
- (NSArray *)findAllData ;

//获取 有多少条记录
- (NSInteger)getCountWithModels;
@end
