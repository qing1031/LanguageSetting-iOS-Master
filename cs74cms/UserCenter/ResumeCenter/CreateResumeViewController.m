//
//  CreateResumeViewController.m
//  74cms
//
//  Created by LPY on 15-4-14.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "CreateResumeViewController.h"
#import "InitData.h"
#import "CreateResume2ViewController.h"
#import "T_Resume.h"
#import "T_Interface.h"
#import "EduViewController.h"
#import "MutableMenuViewController.h"

@interface CreateResumeViewController ()<UITextFieldDelegate, EduDelegate, MutableMenuDelegate>{
    UIView *mainContent;
    UIButton *menBut;
    UIButton *womenBut;
    UIDatePicker *datePicker;
    
    NSMutableArray *array;//存储几个label，用于显示
    NSMutableArray *subMenuArray;//下一页的列表
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
    
    int selected;//由哪个页面跳到子类
    
    NSArray *arr2;//右边的提示语句
    
    NSMutableArray *contentArray;
    NSMutableArray *idArray;
    
    T_Resume *resume;
}

@end

@implementation CreateResumeViewController

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
    [view1 setBackgroundColor:[UIColor colorWithRed:241.0/255 green:133.0/255 blue:74.0/255 alpha:1]];//UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1]
    [topView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10 + width + seperate, 15, seperate - 2, 1)];
    [view2 setBackgroundColor:[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1]];
    [topView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10 + width * 2 + seperate * 2, 15, seperate - 2, 1)];
    [view3 setBackgroundColor:[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1]];
    [topView addSubview:view3];
    
    UILabel *number1 = [[UILabel alloc] initWithFrame:CGRectMake(seperate + 10, 8, 14, 14)];
    number1.layer.cornerRadius = 7;
    number1.layer.masksToBounds = YES;
    number1.textAlignment = NSTextAlignmentCenter;
    number1.text = @"1";
    number1.tag = 1001;
    number1.font = [UIFont systemFontOfSize:14];
    number1.backgroundColor = [UIColor colorWithRed:241.0/255 green:133.0/255 blue:74.0/255 alpha:1];
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
    number2.backgroundColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
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
    mainContent = [[UIView alloc] initWithFrame:CGRectMake(0, 30, [InitData Width], [InitData Height] - 30 - 70)];
    [self.view addSubview:mainContent];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [InitData Width] - 40, 28)];
    title1.text = MYLocalizedString(@"基本信息", @"Base information");
    title1.font = [UIFont systemFontOfSize:13];
    [mainContent addSubview:title1];
    
    float cellHeight = (mainContent.frame.size.height - 56 -6) / 9;
    float height = 28;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"姓    名", @"Name"), MYLocalizedString(@"性    别", @"Gender"), MYLocalizedString(@"出生日期", @"Birthday"), MYLocalizedString(@"工作年限", @"work experience"), MYLocalizedString(@"现居住地", @"Current residence"),MYLocalizedString(@"最高学历", @"Highest education"), MYLocalizedString(@"专业类别", @"Major"),   MYLocalizedString(@"联系电话", @"Phone number"), MYLocalizedString(@"联系邮箱", @"Email"), nil];
    arr2 = [[NSArray alloc] initWithObjects: MYLocalizedString(@"请输入姓名", @"Please enter your name"), @"",MYLocalizedString(@"请选择出生日期", @"Please select your birthday"), MYLocalizedString(@"请选择工作年限", @"Please select work experience"),  MYLocalizedString(@"请选择居住地", @"Please select current residence"),MYLocalizedString(@"请选择学历", @"Please select your education"), MYLocalizedString(@"请选择专业", @"Please select major"), MYLocalizedString(@"请输入联系电话", @"Please enter phone number"), MYLocalizedString(@"请输入邮箱", @"Please enter mail"), nil];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        if (i == 7){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 200, 28)];
            label.text = MYLocalizedString(@"联系方式", @"Contact");
            label.font = title1.font;
            [mainContent addSubview:label];
            height += 28;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [mainContent addSubview:view];
        
        if (i == 2){
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
        }
        else if (i == 3 || i == 4 || i == 5 || i==6){
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSubMenu:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
        }
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cellHeight - 10) / 2, 10, 10)];
        [imgView setImage:[UIImage imageNamed:@"asterisk.png"]];
        [view addSubview:imgView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        if (i == 1){
            menBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [menBut setImage:[UIImage imageNamed:@"menUnselect.png"] forState:UIControlStateNormal];
            [menBut setImage:[UIImage imageNamed:@"menSelected.png"] forState:UIControlStateSelected];
            menBut.tag = 3001;
            [menBut addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [menBut setFrame:CGRectMake([InitData Width] - 116, (cellHeight - 40) / 2, 40, 40)];
            [menBut setImageEdgeInsets:UIEdgeInsetsMake(10, 13, 10, 13)];
            [view addSubview:menBut];
            
            UILabel *nan = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 85, (cellHeight - 15) / 2, 15, 15)];
            nan.text = MYLocalizedString(@"男", @"Man");
            nan.textColor = color2;
            nan.font = font2;
            [view addSubview:nan];
            [array addObject:menBut];
            if (contentArray != nil &&[contentArray count] > i && [[contentArray objectAtIndex:i] isEqualToString:nan.text])
                menBut.selected = YES;
            
            
            womenBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [womenBut setImage:[UIImage imageNamed:@"womenUnselect.png"] forState:UIControlStateNormal];
            [womenBut setImage:[UIImage imageNamed:@"womenSelected"] forState:UIControlStateSelected];
            womenBut.tag = 3002;
            [womenBut addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [womenBut setFrame:CGRectMake([InitData Width] - 65, (cellHeight - 40) / 2, 40, 40)];
            [womenBut setImageEdgeInsets:UIEdgeInsetsMake(10, 14, 10, 14)];
            [view addSubview:womenBut];
            
            UILabel *nv = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 35, (cellHeight - 15) / 2, 15, 15)];
            nv.text = MYLocalizedString(@"女", @"Woman");
            nv.textColor = color2;
            nv.font = font2;
            [view addSubview:nv];
            
            if (contentArray != nil && [contentArray count] > i&&[[contentArray objectAtIndex:i] isEqualToString:nv.text])
                womenBut.selected = YES;
        }
        else if (i == 0 || i == 7 || i == 8){
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            textField.placeholder = [arr2 objectAtIndex:i];
            textField.textColor = color2;
            textField.font = font2;
            textField.delegate = self;
            textField.textAlignment = NSTextAlignmentRight;
            [view addSubview:textField];
            [array addObject:textField];
            if (contentArray != nil &&[contentArray count] > i &&![[contentArray objectAtIndex:i] isEqualToString:@""]){
                textField.text = [contentArray objectAtIndex:i];
            }
            UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
            [img setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal] ;
            [img setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            [img setFrame:CGRectMake([InitData Width] - 50, (cellHeight - 40) / 2, 40, 40)];
            [img addTarget:self action:@selector(cancelButClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:img];
        }
        else{
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = [arr2 objectAtIndex:i];
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            [array addObject:label2];
            if (contentArray != nil  &&[contentArray count] > i && ![[contentArray objectAtIndex:i] isEqualToString:@""]){
                label2.text = [contentArray objectAtIndex:i];
                if ([idArray count] > i)
                    label2.tag = [[idArray objectAtIndex:i] intValue];
               // NSLog(@"%ld", label2.tag);
            }
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [view addSubview:img];
        }
        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 20, (cellHeight + 1) * 4)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [mainContent addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, 30, 20, (cellHeight + 1) * 4)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [mainContent addSubview:view2];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, (cellHeight + 1) * 6 + 10 , 20, (cellHeight + 1) * 1)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [mainContent addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, (cellHeight + 1) * 6 + 10 , 20, (cellHeight + 1) * 1)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [mainContent addSubview:view4];
}
- (void) getInfo{
    if (resume == nil)
        return;
    contentArray = [[NSMutableArray alloc] init];
    idArray = [[NSMutableArray alloc] init];
    
    if (resume.fullname != nil)
        [contentArray addObject:resume.fullname];
    if (resume.sex_cn!= nil)
        [contentArray addObject:resume.sex_cn];
    if (resume.birthdate != nil)
        [contentArray addObject:resume.birthdate];
    if (resume.experience_cn != nil)
        [contentArray addObject:resume.experience_cn];
    if (resume.residence_cn!= nil)
        [contentArray addObject:resume.residence_cn];
    if (resume.education_cn != nil)
        [contentArray addObject:resume.education_cn];
    if (resume.major_cn != nil)
        [contentArray addObject:resume.major_cn];
    if (resume.telephone != nil)
        [contentArray addObject:resume.telephone];
    if (resume.email != nil)
        [contentArray addObject:resume.email];
    
    [idArray addObject:[NSNumber numberWithInt:0]];
    [idArray addObject:[NSNumber numberWithInt:resume.sex]];
    [idArray addObject:[NSNumber numberWithInt:0]];
    [idArray addObject:[NSNumber numberWithInt:resume.experience]];
    [idArray addObject:[NSNumber numberWithInt:resume.residence]];
    [idArray addObject:[NSNumber numberWithInt:resume.education]];
    [idArray addObject:[NSNumber numberWithInt:resume.major]];
    [idArray addObject:[NSNumber numberWithInt:resume.sex]];
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    array = [[NSMutableArray alloc] init];
    [self drawTopView];
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        if (user.profile)
            resume = [[[T_Interface alloc] init] getResumeByUsername:user.username andUserPwd:user.userpwd andResume:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getInfo];
            [InitData haveLoaded:self.view];
            [self drawMainContent];
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setFrame:CGRectMake(15, mainContent.frame.size.height + mainContent.frame.origin.y + 15, [InitData Width] - 30, 30)];
    [next setBackgroundColor:[UIColor colorWithRed:241.0/255 green:133.0/255 blue:74.0/255 alpha:1]];
    next.layer.cornerRadius = 5;
    [next setTitle:MYLocalizedString(@"下一步", @"Next step") forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
            
        });
    });
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0){
        [self drawView];
        [self registerKeyBoardNotification];
    }
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
        [self drawView];
    [self.myNavigationController setTitle:MYLocalizedString(@"创建简历", @"Create resume")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - event
- (void) nextClicked{
    
    CreateResume2ViewController *create2 = [[CreateResume2ViewController alloc] init];
    
    //判断信息是否为空
    if (!menBut.selected && !womenBut.selected){
        [InitData netAlert:MYLocalizedString(@"请选择性别", @"Please select the gender")];
        return;
    }
    NSArray *infoArr = [NSArray arrayWithObjects:MYLocalizedString(@"姓名不能为空", @"Name cannot be empty"), @"", MYLocalizedString(@"出生日期不能为空", @"Birthday cannot be empty"), MYLocalizedString(@"工作年限不能为空", @"Work experience cannot be empty"), MYLocalizedString(@"现居住地不能为空", @"Current residence cannot be empty"),MYLocalizedString(@"请选择学历", @"Please select your education"), MYLocalizedString(@"请选择专业", @"Please select major"), MYLocalizedString(@"联系电话不能为空", @"Phone number cannot be empty"), MYLocalizedString(@"联系邮箱不能为空", @"Email cannot be empty"), nil];

    for (int i=0; i<[array count]; i++) {
        if (i == 1)
            continue;
        if (i == 0 || i == 7 || i == 8){
            UITextField *textf = (UITextField*)[array objectAtIndex:i];
         //   NSLog(@"%d", [textf.text isEqualToString:[arr2 objectAtIndex:i]]);
            if (![textf.text isEqualToString:@""] && ![textf.text isEqualToString:[arr2 objectAtIndex:i]])
                 continue;
            else{
                [InitData netAlert:[infoArr objectAtIndex:i]];
                return;
            }
        }

        UILabel *textf = (UILabel*)[array objectAtIndex:i];
        if (![textf.text isEqualToString:@""])
            continue;

        [InitData netAlert:[infoArr objectAtIndex:i]];
        return;
    }
    if (![InitData stringIsPhoneNumber:((UITextField*)[array objectAtIndex:7]).text]){
        [InitData netAlert:MYLocalizedString(@"请输入正确的手机号", @"Please enter correct phone number")];
        return;
    }
    if (![InitData stringIsEmail:((UITextField*)[array objectAtIndex:8]).text]){
        [InitData netAlert:MYLocalizedString(@"请输入正确的邮箱", @"Please enter correct email")];
        return;
    }
    NSString *sex = ((UIButton*)[array objectAtIndex:0]).selected?MYLocalizedString(@"男", @"Man"):MYLocalizedString(@"女", @"Woman");
    
    if (resume == nil)
        resume = [[T_Resume alloc] init];
    resume.fullname =((UILabel*)[array objectAtIndex:0]).text;
    resume.birthdate = ((UILabel*)[array objectAtIndex:2]).text;
    resume.sex = [sex isEqualToString:MYLocalizedString(@"男", @"Man")]?1:2;
    resume.sex_cn = sex;
    resume.experience = (int)((UILabel*)[array objectAtIndex:3]).tag;
    resume.experience_cn =((UILabel*)[array objectAtIndex:3]).text;
    resume.residence = (int)((UILabel*)[array objectAtIndex:4]).tag;
    resume.residence_cn = ((UILabel*)[array objectAtIndex:4]).text;
    resume.education = (int)((UILabel*)[array objectAtIndex:5]).tag;
    resume.education_cn = ((UILabel*)[array objectAtIndex:5]).text;
    resume.major = (int)((UILabel*)[array objectAtIndex:6]).tag;
    resume.major_cn = ((UILabel*)[array objectAtIndex:6]).text;
    resume.telephone =((UITextField*)[array objectAtIndex:7]).text;
    resume.email =((UITextField*)[array objectAtIndex:8]).text;
    [create2 setResume:resume];
    
    [self.myNavigationController pushAndDisplayViewController:create2];
    T_User *user = [InitData getUser];
    user.profile = YES;
    [InitData setUser:user];
}

- (void) datePicker:(UITapGestureRecognizer*) recognizer{
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    
    if (recognizer.view.tag == 3){
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, [InitData Width], 100)];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:datePicker];
    }
}

