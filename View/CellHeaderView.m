//
//  CellHeaderView.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/28.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "CellHeaderView.h"

@implementation CellHeaderView
//
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title labelText:(NSString *)text{
    
    if (self=[super init]) {
        self.frame=frame;
        self.backgroundColor=[UIColor whiteColor];
        [self addTitle:title text:text];
    }
    
    
    return self;
}

//
-(void)addTitle:(NSString*)title text:(NSString*)text{
    UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width/2, 44)];
    [self addSubview:label1];
    label1.text=title;
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-5, 0, self.frame.size.width/2, 44)];
    label.text=text;
    label.textAlignment=NSTextAlignmentRight;
    label.textColor=[UIColor redColor];
    UILabel* line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:label];
    [self addSubview:line];
}
@end
