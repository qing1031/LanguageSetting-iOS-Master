//
//  MessageViewController.m
//  74cms
//
//  Created by LPY on 15-4-13.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "MessageViewController.h"
#import "InitData.h"
#import "MessageTableViewCell.h"
#import "T_Interface.h"
#import "T_Pms.h"
#import "UIScrollView+KS.h"
#import "MessageDetailViewController.h"

#define pageCount 8

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate
//, MessageTableViewCellDelegate
, KSRefreshViewDelegate>{
    UITableView *mainTableView;
    NSMutableArray *dataSource;
    float cellHeight;
    
    BOOL last;//为真 为还有数据
}

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) drawView{

    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    
    cellHeight = 84;
    
    float height = cellHeight * [dataSource count] > [InitData Height]? [InitData Height] : (cellHeight * [dataSource count]);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    //分割线顶到头
    mainTableView.separatorInset = UIEdgeInsetsZero;
    mainTableView.separatorStyle = NO;
    [self.view addSubview:mainTableView];
    
    
    mainTableView.frame          = CGRectMake(0, 0, KS_SCREEN_WIDTH, KS_SCREEN_HEIGHT);
    mainTableView.header         = [[KSDefaultHeadRefreshView alloc] initWithDelegate:self]; //下拉刷新
    mainTableView.footer         = [[KSDefaultFootRefreshView alloc] initWithDelegate:self]; //上拉刷新
    
    mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    else{
        dataSource = nil;
        [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"消息提醒", @"Message alert")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:MYLocalizedString(@"清空", @"Empty") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(cleanButClick) forControlEvents:UIControlEventTouchUpInside];
    NSArray *butArr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:butArr];
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning
{
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
    tarray = [[[T_Interface alloc] init] pmsByUsername:user.username andUserpwd:user.userpwd andStart:start andRow:pageCount andPMid:0];
    [dataSource addObjectsFromArray:tarray];
    
    //[mainTableView reloadData];
    last = tarray.count == pageCount;
}

#pragma mark event
- (void) cleanButClick{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        BOOL res = YES;
        for (int i=[dataSource count] - 1; i>= 0; i--){
            T_Pms *pms = [dataSource objectAtIndex:i];
            NSMutableArray * tarray = [[[T_Interface alloc] init] pmsByUsername:user.username andUserpwd:user.userpwd andStart:0 andRow:0 andPMid:pms.pmid];
            if (tarray == nil)
                res = NO;
            [dataSource removeObjectAtIndex:i];
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (res){
                [self noMessage];
            }
        });
    });
}

#pragma mark - delegate
- (void) noMessage{
    if (dataSource == nil || [dataSource count] == 0){
        [mainTableView removeFromSuperview];
    mainTableView = nil;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] / 7 * 2, ([InitData Height] - [InitData Width] * 3 / 7 * 70 / 61) / 2, [InitData Width] * 3 / 7, [InitData Width] * 3 / 7 * 70 / 61)];
    [imgView setImage:[UIImage imageNamed:@"noMessage.png"]];
    [self.view addSubview:imgView];
    }
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
                if (dataSource == nil || [dataSource count] == 0){
                    [self noMessage];
                    
                    return ;
                }
                
                if (mainTableView.footer) {
                    mainTableView.footer.isLastPage = !last;
                }
                
                [mainTableView reloadData];
                [mainTableView.header setState:RefreshViewStateDefault];
            });
        });
      /*  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [dataSource removeAllObjects];
            [self addData];
            
            if (dataSource == nil || [dataSource count] == 0){
                [mainTableView removeFromSuperview];
                mainTableView = nil;
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] / 7 * 2, ([InitData Height] - [InitData Width] * 3 / 7 * 70 / 61) / 2, [InitData Width] * 3 / 7, [InitData Width] * 3 / 7 * 70 / 61)];
                [imgView setImage:[UIImage imageNamed:@"noMessage.png"]];
                [self.view addSubview:imgView];
                
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
    return [dataSource count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageTableViewCell *cell = (MessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[MessageTableViewCell alloc] init];
    }
    //cell.delegate = self;
    cell.tag = 2000 + [indexPath row];
    T_Pms *pms = [dataSource objectAtIndex:indexPath.row];
    [cell setTitle:MYLocalizedString(@"系统消息", @"System message")];
    [cell setMessage:pms.message];
   // [cell setState:@"已查看"];
    [cell setTime:pms.dateline];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    MessageDetailViewController *detail = [[MessageDetailViewController alloc] init];

    [self.myNavigationController pushAndDisplayViewController:detail];
    [detail setMessageId:((T_Pms*)[dataSource objectAtIndex:indexPath.row]).pmid];
    
    [mainTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
