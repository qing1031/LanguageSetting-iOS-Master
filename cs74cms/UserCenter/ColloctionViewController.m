
//
//  ColloctionViewController.m
//  74cms
//
//  Created by LPY on 15-4-14.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "ColloctionViewController.h"
#import "InitData.h"
#import "CollectionTableViewCell.h"
#import "T_Interface.h"
#import "UIScrollView+KS.h"
#import "T_ApplyJob.h"
#import "T_CareMe.h"
#import "T_Interview.h"
#import "T_Collection.h"
#import "Preview2ViewController.h"
#import "JobDetailViewController.h"

#import "ITF_Company.h"

#define pageCount 8

@interface ColloctionViewController ()<UITableViewDelegate, UITableViewDataSource, KSRefreshViewDelegate>{
    UITableView *mainTableView;
    NSMutableArray *dataSource;
    
    float cellHeight;
    int type;//0申请的职位  1谁关注我  2个人的面试邀请   3我的收藏  4应聘简历  5下载简历  6公司的面试邀请 7收藏的简历
    int Pid;
    
    BOOL last;//为真 为还有数据
}

@end

@implementation ColloctionViewController

- (void) drawView{
    
    cellHeight = 81;
    
    float height = 0 ;
    if (dataSource != nil)
        height = cellHeight * [dataSource count] >[InitData Height] ?[InitData Height] : cellHeight * [dataSource count];
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
    
    mainTableView.frame          = CGRectMake(0, 0, KS_SCREEN_WIDTH, KS_SCREEN_HEIGHT);
    mainTableView.header         = [[KSDefaultHeadRefreshView alloc] initWithDelegate:self]; //下拉刷新
    mainTableView.footer         = [[KSDefaultFootRefreshView alloc] initWithDelegate:self]; //上拉刷新
    
    mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据
    mainTableView.separatorStyle = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    /*   if ([[self.view subviews] count] <= 0)
     {
     [self drawView];
     }*/
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
    {
        [self drawView];
    }
  //  else{
   //     [mainTableView.header setState:RefreshViewStateLoading];
   // }
    switch (type) {
        case 0:
            [self.myNavigationController setTitle:MYLocalizedString(@"申请的职位", @"Applied position")];
            break;
        case 1:
            [self.myNavigationController setTitle:MYLocalizedString(@"谁关注我", @"Who pays attention to me")];
            break;
        case 2:
            [self.myNavigationController setTitle:MYLocalizedString(@"面试邀请", @"Interview invitation")];
            break;
        case 3:
            [self.myNavigationController setTitle:MYLocalizedString(@"我的收藏", @"My collection")];
            break;
        case 4:
            [self.myNavigationController setTitle:MYLocalizedString(@"应聘简历", @"Recume")];
            break;
        case 5:
            [self.myNavigationController setTitle:MYLocalizedString(@"已下载的简历", @"Downloaded resume")];
            break;
        case 6:
            [self.myNavigationController setTitle:MYLocalizedString(@"发起的面试邀请", @"Initiated interview invitation")];
            break;
        case 7:
            [self.myNavigationController setTitle:MYLocalizedString(@"收藏的简历", @"Collectioned recume")];
            break;
    }
}

- (void) setTitle:(NSString *)title{
    [self.myNavigationController setTitle:title];
}

