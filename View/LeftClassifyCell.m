//
//  LeftClassifyCell.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/29.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "LeftClassifyCell.h"
#import "DefineModel.h"
#import "DefiniteMaterialDataBase.h"
@implementation LeftClassifyCell

- (void)awakeFromNib {
    
    //[self getDataBaseData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:@"countArray" object:nil];
    self.data2=[[NSMutableArray alloc]init];
   
    
}

-(void)getDataBaseData{
    self.hub=[[RKNotificationHub alloc]initWithView:self.contentView];
    [self.hub moveCircleByX:-8 Y:8];
    self.data=[[NSMutableArray alloc]init];
    self.data2=[[NSMutableArray alloc]init];
    NSArray*arry=[[DefiniteMaterialDataBase defaultDatabase]findAllData];
    if (arry.count>0) {
        [self.data addObjectsFromArray:arry];
    }
    [self getModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.hub=[[RKNotificationHub alloc]initWithView:self.contentView];
    [self.hub moveCircleByX:-8 Y:8];
    
}

-(void)changeText:(NSNotification *)notification{
    if([notification object] != nil){
        self.data=[notification object];
        
        [self getModel];
    }
}
-(void)getModel{
    if (self.data2.count>0) {
        [self.data2 removeAllObjects];
    }
    for (DefineModel*model in self.data) {
        
        
        if (model.apply_num>0) {
            //model.category_name
            //NSLog(@"%.2f",model.apply_num);
            
            [self.data2 addObject:model.category_name];
        }
    }
   
    //重置
    [self.hub setCount:0];
    //角标数
    
    
    
    NSMutableArray* ary=[[NSMutableArray alloc]init];
    for (NSString* s in self.data2) {
        /*
         *在这里需要解释一下，tag索取的值在5s以上是没问题的，但在5.4s上不行我分析了一下可能是tag是12位的，而低设备的位数较低超过了原来的位数
          所以我在这里统一一下截取3个有效数字
         */
         // NSLog(@"%ld",(long)self.tag);
        if (self.tag==[[s substringWithRange:NSMakeRange(1, 3)]integerValue]) {
          
            [ary addObject:s];
            
        }
        
        if (ary.count>0) {
          [self.hub setCount:ary.count];
        }else{
          //[self.hub setCount:self.data2.count];
        }
        
    }
    
  
}
-(void)dealloc{
    //删除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"countArray" object:nil];
}
@end
