//
//  EducationViewController.m
//  74cms
//
//  Created by niko on 15/4/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EducationViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "T_Interface.h"
#define EDUCATION_TAGBEGIN 300

@interface EducationViewController ()<UITextFieldDelegate, EduDelegate>{
    UITextField *schoolField;
    UITextField *professional;
    
    float cellHeight;
    
    
    UILabel *startDate;
    UILabel *endDate;
    UILabel *eduLabel;
    
    UIDatePicker * startDatePicker;
    UIDatePicker * endDatePicker;
    
    NSMutableArray *subMenuArray;
    NSMutableArray *array;//控件
    NSArray *arr2;
    T_Education *edu;
}

@end

@implementation EducationViewController


- (void) content:(UIView*) view andTag:(int) t{
    
    arr2 = [NSArray arrayWithObjects:MYLocalizedString(@"请选择开始时间", @"Please select start time"), MYLocalizedString(@"请选择结束时间", @"Please select end time"), MYLocalizedString(@"请输入学校", @"Please enter school"), MYLocalizedString(@"请选择学历", @"Please select your education"),MYLocalizedString(@"请输入专业", @"Please enter your major"), nil];
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
            if (edu != nil){
                startDate.text = edu.starttime;
            }
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
            }
            break;
                        
        case 1:{
            endDate = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 190, 0, 150, cellHeight)];
            endDate.text = MYLocalizedString(@"至今", @"So far");
            endDate.textColor = color2;
            endDate.font = font2;
            endDate.textAlignment = NSTextAlignmentRight;
            [view addSubview:endDate];
            [array addObject:endDate];
            if (edu!= nil){
                endDate.text = edu.endtime;
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
            if (edu != nil){
                schoolField.text = edu.school;
            }
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
            schoolField.rightView = imgView;
            schoolField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [view addSubview:schoolField];
        }
            break;
        case 3:{
            eduLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 190, 0, 150, cellHeight)];
            eduLabel.text = [arr2 objectAtIndex:t];
            eduLabel.textColor = color2;
            eduLabel.font = font2;
            eduLabel.textAlignment = NSTextAlignmentRight;
            [view addSubview:eduLabel];
            [array addObject:eduLabel];
            if (edu != nil){
                eduLabel.text = edu.education_cn;
                eduLabel.tag = edu.education;
            }
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEdu)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
        }
            break;
            
        default:
            professional = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] / 2, 0, [InitData Width] / 2 - 20, cellHeight)];
            professional.placeholder = [arr2 objectAtIndex:t];
            professional.delegate = self;
            professional.font = font2;
            professional.textColor = color2;
            professional.textAlignment = NSTextAlignmentRight;
            professional.returnKeyType = UIReturnKeyDone;
            [view addSubview:professional];
            [array addObject:professional];
            if (edu != nil){
                professional.text = edu.speciality;
            }
            break;
    }
}

- (void) drawView{
    cellHeight = [InitData Height] / 2 / 5;
    float height = 0;

    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"开始时间", @"Start time"), MYLocalizedString(@"结束时间", @"End time"), MYLocalizedString(@"学    校", @"School"), MYLocalizedString(@"学    历", @"Education"), MYLocalizedString(@"专    业", @"Major"), nil];
    array = [[NSMutableArray alloc] init];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];

    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];

    
    for (int i=0; i<[arr count]; i++){
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = EDUCATION_TAGBEGIN + i;
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
        
        if (i != 2 && i != 4){
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 35, (cellHeight - 30) / 2, 20, 30)];
            [view addSubview:img];
        }
        
        height += cellHeight + 1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
}

- (void) setEducation:(T_Education*) tedu{
    edu = tedu;
    if ([[self.view subviews] count] <= 0)
    {
        [self drawView];
    }
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
    {
        [self drawView];
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"教育经历", @"Education experience")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
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
- (void) selectEdu{
    subMenuArray = [[[T_Interface alloc] init] classify:@"QS_education" andParentid:0];
    NSMutableArray *tarray = [[NSMutableArray alloc] init];
    for (int i=0; i<[subMenuArray count]; i++){
        T_category *cat = [subMenuArray objectAtIndex:i];
        [tarray addObject:cat.c_name];
    }
    EduViewController *tedu = [[EduViewController alloc] init];
    [tedu setViewWithNSArray: tarray];
    tedu.delegate = self;
    [self.myNavigationController pushAndDisplayViewController: tedu];
    [tedu setTitle:MYLocalizedString(@"学历", @"Education")];
}
- (void) datePicker:(UITapGestureRecognizer*) recognizer{
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    
    if (recognizer.view.tag == EDUCATION_TAGBEGIN){
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

- (void) save{
    T_Education *tedu = [[T_Education alloc] init];
    for (int i=0; i<[arr2 count]; i++){
        UILabel *label = [array objectAtIndex:i];
        if ([label.text isEqualToString:@""] || [label.text isEqualToString:[arr2 objectAtIndex:i]]){
            [InitData netAlert:[arr2 objectAtIndex:i]];
            return;
        }
    }
    
    tedu.starttime = ((UILabel*)[array objectAtIndex:0]).text;
    tedu.endtime = ((UILabel*)[array objectAtIndex:1]).text;
    if ([((UILabel*)[array objectAtIndex:1]).text isEqualToString:MYLocalizedString(@"至今", @"So far")]){
        tedu.todate = 1;
    }
    tedu.school = ((UITextField*)[array objectAtIndex:2]).text;
    tedu.education = (int)((UILabel*)[array objectAtIndex:3]).tag;
    tedu.education_cn = ((UILabel*)[array objectAtIndex:3]).text;
    tedu.speciality = ((UILabel*)[array objectAtIndex:4]).text;
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        if (edu == nil){
            [[[T_Interface alloc] init] resumeEducationByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andEductaion:tedu] ;
        }
        else{
            tedu.ID = edu.ID;
            [[[T_Interface alloc] init] resumeEducationByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andEductaion:tedu] ;
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self.myNavigationController dismissViewController];
        });
    });
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

#pragma mark delegate
- (void) selectIndex:(int)index{
    UILabel *label = [array objectAtIndex:3];
    T_category *cat = [subMenuArray objectAtIndex:index];
    label.tag = cat.c_id;
    label.text = cat.c_name;
}

@end