- (void) setType:(int)ttype andPid:(int) pid{
    type = ttype;
    Pid = pid;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addData
{
    if (dataSource == nil)
        dataSource = [[NSMutableArray alloc] init];
    
    T_User *user = [InitData getUser];
    int start = (dataSource == nil || dataSource.count ==0 )?0:dataSource.count ;
    NSArray *tarray;
    switch (type) {
        case 0:
            tarray = [[[T_Interface alloc] init] resumeApplyJobsByUsername:user.username andUserpwd:user.userpwd andPid:Pid andStart:start andRow:pageCount];
            break;
        case 1:
             tarray = [[[T_Interface alloc] init] resumeAttentionMeByUsername:user.username andUserpwd:user.userpwd andPid:Pid andStart:start andRow:pageCount];
            break;
        case 2:
            tarray = [[[T_Interface alloc] init] resumeInterviewByUsername:user.username andUserpwd:user.userpwd andPid:Pid andStart:start andRow:pageCount];
            break;
        case 3:
            tarray = [[[T_Interface alloc] init] resumeFavoritesByUsername:user.username andUserpwd:user.userpwd andStart:start andRow:pageCount];
            break;
        case 4:
            tarray = [[[ITF_Company alloc] init] jobsApplyByUser:[InitData getUser] andJID:[InitData getPid] andStart:start andRow:pageCount];
            break;
        case 5:
            tarray = [[[ITF_Company alloc] init] downResumeByUser:[InitData getUser] andStart:start andRow:pageCount];
            break;
        case 6:
            tarray = [[[ITF_Company alloc] init] interviewByUser:[InitData getUser] andStart:start andRow:pageCount];
            break;
        case 7:
            tarray = [[[ITF_Company alloc] init] favoritesByUser:[InitData getUser] andStart:start andRow:pageCount];
            break;
        default:
            break;
    }
        
    [dataSource addObjectsFromArray:tarray];
    
    //[mainTableView reloadData];
    last = tarray.count == pageCount;
}

- (void) noData{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 138) / 2, ([InitData Height] - 93) / 2, 138, 93)];
    [imgView setImage:[UIImage imageNamed:@"nodata.png"]];
    [self.view addSubview:imgView];
}

