//
//  TrainViewController.m
//  74cms
//
//  Created by lyp on 15/4/21.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "TrainViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "AchievementViewController.h"

#define TRA_TAGBEGIN 380

@interface TrainViewController ()<UITextFieldDelegate, AchievementDelegate>{
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
    T_Training *data;
    
    int selected;
}

@end

@implementation TrainViewController

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
            if (data != nil){
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
                schoolField.text = data.agency;
            }
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
            schoolField.rightView = imgView;
            schoolField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [view addSubview:schoolField];
        }
            break;
        case 3:{
            professional = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] / 2, 0, [InitData Width] / 2 - 20, cellHeight)];
            professional.placeholder = [arr2 objectAtIndex:t];
            professional.delegate = self;
            professional.font = font2;
            professional.textColor = color2;
            professional.textAlignment = NSTextAlignmentRight;
            professional.returnKeyType = UIReturnKeyDone;
            [view addSubview:professional];
            [array addObject:professional];
            if (data != nil){
                professional.text = data.course;
            }
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
                eduLabel.text = [NSString stringWithFormat:@"已输入%u字", [data.description length]];
            }
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEdu)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
            break;
    }
}

- (void) drawView{
    cellHeight = [InitData Height] / 2 / 5;
    float height = 0;
    
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"开始时间", @"Start time"), MYLocalizedString(@"结束时间", @"End time"), MYLocalizedString(@"培训机构", @"Training institutions"), MYLocalizedString(@"培训课程", @"Training course"), MYLocalizedString(@"培训内容", @"Training content"), nil];
    arr2 = [NSArray arrayWithObjects:MYLocalizedString(@"请选择开始时间", @"Please select start time"), MYLocalizedString(@"请选择结束时间", @"Please select end time"), MYLocalizedString(@"请输入培训机构名称", @"Please enter the name of the training organization"), MYLocalizedString(@"请输入培训课程", @"Please enter a training course"), MYLocalizedString(@"请输入培训内容", @"Please enter the training content"), nil];
    array = [[NSMutableArray alloc] init];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    
    for (int i=0; i<[arr count]; i++){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = TRA_TAGBEGIN + i;
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
        
        if (i != 2 && i != 3){
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 35, (cellHeight - 30) / 2, 20, 30)];
            [view addSubview:img];
        }
        
        height += cellHeight + 1;
    }
}
- (void) setTrain:(T_Training *) ttrain{
    data = ttrain;
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
    
    [self.myNavigationController setTitle:MYLocalizedString(@"添加培训经历", @"Add training experience")];
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

- (void) save:(UIButton*) but{
    T_Training *tdata = [[T_Training alloc] init];
    for (int i=0; i<4; i++){
        UILabel *label = [array objectAtIndex:i];
        if ([label.text isEqualToString:@""] || [label.text isEqualToString:[arr2 objectAtIndex:i]]){
            [InitData netAlert:[arr2 objectAtIndex:i]];
            return;
        }
    }
    if (data.description == nil ||[data.description isEqualToString:@""]){
        [InitData netAlert:[arr2 objectAtIndex:4]];
        return;
    }
    
    tdata.starttime = ((UILabel*)[array objectAtIndex:0]).text;
    tdata.endtime = ((UILabel*)[array objectAtIndex:1]).text;
    if ([((UILabel*)[array objectAtIndex:1]).text isEqualToString:MYLocalizedString(@"至今", @"Until now")]){
        tdata.todate = 1;
    }
    tdata.agency = ((UITextField*)[array objectAtIndex:2]).text;
    tdata.course = ((UILabel*)[array objectAtIndex:3]).text;
    tdata.description = data.description;
    
    [InitData isLoading:self.view];
    but.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        if (data == nil || data.ID == 0){
            [[[T_Interface alloc] init] resumeTrainByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andTraining:tdata] ;
        }
        else{
            tdata.ID = data.ID;
            [[[T_Interface alloc] init] resumeTrainByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andTraining:tdata] ;
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            but.userInteractionEnabled = YES;
            [self.myNavigationController dismissViewController];
        });
    });
}
- (void) selectEdu{
    AchievementViewController *ach = [[AchievementViewController alloc] init];
    ach.delegate = self;
    [self.myNavigationController pushAndDisplayViewController:ach];
    [ach setTitle:MYLocalizedString(@"培训描述", @"Training description") andTishi:MYLocalizedString(@"请对你的培训内容做一个简短的描述", @"Please give a brief description of your training content.")];
    if (data!= nil && data.description!= nil && ![data.description isEqualToString:@""])
        [ach setContent:data.description];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) datePicker:(UITapGestureRecognizer*) recognizer{
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    
    if (recognizer.view.tag == TRA_TAGBEGIN){
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
- (void) achievementScanf:(NSString *)str{
    if ([array count] <= 4)
        return;
    UILabel *label = [array objectAtIndex:4];
    label.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), (unsigned long)[str length]];
    if (data == nil)
        data = [[T_Training alloc] init];
    data.description = str;
}
@end
