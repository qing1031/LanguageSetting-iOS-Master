//
//  rootViewController.m
//  74cms
//
//  Created by LPY on 15-4-8.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "RootViewController.h"
#import "GuideViewController.h"
#import "InitData.h"
#import "BMAdScrollView.h"
#import "MainFunctionDiv.h"
#import "LanguageSettingViewController.h"
#import "UserCenterViewController.h"
#import "MoreCenterViewController.h"
#import "SearchResumeViewController.h"
#import "SearchViewController.h"
#import "DistrictCenterViewController.h"
#import "NewsViewController.h"
#import "RecruitmentViewController.h"
#import "LoginViewController.h"
#import "ITF_Apply.h"

@interface RootViewController ()<MainFunctionDivDelegate, UITextFieldDelegate, ValueClickDelegate>{
    
    BMAdScrollView *topView;
    UITextField *textField;
    
    NSMutableArray *imgArray;
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview: bgControl];
    [bgControl addTarget:self action:@selector(spaceClicked:) forControlEvents:UIControlEventTouchUpInside];
    
 
    //不可从主线程取值
  //  [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        imgArray = [[[ITF_Apply alloc] init] getIndexfocus];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
          //  [InitData haveLoaded:self.view];
            CGSize size =[InitData calculateImageSize:CGSizeMake([InitData Width], [InitData Height]) imageSize:CGSizeMake(640, 270) priorDirection:X];
            
            if (imgArray != nil && [imgArray count] > 0){
                //设置主要内容
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                NSMutableArray *strArr = [[NSMutableArray alloc]init];
                for (int i=0; i<[imgArray count]; i++){
                    T_Ads *ads = [imgArray objectAtIndex:i];
                    [arr addObject:ads.img_path];
                    [strArr addObject:@""];
                }
            
                topView = [[BMAdScrollView alloc] initWithNameArr:arr titleArr:strArr height:size.height offsetY:0];
                topView.pageCenter = CGPointMake([InitData Width] / 2, size.height - 10);
                topView.vDelegate = self;
                [topView setBackgroundColor:[UIColor whiteColor]];
            
                [self.view addSubview:topView];
            }
            //[self drawView:size];
        });
    });
    CGSize size =[InitData calculateImageSize:CGSizeMake([InitData Width], [InitData Height]) imageSize:CGSizeMake(640, 270) priorDirection:X];
    [self drawView:size];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //初始化数据
    [[InitData alloc] initData];

    CGSize size =[InitData calculateImageSize:CGSizeMake([InitData Width], [InitData Height]) imageSize:CGSizeMake(640, 270) priorDirection:X];
    [self drawView:size];
}

- (void) drawView:(CGSize) size{
    //
    UIView *searchView = [[UIView alloc] init];
    [searchView setFrame:CGRectMake(0, size.height, [InitData Width], 40)];
    //[searchView setBackgroundColor:[UIColor grayColor]];
    [searchView setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    [self.view addSubview:searchView];
    UIView * searchBox = [[UIView alloc] init];
    searchBox.layer.cornerRadius = 8;
    searchBox.layer.borderWidth = 2;
    searchBox.layer.borderColor = [[UIColor colorWithRed:233.0 / 255 green:233.0 / 255 blue:233.0 / 255 alpha:0] CGColor];
    [searchBox setFrame:CGRectMake(15, 7, [InitData Width] - 30, 26)];
    [searchBox setBackgroundColor:[UIColor whiteColor]];
    
    [searchView addSubview:searchBox];
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setFrame:CGRectMake(2, 2, 22, 22)];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"searchBut.jpg"] forState:UIControlStateNormal];
    [searchBut addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchBox addSubview:searchBut];
    UIView *seperate = [[UIView alloc] init];
    [seperate setFrame:CGRectMake(26, 2, 1, 22)];
    [seperate setBackgroundColor:[UIColor colorWithRed:226.0 / 255 green:226.0 / 255 blue:226.0 / 255 alpha:1]];
    [searchBox addSubview:seperate];
    
    textField  = [[UITextField alloc] initWithFrame:CGRectMake(30, 2, [InitData Width] - 80, 22)];
    textField.tag = 1000;
    textField.placeholder = MYLocalizedString(@"请输入关键字...", @"please type in key words");
    textField.delegate = self;
    //[textField setBackgroundColor:[UIColor redColor]];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:textField.frame.size.height / 2];
    [searchBox addSubview:textField];
    
    float cellHeight = ([InitData Height] - size.height - 40 ) / 3;
    MainFunctionDiv *search = [[MainFunctionDiv alloc] initWithFrame:CGRectMake(0, size.height + 40, [InitData Width] / 2, cellHeight)];
    search.tag = 1001;
    search.delegate = self;
    [search setImage:@"search.jpg" andTitle:MYLocalizedString(@"职位搜索", @"Job search") ];
    [self.view addSubview:search];
    
    MainFunctionDiv *search2 = [[MainFunctionDiv alloc] initWithFrame:CGRectMake([InitData Width] / 2 , size.height + 40, [InitData Width] / 2, cellHeight)];
    search2.tag = 1002;
    search2.delegate = self;
    [search2 setImage:@"search2.jpg" andTitle:MYLocalizedString(@"搜索简历", @"Search resume")];
    [self.view addSubview:search2];
    
    MainFunctionDiv *zhaopinhui = [[MainFunctionDiv alloc] initWithFrame:CGRectMake(0, size.height + 40 + cellHeight , [InitData Width] / 4, cellHeight)];
    zhaopinhui.tag = 1003;
    zhaopinhui.delegate = self;
    [zhaopinhui setImage:@"zhaopinhui.jpg" andTitle:MYLocalizedString(@"招聘会", @"Recruitment meeting")];
    [self.view addSubview:zhaopinhui];
    
    MainFunctionDiv *weishangquan = [[MainFunctionDiv alloc] initWithFrame:CGRectMake([InitData Width] * 3 / 4, size.height + 40 + cellHeight, [InitData Width] / 4 + 10, cellHeight)];
    weishangquan.tag = 1004;
    weishangquan.delegate = self;
    [weishangquan setImage:@"weishangquan.jpg" andTitle:MYLocalizedString(@"微商圈", @"micro resume&project") ];
    weishangquan.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:weishangquan];
    
    MainFunctionDiv *xinwenzixun = [[MainFunctionDiv alloc] initWithFrame:CGRectMake(0, size.height + 40 + cellHeight * 2, [InitData Width] / 2, cellHeight)];
    xinwenzixun.tag = 1005;
    xinwenzixun.delegate = self;
    [xinwenzixun setImage:@"xinwenzixun.jpg" andTitle:MYLocalizedString(@"新闻资讯", @"News") ];
    [self.view addSubview:xinwenzixun];
    
    MainFunctionDiv *more = [[MainFunctionDiv alloc] initWithFrame:CGRectMake([InitData Width] / 2 , size.height + 40 + cellHeight * 2, [InitData Width] / 2, cellHeight)];
    more.tag = 1006;
    more.delegate = self;
    [more setImage:@"more.jpg" andTitle:MYLocalizedString(@"更多", @"More")];
    [self.view addSubview:more];
    
    MainFunctionDiv *huiyuanzhongxin = [[MainFunctionDiv alloc] initWithFrame:CGRectMake([InitData Width] / 4, size.height + 40 + cellHeight *0.8, [InitData Width] / 2, cellHeight * 1.2)];
    huiyuanzhongxin.tag = 1007;
    huiyuanzhongxin.delegate = self;
    [huiyuanzhongxin setImage:@"huiyuanzhongxin.jpg" andTitle:MYLocalizedString(@"会员中心", @"Membership Center")];
    
    [self.view addSubview:huiyuanzhongxin];
}

