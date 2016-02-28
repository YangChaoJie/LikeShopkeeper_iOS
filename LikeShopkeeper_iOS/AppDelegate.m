//
//  AppDelegate.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/18.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ServerRegisterViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ConfirmViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSString* pin_code=[defaults objectForKey:@"pin_code"];
    RootViewController*nav=[RootViewController sharedInstance];
    self.window.rootViewController=nav;
    
    if (pin_code) {
        
        LoginViewController* lvc=[[LoginViewController alloc]init];
        [[lvc navigationController]setNavigationBarHidden:YES];
        [nav pushViewController:lvc animated:YES];
        //self.window.rootViewController=lvc;
    }else {
        
        ServerRegisterViewController* svc=[[ServerRegisterViewController alloc]init];
        [[svc navigationController]setNavigationBarHidden:YES];
        [nav pushViewController:svc animated:YES];
        //self.window.rootViewController=svc;
    }
    
    
    
    //RegisterViewController* rvc=[[RegisterViewController alloc]init];
    //RootViewController* rootViewController = [[RootViewController alloc]initWithRootViewController:svc];
   // [self.window setRootViewController: rootViewController];
   
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
