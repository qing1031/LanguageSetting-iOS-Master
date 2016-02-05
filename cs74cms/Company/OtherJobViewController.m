//
//  OtherJobViewController.m
//  74cms
//
//  Created by lyp on 15/5/7.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "OtherJobViewController.h"
#import "InitData.h"
#import "CollectionTableViewCell.h"
#import "JobDetailViewController.h"
#import "UIScrollView+KS.h"
#import "ITF_Company.h"

#define pageCount 8

@interface OtherJobViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *mainTableView;
    
    NSMutableArray *dataSource;
    int companyID;
    BOOL last;
    BOOL _loadingMore;
    int JID;
}

@end

@implementation OtherJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void) setCompanyID:(int) tcompanyID{
    companyID = tcompanyID;
    _loadingMore = NO;
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        //不可从主线程取值
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            dataSource = [[[ITF_Company alloc] init] companyJobListByID:companyID andJID:[InitData getPid] andStart:0 andRow:pageCount];
            JID = [InitData getPid];
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                [self drawView];
            });
        });
    }
    else{
        [InitData setPid:JID];
    }
}
- (void) setTitle:(NSString *)title{
    [self.myNavigationController setTitle:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    T_AddJob *job = [dataSource objectAtIndex:0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [InitData Width] - 40, 30)];
    title.backgroundColor = [UIColor whiteColor];
    title.textColor = [UIColor colorWithRed:56./255 green:118./255 blue:173./255 alpha:1];
    title.font = [UIFont systemFontOfSize:14];
    title.text = [NSString stringWithFormat:MYLocalizedString(@"共有%d个职位正在招聘", @"A total of%d jobs are being recruited"), job.demo];
    [self.view addSubview:title];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 30, [InitData Width], 1)];
    sep.backgroundColor = [UIColor colorWithRed:201./255 green:201./255 blue:201./255 alpha:1];
    [self.view addSubview:sep];
    

    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, [InitData Width], [InitData Height] - 31)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    [self.view addSubview:mainTableView];

}


- (void)addData{
    if (dataSource == nil)
        dataSource = [[NSMutableArray alloc] init];
    
    int start = dataSource ==nil?0 :[dataSource count];
    //后台代码
    NSArray *tarray = [[[ITF_Company alloc] init] jobListByUser:[InitData getUser] andStart:start andRow:pageCount];
    
    [dataSource addObjectsFromArray:tarray];
    
    [mainTableView reloadData];
    last = tarray.count == pageCount;
}
#pragma mark delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataSource != nil)
        return [dataSource count];
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString *idf = @"tableSampleIdentifier";
    CollectionTableViewCell *cell = (CollectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionTableViewCell alloc] init];
    }
    T_AddJob *job = [ dataSource objectAtIndex:indexPath.row];
    [cell setTitle:job.jobs_name];
    [cell setMessage:[NSString stringWithFormat:@"%@|%@|%@", job.district_cn, job.education_cn, job.experience_cn]];
    
    return  cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    T_AddJob *job = [dataSource objectAtIndex:indexPath.row];
    [InitData setPid:job.ID];
    JobDetailViewController *detail = [[JobDetailViewController alloc] init];
    [self.myNavigationController pushAndDisplayViewController:detail];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!_loadingMore && !last && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        [self loadDataBegin];
    }
}

// 开始加载数据
- (void) loadDataBegin
{
    if (_loadingMore == NO && !last)
    {
        _loadingMore = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([InitData Width] / 2 - 10., 10.0f, 20.0f, 20.0f)];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [mainTableView.tableFooterView addSubview:tableFooterActivityIndicator];
        
        [self loadDataing];
    }
}

// 加载数据中
- (void) loadDataing
{
    //不可从主线程取值
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        int start = dataSource == nil?0:dataSource.count;
        NSMutableArray * tarray = [[[ITF_Company alloc] init] companyJobListByID:companyID andJID:[InitData getPid] andStart:start andRow:pageCount];
        [dataSource addObjectsFromArray:tarray];
        
        [mainTableView reloadData];
    
        [self loadDataEnd];

    });
}

// 加载数据完毕
- (void) loadDataEnd
{
    _loadingMore = NO;
    [self createTableFooter];
}

// 创建表格底部
- (void) createTableFooter
{
    if([[[mainTableView.tableFooterView subviews] objectAtIndex:0] isKindOfClass:[UIActivityIndicatorView class]]){
       UIActivityIndicatorView *act = [[mainTableView.tableFooterView subviews] objectAtIndex:0];
        [act stopAnimating];
        [act removeFromSuperview];
    }
    mainTableView.tableFooterView = nil;
    
    if (last)
        return;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mainTableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:MYLocalizedString(@"上拉显示更多数据", @"Pull up display more data")];
    [tableFooterView addSubview:loadMoreText];
    
    mainTableView.tableFooterView = tableFooterView;
}

@end
