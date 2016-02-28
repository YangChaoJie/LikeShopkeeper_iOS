//
//  EOderTwoViewController.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/1/20.
//  Copyright © 2016年 QXLK. All rights reserved.
//
#import "MaterrialCatagoryDataBase.h"
#import "DefiniteMaterialDataBase.h"

#import "EOderTwoViewController.h"
#import "CellHeaderView.h"
#import "RKNotificationHub.h"
#import "DefineModel.h"
#import "CommitCell.h"
#import "MaterialCategoryMedol.h"
#import "YYClassInfo.h"
#import "NSObject+YYModel.h"
#import <AFNetworking.h>
#import "OderViewController.h"
#import "AddOderViewController.h"
#import "RootViewController.h"
@interface EOderTwoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)RKNotificationHub*hub;
@property(nonatomic,strong)NSMutableArray*data;
@property(nonatomic,strong)NSMutableArray*data2;
@property(nonatomic,strong)NSMutableArray*data3;
@property (nonatomic,strong)NSMutableArray *testArray;


@property(nonatomic,assign)float num;
@property(nonatomic,assign)float headnum;
@property(nonatomic,assign)float number;

@property(nonatomic,strong)UILabel* label0;


@property(nonatomic,copy)NSString*contentName;
@property(nonatomic,copy)NSString*serverName;

@property(nonatomic,copy)NSString*order_code;
@end

