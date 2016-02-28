//
//  EOderViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/20.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import "MaterialDataBase.h"
#import "MaterrialCatagoryDataBase.h"
#import "DefiniteMaterialDataBase.h"
#import "RuleDataBase.h"
#import "RuleModel.h"
#import "DefineModel.h"

#import "EOderViewController.h"
#import "MaterialsCell.h"
#import <AFNetworking.h>
#import "MBProgressHUD+NJ.h"
#import "MBProgressHUD.h"
#import "MaterialModel.h"
#import "MaterialCategoryMedol.h"
#import "LeftClassifyCell.h"

#import "RKNotificationHub.h"
@interface EOderViewController ()<UITableViewDataSource,UITableViewDelegate,MaterialsCell,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSString* _url;
    RKNotificationHub* hub;
}
@property(nonatomic,strong)NSString*Url;
@property (strong, nonatomic) NSMutableArray *controllsArray;
@property(strong,nonatomic)UITableView* tableView;


//@property(strong,nonatomic)NSMutableArray*categoryCode;
@property(strong,nonatomic)UITableView* leftView;
@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString*serverName;
/*
 * 物料分类数组
 */
@property(nonatomic,strong)NSMutableArray*categoryData;
//物料数组
@property(nonatomic,strong)NSMutableArray*material;
@property(nonatomic,strong)MaterialCategoryMedol*model;

@property(nonatomic,strong)NSString*category;
@property (nonatomic, strong)UIImageView *lineImageView;
/*
 * 保存改变的数据数组
 */
@property(nonatomic,strong)NSMutableArray* countArray;

@property(nonatomic,strong)NSMutableArray* arrayData;
/*
 *保存数组库的物料
 */

@property(nonatomic,strong)NSMutableArray*numberArray;
/*
 *保存规则数组
 */
@property(nonatomic,strong)NSMutableArray*ruleArray;


@end

@implementation EOderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  
    
}
-(instancetype)init{
    if (self=[super init]) {
        //[self initData];
    }
    return self;
}
//懒加载
-(NSArray *)array
 {
         if (self.countArray==nil) {
             self.countArray=[[NSMutableArray alloc]init];
             }
        return self.countArray;
    }


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initFlipTableView{
    //左边的tavleView
    self.leftView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2.75, ScreenHeight-64-10) style:UITableViewStylePlain];
    self.leftView.delegate=self;
    self.leftView.dataSource=self;
    self.leftView.scrollEnabled=NO;
   
    
    
    self.leftView.rowHeight=44;
    [self.view addSubview:self.leftView];
    //让没有内容的边界线消失
    self.leftView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //两个边界线必须都设置为0
    [self.leftView setSeparatorInset:UIEdgeInsetsZero];
    [self.leftView setLayoutMargins:UIEdgeInsetsZero];
    
    
  
    
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2.75, 0, 0.5, ScreenHeight)];
    lable.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lable];
    ////-ScreenWidth/2.75
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2.75+0.5, 0, ScreenWidth-ScreenWidth/2.75, ScreenHeight-64-44) style:UITableViewStylePlain];
    self.tableView.rowHeight=65;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    //分割线填满
  
  
    [self.view addSubview:self.tableView];
    
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, self.leftView.rowHeight)];
    self.lineImageView.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:self.lineImageView];
   
    //[self loadNotificationCell];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addGoodNum) name:@"add" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cutGoodNum) name:@"cut" object:nil];
    
  
}


-(void)createView{
    [self initFlipTableView];
    
}
-(void)initData{
    self.numberArray=[[NSMutableArray alloc]init];
    
    self.categoryData=[[NSMutableArray alloc]init];
    self.material=[[NSMutableArray alloc]init];
  
    self.countArray=[NSMutableArray array];
    
    self.arrayData=[[NSMutableArray alloc]init];
    
    
    self.ruleArray=[[NSMutableArray alloc]init];
    [self initDataBase];
    
    
    [self linkRequestString];
 
}
//在数据库里取出数据
-(void)initDataBase{
    NSArray*models=[[MaterialDataBase defaultDatabase]findAllData];
    NSArray*categorys=[[MaterrialCatagoryDataBase defaultDatabase]findAllData];
    if (models.count>0&&categorys.count>0) {
        [self.arrayData removeAllObjects];
        [self.categoryData removeAllObjects];
        //本地有数据
        [self.arrayData addObjectsFromArray:models];
        [self.categoryData addObjectsFromArray:categorys];
        [self getDataBaseSource];
        [self.tableView reloadData];
        [self.leftView reloadData];
    }else{
        //[self linkRequestString];
    }
}
/*
 *从数据库里取出数组
 */
-(void)getDataBaseSource{
    
    
    
    NSMutableArray*ary=[[NSMutableArray alloc]init];
    for (MaterialCategoryMedol*model in self.categoryData) {
        [ary addObject:model.code];
    }
    
    
    
    NSArray*arry=[[DefiniteMaterialDataBase defaultDatabase]findAllData];
    if (arry.count>0) {
        for (DefineModel*model in arry) {
            [self.numberArray addObject:[NSString stringWithFormat:@"%.2f",model.apply_num]];
            //NSLog(@"%.2f",model.apply_num);
        }
        
    }
     int i=0;
    for (MaterialModel*model in self.arrayData) {
        if ([model.category_code isEqualToString:ary[0]]) {
            [self.material addObject:model];
        }
         [self.leftView reloadData];
       
        
        
        DefineModel* defineModel=[[DefineModel alloc]init];
        defineModel.category_name=model.category_code;
        defineModel.material_name=model.material_name;
        defineModel.material_code=model.material_code;
        defineModel.price=[model.supply_price integerValue];
        defineModel.unit=model.unit_order;
        defineModel.created=model.created;
        defineModel.modified=model.modified;
        defineModel.guid=model.guid;
        defineModel.id=[model.id integerValue];
        if (arry.count>0) {
           defineModel.apply_num=[self.numberArray[i]floatValue];
             i++;
        }
        [self.countArray addObject:defineModel];
       
    }
   
  
}

