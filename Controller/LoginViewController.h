//
//  LoginViewController.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;
@property (strong, nonatomic) IBOutlet UIButton *stock;
@property(nonatomic,copy)NSString*pin_code;
@end
