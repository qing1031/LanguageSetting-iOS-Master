//
//  ManageViewController.m
//  74cms
//
//  Created by lyp on 15/5/5.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ManageViewController.h"
#import "InitData.h"
#import "ManageTableViewCell.h"
#import "UIScrollView+KS.h"
#import "ITF_Company.h"
#import "T_AddJob.h"
#import "EditJobViewController.h"
#import "PublishViewController.h"
#import "JobDetailViewController.h"
#import "ColloctionViewController.h"

#define SELECTEDNULL 9999
#define pageCount 8

@interface ManageViewController ()<UITableViewDataSource, UITableViewDelegate, ManageTableViewCellDelegate>{
    UITableView *mainTableView;
    
    NSMutableArray *dataSource;
    
    int tableCellSelected;
    
    BOOL last;
}

@end

@implementation ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void) viewCanBeSee{

    [self drawView];

    
    [self.myNavigationController setTitle:MYLocalizedString(@"管理职位", @"Manage position")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"发布", @"Release") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];

}
- (void) viewCannotBeSee{
    dataSource = nil;
    [mainTableView removeFromSuperview];
    mainTableView = nil;
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    
    dataSource = nil;
    tableCellSelected = SELECTEDNULL;
    last = NO;
    
    if (mainTableView == nil){
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
        mainTableView.frame          = CGRectMake(0, 0, KS_SCREEN_WIDTH, KS_SCREEN_HEIGHT);
        mainTableView.header         = [[KSDefaultHeadRefreshView alloc] initWithDelegate:(id)self]; //下拉刷新
        mainTableView.footer         = [[KSDefaultFootRefreshView alloc] initWithDelegate:(id)self]; //上拉刷新
    
        mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    [self.view addSubview:mainTableView];
    

    [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据

}


#pragma mark event
- (void) save{
    [self getAddMode];
}
- (void) getAddMode{
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            T_User *user = [InitData getUser];
            int mode = [[[ITF_Company alloc] init] companyAddJobsByUser:user andAddJob:nil];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                if (mode > 0){
                    PublishViewController *pub = [[PublishViewController alloc] init];
                    [pub setMode:mode];
                    [self.myNavigationController pushAndDisplayViewController: pub];
                }
           /*     else if([InitData NetIsExit]){
                    [InitData netAlert:@"您的积分不足，请充值后再发"];
                }*/
                
            });
        });
}

- (void)addData{
    if (dataSource == nil)
        dataSource = [[NSMutableArray alloc] init];

    int start = dataSource ==nil?0 :[dataSource count];
    //后台代码
    NSArray *tarray = [[[ITF_Company alloc] init] jobListByUser:[InitData getUser] andStart:start andRow:pageCount];
    
    [dataSource addObjectsFromArray:tarray];
    
   // [mainTableView reloadData];
    last = tarray.count == pageCount;
}

- (void) refreshJob{
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_AddJob *job = [dataSource objectAtIndex:tableCellSelected];
        NSString *msg = [[[ITF_Company alloc] init] refreshJobByUser:[InitData getUser] andJid:job.ID];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];

            [InitData netAlert:msg];

        });
    });

}

- (void) noData{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 138) / 2, ([InitData Height] - 93) / 2, 138, 93)];
    [imgView setImage:[UIImage imageNamed:@"nodata.png"]];
    [self.view addSubview:imgView];
}
#pragma mark delegate



- (void)managetableViewCellSelected:(int)index{
    T_AddJob *job = [dataSource objectAtIndex:tableCellSelected];
    [InitData setPid:job.ID];
    switch (index) {
        case 0:{
            JobDetailViewController *detail = [[JobDetailViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:detail];
        }

            break;
        case 1:{
            [self refreshJob];
        }
            break;
        case 2:{
            EditJobViewController *editjob = [[EditJobViewController alloc] init];
            T_AddJob *job = [dataSource objectAtIndex:tableCellSelected];
            [editjob setJid:job.ID];
            [self.myNavigationController pushAndDisplayViewController:editjob];
        }
            break;
        case 3:{
            ColloctionViewController *colle = [[ColloctionViewController alloc] init];
            [colle setType:4 andPid:0];
            [self.myNavigationController pushAndDisplayViewController: colle];
            [colle setTitle:[NSString stringWithFormat:MYLocalizedString(@"应聘:%@", @"Apply for:%@"), job.jobs_name]];
        }
            break;
            
        default:{
            [InitData isLoading:self.view];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //后台代码
                int res = [[[ITF_Company alloc] init] deleteJobsBy:[InitData getUser] andJid:[InitData getPid]];
                
                //后台完成后，到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [InitData haveLoaded:self.view];
                    if (res > 0){
          
                        [dataSource removeObjectAtIndex:tableCellSelected];
                        [dataSource removeObjectAtIndex:tableCellSelected];
                        [mainTableView reloadData];
                    }
                });
            });
            

        }
            break;
    }
}




- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:mainTableView.header]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [dataSource removeAllObjects];
            [self addData];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataSource == nil || [dataSource count] == 0){
                    [mainTableView removeFromSuperview];
                    mainTableView = nil;
                    
                    [self noData];
                    return ;
                }
                
                if (mainTableView.footer) {
                    mainTableView.footer.isLastPage = !last;
                }
                
                [mainTableView reloadData];
                [mainTableView.header setState:RefreshViewStateDefault];
            });
        });
        
     /*   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [dataSource removeAllObjects];
            [self addData];
            
            if (dataSource == nil || [dataSource count] == 0){
                [mainTableView removeFromSuperview];
                mainTableView = nil;
                
                UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [InitData Width] - 40, 50)];
                label.text = @"暂无数据！";
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
                [self.view addSubview:label];
                return ;
            }
            
            if (mainTableView.footer) {
                mainTableView.footer.isLastPage = !last;
            }
            
            [mainTableView reloadData];
            [mainTableView.header setState:RefreshViewStateDefault];
            // [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        });
        
        */
        return;
    }
    
    if ([view isEqual:mainTableView.footer]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!last) {
                
                [mainTableView.footer setIsLastPage:YES];
                [mainTableView reloadData];
            } else {
                [self addData];
                [mainTableView.footer setState:RefreshViewStateDefault];
                [mainTableView reloadData];
                
                if (mainTableView.footer) {
                    mainTableView.footer.isLastPage = !last;
                }
            }
        });
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataSource != nil)
        return [dataSource count];
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  /*  if (indexPath.row == tableCellSelected){
        return 76;
    }*/
    if (indexPath.row == tableCellSelected + 1){
       // NSLog(@"%d 50", indexPath.row);
        return 50;
    }
    return 81;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString *idf = @"tableViewCellIdentifier";
    ManageTableViewCell *cell = (ManageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    //下面的控制菜单
    T_AddJob *tjobg = [dataSource objectAtIndex:indexPath.row];
    if (tjobg.ID == 0) {
        cell = [[ManageTableViewCell alloc] init];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell subMenu];
        cell.delegate = self;
        
        return cell;
    }
    
    if (cell == nil){
        cell = [[ManageTableViewCell alloc] init];
    }
    T_AddJob *job = [dataSource objectAtIndex:indexPath.row];
    
    [cell setTitle:job.jobs_name];
    [cell setMessage:[NSString stringWithFormat:MYLocalizedString(@"%@|%@|浏览%d次", @"%@|%@| browse %d times"), job.nature_cn, job.district_cn, job.click]];
    [cell setTime:job.addtime];
    [cell setNum:job.countresume];
    
    return cell;
}

//下面的逻辑复杂，不可改
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableCellSelected!= SELECTEDNULL && indexPath.row - 1 == tableCellSelected){
        return;
    }
    int t = tableCellSelected;
    
    if (tableCellSelected!= SELECTEDNULL){//收起原来的菜单
        NSIndexPath *path = [NSIndexPath indexPathForRow:tableCellSelected + 1 inSection:0];
        NSArray *insertArr = [self deleteOperation:path];
        
    
        tableCellSelected = SELECTEDNULL;
        
        //这一句相当于刷新界面，带有动画
        [tableView deleteRowsAtIndexPaths:insertArr withRowAnimation:UITableViewRowAnimationBottom];
        
        if (t == indexPath.row){
            return;
        }
    }
    
    NSIndexPath *path = indexPath;
    if (indexPath.row > t){
        path = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
    }
    
    NSArray *insertArr = [self insertOperation:path];
    
    //这一句相当于刷新界面，带有动画
    tableCellSelected = (int)path.row;
    [tableView insertRowsAtIndexPaths:insertArr withRowAnimation:UITableViewRowAnimationBottom];

}


-(NSArray *) insertOperation:(NSIndexPath*) path
{
    T_AddJob *tjob = [[T_AddJob alloc] init];
   [dataSource insertObject:tjob atIndex:path.row +1 ];//调用数组函数将其插入其中


    NSMutableArray *PathArray= [NSMutableArray array];//初始化用于存放位置的数组
    NSIndexPath *patht = [NSIndexPath indexPathForRow:[dataSource indexOfObject:tjob] inSection:0];
    [PathArray addObject:patht];

    return PathArray;
}
-(NSArray *) deleteOperation:(NSIndexPath*) path
{
    [dataSource removeObjectAtIndex:path.row];
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    NSIndexPath *tpath = [NSIndexPath indexPathForRow:path.row inSection:0];
    [mutableArr addObject:tpath];
    
    return mutableArr;
}
@end
