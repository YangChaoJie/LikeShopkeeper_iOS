//
//  RootViewController.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UINavigationController
//+ (instancetype)alloc __unavailable;
+ (instancetype)sharedInstance;
@end
