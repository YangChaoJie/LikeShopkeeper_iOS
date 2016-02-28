//
//  DefiniteMaterialDataBase.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/17.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "DefiniteMaterialDataBase.h"
#import "FMDatabase.h"
@implementation DefiniteMaterialDataBase{
    FMDatabase* _database;
}
+ (instancetype)defaultDatabase {
    static DefiniteMaterialDataBase *database = nil;
    @synchronized(self) {//同步
        if (database == nil) {
            database = [[self alloc] init];
        }
    }
    return database;
}
#pragma mark - init

-(instancetype)init{
    if (self=[super init]) {
        _database=[[FMDatabase alloc]initWithPath:[self getFullFilePathWithName:@"DM.sqlite"]];
        
        //NSLog(@"%@",_database.databasePath);
        if ([_database open]) {
            //创建表
            [self creatTable];
        }else{
           NSLog(@"open failed:%@",[_database lastErrorMessage]);
        }
    }
    
    return self;
}
- (void)creatTable {
    //user表不存在那么就创建   id Varchar(256),
   
   //NSString *sql = @"create table if not exists DM(serial integer  Primary Key Autoincrement,material_code Varchar(256),auto_flg Varchar(256),material_name Varchar(256),_id Varchar(256),yesterday_store_num Varchar(256),delete_flg Varchar(256),created Varchar(256),week_compare Varchar(256),recommend_num Varchar(256),apply_diff Varchar(256),add_num_comfirm Varchar(256),out_num Varchar(256),add_num Varchar(256),store_num Varchar(256),material_id Varchar(256),in_num Varchar(256),modified Varchar(256),comfirm_num Varchar(256),apply_num Varchar(256))";
    NSString *sql = @"create table if not exists DM(serial integer  Primary Key Autoincrement,material_code Varchar(256),material_name Varchar(256),material_id Varchar(256),in_num Varchar(256),apply_num Varchar(256),category_name Varchar(256))";
    //执行sql 语句
    BOOL isSuccess = [_database executeUpdate:sql];
    
    if (!isSuccess) {
        NSLog(@"create table failed!%@",[_database lastErrorMessage]);
    }
    
}
#pragma mark - 获取文件的全路径
- (NSString *)getFullFilePathWithName:(NSString *)name {
    //获取在沙盒中的全路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   // NSLog(@"%@",docPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {//检测 目录是否存在
        return [docPath stringByAppendingPathComponent:name];
    }else {
        NSLog(@"Documents目录不存在");//不存在 去创建
        return nil;
    }
}
//检测model 是否存过
- (BOOL)checkModel:(DefineModel *)model {
    NSString *sql = @"select * from DM where material_id = ?";
    //查找
    FMResultSet *rs = [_database executeQuery:sql,model.material_id];
    
    if ([rs next]) {//只要有记录 直接返回YES
        return YES;
    }else{
        return NO;
    }
}
//增加一个数据
- (void)insertModel:(DefineModel *)model {
    //检测 数据库 有没有存过
    if ([self checkModel:model]) {
        //表示存在
        return;
    }

    /*NSString *sql = @"insert into DM (material_code,auto_flg,material_name,_id,yesterday_store_num,delete_flg,created,week_compare,recommend_num,apply_diff,add_num_comfirm,out_num,add_num,store_num,material_id,in_num,modified,comfirm_num,apply_num) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行增加sql语句
    BOOL isS = [_database executeUpdate:sql,model.material_code,model.auto_flg,model.material_name,model._id,model.yesterday_store_num,model.delete_flg,model.created,model.week_compare,model.recommend_num,model.apply_num,model.add_num_comfirm,model.out_num,model.add_num,model.store_num,model.material_id,model.in_num,model.modified,model.comfirm_num,[NSString stringWithFormat:@"%.2f",model.apply_num]];*/
    
    NSString *sql = @"insert into DM (material_code,material_name,material_id,apply_num,category_name) values (?,?,?,?,?)";
    //执行增加sql语句
    BOOL isS = [_database executeUpdate:sql,model.material_code,model.material_name,model.material_id,[NSString stringWithFormat:@"%.2f",model.apply_num],model.category_name];
    
    if (!isS) {
        NSLog(@"insert error:%@",[_database lastErrorMessage]);
    }
    
}

