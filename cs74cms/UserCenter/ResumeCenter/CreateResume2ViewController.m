//
//  CreateResume2ViewController.m
//  74cms
//
//  Created by LPY on 15-4-15.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "CreateResume2ViewController.h"
#import "InitData.h"
#import "ChangeResumeViewController.h"
#import "T_Interface.h"
#import "EduViewController.h"
#import "ChoiceIndustryViewController.h"

@interface CreateResume2ViewController ()<EduDelegate, MutableChoiceDelegate>{
    UIView *mainContent;
    
    T_Resume *resume;
    
    UIView* selected;
    
    NSMutableArray *subMenuArr;//存储子菜单的选择内容
    
    NSMutableArray * array;//存储子菜单的列表
    
    NSArray *arr2;//提示语句
    
    UIButton *nextBut;
}

@end

@implementation CreateResume2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) drawTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 30)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    
    float width = 56 + 14;
    float seperate = ([InitData Width] - width * 2 - 20) / 3;
    
    //
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 15, seperate - 2, 1)];
    [view1 setBackgroundColor:[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1]];
    [topView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10 + width + seperate, 15, seperate - 2, 1)];
    [view2 setBackgroundColor:[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1]];
    [topView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10 + width * 2 + seperate * 2, 15, seperate - 2, 1)];
    [view3 setBackgroundColor:[UIColor colorWithRed:241.0/255 green:133.0/255 blue:74.0/255 alpha:1]];
    [topView addSubview:view3];
    
    UILabel *number1 = [[UILabel alloc] initWithFrame:CGRectMake(seperate + 10, 8, 14, 14)];
    number1.layer.cornerRadius = 7;
    number1.layer.masksToBounds = YES;
    number1.textAlignment = NSTextAlignmentCenter;
    number1.text = @"1";
    number1.tag = 1001;
    number1.font = [UIFont systemFontOfSize:14];
    number1.backgroundColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    number1.textColor = [UIColor whiteColor];
    [topView addSubview:number1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(seperate + 24, 8, 14 * 4, 14)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.tag = 1002;
    label1.textColor = number1.backgroundColor;
    label1.text = MYLocalizedString(@"个人信息", @"Personal information");
    [topView addSubview:label1];
    
    UILabel *number2 = [[UILabel alloc] initWithFrame:CGRectMake(seperate * 2 + width + 10, 8, 14, 14)];
    number2.layer.cornerRadius = 7;
    number2.layer.masksToBounds = YES;
    number2.text = @"2";
    number2.textAlignment = NSTextAlignmentCenter;
    number2.tag = 2001;
    number2.font = [UIFont systemFontOfSize:14];
    number2.backgroundColor = [UIColor colorWithRed:241.0/255 green:133.0/255 blue:74.0/255 alpha:1];
    number2.textColor = [UIColor whiteColor];
    [topView addSubview:number2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(seperate * 2 + width + 24, 8, 14 * 4, 14)];
    label2.tag = 2002;
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = number2.backgroundColor;
    label2.text = MYLocalizedString(@"求职意向", @"Intentional position");
    [topView addSubview:label2];
}

- (void) drawMainContent{
    mainContent = [[UIView alloc] initWithFrame:CGRectMake(0, 30, [InitData Width], ([InitData Height] - 30 - 70) / 8 * 6)];
    [self.view addSubview:mainContent];
    
    subMenuArr = [[NSMutableArray alloc] init];
    
    float cellHeight = (mainContent.frame.size.height - 6) / 6;
    float height = 1;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"求职状态", @"Job status"), MYLocalizedString(@"工作类型", @"Job type"), MYLocalizedString(@"地    区", @"District"), MYLocalizedString(@"行    业", @"Industry"), MYLocalizedString(@"职    能", @"Function"), MYLocalizedString(@"期望薪水", @"Expected salary"), nil];
    arr2 = [[NSArray alloc] initWithObjects:MYLocalizedString(@"请选择状态", @"Please select job status"), MYLocalizedString(@"请选择工作类型", @"Please select job type"), MYLocalizedString(@"请选择地区", @" Please select district"), MYLocalizedString(@"请选择行业", @"Please select industry"), MYLocalizedString(@"请选择职能", @"Please select function"), MYLocalizedString(@"请选择薪水", @"Please select expected salary"), nil];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<6; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [mainContent addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSubMenu:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cellHeight - 10) / 2, 10, 10)];
        [imgView setImage:[UIImage imageNamed:@"asterisk.png"]];
        [view addSubview:imgView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
        label2.text = [arr2 objectAtIndex:i];
        label2.textColor = color2;
        label2.font = font2;
        label2.textAlignment = NSTextAlignmentRight;
        [view addSubview:label2];
        
        [subMenuArr addObject:label2];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
        [view addSubview:img];

        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 20, (cellHeight + 1) * 4)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [mainContent addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, 30, 20, (cellHeight + 1) * 4)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [mainContent addSubview:view2];
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    [self drawTopView];
    [self drawMainContent];
    
    nextBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBut setFrame:CGRectMake(15, mainContent.frame.size.height + mainContent.frame.origin.y + 15, [InitData Width] - 30, 30)];
    [nextBut setBackgroundColor:[UIColor colorWithRed:241.0/255 green:133.0/255 blue:74.0/255 alpha:1]];
    nextBut.layer.cornerRadius = 5;
    [nextBut setTitle:MYLocalizedString(@"保存并继续完善", @"Save and continue to improve") forState:UIControlStateNormal];
    [nextBut addTarget:self action:@selector(saveAndContinueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
}
- (void) setResume:(T_Resume *)res{
    resume = res;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0)
        [self drawView];
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
        [self drawView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event

- (void) saveAndContinueClicked{
    for (int i=0; i<[subMenuArr count]; i++){
        UILabel *label = [subMenuArr objectAtIndex:i];
        if ([label.text isEqualToString:[arr2 objectAtIndex:i]]){
            [InitData netAlert:[arr2 objectAtIndex:i]];
            return;
        }
    }
    
    resume.current = (int)((UILabel*)[subMenuArr objectAtIndex:0]).tag;
    resume.current_cn = ((UILabel*)[subMenuArr objectAtIndex:0]).text;
    resume.nature = (int)((UILabel*)[subMenuArr objectAtIndex:1]).tag;
    resume.nature_cn = ((UILabel*)[subMenuArr objectAtIndex:1]).text;
    //resume.district = (int)((UILabel*)[subMenuArr objectAtIndex:2]).tag;
   // resume.district_cn = ((UILabel*)[subMenuArr objectAtIndex:2]).text;
  //  resume.trade = (int)((UILabel*)[subMenuArr objectAtIndex:3]).tag;
  //  resume.trade_cn = ((UILabel*)[subMenuArr objectAtIndex:3]).text;
  //  resume.intention_jobs_id = (int)((UILabel*)[subMenuArr objectAtIndex:4]).tag;
  //  resume.intention_jobs = ((UILabel*)[subMenuArr objectAtIndex:4]).text;
    resume.wage = (int)((UILabel*)[subMenuArr objectAtIndex:5]).tag;
    resume.wage_cn = ((UILabel*)[subMenuArr objectAtIndex:5]).text;
    
    [InitData isLoading:self.view];
    nextBut.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        int pid = [[[T_Interface alloc] init] createUsername:user.username andUserPwd:user.userpwd andResume:resume] ;
        
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            nextBut.userInteractionEnabled = YES;
            if (pid > 0){
                user.profile = YES;
                [InitData setUser:user];
                [InitData setPid:pid];
                ChangeResumeViewController *changeResu = [[ChangeResumeViewController alloc] init];
                [self.myNavigationController pushAndDisplayViewController: changeResu];
            }
            
        });
    });
}

