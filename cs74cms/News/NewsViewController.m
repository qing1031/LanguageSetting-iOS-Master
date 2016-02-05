//
//  NewsViewController.m
//  74cms
//
//  Created by lyp on 15/5/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "NewsViewController.h"
#import "InitData.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"
#import "UIScrollView+KS.h"
#import "ITF_Other.h"
#import "ITF_Company.h"
#import "T_category.h"

#define pageCount 10

@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate, KSRefreshViewDelegate>{
    UITableView *mainTableView;
    NSMutableArray *dataSource;
    NSMutableArray *subMenuArray;
    
    BOOL last;
    
    int sttr;//时间范围
    int type_id;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle: MYLocalizedString(@"新闻资讯", @"News")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(subMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"side_menu.png"] forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 20, 20)];
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
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
 //   [mainTableView setBackgroundColor:[UIColor whiteColor]];
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
    NSArray *tarray = [[[ITF_Other alloc] init] newsByStart:start andRow:pageCount andType_id:type_id];
    
    [dataSource addObjectsFromArray:tarray];
    
    //[mainTableView reloadData];
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
        
     /*   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
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
#pragma mark delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataSource != nil && [dataSource count] > 0){
        return [dataSource count];
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString *idf = @"tableCellIdentifier";

    NewsTableViewCell *cell = (NewsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[NewsTableViewCell alloc] init];
    }
    cell.tag = 2000 + [indexPath row];
    T_News *news = [dataSource objectAtIndex:indexPath.row];
    [cell setType:news.type andTitle:news.title andMessage:news.content andImg:news.small_img];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    T_News *data = [dataSource objectAtIndex:indexPath.row];
    NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
    [news setNewsID:data.ID];
    [self.myNavigationController pushAndDisplayViewController:news];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark submenu
- (void) drawSubMenu{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    view.tag = 999;
    [self.view addSubview:view];
    [view setShowsHorizontalScrollIndicator:NO];
    [view setShowsVerticalScrollIndicator:NO];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distorySubMenu)];
    recognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:recognizer];
    
    UIView *subMenu = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 160, 0, 160, self.view.frame.size.height)];
    [subMenu setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:subMenu];
    
    if (subMenuArray == nil)
        subMenuArray = [[[ITF_Company alloc] init] classify:@"news" andParentid:1];
    float height = 0;
    for (int i=0; i<= [subMenuArray count]; i++){
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
        [viewt addSubview:label];
        if (i == 0){
            label.text = MYLocalizedString(@"新闻分类", @"News classification");
            label.font = [UIFont systemFontOfSize:18];
            label.adjustsFontSizeToFitWidth = YES;
        }
        else{
            T_category *cat = [subMenuArray objectAtIndex:i - 1];
            label.text = cat.c_name;
        }
        
        
        float x = i==[subMenuArray count]?0:15;
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(x, 44, 160, 1)];
        [sep setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
        [viewt addSubview:sep];
        height += 45;
    }
    [view setContentSize:CGSizeMake(view.frame.size.height, height)];
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
    
    if (index < 0)
        return;
    
    T_category *cat = [subMenuArray objectAtIndex:index];
    type_id = cat.c_id;
    
    dataSource = nil;
    [mainTableView.header setState:RefreshViewStateLoading];//先加载一次数据
    
    NSArray *right = [self.myNavigationController getRightBtn];
    if (right != nil && right.count > 0){
        [self subMenuClicked:[right objectAtIndex:0]];
    }
}

@end
