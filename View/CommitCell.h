//
//  CommitCell.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/3.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *count;
@end
