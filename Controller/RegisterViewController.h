//
//  RegisterViewController.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/18.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIButton *confirm;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;

@property (strong, nonatomic) IBOutlet UITextField *activateCode;

@property(nonatomic,copy)NSString*serverName;
@end
