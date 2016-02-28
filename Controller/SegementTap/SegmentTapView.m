//
//  SegmentTapView.m
//  SegmentTapView

#import "SegmentTapView.h"
#import "RuleModel.h"
#import "RuleDataBase.h"
@interface SegmentTapView (){
    NSString*_num;
    float _number;
}

@end
@interface SegmentTapView ()
@property (nonatomic, strong)NSMutableArray *buttonsArray;
@property (nonatomic, strong)UIImageView *lineImageView;
@end
@implementation SegmentTapView

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _buttonsArray = [[NSMutableArray alloc] init];
        _dataArray = dataArray;
        _titleFont = font;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNumber:) name:@"number" object:nil];
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
    float width = self.frame.size.width / _dataArray.count;
    
    for (int i = 0 ; i < _dataArray.count ; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        button.tag = i+1;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:self.textNomalColor    forState:UIControlStateNormal];
        [button setTitleColor:self.textSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        
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
            UILabel *line = [[UILabel alloc ] initWithFrame:CGRectMake(i * width , 0, 0.45, 40)];
            line.backgroundColor = [UIColor whiteColor];
            [self bringSubviewToFront:line];
            [self addSubview:line];
        }
    }
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, width, 2)];
    self.lineImageView.backgroundColor = _lineColor;
    [self addSubview:self.lineImageView];
}

-(void)tapAction:(id)sender{
    
    NSArray*arry=[[RuleDataBase defaultDatabase]findAllData];
    if (arry.count>0) {
        
        //弹出框
        [self getRuleData:arry uid:sender];
    }else{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
       self.lineImageView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height-1, button.frame.size.width, 2);
    }];
    for (UIButton *subButton in self.buttonsArray) {
        if (button == subButton) {
            subButton.selected = YES;
        }
        else{
            subButton.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:button.tag -1];
    }
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
                self.lineImageView.frame = CGRectMake(subButton.frame.origin.x, self.frame.size.height-1, subButton.frame.size.width, 2);
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
-(void)changeNumber:(NSNotification *)notification{
    if ([notification object]!=nil) {
        _number=[[notification object]floatValue];
        
    }
    
}

-(void)getRuleData:(NSArray*)arry  uid:(id)sender{
    NSMutableString* str=[[NSMutableString alloc]init];
    for (NSUInteger i=0;i<[arry count];i++) {
        RuleModel* model=arry[i];
        _num=[model.conditions objectForKey:@"num"];
        NSLog(@"num=\n%@",_num);
        for (id obj in [[model.conditions objectForKey:@"material_list"]allValues]) {
            [str appendString:[NSString stringWithFormat:@"%@、\t\t\t\t\t",[obj lastObject]]];
        }
        if (i==0) {
            if (_number<[_num floatValue]) {
                NSString*string=[NSString stringWithFormat:@"\n的订购总量应大于%@",_num];
                [str appendString:string];
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
                UIButton *button = (UIButton *)sender;
                [UIView animateWithDuration:0.2 animations:^{
                    self.lineImageView.frame = CGRectMake(0, self.frame.size.height-1, button.frame.size.width, 2);
                }];
            }else{
                UIButton *button = (UIButton *)sender;
                [UIView animateWithDuration:0.2 animations:^{
                    self.lineImageView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height-1, button.frame.size.width, 2);
                }];
                for (UIButton *subButton in self.buttonsArray) {
                    if (button == subButton) {
                        subButton.selected = YES;
                    }
                    else{
                        subButton.selected = NO;
                    }
                }
                if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
                    [self.delegate selectedIndex:button.tag -1];
                }
            }
            [str setString:@""];
        }
 }
}
@end
