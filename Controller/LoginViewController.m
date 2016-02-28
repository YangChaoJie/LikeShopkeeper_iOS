//
//  LoginViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import "ServerRegisterViewController.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MBProgressHUD+NJ.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "UserInfoModel.h"
@interface LoginViewController (){
   bool check;
}
@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString*serverName;
@property(nonatomic,strong)NSUserDefaults* User;
@property(nonatomic,strong)UserInfoModel* model;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.User=[NSUserDefaults standardUserDefaults];
     check=YES;
    
}
//判断接口用户名是否对  同时
-(void)createView{
    UIImageView* bgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
    bgView.frame=[UIScreen mainScreen].bounds;
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    [self setPosition:bgView];
    
}

-(void)setPosition:(UIImageView*)View{
    //取出本地的值
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    
    self.userName=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance, ScreenHeight/3, ScreenWidth-20, 48) placeholder:@"用户名" textColor:nil borderStyle:UITextBorderStyleNone];
    self.userName.text=[defaults objectForKey:@"login_user_id"];
    self.passWord=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance,self.userName.bottom+1, ScreenWidth-20, 48)placeholder:@"密码" textColor:nil borderStyle:UITextBorderStyleNone];
    self.passWord.secureTextEntry=YES;
    self.passWord.text=[defaults objectForKey:@"password"];
    
    
    
   
    
    
    self.stock.frame=CGRectMake(ControlDistance, self.passWord.bottom+1, ScreenWidth/3, 48);
    
    if ([self.passWord.text isEqualToString:@""]) {
      [self.stock setImage:[UIImage imageNamed:@"check_box_normal 6"] forState:UIControlStateNormal];
    }else{
          [self.stock setImage:[UIImage imageNamed:@"check_box_checked 6"] forState:UIControlStateNormal];
    }
    
    //左对齐
    self.stock.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.stock setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
   //
    self.LoginBtn.frame = CGRectMake(ControlDistance, self.stock.bottom+10, ScreenWidth-20, 48);
   
    [self.stock addTarget:self action:@selector(Save:) forControlEvents:UIControlEventTouchUpInside];
    self.LoginBtn.backgroundColor=[UIColor orangeColor];
    [self.LoginBtn addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [View addSubview:self.userName];
    [View addSubview:self.passWord];
    [View addSubview:self.LoginBtn];
    [View addSubview:self.stock];
}


-(void)linkRequestString{
    //self.serverName=@"happylike.com.cn";
    self.serverName=@"ipensee.3322.org:8284";
    self.contentName=@"sync_users";
    
    NSString* url=[NSString stringWithFormat:@"http://%@/api/android/%@",self.serverName,self.contentName];
    [self sendRegisterRequest:url];
    
   
}

/*
 *向服务器请求//56726//83010//28319
 */
- (void)sendRegisterRequest:(NSString*)url {
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    self.pin_code=[defaults objectForKey:@"pin_code"];
    NSDictionary *json = @{@"pin_code":self.pin_code};
    NSLog(@"%@ object=",self.pin_code);
    NSData *jsonData=  [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* data1=@{@"data":jsonString};
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    //[MBProgressHUD showMessage:@"正在加载"];
    [manager POST:url parameters:data1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      
        NSString*status=[object objectForKey:@"status"];
       
        
        if ([status isEqualToString:@"OK"]) {
            NSDictionary* data=[object objectForKey:@"data"];
            NSArray* shopUser=[data objectForKey:@"ShopUser"];
            NSDictionary* dic=[shopUser firstObject];
            self.model =[[UserInfoModel alloc]init];
            [self.model setValuesForKeysWithDictionary:dic];
            
     
        
        HomeViewController* hvc=[[HomeViewController alloc]init];
        
        if ([self.userName.text isEqualToString:self.model.login_user_id]&&[self.passWord.text isEqualToString:self.model.password]) {
            
           // RootViewController* rootViewController = [[RootViewController alloc]initWithRootViewController:hvc];
           // [self presentViewController:rootViewController animated:YES completion:nil];
            RootViewController*nav=[RootViewController sharedInstance];
            [nav setNavigationBarHidden:NO];
            [nav pushViewController:hvc animated:YES];
            //隐藏返回键
            [hvc.navigationItem setHidesBackButton:YES];
        }
      }else if ([status isEqualToString:@"NG"]){
          
          NSDictionary* error=[object objectForKey:@"error"];
          [MBProgressHUD showError:[error objectForKey:@"msg"]];
          NSString*code=[error objectForKey:@"code"];
          if ([code isEqualToString:@"ERR022"]) {
            ServerRegisterViewController*svc=[[ServerRegisterViewController alloc]init];
            [self presentViewController:svc animated:YES completion:nil];
          }
     }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


-(void)Save:(UIButton*)button{
   
    
    //有点小bug
    if (check==YES) {
         [self.User setObject:self.userName.text forKey:@"login_user_id"];
        [self.User setObject:self.passWord.text forKey:@"password"];
        [self.stock setImage:[UIImage imageNamed:@"check_box_checked 6"] forState:UIControlStateNormal];
            check=NO;
    }else{
        [self.User removeObjectForKey:@"login_user_id"];
        [self.User removeObjectForKey:@"password"];
        [self.stock setImage:[UIImage imageNamed:@"check_box_normal 6"] forState:UIControlStateNormal];
        check=YES;
    }
    
}

//登录
-(void)Login:(UIButton*)button{
    

    [self linkRequestString];
  
}

//取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
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