#pragma mark  delegate
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
    if (dataSource == nil)
        return 0;
    return [dataSource count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (void) drawApplyJob:(CollectionTableViewCell*) cell and:(T_ApplyJob*) job{
    [cell setTitle:job.jobs_name];
    
    [cell setMessage:job.companyname];
    
    [cell setTime:job.apply_addtime];
    
    [cell setValue:job.replay_status];
    
    [cell setStyle:1];
}
- (void) drawApplyJob2:(CollectionTableViewCell*) cell and:(T_ApplyJob*) job{
    NSString *title = [NSString stringWithFormat:@"%@ (%@ %@岁 %@ %@)", job.fullname, job.sex_cn, job.birthdate, job.education_cn, job.experience_cn];
    [cell setTitle:title];
    
    NSString *intent = [NSString stringWithFormat:MYLocalizedString(@"应聘:%@", @"Apply for:%@"), job.intention_jobs];
    [cell setMessage:intent];
    [cell setTime:job.replay_status];
    [cell setValue:job.apply_addtime];
    if (job.is_reply == 0)
        [cell setTimeColorType:2];
    else
        [cell setTimeColorType:1];
    [cell setValueColorType:0];
    
}
- (void) drawCareMe:(CollectionTableViewCell*) cell and:(T_CareMe*) data{
    [cell setTitle:data.companyname];
    
    [cell setMessage:[NSString stringWithFormat:@"%@ | %@", data.trade_cn, data.district_cn]];
    
    [cell setTime:data.addtime];

    [cell setValue:data.is_down];
}
- (void) drawInterview:(CollectionTableViewCell*) cell and:(T_Interview*) data{
    [cell setTitle:data.jobs_name];
    
    [cell setMessage:data.company_name];
    
    [cell setTime:data.interview_addtime];
}
- (void) drawCollection:(CollectionTableViewCell*) cell and:(T_Collection*) data{
    [cell setTitle:data.jobs_name];
    
    [cell setMessage:data.company_name];
    
    [cell setTime:data.addtime];

    [cell setValue:data.wage_cn];
}
- (void) drawDownResume:(CollectionTableViewCell*) cell and:(T_ApplyJob*) job{
    NSString *title = [NSString stringWithFormat:@"%@ (%@ %@岁 %@ %@)", job.fullname, job.sex_cn, job.birthdate, job.education_cn, job.experience_cn];
    [cell setTitle:title];
    
    NSString *intent = [NSString stringWithFormat:@"%@", job.intention_jobs];//意向职位:
    [cell setMessage:intent];
    
    [cell setTime:job.down_addtime];
    
    // [cell setStyle:1];
}
- (void) drawCompanyInter:(CollectionTableViewCell*) cell and:(T_ApplyJob*) job{
    NSString *title = [NSString stringWithFormat:@"%@ (%@ %@岁 %@ %@)", job.fullname, job.sex_cn, job.birthdate, job.education_cn, job.experience_cn];
    [cell setTitle:title];
    
    NSString *intent = [NSString stringWithFormat:MYLocalizedString(@"面试职位:%@", @"Position:%@"), job.intention_jobs];//意向职位:
    [cell setMessage:intent];
    [cell setValue:job.apply_addtime];
    [cell setTime:job.replay_status];
    if (job.is_reply == 0)
        [cell setValueColorType:1];
    else
        [cell setValueColorType:0];
    [cell setStyle:1];
}
- (void) drawfavorite:(CollectionTableViewCell*) cell and:(T_ApplyJob*) job{
    NSString *title = [NSString stringWithFormat:MYLocalizedString(@"%@ (%@ %@岁 %@ %@)", @"%@ (%@ %@age %@ %@)") , job.fullname, job.sex_cn, job.birthdate, job.education_cn, job.experience_cn];
    [cell setTitle:title];
    
    NSString *intent = [NSString stringWithFormat:@"%@", job.intention_jobs];//意向职位:
    [cell setMessage:intent];
    
    [cell setTime:job.down_addtime];
    
    // [cell setStyle:1];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // static NSString * tableSampleIdentifier = @"tableSampleIdentifier";
    CollectionTableViewCell *cell = (CollectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionTableViewCell alloc] init];
    }

    switch (type) {
        case 0:
            [self drawApplyJob:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 1:
            [self drawCareMe:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 2:
            [self drawInterview:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 3:
            [self drawCollection:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 4:
            [self drawApplyJob2:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 5:
            [self drawDownResume:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 6:
            [self drawCompanyInter:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 7:
            [self drawfavorite:cell and:[dataSource objectAtIndex:indexPath.row]];
            break;
    }
    
    return cell;
}

- (void) jobdetail:(int) row andJID:(int) jid{
    JobDetailViewController *editjob = [[JobDetailViewController alloc] init];
    [editjob setJid:jid];
    [self.myNavigationController pushAndDisplayViewController:editjob];
}
- (void) whoCareMe:(int) row andCompanyId:(int) companyId{
    JobDetailViewController *editjob = [[JobDetailViewController alloc] init];
    [editjob setJid:1];
    [editjob setCompanyId:companyId];
    [self.myNavigationController pushAndDisplayViewController:editjob];
}
- (void) previewResume:(int) row{
    T_ApplyJob *job = [dataSource objectAtIndex:row];
    Preview2ViewController *preview = [[Preview2ViewController alloc] init];
    if (job.jobs_id > 0)
        [preview setJid:job.jobs_id];
    [self.myNavigationController pushAndDisplayViewController:preview];
    if (![job.fullname isEqualToString:@""])
        [preview setTitle:job.fullname ];
    [preview setPid:job.resume_id];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //0申请的职位  1谁关注我  2个人的面试邀请   3我的收藏  4应聘简历  5下载简历  6公司的面试邀请 7收藏的简历
    switch (type) {
        case 0:
            [self jobdetail:indexPath.row andJID:((T_ApplyJob*)[dataSource objectAtIndex:indexPath.row]).jobs_id];
            break;
        case 1:
            [self whoCareMe:indexPath.row andCompanyId:((T_CareMe*)[dataSource objectAtIndex:indexPath.row]).companyid];
            break;
        case 2:
            [self jobdetail:indexPath.row andJID:((T_Interview*)[dataSource objectAtIndex:indexPath.row]).jobs_id];
            break;
        case 3:
            [self jobdetail:indexPath.row andJID:((T_Collection*)[dataSource objectAtIndex:indexPath.row]).jobs_id];
            break;
            
        case 4:
        case 5:
        case 6:
        case 7:
            [self previewResume:indexPath.row];
            break;
        default:
            break;
    }
}


@end
