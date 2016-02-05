//
//  MutableMenuViewController.m
//  cs74cms
//
//  Created by lyp on 15/5/15.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MutableMenuViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "MutableMenuTableViewCell.h"

@interface MutableMenuViewController ()<UITableViewDataSource, UITableViewDelegate, MutableMenuCellDelegate>{
    UITableView *mainTableView;
    
    NSString *hanshuName;
    
    NSMutableArray *array;//存储数据
    
    MutableMenuTableViewCell *selected;
    int seletedIndex;
    
    BOOL sign;//标记是否嵌套在别的页面中
    BOOL duoXuan;
}

@end

@implementation MutableMenuViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    sign = NO;
}

- (void) viewCanBeSee{
  //  if ([[self.view subviews] count] <= 0)
   //     [self drawView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"确定", @"done") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *butArr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:butArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setCanDuoXuan:(BOOL) duoxuan{
    duoXuan = duoxuan;
}
- (void) setTableViewY:(CGFloat) y andHeight:(CGFloat) height{
     if (mainTableView == nil){
        mainTableView = [[UITableView alloc] init];
    }
    [self.view setFrame:CGRectMake(0, y, [InitData Width], height)];
    [mainTableView setFrame:CGRectMake(0, 0, [InitData Width], height)];
    sign = YES;
}

- (void) setHanshuName:(NSString*) str{
    hanshuName = str;
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        array = [[[T_Interface alloc] init] classify:str andParentid:0];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self drawView];
        });
    });
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    if (mainTableView == nil){
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
           }
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.showsHorizontalScrollIndicator = NO;
    mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainTableView];

}

#pragma mark event
- (T_category*) findParentNodeByParentId:(int) parentid{
    for (int i=0; i<[array count]; i++){
        T_category *cat = [array objectAtIndex:i];
        if (cat.c_id == parentid)
            return cat;
    }
    return nil;
}
- (NSMutableString*) getIdString:(int) t{
    T_category *cat = [array objectAtIndex:t];
    NSMutableString *str = [NSMutableString stringWithFormat:@"%d", cat.c_id];
    while (cat.c_parentid > 0) {
        cat = [self findParentNodeByParentId:cat.c_parentid];
        str = [NSMutableString stringWithFormat:@"%d.%@", cat.c_id, str];
    }
    return str;
}
- (NSMutableString*) getTitleString:(int) t{
    T_category *cat = [array objectAtIndex:t];
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", cat.c_name];
    while (cat.c_parentid > 0) {
        cat = [self findParentNodeByParentId:cat.c_parentid];
        str = [NSMutableString stringWithFormat:@"%@/%@", cat.c_name, str];
    }
    return str;
}

- (void) save{
    if (selected != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(MutableMenuSelectedThis:andString:)]){
        
        [self.delegate MutableMenuSelectedThis:(int)selected.tag andString:[selected getTitle]];

    }
    if (selected != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(MutableMenuSelectedThisIdString:andTitleString:)]){
        
        [self.delegate MutableMenuSelectedThisIdString:[self getIdString:seletedIndex] andTitleString:[self getTitleString:seletedIndex]];
    }
    if (selected != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(MutableMenuSelectedId:andIdString:andTitle:andTitleString:)]){
        
        NSMutableString *idStr =[self getIdString:seletedIndex];
        NSString *titleStr = [self getTitleString:seletedIndex];
        if (duoXuan){
        if ([hanshuName isEqualToString: @"district"]) {
            NSArray *arr = [idStr componentsSeparatedByString:@"."];
            if ([arr count] == 1){
                [idStr appendString:@".0"];
            }
        }else if ([hanshuName isEqualToString:@"jobs"]){
            NSArray *arr = [idStr componentsSeparatedByString:@"."];
            if ([arr count] <= 2){
                [idStr appendString:@".0"];
            }
        }
        }
        
        [self.delegate MutableMenuSelectedId:(int)selected.tag andIdString:idStr andTitle:[selected getTitle] andTitleString:titleStr];
    }
    [self.myNavigationController dismissViewController];
}

