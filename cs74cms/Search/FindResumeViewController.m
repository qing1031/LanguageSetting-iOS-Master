//
//  FindResumeViewController.m
//  74cms
//
//  Created by lyp on 15/4/30.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "FindResumeViewController.h"
#import "InitData.h"
#import "CollectionTableViewCell.h"
#import "RequirementView.h"
#import "ITF_Company.h"
#import "T_category.h"
#import "T_ApplyJob.h"
#import "ITF_Other.h"
#import "Preview2ViewController.h"
#import "JobDetailViewController.h"


#define PageCount 10

@interface FindResumeViewController ()<UITableViewDataSource, UITableViewDelegate, RequirementDelegate>{
    UIButton *selected;
    
    UIImageView *nodataView;
    UITableView *mainTableView;
    
    NSMutableArray *dataSource;
    BOOL last;
    BOOL _loadingMore;
    
    NSArray *reqArr;
    
    int type;//0搜索简历   1企业中的应聘简历  2搜索职位
    int start;
    
    //应聘简历中的条件
    int jid;//职位id
    int remarkid;//备注
    int experienceid;//经验
    
    //搜索简历中的条件
    NSString *district;
    NSString *jobs;
    int educationid;
    NSString *key;
    int current;
    
    //搜索职位中的条件
    NSString *trade;
    NSString *publishTime;
    int wage;
}

@end

@implementation FindResumeViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    jid = jid==0?0:jid;
    remarkid = remarkid==0?0:remarkid;
    experienceid = experienceid == 0? 0:experienceid;
    start = start==0?0:start;
    
    if (district == nil)
        district = @"";
    
    if (jobs == nil)
        jobs = @"";
    
    if (publishTime == nil)
        publishTime = @"";

    if (trade == nil)
        trade = @"";

    if (key == nil)
        key = @"";
    
    
  //  if ([[self.view subviews] count] <= 0){
   //     [self drawView];
   // }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithString:(NSString*) str{
    self = [super init];
    if (self){
        
    }
    return  self;
}
- (void) setType:(int) ttype{
    type = ttype;
}
- (void) setDistrict:(NSString*) distr andJobs:(NSString*) jobsStr andExperience:(int) experi andEducation:(int) education andKey:(NSString *)tkey{
    if (distr != nil)
        district = distr;
    else
        district = @"";
    
    if (jobsStr != nil)
        jobs = jobsStr;
    else
        jobs = @"";
    
    experienceid = experi;
    
    educationid = education;
    
    if (tkey!= nil)
        key = tkey;
    else
        key = @"";
}
- (void) setDistrict:(NSString*) distr andTrade:(NSString*) ttrade andJobs:(NSString*) jobsStr andPublishTime:(NSString*) tpublishTime andKey:(NSString*) tkey{
    if (distr != nil)
        district = distr;
    else
        district = @"";
    
    if (jobsStr != nil)
        jobs = jobsStr;
    else
        jobs = @"";
    

    if (tpublishTime != nil)
        publishTime = tpublishTime;
    else
        publishTime = @"";
    
    if (ttrade != nil)
        trade = ttrade;
    else
        trade = @"";
    
    
    if (tkey!= nil)
        key = tkey;
    else
        key = @"";
}
- (void) content{
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, [InitData Width], [InitData Height] - 35)];
    mainTableView.separatorStyle = NO;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
}

