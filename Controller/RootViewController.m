//
//  RootViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/19.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
+ (instancetype)sharedInstance {
    static RootViewController* instance = nil;
    
    if(instance == nil) {
        @synchronized([RootViewController class]) {
            if(instance == nil) {
                instance = [[super alloc] init];
            }
        }
    }
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [super setNavigationBarHidden: YES];
        self.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                                 };
        self.view.backgroundColor=[UIColor orangeColor];
        self.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
