//
//  InfoViewController.m
//  74cms
//
//  Created by LPY on 15-4-13.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "InfoViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "EduViewController.h"
#import "MutableMenuViewController.h"
#import "UserCenterViewController.h"
//#import "CreateResumeViewController.h"

@interface InfoViewController ()<UITextFieldDelegate, EduDelegate, MutableMenuDelegate>{
    UIButton *menBut;
    UIButton *womenBut;
    
    UIDatePicker *datePicker;
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
    
    int selected;//由哪个页面跳到子类
    
    NSMutableArray *oldInfo;
    NSMutableArray *oldInfoID;
    
    NSMutableArray *subMenuArray;//存放子菜单的选项
    NSMutableArray* array;//存放子菜单选择的控件
    NSArray *tixin;//提示语句
    
    int pid;//简历的id
}

@end

@implementation InfoViewController

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
    
    array = [[NSMutableArray alloc] init];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:bgView];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [InitData Width] - 40, 30)];
    title1.text = @"基本信息";
    title1.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:title1];
    
    float cellHeight = ([InitData Height] - 60 - 30 - 9) / 9;
    float height = 30;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"姓    名", @"Name"), MYLocalizedString(@"性    别", @"Gender"), MYLocalizedString(@"出生日期", @"Birthday"), MYLocalizedString(@"最高学历", @"Highest education"), MYLocalizedString(@"专业类别", @"Major"), MYLocalizedString(@"工作年限", @"work experience"), MYLocalizedString(@"现居住地", @"Current residence"), MYLocalizedString(@"联系电话", @"Phone number"), MYLocalizedString(@"联系邮箱", @"Email"), nil];
    tixin = [[NSArray alloc] initWithObjects:
             MYLocalizedString(@"请输入姓名", @"Please enter your name"), @"",MYLocalizedString(@"请选择出生日期", @"Please select your birthday"), MYLocalizedString(@"请选择学历", @"Please select your education"), MYLocalizedString(@"请选择专业", @"Please select major"), MYLocalizedString(@"请选择工作年限", @"Please select work experience"), MYLocalizedString(@"请选择居住地", @"Please select current residence"), MYLocalizedString(@"请输入联系电话", @"Please enter phone number"), MYLocalizedString(@"请输入邮箱", @"Please enter mail"), nil];
    NSArray *arr2 = tixin;
    //[self getInfo];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<9; i++){
        if (i == 7){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 100, 30)];
            label.text = MYLocalizedString(@"联系方式", @"Contact");
            label.font = title1.font;
            [bgView addSubview:label];
            height += 30;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [bgView addSubview:view];
        
        
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
            [menBut setFrame:CGRectMake([InitData Width] - 106, (cellHeight - 40) / 2, 55, 40)];
            [menBut setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 41)];
            [view addSubview:menBut];
            
            UILabel *nan = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 85, (cellHeight - 15) / 2, 15, 15)];
            nan.text = MYLocalizedString(@"男", @"Man");
            nan.textColor = color2;
            nan.font = font2;
            [view addSubview:nan];
            [array addObject:menBut];

            womenBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [womenBut setImage:[UIImage imageNamed:@"womenUnselect.png"] forState:UIControlStateNormal];
            [womenBut setImage:[UIImage imageNamed:@"womenSelected"] forState:UIControlStateSelected];
            womenBut.tag = 3002;
            [womenBut addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [womenBut setFrame:CGRectMake([InitData Width] - 55, (cellHeight - 40) / 2, 55, 40)];
            [womenBut setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 43)];
            [view addSubview:womenBut];
            
            UILabel *nv = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 35, (cellHeight - 15) / 2, 15, 15)];
            nv.text = MYLocalizedString(@"女", @"Woman");
            nv.textColor = color2;
            nv.font = font2;
            [view addSubview:nv];
            
            if (oldInfo != nil && ![[oldInfo objectAtIndex:i] isEqualToString:@""]){
                if ([[oldInfo objectAtIndex:i] isEqualToString:MYLocalizedString(@"男", @"Man")]) {
                    menBut.selected = YES;
                }
                else{
                    womenBut.selected = YES;
                }
            }
        }
        else if (i == 0 || i == 7 || i == 8){
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            textField.text = [arr2 objectAtIndex:i];
            textField.textColor = color2;
            textField.font = font2;
            textField.delegate = self;
            textField.textAlignment = NSTextAlignmentRight;
            [view addSubview:textField];
            [array addObject:textField];
            
            if (oldInfo != nil && ![[oldInfo objectAtIndex:i] isEqualToString:@""]){
                textField.text = [oldInfo objectAtIndex:i];

            }
            
            
            UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
            [img setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal] ;
            [img setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            [img setFrame:CGRectMake([InitData Width] - 50, (cellHeight - 40) / 2, 40, 40)];
            [img addTarget:self action:@selector(cancelButClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:img];
        }
        else{
            if (i == 2){
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker:)];
                recognizer.numberOfTapsRequired = 1;
                [view addGestureRecognizer:recognizer];
            }
            else{
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSubMenu:)];
                recognizer.numberOfTapsRequired = 1;
                [view addGestureRecognizer:recognizer];
            }
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = [arr2 objectAtIndex:i];
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            [array addObject:label2];
            
            if (oldInfo != nil && ![[oldInfo objectAtIndex:i] isEqualToString:@""]){
                label2.text = [oldInfo objectAtIndex:i];
                label2.tag = (long)[oldInfoID objectAtIndex:i];
            }
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [view addSubview:img];
        }
        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 20, (cellHeight + 1) * 6)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, 30, 20, (cellHeight + 1) * 6)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view2];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, (cellHeight + 1) * 7 + 60, 20, (cellHeight + 1) * 1)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, (cellHeight + 1) * 7 + 60, 20, (cellHeight + 1) * 1)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view4];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0){
        [self registerKeyBoardNotification];
    }
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self getInfo];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"个人资料", @"Personal data")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"保存", @"Save") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}

- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addInfo:(T_Resume*) resume{
    
    if (resume.fullname != nil)
        [oldInfo addObject:resume.fullname];
    else
        [oldInfo addObject:@""];
    
    if (resume.sex_cn != nil)
        [oldInfo addObject:resume.sex_cn];
    else
        [oldInfo addObject:@""];
    
    if (resume.birthdate != nil)
        [oldInfo addObject: resume.birthdate];
    else
        [oldInfo addObject:@""];
    
    if (resume.education_cn != nil)
        [oldInfo addObject:resume.education_cn];
    else
        [oldInfo addObject:@""];
    
    if (resume.major_cn != nil)
        [oldInfo addObject:resume.major_cn];
    else
        [oldInfo addObject:@""];
    
    if (resume.experience_cn)
        [oldInfo addObject:resume.experience_cn];
    else
        [oldInfo addObject:@""];
    
    if (resume.residence_cn!= nil)
        [oldInfo addObject:resume.residence_cn];
    else
        [oldInfo addObject:@""];
    
    if (resume.telephone != nil)
        [oldInfo addObject:resume.telephone];
    else
        [oldInfo addObject:@""];
    
    if (resume.email != nil)
        [oldInfo addObject:resume.email];
    else
        [oldInfo addObject:@""];
    
    [oldInfoID addObject:@""];
    [oldInfoID addObject:[NSNumber numberWithInt:resume.sex]];
    [oldInfoID addObject:@""];
    [oldInfoID addObject:[NSNumber numberWithInt:resume.education]];
    [oldInfoID addObject:[NSNumber numberWithInt:resume.major]];
    [oldInfoID addObject:[NSNumber numberWithInt:resume.experience]];
    [oldInfoID addObject:[NSNumber numberWithInt:resume.residence]];
}
- (void) getInfo{

    oldInfo = [[NSMutableArray alloc] init];
    oldInfoID = [[NSMutableArray alloc] init];
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_Resume *resume;
        if (pid == 0)
            resume = [[[T_Interface alloc] init] personalUserInfo:user.username andUserPwd:user.userpwd andResume:nil];
        else
            resume = [[[T_Interface alloc] init] resumeUserInfo:user.username andUserPwd:user.userpwd andPid:pid andResume:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self addInfo:resume];
            [self drawView];
        });
    });
}

- (void) setPid:(int)tpid{
    pid = tpid;
}

