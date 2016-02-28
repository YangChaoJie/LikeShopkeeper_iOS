//
//  OderViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/20.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import <AFNetworking.h>
#import "MaterialModel.h"
#import "MaterialCategoryMedol.h"
#import "MaterialModel.h"
#import "DefineModel.h"
#import "MaterialCategoryMedol.h"
#import "MaterialDataBase.h"
#import "MaterrialCatagoryDataBase.h"
#import "AddOderViewController.h"
#import "OderViewController.h"
#import "HomeViewController.h"
@interface OderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString*_url;
}

@property(nonatomic,copy)NSString*pin_code;
@property(nonatomic,strong)MaterialCategoryMedol*model;
@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString*serverName;

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,strong)NSMutableArray* imageArray;

//数据数组
@property(nonatomic,strong)NSMutableArray*categoryData;
@property(strong,nonatomic)NSMutableArray*categoryCode;
//@property(nonatomic,strong)NSMutableArray*
/*
 * 保存改变的数据数组
 */
@property(nonatomic,strong)NSMutableArray* countArray;

@property(nonatomic,strong)NSMutableArray* arrayData;
@end

@implementation OderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//创建视图
-(void)createView{

    self.title=@"订单";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                  NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                                                  };

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -24,ScreenWidth, ScreenHeight+24) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.sectionFooterHeight=0;
    self.tableView.sectionHeaderHeight=10;
    //分割线填满
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    [self createNavigationLeftButton:nil];

}


//自定义导航栏
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
-(void)Back:(UIButton*)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//初始化数据
-(void)initData{
    //
    self.categoryData=[[NSMutableArray alloc]init];
    
    self.categoryData=[[NSMutableArray alloc]init];
    //self.material=[[NSMutableArray alloc]init];
    self.categoryCode=[[NSMutableArray alloc]init];
    self.countArray=[NSMutableArray array];
    
    self.arrayData=[[NSMutableArray alloc]init];
    
    
    self.dataArray=[[NSMutableArray alloc]init];
    self.imageArray=[[NSMutableArray alloc]init];
    NSArray* ary1=@[@"新增订单",@"最新订单",@"修改订单",@"订单查询"];
    NSArray* ary2=@[@"验货入库",@"验货查询"];
    NSArray* ary3=@[@"ic_order_create",@"ic_order_now",@"ic_order_change",@"ic_order_query"];
    NSArray* ary4=@[@"ic_examination_warehousing",@"ic_examination_query"];
    
    [self.dataArray addObject:ary1];
    [self.dataArray addObject:ary2];
    [self.imageArray addObject:ary3];
    [self.imageArray addObject:ary4];
    [self linkRequestString];
}
-(void)clearDataBase{
    NSArray*models=[[MaterialDataBase defaultDatabase]findAllData];
    NSArray*categorys=[[MaterrialCatagoryDataBase defaultDatabase]findAllData];
    if (models.count>0||categorys.count>0) {
        [[MaterialDataBase defaultDatabase]deleteAllData];
        [[MaterrialCatagoryDataBase defaultDatabase]deleteAllData];
    }
}

#pragma mark -- 请求
-(void)linkRequestString{
    
    self.serverName=@"ipensee.3322.org:8284";
    self.contentName=@"sync_materials";
    _url=[NSString stringWithFormat:@"http://%@/api/android/%@",self.serverName,self.contentName];
    [self sendRegisterRequest:_url];
}

- (void)sendRegisterRequest:(NSString*)url {
    
    
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    self.pin_code=[defaults objectForKey:@"pin_code"];
    NSDictionary *json = @{@"pin_code":self.pin_code};
    
    NSData *jsonData=  [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* data1=@{@"data":jsonString};
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:_url parameters:data1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString*status=[object objectForKey:@"status"];
        
        
        if ([status isEqualToString:@"OK"]) {
            NSDictionary* data=[object objectForKey:@"data"];
            
            NSArray*category=[data objectForKey:@"category"];
            for (NSDictionary*dic in category) {
                NSDictionary* MaterialCategory=[dic objectForKey:@"MaterialCategory"];
                self.model=[[MaterialCategoryMedol alloc]init];
                //明细
                
                [self.model setValuesForKeysWithDictionary:MaterialCategory];
                
                [self.categoryData addObject:self.model];
                [self.categoryCode addObject:self.model.code];
                
            }
           
            NSArray*categorys=[[MaterrialCatagoryDataBase defaultDatabase]findAllData];
            if (categorys.count>0) {
               
                [[MaterrialCatagoryDataBase defaultDatabase]deleteAllData];
            }
            [[MaterrialCatagoryDataBase defaultDatabase]insertMoreModels:self.categoryData isBegineTransaction:YES];
            
            NSArray*material=[data objectForKey:@"material"];
            for (NSDictionary*dic in material) {
                NSDictionary* Materia=[dic objectForKey:@"Material"];
                MaterialModel*modelTwo=[[MaterialModel alloc]init];
                DefineModel* defineModel=[[DefineModel alloc]init];
                [modelTwo setValuesForKeysWithDictionary:Materia];
               
                
                defineModel.category_name=modelTwo.category_code;
                defineModel.material_name=modelTwo.material_name;
                defineModel.material_code=modelTwo.material_code;
                defineModel.price=[modelTwo.supply_price integerValue];
                defineModel.unit=modelTwo.unit_order;
                defineModel.created=modelTwo.created;
                defineModel.modified=modelTwo.modified;
                defineModel.guid=modelTwo.guid;
                defineModel.id=[modelTwo.id integerValue];
                [self.countArray addObject:defineModel];
                //
                
                [self.arrayData addObject:modelTwo];
                
            }
            NSArray*models=[[MaterialDataBase defaultDatabase]findAllData];
           
            if (models.count>0) {
                [[MaterialDataBase defaultDatabase]deleteAllData];
                
            }
            [[MaterialDataBase defaultDatabase]insertMoreModels:self.arrayData isBegineTransaction:YES];
        }else if ([status isEqualToString:@"NG"]){
            
            NSDictionary* error=[object objectForKey:@"error"];
          //  [MBProgressHUD showError:[error objectForKey:@"msg"]];
            NSString*code=[error objectForKey:@"code"];
            if ([code isEqualToString:@"ERR022"]) {
                
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}



#pragma delegate for tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArray objectAtIndex:section] count] ;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"identifier";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    UIImage*image=[self reSizeImage:[[UIImage imageNamed:[[self.imageArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toSize:CGSizeMake(20, 20)];
    cell.imageView.image=image;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddOderViewController* avc=[[AddOderViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
