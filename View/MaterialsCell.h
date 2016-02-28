//
//  MaterialsCell.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/25.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import "MaterialModel.h"
#import "DefineModel.h"
#import <UIKit/UIKit.h>
@class MaterialsCell;
@protocol MaterialsCell <NSObject>
@optional

/**
 选择index回调
 
 @param index
 */
-(void)selectedTag:(NSInteger)tag;
-(void)shopCartListCell:(MaterialsCell *)Cell WithTextField:(UITextField *)textField;
@end
@interface MaterialsCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *material;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UITextField *count;

@property (nonatomic, assign)id<MaterialsCell> delegate;


/*
 物料明细
 */
@property(nonatomic,strong)DefineModel* defineModel;

/*
 物料
 */
@property(nonatomic,strong)MaterialModel*model;

//已选数
@property (nonatomic, assign) float choosedCount;
/*
 * 保存改变的数据
 */
@property(nonatomic,strong)NSMutableArray* countArray;
/*
 *
 */
@property(nonatomic,strong)NSMutableArray*materialCategory;
- (void)setDataToCellContentView:(MaterialModel *)model ArrayList:(NSMutableArray*)arrayList defineModel:(DefineModel*)defineModel CountArray:(NSMutableArray*)countarry category_name:(NSMutableArray*)category;
@end
