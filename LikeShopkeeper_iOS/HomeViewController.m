//
//  HomeViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/18.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "HomeViewController.h"
#import "BtnView.h"
#import "OderViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"来客E订货";
    //设置标题字体颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                  NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                                                  };

}
//创建视图
-(void)createView{
    [self setPosition:self.logoImage];
}
//设置按钮的位置，考虑适配
-(void)setPosition:(UIImageView*)View{
    self.logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_title_image"]];
    self.logoImage.frame=CGRectMake(0, 54, ScreenWidth, 150) ;
    
    self.oderBtn=[Factory createButtonWithTitle:@"订单" frame:CGRectMake(ControlDistance, self.logoImage.bottom+ControlDistance, (ScreenWidth-ControlDistance*3)/2, (ScreenHeight-Default-4*ControlDistance-self.logoImage.height)*0.6) target:self selector:@selector(handleButton:)];
    
    self.oderBtn.backgroundColor=RGBA(255, 106, 106, 1);
    self.oderBtn.tag=101;
    
 
    
    self.stockBtn=[Factory createButtonWithTitle:@"库存" frame:
                   CGRectMake(ControlDistance, self.oderBtn.bottom+ControlDistance,self.oderBtn.width, (ScreenHeight-Default-4*ControlDistance-self.logoImage.height)*0.4) target:self selector:@selector(handleButton:)];
    
    self.stockBtn.backgroundColor=[UIColor purpleColor];
    
    self.stockBtn.tag=102;
    
    
    self.complainBtn=[Factory createButtonWithTitle:@"投诉建议" frame:CGRectMake(self.stockBtn.width+2*ControlDistance, self.logoImage.bottom+ControlDistance, self.oderBtn.width,(ScreenHeight-Default-5*ControlDistance-self.logoImage.height)/3 ) target:self selector:@selector(handleButton:)];
   
    self.complainBtn.backgroundColor=RGBA(255, 185, 15, 1);
    self.complainBtn.tag=103;
    
    
    
    self.publicBtn=[Factory createButtonWithTitle:@"公告" frame:CGRectMake(self.complainBtn.left,self.complainBtn.bottom+ControlDistance , self.complainBtn.width, self.complainBtn.height) target:self selector:@selector(handleButton:)];
    self.publicBtn.backgroundColor=RGBA(255, 105, 180, 1);
  
    self.publicBtn.tag=104;
    
    
 
    
    self.settingBtn=[Factory createButtonWithTitle:@"设置" frame:CGRectMake(self.complainBtn.left, self.publicBtn.bottom+ControlDistance, self.publicBtn.width, self.publicBtn.height) target:self selector:@selector(handleButton:)];
    
    self.settingBtn.backgroundColor=RGBA(99, 184, 255, 1);
    self.settingBtn.tag=105;
    //
    [self setImage];
    

    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.oderBtn];
    [self.view addSubview:self.stockBtn];
    [self.view addSubview:self.complainBtn];
    [self.view addSubview:self.publicBtn];
    [self.view addSubview:self.settingBtn];
}
//设置图片
-(void)setImage{
    BtnView* oder=[[BtnView alloc]initWithFrame:CGRectMake(self.oderBtn.width/2-12, self.oderBtn.height/2-28, 30, 30) Title:nil Image:[UIImage imageNamed:@"ic_order"]];
    
    [self.oderBtn addSubview:oder];
    
    BtnView* stock=[[BtnView alloc]initWithFrame:CGRectMake(self.stockBtn.width/2-12, self.stockBtn.height/2-28, 30, 30) Title:nil Image:[UIImage imageNamed:@"ic_stock"]];
    [self.stockBtn addSubview:stock];
    
    BtnView* complain=[[BtnView alloc]initWithFrame:CGRectMake(self.complainBtn.width/2-12, self.complainBtn.height/2-28, 30, 30) Title:nil Image:[UIImage imageNamed:@"ic_complaints_suggestions"]];
    [self.complainBtn addSubview:complain];
    
    BtnView* public=[[BtnView alloc]initWithFrame:CGRectMake(self.publicBtn.width/2-12, self.publicBtn.height/2-28, 30, 30) Title:nil Image:[UIImage imageNamed:@"ic_bulletin"]];
    [self.publicBtn addSubview:public];
    
    BtnView* setting=[[BtnView alloc]initWithFrame:CGRectMake(self.settingBtn.width/2-12, self.settingBtn.height/2-28, 30, 30) Title:nil Image:[UIImage imageNamed:@"ic_setting"]];
    [self.settingBtn addSubview:setting];
}

/*
 *设置图片的大小
 */
/*-(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}*/

//button的点击事件
-(void)handleButton:(UIButton*)button{
    switch (button.tag) {
        case 101 :
            
            [self oder];
            break;
        case 102 :
            [self stock];
            break;
        case 103 :
            [self complain];
            break;
        case 104 :
            [self public];
            break;
        case 105 :
            [self setting];
            break;
        default:
            break;
    }
}
//
-(void)oder{
    OderViewController* ovc=[[OderViewController alloc]init];
    [[ovc navigationController]setNavigationBarHidden:NO];
    [self.navigationController pushViewController:ovc animated:YES];
     // NSLog(@"订单");
}
//
-(void)stock{
     NSLog(@"库存");
}
//
-(void)complain{
     NSLog(@"投诉");
}
//
-(void)public{
     NSLog(@"公告");
}
//
-(void)setting{
    NSLog(@"设置");
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
