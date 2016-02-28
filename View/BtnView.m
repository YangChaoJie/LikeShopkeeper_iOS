//
//  BtnView.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BtnView.h"

@implementation BtnView
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title Image:(UIImage*)image{
    if (self=[super init]) {
        self.frame=frame;
        UIImageView* logo=[[UIImageView alloc]initWithImage:image];
        logo.frame=CGRectMake(0, 0, 30, 30);
        [self addSubview:logo];
    }
    
    
    return self;
}
-(void)setView:(UIView*)view Labeltitle:(UILabel*)label{
    
     //label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40,30)];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
