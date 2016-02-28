//
//  MenuListView.h
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/25.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuListViewDelegate <NSObject>
@optional

/**
 选择index回调
 
 @param index
 */
-(void)selectedCode:(NSString *)code;
@end
@interface MenuListView : UIView
/**
 选择回调
 */
@property (nonatomic, assign)id<MenuListViewDelegate> delegate;
/**
 数据源
 */
@property (nonatomic, strong)NSArray *dataArray;
/**
 字体非选中时颜色
 */
@property (nonatomic, strong)UIColor *textNomalColor;
/**
 字体选中时颜色
 */
@property (nonatomic, strong)UIColor *textSelectedColor;
/**
 横线颜色
 */
@property (nonatomic, strong)UIColor *lineColor;
/**
 字体大小
 */
@property (nonatomic, assign)CGFloat titleFont;
/**
 Initialization
 
 @param frame     fram
 @param dataArray 标题数组
 @param font      标题字体大小
 
 @return instance
 */
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font Category_code:(NSString*)category_code;
/**
 手动选择
 
 @param index inde（从1开始）
 */
-(void)selectIndex:(NSInteger)index ;
@end
