//
//  DistrictCenterViewController.m
//  74cms
//
//  Created by lyp on 15/5/1.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "DistrictCenterViewController.h"
#import "InitData.h"
#import "CollectionTableViewCell.h"
#import "MicroResumeViewController.h"
#import "MicroZhaoPinViewController.h"
#import "PublicResumeViewController.h"
#import "T_Simple.h"
#import "ITF_Other.h"
#import "PublicResumeViewController.h"
#import "PublicJobViewController.h"


#define pageCount 10

@interface DistrictCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UIButton *zhaopin;
    UIButton *resume;
    
    UITextField *textField;
    UIButton *fabu;
    UITableView *mainTableView;
    
    int selected;
    
    NSMutableArray *dataSource;
    
    BOOL _loadingMore;
    BOOL last;
}

@end

@implementation DistrictCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    [self topView];
    [self next];
    [self content];
    [self buttom];
    [self.myNavigationController setTitle:MYLocalizedString(@"微商圈", @"Micro CV&job")];
    [self.myNavigationController setRightBtn:nil];
}

- (void) topView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, [InitData Width] + 2, 37)];
    topView.layer.borderColor = [UIColor colorWithRed:206./255 green:206./255 blue:206./255 alpha:1].CGColor;
    topView.layer.borderWidth = 1;
    [self.view addSubview:topView];
    
    zhaopin = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhaopin setFrame:CGRectMake(1, 0, [InitData Width] / 2, 37)];
    zhaopin.tag = 1;
    zhaopin.selected = YES;
    selected = 1;
    [zhaopin setTitle:MYLocalizedString(@"微招聘", @"Micro recruitment") forState:UIControlStateNormal];
    [zhaopin setTitleColor:[UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1] forState:UIControlStateNormal];
    [zhaopin setTitleColor:[UIColor colorWithRed:234./255 green:103./255 blue:33./255 alpha:1] forState:UIControlStateSelected];
    [zhaopin addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:zhaopin];
    
    resume = [UIButton buttonWithType:UIButtonTypeCustom];
    [resume setFrame:CGRectMake([InitData Width] / 2, 0, [InitData Width] / 2, 37)];
    resume.tag = 2;
    [resume setTitle:MYLocalizedString(@"微简历", @"Micro resume") forState:UIControlStateNormal];
    [resume setTitleColor:[UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1] forState:UIControlStateNormal];
    [resume setTitleColor:[UIColor colorWithRed:234./255 green:103./255 blue:33./255 alpha:1] forState:UIControlStateSelected];
    [resume addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:resume];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] / 2 + 1, 0, 1, 37)];
    [view setBackgroundColor:[UIColor colorWithRed:206./255 green:206./255 blue:206./255 alpha:1]];
    [topView addSubview:view];
}

