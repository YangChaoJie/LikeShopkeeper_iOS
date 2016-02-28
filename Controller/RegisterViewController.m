//
//  RegisterViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/18.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import <AFNetworking.h>
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD+NJ.h"
#import "ConfirmViewController.h"
@interface RegisterViewController ()
@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString* activation_code;
@property(nonatomic,copy)NSString* pin_code;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
}
-(void)createView{
    //设置背景
    UIImageView* bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_bg"]];
    bgView.frame=[UIScreen mainScreen].bounds;
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    [self setPosition:bgView];
    
}
-(void)setPosition:(UIImageView*)View{
    
    self.userName=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance, ScreenHeight/3, ScreenWidth-20, 48) placeholder:@"用户名" textColor:nil borderStyle:UITextBorderStyleNone];
 
    self.passWord=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance,self.userName.bottom+1, ScreenWidth-20, 48)placeholder:@"密码" textColor:RGBA(211, 211, 211, 1) borderStyle:UITextBorderStyleNone];
  
    self.passWord.secureTextEntry=YES;
    self.activateCode=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance,self.passWord.bottom+1, ScreenWidth-20, 48) placeholder:@"验证码" textColor:nil borderStyle:UITextBorderStyleNone];
   
    self.confirm.backgroundColor=[UIColor orangeColor];
    self.confirm.frame =CGRectMake(ControlDistance,self.activateCode.bottom+10, ScreenWidth-20, 48);
    self.confirm.layer.cornerRadius=1;
    self.confirm.layer.masksToBounds=YES;
    [self.confirm addTarget:self action:@selector(Register:) forControlEvents:UIControlEventTouchUpInside];
    [View addSubview:self.userName];
    [View addSubview:self.passWord];
    [View addSubview:self.activateCode];
    [View addSubview:self.confirm];
}
-(void)linkRequestString{
    self.activation_code = self.activateCode.text;
    self.contentName=@"new_shop_register";
    NSString* url=[NSString stringWithFormat:@"http://%@/api/android/%@",self.serverName,self.contentName];
    [self sendRegisterRequest:url];
}

/*
 *向服务器请求//56726//83010//28319
 */
- (void)sendRegisterRequest:(NSString*)url {
   
    NSDictionary *json = @{@"activation_code":self.activation_code,@"app_info":@"e.g VersionCode:12 VersionName:1.0",@"device_info":@"e.g. CPU:4d12d53d3a3cbe18 MAC:FC:C7:34:C7:5C:B0 ANDROID_ID:847e1fb0ddcd95dd",@"agent_login_name":@"",@"agent_password":@"",@"shop_name":@"",@"shop_address":@"",@"shop_tel":@""};
   
     NSData *jsonData=  [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* data1=@{@"data":jsonString};
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
   
    [MBProgressHUD showSuccess:@"正在加载····"];
    
    [manager POST:url parameters:data1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        NSDictionary* data=[object objectForKey:@"data"];
        self.pin_code=[data objectForKey:@"pin_code"];
        
        //存进本地
        NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:self.pin_code forKey:@"pin_code"];
        
        if (self.pin_code) {
            ConfirmViewController* lvc=[[ConfirmViewController alloc]init];
            lvc.pin_code=self.pin_code;
               [self presentViewController:lvc animated:YES completion:nil];
        }else{
            // 几秒后消失,当前，这里可以改为网络请求
           // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 移除HUD
                [MBProgressHUD hideHUD];
                //提醒有没有新版本
                [MBProgressHUD showError:@"激活码错误"];
            //});
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)Register:(UIButton*)button{
    [self linkRequestString];
}
//取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.activateCode resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