#pragma mark event
- (void) save{
    
    if (!menBut.selected && !womenBut.selected){
        [InitData netAlert:MYLocalizedString(@"请选择性别", @"Please select the gender")];
        return;
    }
    for (int i=0; i<[array count]; i++) {
        if (i == 1)
            continue;
        if (i == 0 || i == 5 || i == 6){
            UITextField *textf = (UITextField*)[array objectAtIndex:i];
         //   NSLog(@"%d", [textf.text isEqualToString:[tixin objectAtIndex:i]]);
            if (![textf.text isEqualToString:@""] && ![textf.text isEqualToString:[tixin objectAtIndex:i]])
                continue;
        }
        else{
        
            UILabel *textf = (UILabel*)[array objectAtIndex:i];
            if (![textf.text isEqualToString:@""])
                continue;
        }
        
        [InitData netAlert:[tixin objectAtIndex:i]];
        return;
    }
    
    NSString *sex = menBut.selected?MYLocalizedString(@"男", @"Man"):MYLocalizedString(@"女", @"Woman");
    
    T_Resume *resume = [[T_Resume alloc] init];
    resume.fullname =((UILabel*)[array objectAtIndex:0]).text;
    
    resume.sex = [sex isEqualToString:MYLocalizedString(@"男", @"Man")]?1:2;
    resume.sex_cn = sex;
    resume.birthdate = ((UILabel*)[array objectAtIndex:2]).text;
    
    resume.education = (int)((UILabel*)[array objectAtIndex:3]).tag;
    resume.education_cn =((UILabel*)[array objectAtIndex:3]).text;
    
    resume.major = (int)((UILabel*)[array objectAtIndex:4]).tag;
    resume.major_cn =((UILabel*)[array objectAtIndex:4]).text;
    
    resume.experience = (int)((UILabel*)[array objectAtIndex:5]).tag;
    resume.experience_cn =((UILabel*)[array objectAtIndex:5]).text;
    
    resume.residence = (int)((UILabel*)[array objectAtIndex:6]).tag;
    resume.residence_cn = ((UILabel*)[array objectAtIndex:6]).text;
    
    resume.telephone =((UITextField*)[array objectAtIndex:7]).text;
    resume.email =((UITextField*)[array objectAtIndex:8]).text;
    
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_Resume *tresume;
        if (pid == 0) {
            tresume = [[[T_Interface alloc] init] personalUserInfo:user.username andUserPwd:user.userpwd andResume:resume];
        }
        else{
            tresume = [[[T_Interface alloc] init] resumeUserInfo:user.username andUserPwd:user.userpwd andPid:pid andResume:resume];
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (tresume == nil)
                return ;
            if ( pid == 0){
                [self.myNavigationController dismissViewController];
                
               // if (user.profile)
               //     [self.myNavigationController pushAndDisplayViewController:[[UserCenterViewController alloc] init]];
              //  else
               //     [self.myNavigationController pushAndDisplayViewController:[[CreateResumeViewController alloc] init]];
            }
            else{
        
                [self.myNavigationController dismissViewController];
            }

        });
    });
    
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
- (void) cancelButClicked:(UIButton*) but{
    UIView *view = but.superview;
    if ([[view subviews] count] > 2){
        UITextField *textfield = [[view subviews] objectAtIndex:2];
        textfield.text = @"";
    }
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
        
        if ([array objectAtIndex:2] != nil) {
            UILabel *label = [array objectAtIndex:2];
            if (![label.text isEqualToString:[tixin objectAtIndex:2]]){
                NSString *dateStr = [NSString stringWithFormat:@"%@-01-01", label.text];
                NSDate *date = [InitData dateFromString:dateStr];
                [datePicker setDate:date];
            }
        }
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

- (void) selectSubMenu:(UITapGestureRecognizer*) recognizer{
    NSString *req;
    selected = (int)recognizer.view.tag - 1;
    if (recognizer.view.tag != 7){//工作年限
        switch (recognizer.view.tag) {
            case 4:
                req = @"QS_education";
                break;
            case 5:
                req = @"QS_major";
                break;
            case 6:
                req = @"QS_experience";
            default:
                break;
        }

        subMenuArray = [[[T_Interface alloc] init] classify:req andParentid:0];
        
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for (int i=0; i<[subMenuArray count]; i++) {
            T_category *cat = [subMenuArray objectAtIndex:i];
            [arr addObject:cat.c_name];
        }
        
        EduViewController *edu = [[EduViewController alloc] init];
        [edu setViewWithNSArray:arr];
        edu.delegate = self;
        
        [self.myNavigationController pushAndDisplayViewController:edu];
        return;
    }
    
    req = @"district";
    MutableMenuViewController *mutab = [[MutableMenuViewController alloc] init];
    mutab.delegate = self;
    [mutab setHanshuName:req];
    [self.myNavigationController pushAndDisplayViewController:mutab];
    
}


#pragma mark delegate
//edudelagate
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

- (void) MutableMenuSelectedThis:(int)c_id andString:(NSString *)str{
    UILabel *label = [array objectAtIndex:selected];
    label.text = str;
    label.tag = c_id;
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
    
    UIView *view = [[self.view subviews] objectAtIndex:0];
    
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    if(i_offset > 0)
    {
        CGRect rect = CGRectMake(0.0f,-i_offset,width,height); //把整个view 往上提，肯定要用负数 y
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
        UIView *view = [[self.view subviews] objectAtIndex:0];
        float width = view.frame.size.width;
        float height = view.frame.size.height;
        CGRect rect = CGRectMake(0.0f,0,width,height); //把整个view 往上提，肯定要用负数 y   注意self.view 的y 是从20开始的，即StautsBarHeight
        
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
