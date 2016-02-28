//
//  RuleDataBase.m
//  LikeShopkeeper_iOS
//
//  Created by 杨超杰 on 16/2/22.
//  Copyright © 2016年 QXLK. All rights reserved.
//

#import "RuleDataBase.h"
#import "FMDatabase.h"
#import "YYClassInfo.h"
#import "NSObject+YYModel.h"
@implementation RuleDataBase{
    FMDatabase* _database;
}
+ (instancetype)defaultDatabase {
    static RuleDataBase *database = nil;
    @synchronized(self) {//同步
        if (database == nil) {
            database = [[self alloc] init];
        }
    }
    return database;
}
-(instancetype)init{
    if (self=[super init]) {
        _database=[[FMDatabase alloc]initWithPath:[self getFullFilePathWithName:@"RuleDataBase.sqlite"]];
        
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
-(void)creatTable{
    NSString *sql = @"create table if not exists RuleDataBase(serial integer  Primary Key Autoincrement,name Varchar(256),conditions Varchar(256),result Varchar(256))";
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
- (BOOL)checkModel:(RuleModel *)model {
    NSString *sql = @"select * from DM where name = ?";
    //查找
    FMResultSet *rs = [_database executeQuery:sql,model.name];
    
    if ([rs next]) {//只要有记录 直接返回YES
        return YES;
    }else{
        return NO;
    }
}
//增加一个数据
- (void)insertModel:(RuleModel *)model {
    //检测 数据库 有没有存过
    if ([self checkModel:model]) {
        //表示存在
        return;
    }
    
    NSString *sql = @"insert into RuleDataBase (name,conditions,result) values (?,?,?)";
    //执行增加sql语句
    BOOL isS = [_database executeUpdate:sql,model.name,[self getJsonDataArray:model.conditions],[self getJsonDataArray:model.result]];
    if (!isS) {
        NSLog(@"insert error:%@",[_database lastErrorMessage]);
    }
    
}
//转换为json数据
-(NSString*)getJsonDataArray:(NSDictionary*)dict{
    NSError *err = nil;
    if (dict!=nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}

-(NSDictionary*)getJsonDataString:(NSString*)s{
    
    NSError*err=nil;
    if (s!=nil) {
    NSData *jsonData = [s dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonStr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
        return jsonStr;
    }
    
    return nil;
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
            for (RuleModel *model in modelArr) {
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
        for (RuleModel *model in modelArr) {
            [self insertModel:model];
        }
    }
}


//根据material_code  删除记录
- (void)deleteDataWithUid:(NSString *)uid {
    NSString *sql = @"delete from RuleDataBase where name = ?";
    //根据uid 删除记录
    if (![_database executeUpdate:sql,uid]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
}
//删除所有的
- (void)deleteAllData {
    NSString *sql = @"delete from RuleDataBase";
    //删除所有记录
    if (![_database executeUpdate:sql]) {
        NSLog(@"delete error:%@",[_database lastErrorMessage]);
    }
    
}

//查询所有的数据
- (NSArray *)findAllData {
    NSString *sql = @"select * from RuleDataBase";
    //创建一个数组
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *rs = [_database executeQuery:sql];
    while ([rs next]) {
       RuleModel *model = [[RuleModel alloc]init];
        //把数据放入数据模型
        model.name=[rs stringForColumn:@"name"];
       // RuleDataBase* book=[RuleDataBase modelWithJSON:[rs stringForColumn:@"conditions"]];
          RuleDataBase* book2=[RuleDataBase modelWithJSON:[rs stringForColumn:@"result"]];
       // model.conditions=(NSDictionary*)[book modelToJSONData];
        model.result=(NSDictionary*)[book2 modelToJSONData];
        model.result=(NSDictionary*)[rs stringForColumn:@"result"];
        model.conditions=[self getJsonDataString:[rs stringForColumn:@"conditions"]];
      
        //放入数组
        [arr addObject:model];
        
    }
    //返回查询好的数组
    return arr;
}
//获取 有多少条记录
- (NSInteger)getCountWithModels {
    NSString *sql = @"select count(*) from RuleDataBase";
    FMResultSet *rs = [_database executeQuery:sql];
    NSInteger count = 0;
    while ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    return count;
}

@end