- (void) viewCanBeSee{
    //设置导航条
    [self.myNavigationController setTitle:MYLocalizedString(@"首页", @"Hompage")];
    [self.myNavigationController setNavigationBarColor:[InitData getSkinColor]];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(langMenuClicked:selectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"language_menu.png"] forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 20, 20)];
    but.selected = NO;
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}

- (void) langMenuClicked:(UIButton*) but selectedIndex:(NSInteger) index{
//    [self.myNavigationController pushAndDisplayViewController:[[LanguageSettingViewController alloc] init]];
    [self.myNavigationController popAndPushViewController:[[LanguageSettingViewController alloc] init]];
}

#pragma mark - event
- (void) search{
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.myNavigationController pushAndDisplayViewController:search];
}

- (void) spaceClicked:(id) sender{
    [textField resignFirstResponder];
}

- (void) selectLanguage:(UITapGestureRecognizer*) recognizer{
    NSInteger index = recognizer.view.tag - 2;
    
    if (index < 0)
        return;
    
    NSArray *right = [self.myNavigationController getRightBtn];
    if (right != nil && right.count > 0){
        [self langMenuClicked:[right objectAtIndex:0] selectedIndex:index];
    }
}

- (void) selectThis:(int) tag{
    if (tag == 1001) {
        SearchResumeViewController *search = [[SearchResumeViewController alloc] init];
        [search setType:1];
        [self.myNavigationController pushAndDisplayViewController:search];
        return;
    }
    if (tag == 1002) {
        SearchResumeViewController *search = [[SearchResumeViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:search];
        return;
    }
    if (tag == 1003) {
        RecruitmentViewController *zhaopin = [[RecruitmentViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:zhaopin];
        return;
    }
    if (tag == 1004){
        DistrictCenterViewController *dis = [[DistrictCenterViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:dis];
        return;
    }
    if (tag == 1005){
        NewsViewController *dis = [[NewsViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:dis];
        return;
    }
    if (tag == 1006){
        MoreCenterViewController *more = [[MoreCenterViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:more];
        return;
    }
    
    if (tag == 1007){
       // UserCenterViewController *userCenter = [[UserCenterViewController alloc] init];
       // [self.myNavigationController pushAndDisplayViewController:userCenter];
     //   EditCompanyViewController * edit = [[EditCompanyViewController alloc] init];
       // [self.myNavigationController pushAndDisplayViewController:edit];
        LoginViewController *login =[[LoginViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:login];
        return;
    }
}


- (void) textFieldDidBeginEditing:(UITextField *)ttextField{
    [self search];
    [ttextField resignFirstResponder];
}
- (void) buttonClick:(int)vid{
    T_Ads * ads = [imgArray objectAtIndex:vid - 1];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ads.img_url]];
    
}

@end
