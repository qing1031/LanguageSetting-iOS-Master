//
//  RecruitmentViewController.m
//  74cms
//
//  Created by lyp on 15/5/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "RecruitmentViewController.h"
#import "InitData.h"
#import "CollectionTableViewCell.h"
#import "RecruitmentDetailViewController.h"
#import "UIScrollView+KS.h"
#import "ITF_Other.h"
#import "T_Jobfair.h"

#define pageCount 8

@interface RecruitmentViewController ()<UITableViewDataSource, UITableViewDelegate, KSRefreshViewDelegate>{
    NSMutableArray *dataSource;
    
    UITableView *mainTableView;
    
    BOOL last;
    
    int sttr;//时间范围
}

@end

@implementation RecruitmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    sttr = 60;
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle: MYLocalizedString(@"招聘会",@"job fair")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(subMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"screen.png"] forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    [but setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    but.selected = NO;
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}

- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [mainTableView setBackgroundColor:[UIColor whiteColor]];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    [self.view addSubview:mainTableView];
    
    
    mainTableView.frame          = CGRectMake(0, 0, KS_SCREEN_WIDTH, KS_SCREEN_HEIGHT);
    mainTableView.header         = [[KSDefaultHeadRefreshView alloc] initWithDelegate:self]; //下拉刷新
    mainTableView.footer         = [[KSDefaultFootRefreshView alloc] initWithDelegate:self]; //上拉刷新
    
    mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据
}

- (void) noData{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 138) / 2, ([InitData Height] - 93) / 2, 138, 93)];
    [imgView setImage:[UIImage imageNamed:@"nodata.png"]];
    [self.view addSubview:imgView];
}
#pragma mark delegate
- (void)addData
{
    if (dataSource == nil)
        dataSource = [[NSMutableArray alloc] init];
    
    int start = (dataSource == nil || dataSource.count ==0 )?0:dataSource.count ;
    NSArray *tarray = [[[ITF_Other alloc] init] jobfairByStart:start andRow:pageCount andSettr:sttr];
    
    [dataSource addObjectsFromArray:tarray];
    
  //  [mainTableView reloadData];
    last = tarray.count == pageCount;
}

- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:mainTableView.header]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            [dataSource removeAllObjects];
            [self addData];
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //把暂无数据去掉
                if ([[self.view subviews] count] > 1){
                    UIView *label = [[self.view subviews] objectAtIndex:1];
                    [label removeFromSuperview];
                }
                
                if (dataSource == nil || [dataSource count] == 0){
                    // [mainTableView removeFromSuperview];
                    //  mainTableView = nil;
                    
                    [self noData];
                    // return ;
                }
                
                else if (mainTableView.footer) {
                    mainTableView.footer.isLastPage = !last;
                }
                
                [mainTableView reloadData];
                [mainTableView.header setState:RefreshViewStateDefault];

            });
        });
        
    /*    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [dataSource removeAllObjects];
            [self addData];
            
            //把暂无数据去掉
            if ([[self.view subviews] count] > 1){
                UIView *label = [[self.view subviews] objectAtIndex:1];
                [label removeFromSuperview];
            }
            
            if (dataSource == nil || [dataSource count] == 0){
               // [mainTableView removeFromSuperview];
              //  mainTableView = nil;
                
                UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [InitData Width] - 40, 50)];
                label.text = @"暂无数据！";
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
                [self.view addSubview:label];
               // return ;
            }
            
            else if (mainTableView.footer) {
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
      //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!last) {
                
                [mainTableView.footer setIsLastPage:YES];
               // [mainTableView reloadData];
            } else {
                [self addData];
                
                
                [mainTableView reloadData];
                [mainTableView.header setState:RefreshViewStateDefault];
                
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
    return 81;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  static NSString *idf = @"tableViewIdentifier";
    CollectionTableViewCell *cell = (CollectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionTableViewCell alloc] init];
    }
  //  if (indexPath.row < [dataSource count]){
        T_Jobfair *fair = [dataSource objectAtIndex:indexPath.row];
    
        [cell setTitle:fair.title];
        [cell setMessage:fair.address];
        [cell setTime:fair.holddate_start];
  //  }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecruitmentDetailViewController *detail = [[RecruitmentDetailViewController alloc] init];
    T_Jobfair *job = [dataSource objectAtIndex:indexPath.row];
    [detail setRID:job.ID];
    [self.myNavigationController pushAndDisplayViewController:detail];
    
    //点击松开后恢复白色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark event
- (void) drawSubMenu{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    view.tag = 999;
    [self.view addSubview:view];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distorySubMenu)];
    recognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:recognizer];
    
    UIView *subMenu = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 160, 0, 160, self.view.frame.size.height)];
    [subMenu setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:subMenu];
    
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"时间范围", @"Time frame"), MYLocalizedString(@"今天", @"Today"), MYLocalizedString(@"近三天", @"In 3 days"), MYLocalizedString(@"近两周", @"In 2 weeks"), MYLocalizedString(@"近一月", @"In one month"), MYLocalizedString(@"近两月", @"In 2 months"), MYLocalizedString(@"已举行", @"Expired"), nil];
    float height = 0;
    for (int i=0; i<[arr count]; i++){
        UIView *viewt = [[UIView alloc] initWithFrame:CGRectMake(0, height, 160, 45)];
        [viewt setBackgroundColor:[UIColor whiteColor]];
        [subMenu addSubview:viewt];
        viewt.tag = i + 1;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [viewt addGestureRecognizer:recognizer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 130, 15)];
        label.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        if (i == 16){
            label.font = [UIFont systemFontOfSize:16];
        }
        label.text = [arr objectAtIndex:i];
        [viewt addSubview:label];
        
        float x = i==[arr count] - 1?0:15;
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(x, 44, 160, 1)];
        [sep setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
        [viewt addSubview:sep];
        height += 45;
    }
}
- (void) subMenuClicked:(UIButton*) but{
    if (but.selected == NO){
        [self drawSubMenu];
    }
    else{
        UIView *view;
        for (int i=0; i<[[self.view subviews] count]; i++){
            view =[[self.view subviews] objectAtIndex:i];
            if (view.tag == 999){
                [InitData distory:view];
                break;
            }
        }
    }
    but.selected = !but.selected;
}

- (void) distorySubMenu{
    long t = [[self.view subviews] count];
    UIView *view = [[self.view subviews] objectAtIndex:t - 1];
    if (view.tag == 999){
        [InitData distory:view];
    }
    
    NSArray *arr = [self.myNavigationController getRightBtn];
    if ([arr count] > 0){
        UIButton *but = [arr objectAtIndex:[arr count] - 1];
        but.selected = !but.selected;
    }
}
- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    long index = recognizer.view.tag - 2;
    if (index <  0)
        return;
    NSArray *tarray = [NSArray arrayWithObjects:@"1", @"3", @"14", @"30", @"60", @"0", nil];
    sttr = [[tarray objectAtIndex:index] intValue];
    
    dataSource = nil;
    [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据
    
    NSArray *right = [self.myNavigationController getRightBtn];
    if (right != nil && right.count > 0){
        [self subMenuClicked:[right objectAtIndex:0]];
    }
}

@end
