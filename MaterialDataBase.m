//
//  MaterialDataBase.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/15.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "MaterialDataBase.h"
#import "FMDatabase.h"
@implementation MaterialDataBase{
    FMDatabase*_database;
}
+ (instancetype)defaultDatabase {
    static MaterialDataBase *database = nil;
    @synchronized(self) {//同步
        if (database == nil) {
            database = [[self alloc] init];
        }
    }
    return database;
}

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        _database = [[FMDatabase alloc] initWithPath:[self getFullFilePathWithName:@"materialInfo.sqlite"]];
        
        /*
         这里 数据库只开启一次
         //有时候我们在每次进行增删改查 都要先开启 然后完成之后再关闭数据库的
         [_database close];
         */
        
        if ([_database open]) {//打开 不存在那么则创建并打开
            //创建表
            [self creatTable];
        }else{
            NSLog(@"open failed:%@",[_database lastErrorMessage]);
        }
    }
    return self;
}
- (void)creatTable {
    //user表不存在那么就创建id Varchar(256),
    NSString *sql = @"create table if not exists materialInfo(serial integer  Primary Key Autoincrement,material_code Varchar(256),material_name Varchar(256),category_code Varchar(256),supply_price Varchar(256),unit_order Varchar(256),min_num Varchar(256),standard Varchar(256),uid Varchar(256),created Varchar(256),modified Varchar(256),guid Varchar(256))";
    
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
    //NSLog(@"%@",docPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {//检测 目录是否存在
        return [docPath stringByAppendingPathComponent:name];
    }else {
        NSLog(@"Documents目录不存在");//不存在 去创建
        return nil;
    }
}


//检测model 是否存过
- (BOOL)checkModel:(MaterialModel *)model {
    NSString *sql = @"select * from materialInfo where material_code = ?";
    //查找
    FMResultSet *rs = [_database executeQuery:sql,model.material_code];
    
    if ([rs next]) {//只要有记录 直接返回YES
        return YES;
    }else{
        return NO;
    }
}

//增加一个数据
- (void)insertModel:(MaterialModel *)model {
    //检测 数据库 有没有存过
    if ([self checkModel:model]) {
        //表示存在
        return;
    }
    NSString *sql = @"insert into materialInfo (material_code,material_name,category_code,supply_price,unit_order,min_num,standard,uid,created,modified,guid) values (?,?,?,?,?,?,?,?,?,?,?)";
    ///NSString *sql = @"insert into materialInfo (material_code,material_name,category_code,supply_price,unit_order,min_num,standard) values (?,?,?,?,?,?,?)";
    //执行增加sql语句
    BOOL isS = [_database executeUpdate:sql,model.material_code,model.material_name,model.category_code,model.supply_price,model.unit_order,model.min_num,model.standard,model.id,model.created,model.modified,model.guid];
    //BOOL isS = [_database executeUpdate:sql,model.material_code,model.material_name,model.category_code,model.supply_price,model.unit_order,model.min_num,model.standard];
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
            for (MaterialModel *model in modelArr) {
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
        for (MaterialModel *model in modelArr) {
            [self insertModel:model];
        }
    }
}


//根据material_code  删除记录
- (void)deleteDataWithUid:(NSString *)uid {
    NSString *sql = @"delete from materialInfo where material_code = ?";
    //根据uid 删除记录
    if (![_database executeUpdate:sql,uid]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
}
//删除所有的
- (void)deleteAllData {
    NSString *sql = @"delete from materialInfo";
    //删除所有记录
    if (![_database executeUpdate:sql]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
    
}

//查询所有的数据
- (NSArray *)findAllData {
    NSString *sql = @"select * from materialInfo";
    //创建一个数组
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *rs = [_database executeQuery:sql];
    while ([rs next]) {
        MaterialModel *model = [[MaterialModel alloc]init];
        //把数据放入数据模型
        //model.id = [rs stringForColumn:@"id"];
        model.material_name = [rs stringForColumn:@"material_name"];
        model.material_code = [rs stringForColumn:@"material_code"];
        model.supply_price = [rs stringForColumn:@"supply_price"];
        model.unit_order = [rs stringForColumn:@"unit_order"];
        model.min_num = [rs stringForColumn:@"min_num"];
        model.category_code = [rs stringForColumn:@"category_code"];
        model.standard = [rs stringForColumn:@"standard"];
        model.id=[rs stringForColumn:@"uid"];
        
        
        model.created=[rs stringForColumn:@"created"];
        model.guid=[rs stringForColumn:@"guid"];
        model.modified=[rs stringForColumn:@"modified"];
        //放入数组
        [arr addObject:model];
      
    }
    //返回查询好的数组
    return arr;
}

//获取 有多少条记录
- (NSInteger)getCountWithModels {
    NSString *sql = @"select count(*) from materialInfo";
    FMResultSet *rs = [_database executeQuery:sql];
    NSInteger count = 0;
    while ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    return count;
}

@end
