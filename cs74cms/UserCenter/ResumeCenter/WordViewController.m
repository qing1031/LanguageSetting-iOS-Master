//
//  WordViewController.m
//  74cms
//
//  Created by lyp on 15/4/21.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "WordViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "T_Work.h"
#import "SelfEvaluationViewController.h"
#import "MutableMenuViewController.h"
#import "AchievementViewController.h"

#define WOR_TAGBEGIN 420

@interface WordViewController ()<UITextFieldDelegate,MutableMenuDelegate, AchievementDelegate>{
    UITextField *schoolField;
    UITextField *professional;
    
    float cellHeight;
    
    
    UILabel *startDate;
    UILabel *endDate;
    UILabel *eduLabel;
    UILabel *funcLabel;
    
    UIDatePicker * startDatePicker;
    UIDatePicker * endDatePicker;
    
    NSMutableArray *subMenuArray;
    NSMutableArray *array;//控件
    NSArray *arr2;
    T_Work *data;
    
    int selected;
}

@end

@implementation WordViewController

- (void) content:(UIView*) view andTag:(int) t{
    

    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    
    
    
    
    switch (t) {
        case 0:{
            startDate = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 190, 0, 150, cellHeight)];
            startDate.text = [arr2 objectAtIndex:t];
            startDate.textColor = color2;
            startDate.font = font2;
            startDate.textAlignment = NSTextAlignmentRight;
            [view addSubview:startDate];
            [array addObject:startDate];
            if (data != nil){
                startDate.text = data.starttime;
            }
        
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
        }
            break;
            
        case 1:{
            endDate = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 190, 0, 150, cellHeight)];
            endDate.text = MYLocalizedString(@"至今", @"Until now");
            endDate.textColor = color2;
            endDate.font = font2;
            endDate.textAlignment = NSTextAlignmentRight;
            [view addSubview:endDate];
            [array addObject:endDate];
            if (data!= nil){
                endDate.text = data.endtime;
            }
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
        }
            break;
        case 2:{
            
            schoolField = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] / 2, 0, [InitData Width] / 2 - 20, cellHeight)];
            schoolField.placeholder = [arr2 objectAtIndex:t];
            schoolField.delegate = self;
            schoolField.font = font2;
            schoolField.textColor = color2;
            schoolField.textAlignment = NSTextAlignmentRight;
            schoolField.returnKeyType = UIReturnKeyDone;
            [array addObject:schoolField];
            if (data != nil){
                schoolField.text = data.companyName;
            }
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
            schoolField.rightView = imgView;
            schoolField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [view addSubview:schoolField];
        }
            break;
        case 3:{
            funcLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 190, 0, 150, cellHeight)];
            funcLabel.text = [arr2 objectAtIndex:t];
            funcLabel.textColor = color2;
            funcLabel.font = font2;
            funcLabel.textAlignment = NSTextAlignmentRight;
            [view addSubview:funcLabel];
            [array addObject:funcLabel];
            if (data != nil){
                funcLabel.text = data.jobs;
            }
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEdu:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
        }
            break;
        default:
            eduLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 190, 0, 150, cellHeight)];
            eduLabel.text = [arr2 objectAtIndex:t];
            eduLabel.textColor = color2;
            eduLabel.font = font2;
            eduLabel.textAlignment = NSTextAlignmentRight;
            [view addSubview:eduLabel];
            [array addObject:eduLabel];
            if (data != nil){
                eduLabel.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"),(unsigned long)[data.achievements length]];
            }
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEdu:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
            break;
    }
}

- (void) drawView{
    cellHeight = [InitData Height] / 2 / 5;
    float height = 0;
    
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"开始时间", @"Start time"), MYLocalizedString(@"结束时间", @"End time"), MYLocalizedString(@"开始时间", @"Start time"), MYLocalizedString(@"公    司", @"Company"), MYLocalizedString(@"职    位", @"Job position"),MYLocalizedString(@"工作职责", @"Job duties"), nil];
    arr2 = [NSArray arrayWithObjects:MYLocalizedString(@"请选择开始时间", @"Please select start time"), MYLocalizedString(@"请选择结束时间", @"Please select end time"), MYLocalizedString(@"请输入公司", @"Please enter company"), MYLocalizedString(@"请选择职能", @"Please select the function"), MYLocalizedString(@"请输入工作职责", @"Please enter your job duties"), nil];
    array = [[NSMutableArray alloc] init];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    
    for (int i=0; i<[arr count]; i++){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = WOR_TAGBEGIN + i;
        [self.view addSubview:view];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cellHeight - 10) / 2, 10, 10)];
        [imgView setImage:[UIImage imageNamed:@"asterisk.png"]];
        [view addSubview:imgView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        [self content:view andTag:i];
        
        /*  UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
         label2.text = [arr2 objectAtIndex:i];
         label2.textColor = color2;
         label2.font = font2;
         label2.textAlignment = NSTextAlignmentRight;
         [view addSubview:label2];
         */
        
        if (i != 2){
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 35, (cellHeight - 30) / 2, 20, 30)];
            [view addSubview:img];
        }
        
        height += cellHeight + 1;
    }
}

