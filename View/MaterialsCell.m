//
//  MaterialsCell.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/25.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "MaterialsCell.h"

@implementation MaterialsCell

- (void)awakeFromNib {
    self.countArray=[[NSMutableArray alloc]init];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
   self.count.clearsOnBeginEditing=YES;
  
}
- (void)setDataToCellContentView:(MaterialModel *)model ArrayList:(NSMutableArray *)arrayList defineModel:(DefineModel*)defineModel CountArray:(NSMutableArray*)countarry category_name:(NSMutableArray*)category{
    self.model=model;
    self.defineModel=defineModel;
    self.materialCategory=category;
    for (defineModel in countarry) {
        if ([model.material_code isEqualToString:defineModel.material_code]) {
            //还要在赋值
            self.defineModel=defineModel;
            self.count.text=[NSString stringWithFormat:@"%.2f",defineModel.apply_num];
            
           /* NSLog(@"物料：%@",model.material_name);
            NSLog(@"物料明细：%@",defineModel.material_name);
            NSLog(@"物料:%@",model.material_code);
            NSLog(@"物料明细：%@",defineModel.material_code);*/
          self.countArray=countarry;
            
        }
    }
    
        if (self.count.text) {
              self.choosedCount=[self.count.text floatValue];
           // self.choosedCount=defineModel.apply_num;
        }
        else{
            
            //self.choosedCount=[model.min_num integerValue];
            self.choosedCount=defineModel.apply_num;
        }
    
   
    self.count.delegate=self;
    
    self.money.text=[NSString stringWithFormat:@"￥%@/%@",model.supply_price,model.unit_order];
    self.count.textAlignment=NSTextAlignmentCenter;
   
    self.count.clipsToBounds=YES;
    self.material.text=model.material_name;
    self.material.font=[UIFont systemFontOfSize:15];
  
   
    
    if ([self.count.text floatValue]>0) {
        
        self.count.layer.borderWidth= 2.0f;
        self.count.layer.borderColor=[[UIColor orangeColor] CGColor];
     
        
    }else if([self.count.text floatValue]<=0){
        
        self.count.layer.borderWidth= 1.0f;
        self.count.layer.borderColor=[[UIColor grayColor] CGColor];
    }
   
     [[NSNotificationCenter defaultCenter] postNotificationName:@"countArray" object:self.countArray];
}

#pragma mark delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self createKeyboard];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.count= textField;
   
    //NSLog(@"%@",self.count.text);
    if ([self isPureInt:self.count.text]) {
        if ([self.count.text integerValue]<0) {
            self.count.text=@"0.00";
            
        }
        
    }
    else
    {
        
    }
    
    
    if ([self.count.text isEqualToString:@""] ) {
        self.choosedCount = 0.00;
        self.count.text=@"0.00";
        
    }
     self.model.min_num=self.count.text;
     self.choosedCount=[self.count.text floatValue];
     self.defineModel.apply_num=self.choosedCount;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"countArray" object:self.countArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryData" object:self.materialCategory];
    
    if ([self.count.text floatValue]>0) {
        
        self.count.layer.borderWidth= 2.0f;
        self.count.layer.borderColor=[[UIColor orangeColor] CGColor];
        
        
        if ([self.delegate respondsToSelector:@selector(selectedTag:)]) {
            [self.delegate selectedTag:textField.tag];
        }
        
    }else if([self.count.text floatValue]<=0){
        
        
        if ([self.delegate respondsToSelector:@selector(shopCartListCell:WithTextField:)]) {
            [self.delegate shopCartListCell:self WithTextField:textField];
        }
        
        self.count.layer.borderWidth= 1.0f;
        self.count.layer.borderColor=[[UIColor grayColor] CGColor];
    }
    
    
    
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


/*
 *自定义键盘
 */


#pragma mark keyboard
-(void)createKeyboard{
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    toolBar.barStyle = UIBarStyleBlack;
    //将UIBarButtonSystemItemFlexibleSpace是用来调整按钮之间保持等间距的,UIBarButtonSystemItemFlexibleSpace如果设置成toolBar的items数组中的第一个元素可以创建靠右的工具条按钮.
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *item3 =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyboard)];
    toolBar.items = @[item1,item2,item3];
    //inputAccessoryView默认是nil,如果设置了,它会随键盘一起弹出并显示在键盘的顶端.
    self.count.inputAccessoryView = toolBar;
    
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    keyboardView.backgroundColor = [UIColor lightGrayColor];
    //inputView显示键盘的view,如果重写这个view将不再弹出键盘,而是弹出我们自定义的view
    self.count.inputView = keyboardView;
    NSArray*array=@[@"1",@"2",@"3",@"4",@"5",@".",@"6",@"7",@"8",@"9",@"0",@"删除"];
 
    for(int i = 0;i<12;i++)
    {     UIButton * btn = [[UIButton alloc]init];
        
        [btn setBackgroundColor:nil];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
     
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
        
        CGFloat dis = 10;
        CGFloat disy = 5;
        CGFloat btnW =([UIScreen mainScreen].bounds.size.width - (7*dis))/6 ;
        CGFloat btnH =(keyboardView.frame.size.height - (3*disy))/2 ;
        CGFloat btnY = (i/6)*(btnH + disy)+disy;
        CGFloat btnX=0;
        if (i<6) {
            btnX = (i)*(btnW + dis)+dis;
        }else{
            btnX = (i%6)*(btnW + dis)+dis;
        }
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.layer.cornerRadius=3;
        btn.layer.masksToBounds=YES;
        [keyboardView addSubview:btn];
        
        
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.count becomeFirstResponder];

}
- (void)resignKeyboard
{
    [self.count resignFirstResponder];
}

- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 11:
        {
            //删除一个字符
            [self.count deleteBackward];
        }
            break;
          
        case 5:
        {
            //插入字符
            [self.count insertText:@"."];
        }
            break;
        case 10:
        {
            //插入字符
            [self.count insertText:@"0"];
        }
            break;
       
            
        default:
        {
            //插入字符
            if (sender.tag>5) {
               [self.count insertText:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            }else{
              [self.count insertText:[NSString stringWithFormat:@"%ld",(long)sender.tag+1]];
            }
            
            
        }
            break;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.count resignFirstResponder];
}
@end