- (void) spaceClicked:(UIControl*) control{
    UILabel *label = [array objectAtIndex:2];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    if (datePicker != nil){
        NSDate *date = datePicker.date;
        
        [datePicker removeFromSuperview];
        datePicker = nil;
        label.text = [format stringFromDate:date];
    }
    
    [control removeFromSuperview];
}

- (void)sexSelected:(UIButton*)but{
    if (but.tag == 3001){//men
        menBut.selected = YES;
        womenBut.selected = NO;
        
    }
    else{
        menBut.selected = NO;
        womenBut.selected = YES;
    }
}

- (void) selectSubMenu:(UITapGestureRecognizer*) recognizer{
    NSString *req;
    if (recognizer.view.tag != 5){//工作年限
        switch (recognizer.view.tag) {
            case 4:
                req = @"QS_experience";
                break;
            case 6:
                req = @"QS_education";
                break;
            default:
                req = @"QS_major";
                break;
        }
        
        selected = (int)recognizer.view.tag - 1;
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            subMenuArray = [[[T_Interface alloc] init] classify:req andParentid:0];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                NSMutableArray * arr = [[NSMutableArray alloc] init];
                for (int i=0; i<[subMenuArray count]; i++) {
                    T_category *cat = [subMenuArray objectAtIndex:i];
                    [arr addObject:cat.c_name];
                }
    
                EduViewController *edu = [[EduViewController alloc] init];
                [edu setViewWithNSArray:arr];
                edu.delegate = self;
    
                [self.myNavigationController pushAndDisplayViewController:edu];
            });
        });
        return;
    }
    
    req = @"district";
    selected = 4;
    MutableMenuViewController *mutab = [[MutableMenuViewController alloc] init];
    mutab.delegate = self;
    [mutab setHanshuName:req];
    [self.myNavigationController pushAndDisplayViewController:mutab];

}
- (void) cancelButClicked:(UIButton*) but{
    UIView *view = but.superview;
    if ([[view subviews] count] > 2){
        UITextField *textfield = [[view subviews] objectAtIndex:2];
        textfield.text = @"";
    }
}
#pragma mark delegate
- (void) MutableMenuSelectedThis:(int)c_id andString:(NSString *)str{
    UILabel *label = [array objectAtIndex:selected];
    label.text = str;
    label.tag = c_id;
}


