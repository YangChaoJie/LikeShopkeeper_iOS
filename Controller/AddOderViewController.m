//
//  AddOderViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/20.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import "MaterialsCell.h"
#import <AFNetworking.h>
#import "MBProgressHUD+NJ.h"
#import "MBProgressHUD.h"
#import "MaterialModel.h"
#import "MaterialCategoryMedol.h"
#import "LeftClassifyCell.h"


#import "SegmentTapView.h"
#import "FlipTableView.h"

#import "AddOderViewController.h"
#import "EOderTwoViewController.h"
#import "EOderViewController.h"
#import "RuleDataBase.h"
#import "MaterrialCatagoryDataBase.h"
#import "DefiniteMaterialDataBase.h"
#import "DailyOrderDetailDataBase.h"
@interface AddOderViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,UIAlertViewDelegate>{
    NSString*_num;
    float _number;
}
@property(nonatomic,copy)NSString*pin_code;



@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (strong, nonatomic) NSMutableArray *controllsArray;


@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString*serverName;

/*
 *暂时保存的订单明细
 */
@property (strong, nonatomic) NSMutableArray *countArray;
@property(strong,nonatomic)NSMutableArray* categoryData;

/*
 *保存规则数组
 */
@property(nonatomic,strong)NSMutableArray*ruleArray;
@end

@implementation AddOderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"新增订单";
    self.view.backgroundColor=RGBA(211, 211, 211, 1);
    [self initSegment];
    [self initFlipTableView];
}

-(instancetype)init{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:@"countArray" object:nil];
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNumber:) name:@"number" object:nil];
        self.countArray=[[NSMutableArray alloc]init];
        
        
        self.ruleArray=[[NSMutableArray alloc]init];
    
    }
    return self;
}

-(void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 64, ScreeFrame.size.width, 40) withDataArray:[NSArray arrayWithObjects:@"物料检索",@"待定货", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}
-(void)initFlipTableView{
    
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    EOderTwoViewController *v1 = [[EOderTwoViewController alloc]init];
    
    EOderViewController *v2 =[[EOderViewController alloc]init];
    
    
    [self.controllsArray addObject:v2];
    [self.controllsArray addObject:v1];

    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 114, ScreenWidth, self.view.frame.size.height - 114) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    
    
}
-(void)createView{
    [self createNavigationLeftButton:nil];
  
}

//自定义导航按钮
-(void)createNavigationLeftButton:(id)view{
    // 自定义导航栏的"返回"按钮
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
     btn.frame = CGRectMake(15, 5, 15, 20);
    [btn setBackgroundImage:[self reSizeImage:[[UIImage imageNamed:@"ic_left_arrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toSize:CGSizeMake(15, 20)] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(Back:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    // 设置导航栏的leftButton
    
    self.navigationItem.leftBarButtonItem=back;
}


//#pragma mark -- 请求数据

-(void)Back:(UIButton*)button{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否需要保存订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
   
    [alert show];
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSArray*ary=[[DefiniteMaterialDataBase defaultDatabase]findAllData];
        if (ary.count>0) {
            
            [[DefiniteMaterialDataBase defaultDatabase]deleteAllData];
        }
        [[DefiniteMaterialDataBase defaultDatabase]insertMoreModels:self.countArray isBegineTransaction:YES];
        
        
        //每日订单的储存
        //[[DailyOrderDetailDataBase defaultDatabase]insertMoreModels:self.countArray isBegineTransaction:YES];
        //[[MaterrialCatagoryDataBase defaultDatabase]insertMoreModels:self.categoryData isBegineTransaction:YES];
    }else{
        [[DefiniteMaterialDataBase defaultDatabase]deleteAllData];
    }
       [self.navigationController popViewControllerAnimated:YES];
}


-(void)changeText:(NSNotification *)notification{
    if([notification object] != nil){
        self.countArray=[notification object];
    }
}

#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    
    
       [self.flipView selectIndex:index];
   
   
}
//滑动的时候
-(void)scrollChangeToIndex:(NSInteger)index
{
       [self.segment selectIndex:index];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