@implementation EOderTwoViewController
-(instancetype)init{
    self=[super init];
    if (self) {
    /*
     *之所以把通知中心放在这里就是因为放在viewDidLoad会有延迟，可能无法第一时间内获取改变的数量
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:@"countArray" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeData:) name:@"categoryData" object:nil];
    [self initDataArray];
    }
    return self;
}


//懒加载
-(NSMutableArray*)testArray{
    if (_testArray.count ==0) {
        _testArray = [[NSMutableArray alloc]init];
    }
    return _testArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
   
    [self createFootView];
}

-(void)initDataArray{
    self.data=[[NSMutableArray alloc]init];
    
    self.data3=[[NSMutableArray alloc]init];
    self.data2=[[NSMutableArray alloc]init];
    self.testArray=[NSMutableArray array];
}
-(void)createView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64*2-48-20) style:UITableViewStylePlain];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
     self.tableView.tableFooterView = [UIView new];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
}
-(void)createFootView{
    
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-64*3+20 ,ScreenWidth, 64)];
    UILabel*label0=[[UILabel alloc]initWithFrame:CGRectMake(0, view.top-1, ScreenWidth, 0.5)];
    label0.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:label0];
    
    
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, label0.top-20, 40, 40)];
    imageView.image=[UIImage imageNamed:@"ic_order_submit"];
    [self.view addSubview:imageView];
    
   self.hub=[[RKNotificationHub alloc]initWithView:imageView];
    [self.hub moveCircleByX:-5 Y:5];

    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/3,0,80 , 30)];

    _label0=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/3-20,30,120, 30)];
    
    label.text=@"总金额";
    _label0.textColor=[UIColor redColor];
    _label0.text=[NSString stringWithFormat:@"￥%.2f",_num];
    
    UIButton* button=[Factory createButtonWithTitle:@"提交" frame:CGRectMake(ScreenWidth/3*2, 10, 80,40 ) target:self selector:@selector(commit:)];
    button.backgroundColor=[UIColor orangeColor];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [view addSubview:button];
    [view addSubview:_label0];
    [view addSubview:label];
    [self.view addSubview:view];
}
//提交订单
-(void)commit:(UIButton*)button{
    [self postRequest];
}

-(void)postRequest{
    self.serverName=@"ipensee.3322.org:8284";
    self.contentName=@"daily_order";
   NSString* url=[NSString stringWithFormat:@"http://%@/api/android/%@",self.serverName,self.contentName];
    [self sendRegisterRequest:url];
}
- (void)sendRegisterRequest:(NSString*)url {
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
   NSString*  pin_code=[defaults objectForKey:@"pin_code"];
    NSMutableArray*arry=[[NSMutableArray alloc]init];
    NSMutableDictionary*data0=[[NSMutableDictionary alloc]init];
    NSMutableDictionary*data=[[NSMutableDictionary alloc]init];
      NSArray*ary=[self.data2 modelToJSONObject];
    for (id obj in ary) {
        [data0 setObject:obj forKey:@"OrderDetail"];
        [arry addObject:data0];
    }
    [data setValue:pin_code forKey:@"pin_code"];
     [data setValue:arry forKey:@"order_detail"];
     [data setValue:@"zho1" forKey:@"login_user_id"];
    NSString*jsonString=[data modelToJSONString];
    //NSData *jsonData=  [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* data1=@{@"data":jsonString};
    NSString*s=[data modelToJSONString];
    NSLog(@"%@",s);
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:data1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString*status=[object objectForKey:@"status"];
        NSLog(@"%@",object);
        
        if ([status isEqualToString:@"OK"]) {
            
            NSDictionary*data=[object objectForKey:@"data"];
            [self getOderSucess:data];
            
        
            
        }else if ([status isEqualToString:@"NG"]){
            
            NSDictionary* error=[object objectForKey:@"error"];
            //[MBProgressHUD showError:[error objectForKey:@"msg"]];
            NSString*code=[error objectForKey:@"code"];
            if ([code isEqualToString:@"ERR022"]) {
                
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
        
        
    }];
    
  

}
-(void)getOderSucess:(NSDictionary*)data{
    self.order_code=[data objectForKey:@"order_code"];
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"成功生成订单,订单号为：%@",self.order_code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    OderViewController* ovc=[[OderViewController alloc]init];
    RootViewController*nav=[RootViewController sharedInstance];
   // assert([nav topViewController] == ovc);
    //RootViewController* nav=[[RootViewController alloc]initWithRootViewController:ovc];
    //AddOderViewController*avc=[[AddOderViewController alloc]init]
   
    //[self presentViewController:nav animated:YES completion:nil];
    
    [nav pushViewController:ovc animated:YES];
}

#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data.count!=0) {
        return self.testArray.count;
     
    }else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.data.count!=0) {
        NSInteger count=[(NSArray*)[self.testArray objectAtIndex:section] count];
       
        return count;
   }else{
      
       return 0;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.data2.count!=0) {
        static NSString* cellIdtifier = @"Cell";
       
        CommitCell* cell=[tableView dequeueReusableCellWithIdentifier:cellIdtifier];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"CommitCell" owner:self options:nil]lastObject];
            //cell分割线延长
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
         DefineModel*model=[[self.testArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.name.text=model.material_name;
       
        cell.price.text=[NSString stringWithFormat:@"￥ %.2f",model.apply_num*model.price];
        cell.count.text=[NSString stringWithFormat:@"%.2f%@",model.apply_num,model.unit];
        return cell;
    }else{
        static NSString* cellIdtifier = @"Cell";
        
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellIdtifier];
        if (cell == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdtifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
       
            cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
        return cell;
   
    }
}

/*
 *必须要有下面这句话，并且
 */

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"1";
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* ary=[self.testArray objectAtIndex:section];
    
    _headnum=0;
    for (DefineModel* model in ary) {
        _headnum=_headnum+model.apply_num*model.price;
    
    }
    
 //标题判断
    if (self.data3.count>0) {
        MaterialCategoryMedol*model=[self.data3 objectAtIndex:section];
        CellHeaderView* view=[[CellHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) title:model.name labelText:[NSString stringWithFormat:@"￥%.2f",_headnum]];
        return view;
    }else{
        CellHeaderView* view=nil;
        NSArray*ary=[[DefiniteMaterialDataBase defaultDatabase]findAllData];
        if (ary.count>0) {
            NSArray*arry=[[MaterrialCatagoryDataBase defaultDatabase]findAllData];
            MaterialCategoryMedol*model=[arry objectAtIndex:section];
                 view=[[CellHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) title:model.name labelText:[NSString stringWithFormat:@"￥%.2f",_headnum]];
        }
        return view;
    }
   
}

#pragma mark --通知
/*
 *获取改变的值
 */
-(void)changeText:(NSNotification *)notification{
    if([notification object] != nil){
        self.data=[notification object];
        
         
        //[self.tableView reloadData];
        [self getModel];
        
    }
}


-(void)changeData:(NSNotification *)notification{
    if([notification object] != nil){
        
        self.data3=[notification object];
        
    }
}


-(void)getModel{
    if (self.data2.count>0) {
        [self.data2 removeAllObjects];
    }
    if (self.testArray.count>0) {
        [self.testArray removeAllObjects];
    }
    for (DefineModel*model in self.data) {
 
        
        if (model.apply_num>0) {
            [self.data2 addObject:model];
        }
    }
    //提取相同的数组元素
    [self getDataArray:self.data2];
 

    //重置数据
    _num=0;
    _number=0;
    for (DefineModel* model in self.data2) {
        _num=_num+model.apply_num*model.price;
        _number=_number+model.apply_num;
       
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"number" object:[NSString stringWithFormat:@"%f",_number]];
    
    
    _label0.text=[NSString stringWithFormat:@"￥%.2f",_num];
    //重置角标数
    [self.hub setCount:0];
    //角标数
    [self.hub incrementBy:self.data2.count];
    [self.tableView reloadData];
}
/*
 *提取相同的数组元素
 */
-(void)getDataArray:(NSArray*)arrayData{
    NSMutableArray* array=[NSMutableArray arrayWithArray:arrayData];
    for (int i=0; i<array.count; i++) {
        DefineModel*model1 =array[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model1];
        for (int j= i+1; j<array.count; j++) {
            DefineModel*model2 = array[j];
            
            if([model1.category_name isEqualToString:model2.category_name]){
                
                [tempArray addObject:model2];
            }
        }
        if ([tempArray count] > 0) {
            
            [self.testArray addObject:tempArray];
            
            [array removeObjectsInArray:tempArray];
            
            i -= 1;    //去除重复数据 新数组开始遍历位置不变
            
        }
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    //删除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"countArray" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"categoryData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