- (void) selectIndex:(int)index{
    if ([array count] > selected){
        UILabel *label = [array objectAtIndex:selected];
        if ([subMenuArray count] > index){
            T_category *cat = [subMenuArray objectAtIndex:index];
            label.text = cat.c_name;
            label.tag = cat.c_id;
        }
    }
}



- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    i_textFieldY = [self getAllY:textField];
    i_textFieldHeight = textField.frame.size.height;
    
    // float bottom = [InitData Height] - allY - textField.frame.size.height;
}
- (void) save{
    //[self.myNavigationController pushAndDisplayViewController:[[CompanyCenterViewController alloc] init]];
}


#pragma mark- 键盘通知事件 ［核心代码］


//注册键盘监听消息
-(void)registerKeyBoardNotification
{
    //增加监听，当键盘出现或改变时收出消息    ［核心代码］
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    //计算偏移量
    i_offset = keyboardHeight - ([InitData Height]-(i_textFieldY+i_textFieldHeight));
    
    //进行偏移
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    UIView *view = [[self.view subviews] objectAtIndex:1];
    
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    if(i_offset > 0)
    {
        CGRect rect = CGRectMake(0.0f,30-i_offset,width,height); //把整个view 往上提，肯定要用负数 y
        view.frame = rect;
    }
    
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(i_offset > 0)
    {
        //恢复到偏移前的正常量
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        UIView *view = [[self.view subviews] objectAtIndex:1];
        float width = view.frame.size.width;
        float height = view.frame.size.height;
        CGRect rect = CGRectMake(0.0f,30,width,height); //把整个view 往上提，肯定要用负数 y   注意self.view 的y 是从20开始的，即StautsBarHeight
        
        view.frame = rect;
        
        [UIView commitAnimations];
    }
    
    i_offset = 0;
}

- (float) getAllY:(UIView*) view{
    if (view == self.view){
        return 0;
    }
    float all = view.frame.origin.y;
    if ([view superview] != nil){
        all += [self getAllY:[view superview]];
    }
    return all;
}

@end
