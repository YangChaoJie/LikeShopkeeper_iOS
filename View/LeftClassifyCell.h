//
//  LeftClassifyCell.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/29.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKNotificationHub.h"

@interface LeftClassifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property(nonatomic,strong)RKNotificationHub* hub;

@property(nonatomic,strong)NSMutableArray*data;
@property(nonatomic,strong)NSMutableArray*data2;

@property(nonatomic,assign)NSInteger tage;


@end
