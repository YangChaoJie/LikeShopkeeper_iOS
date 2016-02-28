//
//  DailyOrderDetailDataBase.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/23.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "DailyOrderDetailDataBase.h"
#import "FMDatabase.h"
@implementation DailyOrderDetailDataBase{
FMDatabase* _database;
}
+ (instancetype)defaultDatabase {
    static DailyOrderDetailDataBase *database = nil;
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
        _database=[[FMDatabase alloc]initWithPath:[self getFullFilePathWithName:@"DailyOrderDetailDataBase.sqlite"]];
        
        NSLog(@"DailyOrderDetailDataBase==%@",_database.databasePath);
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
    
    NSString *sql = @"create table if not exists DailyOrderDetailDataBase(serial integer  Primary Key Autoincrement,auto_flg INTEGER,order_id INTEGER,material_code TEXT,uid INTEGER,yesterday_store_num INTEGER,delete_flg INTEGER,_id INTEGER,created TEXT,week_compare INTEGER,recommend_num INTEGER,apply_diff INTEGER,add_num_comfirm INTEGER,out_num INTEGER,add_num INTEGER,store_num INTEGER,material_id INTEGER,in_num INTEGER,modified TEXT,comfirm_num INTEGER,guid TEXT,material_name TEXT,unit TEXT,apply_num TEXT,price INTEGER,category_name TEXT,fix_num INTEGER)";
    //NSString *sql = @"create table if not exists DailyOrderDetailDataBase(serial integer  Primary Key Autoincrement,material_code Varchar(256),material_name Varchar(256),material_id Varchar(256),in_num Varchar(256),apply_num Varchar(256),category_name Varchar(256))";
    //执行sql 语句modified_id INTEGER,created_id INTEGER,
    BOOL isSuccess = [_database executeUpdate:sql];
    
    if (!isSuccess) {
        NSLog(@"create table failed!%@",[_database lastErrorMessage]);
    }
    
}
#pragma mark - 获取文件的全路径
- (NSString *)getFullFilePathWithName:(NSString *)name {
    //获取在沙盒中的全路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",docPath);
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
    NSString *sql = @"select * from DailyOrderDetailDataBase where material_id = ?";
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
    
    //model.created=@"1";
    //model.guid=@"2";
   // model.modified=@"3";
    //检测 数据库 有没有存过
    if ([self checkModel:model]) {
        //表示存在
        return;
    }
    
    NSString *sql = @"insert into DailyOrderDetailDataBase (auto_flg,order_id,material_code,uid,yesterday_store_num,delete_flg,_id,created,week_compare,recommend_num,apply_diff,add_num_comfirm,out_num,add_num,store_num,material_id,in_num,modified,comfirm_num,guid,material_name,unit,apply_num,price,category_name,fix_num) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
     //执行增加sql语句,modified_id,created_id,
     BOOL isS = [_database executeUpdate:sql,model.auto_flg,model.order_id,model.material_code,model.id,model.yesterday_store_num,model.delete_flg,model.created,model.week_compare,model.recommend_num,model.apply_diff,model.add_num_comfirm,model.add_num,model.store_num,model.material_id,model.in_num,model.modified,model.comfirm_num,model.guid,model.material_name,model.unit,[NSString stringWithFormat:@"%.2f",model.apply_num],model.price,model.category_name,model.fix_num];
    //model.modified_id,model.created_id,
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
    NSString *sql = @"delete from DailyOrderDetailDataBase where material_id = ?";
    //根据uid 删除记录
    if (![_database executeUpdate:sql,uid]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
}
//删除所有的
- (void)deleteAllData {
    NSString *sql = @"delete from DailyOrderDetailDataBase";
    //删除所有记录
    if (![_database executeUpdate:sql]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
    
}


//查询所有的数据
- (NSArray *)findAllData {
    NSString *sql = @"select * from DailyOrderDetailDataBase";
    //创建一个数组
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *rs = [_database executeQuery:sql];
    while ([rs next]) {
        DefineModel *model = [[DefineModel alloc]init];
        //把数据放入数据模型
        //
        
        model.auto_flg = [rs intForColumn:@"auto_flg"];
        model.order_id = [rs intForColumn:@"order_id"];
        model.material_code = [rs stringForColumn:@"material_code"];
        model.id = [rs intForColumn:@"uid"];
        model.yesterday_store_num = [rs intForColumn:@"yesterday_store_num"];
        model.delete_flg = [rs intForColumn:@"delete_flg"];
        model._id = [rs intForColumn:@"_id"];
        model.created = [rs stringForColumn:@"created"];
        model.week_compare = [rs intForColumn:@"week_compare"];
        model.recommend_num = [rs intForColumn:@"recommend_num"];
        model.apply_diff = [rs intForColumn:@"apply_diff "];
        
        model.add_num_comfirm = [rs intForColumn:@"add_num_comfirm"];
        model.out_num=[rs intForColumn:@"out_num"];
        model.add_num=[rs intForColumn:@"add_num"];
        model.store_num=[rs intForColumn:@"store_num"];
        model.material_id = [rs intForColumn:@"material_id"];
        model.in_num = [rs intForColumn:@"in_num"];
        model.modified = [rs stringForColumn:@"modified"];
        
        
        model.comfirm_num = [rs intForColumn:@"comfirm_num"];
        model.guid = [rs stringForColumn:@"guid"];
        model.material_name = [rs stringForColumn:@"material_name"];
        model.created_id = [rs intForColumn:@"created_id"];
        model.unit = [rs stringForColumn:@"unit"];
        model.apply_num = [[rs stringForColumn:@"apply_num"]floatValue];
        model.price = [rs intForColumn:@"price"];
        
        model.category_name = [rs stringForColumn:@"category_name"];
        model.fix_num = [rs intForColumn:@"fix_num"];
       
        //放入数组
        [arr addObject:model];
        
    }
    //返回查询好的数组
    return arr;
}

//获取 有多少条记录
- (NSInteger)getCountWithModels {
    NSString *sql = @"select count(*) from DailyOrderDetailDataBase";
    FMResultSet *rs = [_database executeQuery:sql];
    NSInteger count = 0;
    while ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    return count;
}
@end
