//
//  FlipTableView.m
//  FlipTableView
//
//  Created by fujin on 15/7/9.
//  Copyright (c) 2015年 fujin. All rights reserved.
//

#import "FlipTableView.h"
#import "RuleModel.h"
#import "RuleDataBase.h"
#import "DefiniteMaterialDataBase.h"
@interface FlipTableView (){
    NSString*_num;
    float _number;
}


@end
@implementation FlipTableView
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)contentArray
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
        [self.dataArray addObjectsFromArray:contentArray];
        
        self.frame = frame;
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.tableView.frame = self.bounds;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNumber:) name:@"number" object:nil];
        self.tableView.bounces = NO;
        self.tableView.scrollsToTop = YES;
        self.tableView.pagingEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
    }
    return self;
}
#pragma mark --- tableView datasouce and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.dataArray.count);
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdtifier = @"cell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdtifier];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIViewController *vc = [_dataArray objectAtIndex:indexPath.row];
        vc.view.frame = cell.bounds;
        [cell.contentView addSubview:vc.view];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%f",self.frame.size.width);
    return self.frame.size.width;
}

#pragma mark --- scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollChangeToIndex:)]) {
        int index = scrollView.contentOffset.y / self.frame.size.width;
        
        [self.delegate scrollChangeToIndex:index + 1];
    }
    
}
//开始滑动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSArray*arry=[[RuleDataBase defaultDatabase]findAllData];
   
    if (arry.count>0&&_number>0) {
        [self getRuleData:arry View:scrollView];
    }
    NSLog(@"===========================");
}
#pragma mark --- select onesIndex
-(void)selectIndex:(NSInteger)index
{
   
    [UIView animateWithDuration:0.3 animations:^{
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];

}
-(void)changeNumber:(NSNotification *)notification{
    if ([notification object]!=nil) {
        _number=[[notification object]floatValue];
        
    }
    
}

-(void)getRuleData:(NSArray*)arry View:(UIScrollView *)scrollView{
    NSMutableString* str=[[NSMutableString alloc]init];
    for (NSUInteger i=0;i<[arry count];i++) {
        RuleModel* model=arry[i];
        _num=[model.conditions objectForKey:@"num"];
        NSLog(@"num=\n%@",_num);
        for (id obj in [[model.conditions objectForKey:@"material_list"]allValues]) {
            [str appendString:[NSString stringWithFormat:@"%@、\t\t\t\t\t",[obj lastObject]]];
        }
        if (i==0) {
            if (_number<[_num floatValue]) {
                NSString*string=[NSString stringWithFormat:@"\n的订购总量应大于%@",_num];
                [str appendString:string];
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
               
            }else{
                if ([self.delegate respondsToSelector:@selector(scrollChangeToIndex:)]) {
                    int index = scrollView.contentOffset.y / self.frame.size.width;
                    
                    [self.delegate scrollChangeToIndex:index + 1];
                }
          
        }
     [str setString:@""];
    }
 }

}

@end