//增加 多个 记录
- (void)insertMoreModels:(NSArray *)modelArr isBegineTransaction:(BOOL)isBegine{
    if (isBegine) {
        //开启事务
        BOOL isError = NO;//记录是否有异常
        @try {
            //把可能会出现异常代码 写到这里
            [_database beginTransaction];//开启事务选项
            //开启事务 会先存在_database 对象内存中 不会立即写磁盘
            for (DefineModel *model in modelArr) {
               // NSLog(@"%.2f",model.apply_num);
                [self insertModel:model];
            }
        }
        @catch (NSException *exception) {
            //捕捉异常
            //上面@try 代码中有异常了这里才会调用
            NSLog(@"resone:%@",exception.reason);
            //如果有异常了那么 要回滚 回到数据库连续增加多个数据之前的状态
            [_database rollback];
            isError = YES;//记录有异常
        }
        @finally {
            //不管有没有异常 都会调用
            if (!isError) {
                //没有异常
                [_database commit];//提交事务 这个时候会写一次磁盘
            }
        }
    }else {
        //不开启事务
        //常规 增加多个 数据 不考虑效率
        for (DefineModel *model in modelArr) {
            [self insertModel:model];
        }
    }
}
//根据material_code  删除记录
- (void)deleteDataWithUid:(NSString *)uid {
    NSString *sql = @"delete from DM where material_id = ?";
    //根据uid 删除记录
    if (![_database executeUpdate:sql,uid]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
}
//删除所有的
- (void)deleteAllData {
    NSString *sql = @"delete from DM";
    //删除所有记录
    if (![_database executeUpdate:sql]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
    
}


//查询所有的数据
- (NSArray *)findAllData {
    NSString *sql = @"select * from DM";
    //创建一个数组
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *rs = [_database executeQuery:sql];
    while ([rs next]) {
        DefineModel *model = [[DefineModel alloc]init];
        //把数据放入数据模型
        //model.id = [rs stringForColumn:@"id"];
        
       // model.auto_flg = [rs intForColumn:@"auto_flg"];
        //model.order_id = [rs intForColumn:@"order_id"];
        //model.yesterday_store_num = [rs intForColumn:@"yesterday_store_num"];
       // model.delete_flg = [rs intForColumn:@"delete_flg"];
        //model._id = [rs intForColumn:@"_id"];
        //model.week_compare = [rs intForColumn:@"week_compare"];
        //model.recommend_num = [rs intForColumn:@"recommend_num"];
        //model.apply_diff = [rs intForColumn:@"apply_diff "];
        //model.add_num_comfirm = [rs intForColumn:@"add_num_comfirm"];
        //model.store_num = [rs intForColumn:@"store_num"];
        model.material_id = [rs intForColumn:@"material_id"];
       //model.in_num = [rs intForColumn:@"in_num"];
        //model.comfirm_num = [rs intForColumn:@"comfirm_num"];
        //model.created_id = [rs intForColumn:@"created_id"];
        //model.price = [rs intForColumn:@"price"];
        
       // model.fix_num = [rs intForColumn:@"fix_num"];
        
        model.apply_num = [[rs stringForColumn:@"apply_num"]integerValue];
        
       
        
        
        model.material_code = [rs stringForColumn:@"material_code"];
       // model.created = [rs stringForColumn:@"created"];
        
        //model.modified = [rs stringForColumn:@"modified"];
        
       // model.guid = [rs stringForColumn:@"guid"];
        model.material_name = [rs stringForColumn:@"material_name"];
       // model.unit = [rs stringForColumn:@"unit"];
        model.category_name = [rs stringForColumn:@"category_name"];
        //放入数组
        [arr addObject:model];
        
    }
    //返回查询好的数组
    return arr;
}

//获取 有多少条记录
- (NSInteger)getCountWithModels {
    NSString *sql = @"select count(*) from DM";
    FMResultSet *rs = [_database executeQuery:sql];
    NSInteger count = 0;
    while ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    return count;
}

@end
