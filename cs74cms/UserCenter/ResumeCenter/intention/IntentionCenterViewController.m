//
//  IntentionCenterViewController.m
//  74cms
//
//  Created by lyp on 15/4/27.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "IntentionCenterViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "ChoiceIndustryViewController.h"
#import "T_Interface.h"

#define INT_TAGBEGIN 400

@interface IntentionCenterViewController ()<EduDelegate,MutableChoiceDelegate>{
  
    int pid;
    
    NSMutableArray *subMenuArr;
    NSMutableArray *array;//存储控件
    NSArray * tishi;//提示语句
    T_Resume *resume;
    
    int selected;
}

@end

@implementation IntentionCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            
            T_User *user = [InitData getUser];
            resume = [[[T_Interface alloc] init] resumeIntentionByUsername:user.username andUserpwd:user.userpwd andPid:pid andResume:nil];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                [self drawView];
            });
        });
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"求职意向", @"Intentional position")];
    UIButton *remark = [UIButton buttonWithType:UIButtonTypeCustom];
    [remark setTitle:MYLocalizedString(@"保存", @"Save") forState:UIControlStateNormal];
    [remark addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [remark setFrame:CGRectMake(0, 0, 40, 40)];
    remark.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObjects:remark, nil];
    [self.myNavigationController setRightBtn:arr];
}
- (void) setPid:(int) tpid{
    pid = tpid;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    
    float cellHeight = 44;
    float height = 1;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"求职状态", @"Job status"), MYLocalizedString(@"工作类型", @"Job type"), MYLocalizedString(@"地    区", @"District"), MYLocalizedString(@"行    业", @"Industry"), MYLocalizedString(@"职    能", @"Function"), MYLocalizedString(@"期望薪水", @"Expected salary"), nil];
    tishi = [[NSArray alloc] initWithObjects:MYLocalizedString(@"请选择状态", @"Please select job status"), MYLocalizedString(@"请选择工作类型", @"Please select job type"), MYLocalizedString(@"请选择地区", @" Please select district"), MYLocalizedString(@"请选择行业", @"Please select industry"), MYLocalizedString(@"请选择职能", @"Please select function"), MYLocalizedString(@"请选择薪水", @"Please select expected salary"), nil];
    array = [[NSMutableArray alloc] init];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    if (resume != nil){
        [arr2 addObject:resume.current_cn];
        [arr2 addObject:resume.nature_cn];
        [arr2 addObject:resume.district_cn];
        [arr2 addObject:resume.trade_cn];
        [arr2 addObject:resume.intention_jobs];
        [arr2 addObject:resume.wage_cn];
        
        [arr3 addObject:[NSNumber numberWithInt: resume.current]];
        [arr3 addObject:[NSNumber numberWithInt: resume.nature]];
        [arr3 addObject:[NSNumber numberWithInt: resume.district]];
        [arr3 addObject:[NSNumber numberWithInt: resume.trade]];
        [arr3 addObject:[NSNumber numberWithInt: resume.intention_jobs_id]];
        [arr3 addObject:[NSNumber numberWithInt: resume.wage]];
    }
    else{
        arr2 = [NSMutableArray arrayWithArray:tishi];
    }
    
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = INT_TAGBEGIN + i;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
        label2.text = [tishi objectAtIndex:i];
        label2.textColor = color2;
        label2.font = font2;
        label2.textAlignment = NSTextAlignmentRight;
        [view addSubview:label2];
        [array addObject:label2];
        if (resume != nil){
            label2.tag = (int)[arr3 objectAtIndex:i];
            if (![[arr2 objectAtIndex:i] isEqualToString:@""]){
                label2.text = [arr2 objectAtIndex:i];
            }
        }
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 36, (cellHeight - 20) / 2, 15, 20)];
        [view addSubview:img];
        
        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 20, (cellHeight + 1) * 5)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, 30, 20, (cellHeight + 1) * 5)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
}


- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    selected = (int)recognizer.view.tag - INT_TAGBEGIN;
    NSString *req;
    NSString * title;
   
    switch (selected) {
        case 0:
            req = @"QS_current";
            title = MYLocalizedString(@"求职状态", @"Job status");
            break;
        case 1:
            req = @"QS_jobs_nature";
            title = MYLocalizedString(@"工作类型", @"Job type");
            break;
        case 2:
            req = @"district";
            title = MYLocalizedString(@"选择地区", @"Select district");
            break;
        case 3:
            req = @"QS_trade";
            title = MYLocalizedString(@"选择行业", @"Select industry");
            break;
        case 4:
            req = @"jobs";
            title = MYLocalizedString(@"选择职能", @"Select function");
            break;
        default:
            req = @"QS_wage";
            title = MYLocalizedString(@"期望薪水", @"Expected salary");
            break;
    }
    if (selected != 2 && selected != 3 && selected!=4){
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            subMenuArr = [[[T_Interface alloc] init] classify:req andParentid:0];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                NSMutableArray *tarray = [[NSMutableArray alloc] init];
                for (int i=0; i<[subMenuArr count]; i++){
                    T_category *cat = [subMenuArr objectAtIndex:i];
                    [tarray addObject:cat.c_name];
                }
                EduViewController *next = [[EduViewController alloc] init];
                [next setViewWithNSArray: tarray];
                next.delegate = self;
                [self.myNavigationController pushAndDisplayViewController: next];
                [next setTitle:title];
                return;
            });
        });
        return;
    }

    ChoiceIndustryViewController *cho = [[ChoiceIndustryViewController alloc] init];
    [cho setHanshuName:req];
    [cho setTitle:title];
    cho.delegate = self;
    [self.myNavigationController pushAndDisplayViewController: cho];
        
    return;
}
- (void) saveClicked{
    for (int i=0; i<[array count]; i++){
        UILabel *label = [array objectAtIndex:i];
        if ([label.text isEqualToString:[tishi objectAtIndex:i]]){
            [InitData netAlert:[tishi objectAtIndex:i]];
            return;
        }
        switch (i) {
            case 0:
                resume.current = (int)label.tag;
                resume.current_cn = label.text;
                break;
            case 1:
                resume.nature = (int)label.tag;
                resume.nature_cn = label.text;
                break;
            case 5:
                resume.wage = (int)label.tag;
                resume.wage_cn = label.text;
            default:
                break;
        }
    }
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_Resume *rest = [[[T_Interface alloc] init] resumeIntentionByUsername:user.username andUserpwd:user.userpwd andPid:resume.ID andResume:resume];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (rest != nil){
                [self.myNavigationController dismissViewController];
            }
        });
    });
}

#pragma mark delegate
- (void) selectIndex:(int)index{
    UILabel *label = [array objectAtIndex:selected];
    T_category *cat = [subMenuArr objectAtIndex:index];
    label.text = cat.c_name;
    label.tag = cat.c_id;
}

- (void) mutableChoiceByContent:(NSString *)content andId:(NSString *)idStr{
    UILabel *label = [array objectAtIndex:selected];
    if (selected == 2){
        resume.district_cn = content;
        resume.districtIdString = idStr;
        label.text = content;
    }
    else if (selected == 3){
        resume.trade_cn = content;
        resume.tradeIdString = idStr;
        label.text = content;
    }
    else{
        resume.intention_jobs = content;
        resume.intention_jobs_id_string = idStr;
        label.text = content;
    }
}

@end