- (void) topView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, [InitData Width] + 2, 35)];
    topView.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1];
    topView.layer.borderColor = [UIColor colorWithRed:222./255 green:222./255 blue:222./255 alpha:1].CGColor;
    topView.layer.borderWidth = 1;
    [self.view addSubview:topView];
    
    NSArray *arr = [self getMenu];
       
    float width = -1;
    
    for (int i=0; i<[arr count]; i++){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 1, 35)];
        [view setBackgroundColor:[UIColor colorWithCGColor:topView.layer.borderColor]];
        [topView addSubview:view];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [but setTitleColor:[UIColor colorWithRed:51./255 green:51./255 blue:51./255 alpha:1] forState:UIControlStateNormal];
        [but setFrame:CGRectMake(width, 0, [InitData Width] / 3, 34)];
        [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        but.tag = i;
        [but addTarget:self action:@selector(selectThis:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:but];
        
        UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
        [img setImage:[UIImage imageNamed:@"top.png"] forState:UIControlStateSelected];
        [img setImage:[UIImage imageNamed:@"bottom.png"] forState:UIControlStateNormal];
        [img setFrame:CGRectMake(width+[InitData Width] / 6 + 30, 12, 8, 8)];
        [topView addSubview:img];
        
        width += [InitData Width] / 3;

    }
}

- (void) selectThis:(UIButton*) but{
    //把菜单去掉
    if([[self.view subviews] count] > 2 && selected != nil){
        long t = [[self.view subviews] count];
        UIView *view = [[self.view subviews] objectAtIndex:t - 1];
        [InitData distory:view];
    }
    
    if (selected != nil){
        if (but.tag == selected.tag){
            selected.selected = NO;
            UIButton *img = [[selected.superview subviews] objectAtIndex:selected.tag * 3 + 2];
            img.selected = NO;
            
            selected = nil;//收回

            return;
        }
        selected.selected = NO;
        UIButton *img = [[selected.superview subviews] objectAtIndex:selected.tag * 3 + 2];
        img.selected = NO;
    }
    but.selected = YES;
    UIButton *img = [[but.superview subviews] objectAtIndex:but.tag * 3 + 2];
    img.selected = YES;
    
    selected = but;
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        reqArr = [self getMenuContent:selected.tag];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            RequirementView *req = [[RequirementView alloc] initWithFrame:CGRectMake(0, 35, [InitData Width], [InitData Height] - 35)];
            req.delegate = self;
            [req setWithArray:reqArr];
            [self.view addSubview:req];
        });
    });
}

#pragma mark mutableData

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    else{
        start = 0;
        _loadingMore = NO;
        last = NO;
        dataSource = [[NSMutableArray alloc] init];
        [self loadDataBegin];
    }
    
    switch (type) {
        case 0:
            [self.myNavigationController setTitle:MYLocalizedString(@"搜索简历", @"Search resume")];
            break;
        case 1:
            [self.myNavigationController setTitle:MYLocalizedString(@"应聘简历", @"Resume")];
            break;
        case 2:
            [self.myNavigationController setTitle:MYLocalizedString(@"搜索职位", @"Search for jobs")];
            break;
            
        default:
            break;
    }
}

