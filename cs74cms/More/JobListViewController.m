//
//  JobListViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/11.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "JobListViewController.h"
#import "InitData.h"
#import "CollectionTableViewCell.h"
#import "T_AddJob.h"
#import "JobDetailViewController.h"

@interface JobListViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *mainTableView;
    NSMutableArray *dataSource;
}

@end

@implementation JobListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void) viewCanBeSee{
    [self.myNavigationController setTitle: MYLocalizedString(@"列表", @"list")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDataSource:(NSMutableArray*) tdataSource{
    dataSource = tdataSource;
    
    if (tdataSource == nil || [tdataSource count] == 0){
      /*  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [InitData Width] - 40, 20)];
        label.textColor = [UIColor colorWithRed:51./255 green:51./255 blue:51./255 alpha:1];
        [self.view addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无职位";
        */
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 138) / 2, ([InitData Height] - 93) / 2, 138, 93)];
        [imgView setImage:[UIImage imageNamed:@"nodata.png"]];
        [self.view addSubview:imgView];
        
        return;
    }
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [mainTableView setBackgroundColor:[UIColor whiteColor]];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    [self.view addSubview:mainTableView];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataSource == nil)
        return 0;
    return [dataSource count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // static NSString * tableSampleIdentifier = @"tableSampleIdentifier";
    CollectionTableViewCell *cell = (CollectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionTableViewCell alloc] init];
    }
    T_AddJob *job = [dataSource objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@", job.jobs_name];
    [cell setTitle:title];
    
   // NSString *intent = [NSString stringWithFormat:@"%@", job.companyname];//意向职位:
    [cell setMessage:job.companyname];
    [cell setValue:job.refreshtime];
    [cell setTime:job.wage_cn];
    
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    T_AddJob *job = [dataSource objectAtIndex:indexPath.row];
    JobDetailViewController *editjob = [[JobDetailViewController alloc] init];
    [editjob setJid:job.ID];
    [self.myNavigationController pushAndDisplayViewController:editjob];
}

@end