#pragma mark delegate
- (void) getSelectedCell:(int) index andSelected:(BOOL) select{
    if (select){
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        selected = (MutableMenuTableViewCell*)[mainTableView cellForRowAtIndexPath:path];
        seletedIndex = index;
        [self save];
    }
    else{
        
    }
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (array != nil)
        return [array count];
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString * idf = @"tableviewcellidf";
    //MutableMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];
    MutableMenuTableViewCell *cell = (MutableMenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[MutableMenuTableViewCell alloc] init];
    }
    
    T_category *cat = [array objectAtIndex:[indexPath row]];
    [cell setTitle:cat.c_name];
    [cell setTitleX:25 * cat.level];
    cell.tag = cat.c_id;
    cell.level = cat.level;
    cell.delegate = self;
    
    if (indexPath.row + 1 < [array count]){
        T_category *next = [array objectAtIndex:indexPath.row + 1];
        if (next.level > cat.level)
            [cell setOpen:YES];
    }//cat.level == 0 &&
    if (duoXuan && ([hanshuName isEqualToString: @"district"] || (cat.level >= 1 && [hanshuName isEqualToString:@"jobs"])
        ||(![hanshuName isEqualToString:@"district"] && ![hanshuName isEqualToString:@"jobs"]))){

        [cell setCanSelectedByIndex:indexPath.row];
    }
    
    return cell;
}
//当cell被选择（被点击）时调用的函数
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MutableMenuTableViewCell *cell= (MutableMenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(((T_category*)[array objectAtIndex:indexPath.row]).open){
        [self deleteOperationByPath:indexPath];
        [mainTableView reloadData];
        return;
    }
    
    T_category *cat = [array objectAtIndex:indexPath.row];
    if ((cat.level == 1 && [hanshuName isEqualToString: @"district"]) || (cat.level == 2 && [hanshuName isEqualToString:@"jobs"])
        ||(![hanshuName isEqualToString:@"district"] && ![hanshuName isEqualToString:@"jobs"])){
        if (selected != nil)
            [selected setChance:NO];
        [cell setChance:YES];
        selected = cell;
        seletedIndex = (int)indexPath.row;
        if (sign){
            [self save];
            [cell setChance:NO];
        }
        return;
    }
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        
        int parentid = (int)cell.tag;
        NSArray *tarry = [[[T_Interface alloc] init] classify:hanshuName andParentid:parentid];
        cell.ChildArray = [tarry copy];
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if(cell.ChildArray == nil || cell.ChildArray.count==0)//如果没有子菜单
            {
                //NSLog(@"要打开页面");
                if (selected != nil)
                    [selected setChance:NO];
                [cell setChance:YES];
                selected = cell;
                seletedIndex = (int)indexPath.row;
                if (sign){
                    [self save];
                    [cell setChance:NO];
                }
            }
            else
            {
                if(!((T_category*)[array objectAtIndex:indexPath.row]).open)//如果子菜单是关闭的
                {
                    [self insertOperation:cell andPath:indexPath];
                    [mainTableView reloadData];
                    
                }
            }
        });
    });
}
- (void) insertOperation:(MutableMenuTableViewCell *)item andPath:(NSIndexPath*) path
{
    ((T_category*)[array objectAtIndex:path.row]).open = YES;

    
    for(int i=0;i<item.ChildArray.count;i++)
    {
        T_category *cat = [item.ChildArray objectAtIndex:i];
        [array insertObject:cat atIndex:path.row + i +1 ];//调用数组函数将其插入其中
        ((T_category*)[array objectAtIndex:path.row + i + 1]).level =  item.level + 1;
    }
}
- (void) deleteOperationByPath:(NSIndexPath*) path
{
    ((T_category*)[array objectAtIndex:path.row]).open = NO;
    
    
  //  MutableMenuTableViewCell *item = (MutableMenuTableViewCell*)[mainTableView cellForRowAtIndexPath:path];
    NSMutableIndexSet *set= [NSMutableIndexSet indexSet];//设置用来存放删除的cell的索引
  /*  for(int i=[item.ChildArray count] - 1; i>= 0; i--)
    {
        int cnt = path.row + i + 1;
        [set addIndex:cnt];
        if (((T_category*)[array objectAtIndex:cnt]).open){
            NSIndexPath *tpath = [NSIndexPath indexPathForRow:cnt inSection:0];

            [self deleteOperationByPath:tpath];
        }
    }*/
    T_category *cat = [array objectAtIndex:path.row];
    int level = cat.level;
    int cnt = path.row + 1;
    cat = [array objectAtIndex:cnt];
    while (cnt <= [array count] && cat.level > level) {
        [set addIndex:cnt];
        cnt ++;
        cat =[array objectAtIndex:cnt];
    }
    
    [array removeObjectsAtIndexes:set];//调用函数来从数组中删除
}
@end