- (void) noData{
    if (dataSource == nil || [dataSource count] == 0){
        if( nodataView == nil){
            nodataView = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 138) / 2, ([InitData Height] - 93) / 2, 138, 93)];
            [nodataView setImage:[UIImage imageNamed:@"nodata.png"]];
            [self.view addSubview:nodataView];
        }
    }
    else{
        if (nodataView != nil){
            [nodataView removeFromSuperview];
            nodataView = nil;
        }
    }
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        dataSource = [NSMutableArray arrayWithArray:[self getDataSource]];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dataSource == nil){
                [self noData];
                
                [mainTableView removeFromSuperview];
                mainTableView = nil;
                return ;
            
            }
            
            [InitData haveLoaded:self.view];
            [self topView];
            [self content];
            

            [self noData];

                
        });
    });
    
}
- (NSArray*) getMenu{
    switch (type) {
        case 0:
            return [NSArray arrayWithObjects:MYLocalizedString(@"求职状态", @"Job status"),MYLocalizedString(@"学历要求", @"Education requirements"), MYLocalizedString(@"工作经验", @"Work experience"), nil];
        case 1:
            return [NSArray arrayWithObjects:MYLocalizedString(@"应聘职位", @"Apply for position"),MYLocalizedString(@"简历备注", @"Resume notes"), MYLocalizedString(@"工作经验", @"Work experience"), nil];
        case 2:
            return [NSArray arrayWithObjects:MYLocalizedString(@"薪资待遇", @"Salary"),MYLocalizedString(@"学历要求", @"Education requirements"), MYLocalizedString(@"工作经验", @"Work experience"), nil];
        default:
            break;
    }
    return nil;
}
- (NSArray*) getMenuContent:(int) index{
    switch (type) {
        case 0:{
            NSString *req;
            switch (index) {
                case 0:
                    req = @"QS_current";
                    break;
                case 1:
                    req = @"QS_education";
                    break;
                    
                default:
                    req = @"QS_experience";
                    break;
            }
            return [[[ITF_Company alloc] init] classify:req andParentid:0];
        }
            break;
        case 1:{
            if (index < 2){
                return [[[ITF_Company alloc] init] auditJobByUser:[InitData getUser] andActtype:index];
            }
            return [[[ITF_Company alloc] init] classify:@"QS_experience" andParentid:0];
        }
            break;
        case 2:{
            NSString *req;
            switch (index) {
                case 0:
                    req = @"QS_wage";
                    break;
                case 1:
                    req = @"QS_education";
                    break;
                    
                default:
                    req = @"QS_experience";
                    break;
            }
            return [[[ITF_Company alloc] init] classify:req andParentid:0];
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (NSArray*) getDataSource{
    switch (type) {
        case 0:{
            NSArray *res = [[[ITF_Other alloc] init] searchResumeByStart:start andRow:PageCount andJobs:jobs andDistrict:district andExperience:experienceid andEducation:educationid andKey:key andCurrent:current];
            last = res.count != PageCount;
            start += res.count;
            return res;
        }
            break;
        case 1:{

            NSArray *res = [[[ITF_Company alloc] init] allJobsApplyByUser:[InitData getUser] andStart:start andRow:PageCount andJid:jid andRemarkid:remarkid andExperience:experienceid];
            last = res.count != PageCount;
            start += res.count;
            return res;
        }
            break;
        case 2:{
            NSArray *res =[[[ITF_Other alloc] init] searchJobByStart:start andRow:PageCount andJobs:jobs andDistrict:district andTrade:trade andSettr:[publishTime intValue] andWage:wage andExperience:experienceid andEducation:educationid andKey:key];
            last = res.count != PageCount;
            start += res.count;
            return res;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark delegate
- (void) get1AddReq:(int) index{
    T_category *cat = reqArr[index];
    switch (selected.tag) {
        case 0:
            start = 0;
            jid =cat.c_id;
            break;
        case 1:
            start = 0;
            remarkid = cat.c_id;
            break;
        default:
            start = 0;
            experienceid = cat.c_id;
            break;
    }
}
- (void) get0AddReq:(int) index{
    T_category *cat = reqArr[index];
    switch (selected.tag) {
        case 0:
            start = 0;
            current =cat.c_id;
            break;
        case 1:
            start = 0;
            educationid = cat.c_id;
            break;
        default:
            start = 0;
            experienceid = cat.c_id;
            break;
    }
}

- (void) get2AddReq:(int) index{
    T_category *cat = reqArr[index];
    switch (selected.tag) {
        case 0:
            start = 0;
            wage = cat.c_id;
            break;
        case 1:
            start = 0;
            educationid = cat.c_id;
            break;
        default:
            start = 0;
            experienceid = cat.c_id;
            break;
    }
}

- (void) requirementThis:(int)index{
/*先根据选择的菜单哪一项，赋值, 在清空
 */
    switch (type) {
        case 0:
            [self get0AddReq:index];
            break;
        case 1:
            [self get1AddReq:index];
            break;
        case 2:
            [self get2AddReq:index];
            break;
            
        default:
            break;
    }
    if (selected != nil){
        T_category *cat = [reqArr objectAtIndex:index];
        
        //按钮名字换为选中项
        [selected setTitle:cat.c_name forState:UIControlStateNormal];
        selected.selected = NO;
        
        UIButton *img = [[selected.superview subviews] objectAtIndex:selected.tag * 3 + 2];
        img.selected = NO;
        selected = nil;
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        
        dataSource = [NSMutableArray arrayWithArray: [self getDataSource]];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [mainTableView reloadData];
            
            [self noData];
            
        });
    });

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
    return 81;
}

- (void) drawSearchResumeByCell:(CollectionTableViewCell*) cell andApplyJob:(T_ApplyJob*) data{
    NSString *title = [NSString stringWithFormat:@"%@ (%@ %@ %@)", data.fullname, data.demo, data.education_cn, data.experience_cn];
    [cell setTitle:title];
            
    NSString *message = [NSString stringWithFormat:MYLocalizedString(@"应聘:%@", @"Apply for:%@"), data.intention_jobs];
    [cell setMessage:message];
    [cell setValue:data.apply_addtime];
}
- (void) drawSearchJobByCell:(CollectionTableViewCell*) cell andApplyJob:(T_ApplyJob*) data{

    [cell setTitle:data.jobs_name];
    
    //NSString *message = [NSString stringWithFormat:@"应聘:%@", data.intention_jobs];
    [cell setMessage:data.companyname];
    [cell setTime:data.apply_addtime];
    [cell setValue:data.demo];
}
- (void) drawYingpinResumeByCell:(CollectionTableViewCell*) cell andApplyJob:(T_ApplyJob*) data{
    NSString *title = [NSString stringWithFormat:@"%@ (%@ %@岁 %@ %@)", data.fullname, data.sex_cn, data.birthdate, data.education_cn, data.experience_cn];
    [cell setTitle:title];
    
    NSString *message = [NSString stringWithFormat:MYLocalizedString(@"应聘:%@", @"Apply for:%@"), data.intention_jobs];
    [cell setMessage:message];
    [cell setValue:data.replay_status];
    [cell setTime:data.apply_addtime];
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString * tableSampleIdentifier = @"tableSampleIdentifier";
    CollectionTableViewCell *cell = (CollectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionTableViewCell alloc] init];
    }
    cell.tag = 2000 + [indexPath row];
    switch (type) {
        case 0:
            [self drawSearchResumeByCell:cell andApplyJob:[dataSource objectAtIndex:indexPath.row]];
            break;
            
        case 1:
            [self drawYingpinResumeByCell:cell andApplyJob:[dataSource objectAtIndex:indexPath.row]];
            break;
        case 2:
            [self drawSearchJobByCell:cell andApplyJob:[dataSource objectAtIndex:indexPath.row]];
            break;
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (type) {
        case 0:{
            T_ApplyJob *job = [dataSource objectAtIndex:indexPath.row];
            Preview2ViewController *preview = [[Preview2ViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:preview];
            [preview setTitle:job.fullname];
            [preview setPid:job.resume_id];
        }
            
            break;
            
        case 1:{
            T_ApplyJob *job = [dataSource objectAtIndex:indexPath.row];
            Preview2ViewController *preview = [[Preview2ViewController alloc] init];
            if (job.jobs_id > 0)
                [preview setJid:job.jobs_id];
            [self.myNavigationController pushAndDisplayViewController:preview];
            [preview setTitle:job.fullname];
            [preview setPid:job.resume_id];
        }
            break;
        case 2:{
            T_ApplyJob*job = [dataSource objectAtIndex:indexPath.row];
            JobDetailViewController *detail = [[JobDetailViewController alloc] init];
            [detail setJid:job.jobs_id];
            [self.myNavigationController pushAndDisplayViewController:detail];
        }
            break;
    }
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
        mainTableView.tableFooterView = nil;
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
        NSArray * tarray = [self getDataSource];
        [dataSource addObjectsFromArray:tarray];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [mainTableView reloadData];
            [self loadDataEnd];

        });
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