- (void) selectSubMenu:(UITapGestureRecognizer*) recognizer{
    selected = recognizer.view;
    NSString *hanshu;
    NSString *title;
    if (selected.tag - 1 == 2 || selected.tag - 1 == 4 || selected.tag - 1 == 3){//2为地区， 4为职能
        if (selected.tag - 1 == 2){
            hanshu = @"district";
            title = MYLocalizedString(@"选择地区", @"Select district");
        }
        else if (selected.tag - 1 == 3){
            hanshu = @"QS_trade";
            title = MYLocalizedString(@"选择行业", @"Select industry");
            
        }else{
            hanshu = @"jobs";
            title = MYLocalizedString(@"选择职能", @"Select function");
        }
            
       /* MutableMenuViewController *mutab = [[MutableMenuViewController alloc] init];
        [mutab setHanshuName:hanshu];
        mutab.delegate = self;
        [self.myNavigationController pushAndDisplayViewController:mutab];
        */
        ChoiceIndustryViewController *cho = [[ChoiceIndustryViewController alloc] init];
        [cho setHanshuName:hanshu];
        [cho setTitle:title];
        cho.delegate = self;
        [self.myNavigationController pushAndDisplayViewController: cho];
        return;
    }
    
    switch (selected.tag - 1) {
        case 0:
            hanshu = @"QS_current";
            break;
        case 1:
            hanshu = @"QS_jobs_nature";
            break;
        case 3:
            hanshu = @"QS_trade";
            break;
        case 5:
            hanshu = @"QS_wage";
            break;
        default:
            break;
    }
    EduViewController *edu = [[EduViewController alloc] init];
    edu.delegate = self;
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        array = [[[T_Interface alloc] init] classify:hanshu andParentid:0];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            NSMutableArray * tarr = [[NSMutableArray alloc] init];
            for (int i=0; i<[array count]; i++){
                T_category *cat = [array objectAtIndex:i];
                [tarr addObject:cat.c_name];
            }
            [edu setViewWithNSArray:tarr];
            [self.myNavigationController pushAndDisplayViewController:edu];
        });
    });
}

#pragma mark delegate
- (void) selectIndex:(int)index{
    if (selected != nil) {
        UILabel * label = [[selected subviews] objectAtIndex:2];
        T_category *cat = [array objectAtIndex:index];
        label.tag = cat.c_id;
        label.text = cat.c_name;
        selected = nil;
    }
}
- (void) MutableMenuSelectedThis:(int)c_id andString:(NSString *)str{
    if (selected != nil){
        UILabel * label = [[selected subviews] objectAtIndex:2];
        label.tag = c_id;
        label.text = str;
        selected = nil;
    }
}
- (void) mutableChoiceByContent:(NSString *)content andId:(NSString *)idStr{
    UILabel *label = [[selected  subviews] objectAtIndex:2];
    if (resume == nil)
        resume = [[T_Resume alloc] init];
    if (selected.tag- 1 == 2){
        resume.district_cn = content;
        resume.districtIdString = idStr;
        label.text = content;
    }
    else if (selected.tag - 1 == 3){
        resume.trade_cn = content;
        resume.tradeIdString = idStr;
        label.text = content;
    }
    else if (selected.tag - 1 == 4){
        resume.intention_jobs = content;
        resume.intention_jobs_id_string = idStr;
        label.text = content;
    }
}
@end
