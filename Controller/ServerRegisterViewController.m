//
//  ServerRegisterViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/18.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "ServerRegisterViewController.h"
#import "RegisterViewController.h"


@interface ServerRegisterViewController ()

@end

@implementation ServerRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self createView];
}
/*
 *设置按钮和输入框颜色
 */
-(void)createView{
    UIImageView* bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_bg"]];
    bgView.frame=ScreeFrame;
    bgView.userInteractionEnabled=YES;
    
    
    [self setPosition:bgView];
    
    [self.view addSubview:bgView];
    
    
    
}


-(void)setPosition:(UIImageView*)View{
    //ipensee.3322.org:8284
    self.severText=[Factory createViewWithText:@"ipensee.3322.org:8284" frame:CGRectMake(ControlDistance, ScreenHeight/2, ScreenWidth-20, 48) placeholder:nil textColor:nil borderStyle:UITextBorderStyleNone];
   
    self.severText.height=48;
    
    self.confirm.backgroundColor=[UIColor orangeColor];
    self.confirm.frame=CGRectMake(ControlDistance, self.severText.bottom+10, self.severText.width, 48);
    self.confirm.layer.cornerRadius=1;
    self.confirm.layer.masksToBounds=YES;
    [self.confirm addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [View addSubview:self.severText];
    [View addSubview:self.confirm];
}
/*
 *确认按钮
 */
-(void)Action:(UIButton*)button{
    RegisterViewController* rvc=[[RegisterViewController alloc]init];
    //属性传值
    rvc.serverName=self.severText.text;
    [self presentViewController:rvc animated:YES completion:nil];
}
/*
 *取消键盘
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.severText resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