- (void) next{
    UIView *searchView = [[UIView alloc] init];
    [searchView setFrame:CGRectMake(0, 36, [InitData Width], 40)];
    [searchView setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    [self.view addSubview:searchView];
    UIView * searchBox = [[UIView alloc] init];
    searchBox.layer.cornerRadius = 8;
    searchBox.layer.borderWidth = 2;
    searchBox.layer.borderColor = [[UIColor colorWithRed:233.0 / 255 green:233.0 / 255 blue:233.0 / 255 alpha:0] CGColor];
    [searchBox setFrame:CGRectMake(15, 7, [InitData Width] - 80, 26)];
    [searchBox setBackgroundColor:[UIColor whiteColor]];
    
    [searchView addSubview:searchBox];
    UIImageView *img = [[UIImageView alloc] init];
    [img setFrame:CGRectMake(2, 2, 22, 22)];
    [img setImage:[UIImage imageNamed:@"searchBut.jpg"]];
    [searchBox addSubview:img];
    UIView *seperate = [[UIView alloc] init];
    [seperate setFrame:CGRectMake(26, 2, 1, 22)];
    [seperate setBackgroundColor:[UIColor colorWithRed:226.0 / 255 green:226.0 / 255 blue:226.0 / 255 alpha:1]];
    [searchBox addSubview:seperate];
    
    textField  = [[UITextField alloc] initWithFrame:CGRectMake(30, 2, [InitData Width] - 130, 22)];
    textField.tag = 1000;
    textField.placeholder = MYLocalizedString(@"请输入关键字...", @"Please type in key words");
    textField.delegate = self;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:13];
    [searchBox addSubview:textField];
    
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setFrame:CGRectMake([InitData Width] - 60, 8, 55, 25)];
    [searchBut setTitleColor:[UIColor colorWithRed:55./255 green:117./255 blue:172./255 alpha:1] forState:UIControlStateNormal];
    [searchBut setTitle:MYLocalizedString(@"搜索", @"Search") forState:UIControlStateNormal];
    searchBut.titleLabel.adjustsFontSizeToFitWidth = YES;
    [searchBut addTarget:self action:@selector(searchButClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBut];
}
- (void) content{
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        dataSource = [[[ITF_Other alloc] init] simpleZhaoPinByStart:0 andRow:pageCount andKey:textField.text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (mainTableView == nil){
                mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 76, [InitData Width], [InitData Height] - 126)];
                mainTableView.delegate = self;
                mainTableView.dataSource = self;
                mainTableView.separatorStyle = NO;
                [self.view addSubview:mainTableView];
            }
        });
    });
}
- (void) buttom{
    fabu = [UIButton buttonWithType:UIButtonTypeCustom];
    [fabu setFrame:CGRectMake(-1, [InitData Height] - 50, [InitData Width] + 2, 51)];
    [fabu setTitle:MYLocalizedString(@"发布微招聘", @"Release micro recruit") forState:UIControlStateNormal];
    [fabu setTitleColor:[UIColor colorWithRed:234./255 green:103./255 blue:33./255 alpha:1] forState:UIControlStateNormal];
    [fabu addTarget:self action:@selector(fabuButClicked:) forControlEvents:UIControlEventTouchUpInside];
    fabu.layer.borderColor = [UIColor colorWithRed:191./255 green:191./255 blue:191./255 alpha:1].CGColor;
    fabu.layer.borderWidth = 1;
    fabu.tag = 3;
    [self.view addSubview:fabu];
}
#pragma mark event
- (void) fabuButClicked:(UIButton*) but{
    if (but.tag == 3){
        [self.myNavigationController pushAndDisplayViewController:[[PublicJobViewController alloc] init]];
    }
    else{
        [self.myNavigationController pushAndDisplayViewController:[[PublicResumeViewController alloc] init]];
    }
}
- (void) reloadData{
    
    /*************************得到新数据*************************/
    //不可从主线程取值
    [InitData isLoading:self.view];
    dataSource = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSMutableArray * tarray = [self getDataSource];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (tarray != nil){
                dataSource = tarray;
            }
            [mainTableView reloadData];
        });
    });
}
- (void) selected:(UIButton*) but{
    if (selected == but.tag){
        return;
    }
    but.selected = YES;
    selected = (int)but.tag;
    
    if (but == resume){
        zhaopin.selected = NO;
        [fabu setTitle:MYLocalizedString(@"发布微简历", @"Release micro resume") forState:UIControlStateNormal];
        fabu.tag = 4;

    }
    else{
        resume.selected = NO;
        [fabu setTitle:MYLocalizedString(@"发布微招聘", @"Release micro recruit") forState:UIControlStateNormal];
        fabu.tag = 3;
    }
    [self reloadData];

}

- (void) searchButClick{

    [self reloadData];
}
- (BOOL) textFieldShouldReturn:(UITextField *)ttextField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
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
   
    CollectionTableViewCell *cell = (CollectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CollectionTableViewCell alloc] init];
    }
    cell.tag = 2000 + [indexPath row];
    T_Simple *data = [dataSource objectAtIndex:indexPath.row];
    if (zhaopin.selected){
        [cell setTitle:data.jobname];
        [cell setMessage:data.comname];
        [cell setValue:data.sdistrict_cn];
        [cell setTime:data.refreshtime];
    }
    else{
        NSString *str = [NSString stringWithFormat:MYLocalizedString(@"%@ (%@ %d岁 %@)", @"%@ (%@ %d age %@)"), data.uname, data.sex_cn, data.age, data.experience_cn];
        [cell setTitle:str];
        [cell setMessage:data.category];
        [cell setValue:data.sdistrict_cn];
        [cell setTime:data.refreshtime];
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    T_Simple *simple = [dataSource objectAtIndex:indexPath.row];
    if (resume.selected == YES){
        MicroResumeViewController *resumeCon = [[MicroResumeViewController alloc] init];
        [resumeCon setMID:simple.ID];
        [self.myNavigationController pushAndDisplayViewController:resumeCon];
    }
    else{
        MicroZhaoPinViewController *zhaopinv = [[MicroZhaoPinViewController alloc] init];
        [zhaopinv setMID:simple.ID];
        [self.myNavigationController pushAndDisplayViewController:zhaopinv];
    }
}

- (NSMutableArray*) getDataSource{
    int start = dataSource == nil?0:[dataSource count];
    if (zhaopin.selected){
        NSMutableArray * tarray =[[[ITF_Other alloc] init] simpleZhaoPinByStart:start andRow:pageCount andKey:textField.text];
        last = tarray.count != pageCount;
        return tarray;
    }else{
        NSMutableArray *tarray =[[[ITF_Other alloc] init] SimpleResumeByStart:start andRow:pageCount andKey:textField.text];
        last = tarray.count != pageCount;
        return tarray;
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