- (void) setWork:(T_Work*) work{
    data = work;
    
    if ([[self.view subviews] count] <= 0)
    {
        [self drawView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    

}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
    {
        [self drawView];
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"添加工作经历", @"Add work experience")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"保存", @"Save") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) spaceClicked:(id) control
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    if (startDatePicker != nil){
        NSDate *date = startDatePicker.date;
        
        [startDatePicker removeFromSuperview];
        startDatePicker = nil;
        startDate.text = [format stringFromDate:date];
    }
    else{
        NSDate *date = endDatePicker.date;
        [endDatePicker removeFromSuperview];
        endDatePicker = nil;
        endDate.text = [format stringFromDate:date];
    }
    [control removeFromSuperview];
}

- (void) datePicker:(UITapGestureRecognizer*) recognizer{
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    
    if (recognizer.view.tag == WOR_TAGBEGIN){
        startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, [InitData Width], 100)];
        [startDatePicker setBackgroundColor:[UIColor whiteColor]];
        startDatePicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:startDatePicker];
    }
    else{
        endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, [InitData Width], 100)];
        [endDatePicker setBackgroundColor:[UIColor whiteColor]];
        endDatePicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:endDatePicker];
    }
}


- (void) selectEdu:(UITapGestureRecognizer*) recognizer{

    selected = (int)recognizer.view.tag - WOR_TAGBEGIN;
    if (selected == 3){
        NSString *req = @"jobs";
        MutableMenuViewController *mut = [[MutableMenuViewController alloc] init];
        mut.delegate = self;
        [mut setHanshuName:req];
        [self.myNavigationController pushAndDisplayViewController:mut];
        return;
    }
    
    AchievementViewController *ach = [[AchievementViewController alloc] init];
    ach.delegate = self;
    [self.myNavigationController pushAndDisplayViewController:ach];
    if (data!= nil && data.achievements!= nil && ![data.achievements isEqualToString:@""])
        [ach setContent:data.achievements];
}

//保存
- (void) save:(UIButton*) but{
    T_Work *tdata = [[T_Work alloc] init];
    for (int i=0; i<4; i++){
        UILabel *label = [array objectAtIndex:i];
        if ([label.text isEqualToString:@""] || [label.text isEqualToString:[arr2 objectAtIndex:i]]){
            [InitData netAlert:[arr2 objectAtIndex:i]];
            return;
        }
    }
    if (data.achievements == nil ||[data.achievements isEqualToString:@""]){
        [InitData netAlert:[arr2 objectAtIndex:4]];
        return;
    }

    tdata.starttime = ((UILabel*)[array objectAtIndex:0]).text;
    tdata.endtime = ((UILabel*)[array objectAtIndex:1]).text;
    if ([((UILabel*)[array objectAtIndex:1]).text isEqualToString:MYLocalizedString(@"至今", @"Until now")]){
        tdata.todate = 1;
    }
    tdata.companyName = ((UITextField*)[array objectAtIndex:2]).text;
    tdata.jobs = ((UILabel*)[array objectAtIndex:3]).text;
    tdata.achievements = data.achievements;
    
    [InitData isLoading:self.view];
    but.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        if (data == nil || data.ID == 0){
            [[[T_Interface alloc] init] resumeWorkByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andWork:tdata] ;
        }
        else{
            tdata.ID = data.ID;
            [[[T_Interface alloc] init] resumeWorkByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andWork:tdata] ;
        }
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            but.userInteractionEnabled = YES;
            [self.myNavigationController dismissViewController];
        });
    });
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark delegate
- (void)MutableMenuSelectedThis:(int)c_id andString:(NSString *)str{
    if ([array count] <= selected)
        return;
    UILabel *label = [array objectAtIndex:selected];
    label.tag = c_id;
    label.text = str;
}

- (void) achievementScanf:(NSString *)str{
    if ([array count] <= selected)
        return;
    UILabel *label = [array objectAtIndex:selected];
    label.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), (unsigned long)[str length]];
    if (data == nil)
        data = [[T_Work alloc] init];
    data.achievements = str;
}

@end