#pragma mark -- 请求数据--订货规则
-(void)linkRequestString{
   
   
    self.serverName=@"ipensee.3322.org:8284";
    self.contentName=@"sync_order_rule";
     _url=[NSString stringWithFormat:@"http://%@/api/android/%@",self.serverName,self.contentName];
    [self sendRegisterRequest:_url];
}
/*
 *加载右面的数据
 */
-(void)sendRightData{
    if (self.material.count!=0) {
        [self.material removeAllObjects];
    }
    
    
    for (MaterialModel*model in self.arrayData) {
        
        if ([model.category_code isEqualToString:self.category]) {
            [self.material addObject:model];
            
        }
     
    }

    [self.tableView reloadData];
}

/*
 *向服务器请求//56726//83010//28319
 */
- (void)sendRegisterRequest:(NSString*)url {
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    self.pin_code=[defaults objectForKey:@"pin_code"];
    NSDictionary *json = @{@"pin_code":self.pin_code};
    
    NSData *jsonData=  [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* data1=@{@"data":jsonString};
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    //[MBProgressHUD showSuccess:@"加载成功"];
    [manager POST:_url parameters:data1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString*status=[object objectForKey:@"status"];
        
        
        if ([status isEqualToString:@"OK"]) {
           
            NSDictionary*dict=[object objectForKey:@"data"];
              //NSLog(@"%@",dict);
            NSDictionary*ary=[[NSDictionary alloc]init];
            for (ary in [dict allKeys]) {
                NSArray*dic=[dict objectForKey:ary];
             
                for (NSDictionary*data in dic) {
                   RuleModel*model=[[RuleModel alloc]init];
                    //model.conditions=[data objectForKey:@"conditions"];
                    [model setValuesForKeysWithDictionary:data];
                   //  NSLog(@"object=%@",model.conditions);
                    [self.ruleArray addObject:model];
                }
                NSArray*arry=[[RuleDataBase defaultDatabase]findAllData];
                if (arry.count>0) {
                    [[RuleDataBase defaultDatabase]deleteAllData];
                }
                  [[RuleDataBase defaultDatabase]insertMoreModels:self.ruleArray isBegineTransaction:YES];
            }
            
        }else if ([status isEqualToString:@"NG"]){
            
            NSDictionary* error=[object objectForKey:@"error"];
            [MBProgressHUD showError:[error objectForKey:@"msg"]];
            NSString*code=[error objectForKey:@"code"];
            if ([code isEqualToString:@"ERR022"]) {
               
            }
        }
        [self.leftView reloadData];
        [self.tableView reloadData];
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark --- tableView datasouce and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.leftView) {
        return self.categoryData.count;
    }else{
        return self.material.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.leftView) {
     static NSString* cellIdtifier = @"LeftCell";
        LeftClassifyCell* cell=[tableView dequeueReusableCellWithIdentifier:cellIdtifier ];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftClassifyCell" owner:self options:nil]lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //cell分割线延长
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
           
        }
        MaterialCategoryMedol* model=[self.categoryData objectAtIndex:indexPath.row];
        cell.title.text=model.name;
        cell.title.font=[UIFont systemFontOfSize:15];
        cell.tag=[[model.code substringWithRange:NSMakeRange(1, 3)]integerValue];
       
        
        return cell;
        
    }else{
        static NSString *cellIdtifier = @"CellID";
        MaterialsCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdtifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MaterialsCell" owner:self options:nil]lastObject];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            
        }
        MaterialModel*model=[self.material objectAtIndex:indexPath.row];
        DefineModel* defineModel=nil;
        if (self.countArray.count!=0) {
            defineModel=[self.countArray objectAtIndex:indexPath.row];
        }
        
        cell.delegate=self;
        cell.count.tag=indexPath.row;
      
        
        [cell setDataToCellContentView:model ArrayList:self.material defineModel:defineModel CountArray:self.countArray category_name:self.categoryData];
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftView) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.lineImageView.frame = CGRectMake(0, 44*indexPath.row, 2, 44);
        }];
        MaterialCategoryMedol* model=[self.categoryData objectAtIndex:indexPath.row];
        
        self.category=model.code;
        
        
        
        
        [self sendRightData];
       
    }else{
        
    }
}


#pragma mark materialCell delegate 
-(void)selectedTag:(NSInteger)tag{
    
  [[NSNotificationCenter defaultCenter]postNotificationName:@"add" object:nil];
}


-(void)shopCartListCell:(MaterialsCell *)Cell WithTextField:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cut" object:nil];
}
/*
 *角标-1
 */
-(void)cutGoodNum
{
    [hub decrement];
    
}
/*
 *角标+1
 */
-(void)addGoodNum
{
    [hub increment];
    [hub pop];
}


@end
