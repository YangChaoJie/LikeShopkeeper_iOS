//
//  MenuListView.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/25.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "MenuListView.h"
@interface MenuListView ()
@property (nonatomic, strong)NSMutableArray *buttonsArray;
@property (nonatomic, strong)UIImageView *lineImageView;
@property (nonatomic,strong)NSString*code;
@end
@implementation MenuListView

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font Category_code:(NSString*)category_code{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _buttonsArray = [[NSMutableArray alloc] init];
        _dataArray = dataArray;
        _titleFont = font;
        
        self.code=category_code;
        self.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor grayColor]);
        self.layer.borderWidth=2;
        //默认
        self.textNomalColor    = [UIColor blackColor];
        self.textSelectedColor = [UIColor orangeColor];
        self.lineColor = [UIColor orangeColor];
        
        [self addSubSegmentView];
    }
    return self;
}
-(void)addSubSegmentView
{
    //float height = self.frame.size.height / (_dataArray.count+2);
    float height =44;
    for (int i = 0 ; i < _dataArray.count ; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, height*i, self.frame.size.width, height)];
        button.tag = i+1;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:self.textNomalColor    forState:UIControlStateNormal];
        [button setTitleColor:self.textSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        
        //加入下划线
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.size.height - 0.5, button.frame.size.width, 0.5)];
  
        label.backgroundColor = [UIColor grayColor];
        
        //加入右面边界线
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
        
        label1.backgroundColor = [UIColor grayColor];
        [self addSubview:label1];
        
        
        [button addSubview:label];
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认第一个选中
        if (i == 0) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
        
        [self.buttonsArray addObject:button];
        [self addSubview:button];
        
        if (i != _dataArray.count || i != 0) {
            UILabel *line = [[UILabel alloc ] initWithFrame:CGRectMake(0 , i * height, 0.45, 40)];
            line.backgroundColor = [UIColor whiteColor];
            [self bringSubviewToFront:line];
            [self addSubview:line];
        }
    }
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, height)];
    self.lineImageView.backgroundColor = _lineColor;
    [self addSubview:self.lineImageView];
}
-(void)tapAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineImageView.frame = CGRectMake(0, button.frame.origin.y, 2, button.frame.size.height);
    }];
    for (UIButton *subButton in self.buttonsArray) {
        if (button == subButton) {
            subButton.selected = YES;
        }
        else{
            subButton.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedCode:)]) {
        [self.delegate selectedCode:self.code];
    }
}
-(void)selectIndex:(NSInteger)index 
{
    for (UIButton *subButton in self.buttonsArray) {
        if (index != subButton.tag) {
            subButton.selected = NO;
        }
        else{
            subButton.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.lineImageView.frame = CGRectMake(0, subButton.frame.origin.y, 2, subButton.frame.size.height);
            }];
        }
    }
}
#pragma mark -- set
-(void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        self.lineImageView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}
-(void)setTextNomalColor:(UIColor *)textNomalColor{
    if (_textNomalColor != textNomalColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textNomalColor forState:UIControlStateNormal];
        }
        _textNomalColor = textNomalColor;
    }
}
-(void)setTextSelectedColor:(UIColor *)textSelectedColor{
    if (_textSelectedColor != textSelectedColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textSelectedColor forState:UIControlStateSelected];
        }
        _textSelectedColor = textSelectedColor;
    }
}
-(void)setTitleFont:(CGFloat)titleFont{
    if (_titleFont != titleFont) {
        for (UIButton *subButton in self.buttonsArray){
            subButton.titleLabel.font = [UIFont systemFontOfSize:titleFont] ;
        }
        _titleFont = titleFont;
    }
}
@end
