//
//  ConfirmViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/26.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import <AFNetworking.h>
#import "ConfirmViewController.h"
#import "LoginViewController.h"
#import "ShopInfoModel.h"
@interface ConfirmViewController ()
@property(nonatomic,strong)UITextField*userName;
@property(nonatomic,strong)UITextField*passWord;
@property(nonatomic,strong)UITextField*activateCode;
@property(nonatomic,strong)UIButton*confirm;
@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString*serverName;


@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self linkRequestString];
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
    
    self.passWord=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance,self.userName.bottom+1, ScreenWidth-20, 48)placeholder:@"密码" textColor:nil borderStyle:UITextBorderStyleNone];
    
    
    self.activateCode=[Factory createViewWithText:nil frame:CGRectMake(ControlDistance,self.passWord.bottom+1, ScreenWidth-20, 48) placeholder:@"验证码" textColor:nil borderStyle:UITextBorderStyleNone];
    
    self.confirm=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirm setTitle:@"确认" forState:UIControlStateNormal];
    self.confirm.backgroundColor=[UIColor orangeColor];
    self.confirm.frame =CGRectMake(ControlDistance,self.activateCode.bottom+10, ScreenWidth-20, 48);
    self.confirm.layer.cornerRadius=1;
    self.confirm.layer.masksToBounds=YES;
    [self.confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [View addSubview:self.userName];
    [View addSubview:self.passWord];
    [View addSubview:self.activateCode];
    [View addSubview:self.confirm];
}

-(void)linkRequestString{
    self.serverName=@"ipensee.3322.org:8284";
    //self.serverName=@"happylike.com.cn";
    self.contentName=@"get_shop_info";
    
    NSString* url=[NSString stringWithFormat:@"http://%@/api/android/%@",self.serverName,self.contentName];
    [self sendRegisterRequest:url];
}

/*
 *向服务器请求//56726//83010//28319
 */
- (void)sendRegisterRequest:(NSString*)url {
    
    NSDictionary *json = @{@"pin_code":self.pin_code};
    
    NSData *jsonData=  [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* data1=@{@"data":jsonString};
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:data1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@"%@ object=",object);
        NSDictionary* data=[object objectForKey:@"data"];
        NSString*status=[object objectForKey:@"status"];
        
        if ([status isEqualToString:@"OK"]) {
            ShopInfoModel*model=[[ShopInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:data];
            self.userName.text=model.shop_name;
            self.passWord.text=model.shop_address;
            self.activateCode.text=model.shop_tel;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}




-(void)confirm:(UIButton*)button{
    LoginViewController* lvc=[[LoginViewController alloc]init];
    lvc.pin_code  = self.pin_code;
    [self presentViewController:lvc animated:YES completion:nil];
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
