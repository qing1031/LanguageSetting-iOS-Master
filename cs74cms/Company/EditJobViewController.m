//
//  PublishViewController.m
//  74cms
//
//  Created by lyp on 15/5/7.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EditJobViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "IntruduceViewController.h"
#import "T_AddJob.h"
#import "MutableMenuViewController.h"
#import "ITF_Company.h"
#import "T_category.h"

@interface EditJobViewController ()<UITextFieldDelegate, EduDelegate, IntruduceDelegate, MutableMenuDelegate>{
    int selected;//标记选中了哪个
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
    
    NSMutableArray *array;
    NSArray *tixin;
    NSMutableArray *subMenuArray;
    
    NSMutableArray *oldInfo;
    NSMutableArray *oldInfoID;
    
    int Jid;
    T_AddJob *job;
}

@end

@implementation EditJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    i_offset = 0;    //默认偏移量为0
    i_textFieldY = 0;
    i_textFieldHeight = 0;
    
    //注册键盘监听消息
    [self registerKeyBoardNotification];

}
- (void) setJid:(int) jid{
    Jid = jid;

}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        job = [[[ITF_Company alloc] init] editJobsByUser:[InitData getUser] andJid:Jid AddJob:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (job != nil){
                [self addInfo:job];
                [self drawView];
            }
        });
    });
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"修改职位", @"Change position")];
    
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


- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];

    UIScrollView *content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [content setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [content setShowsHorizontalScrollIndicator:NO];
    [content setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:content];
    
    float cellHeight = 40;
    float height = 0;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"职位名称", @"Position name"), MYLocalizedString(@"职位性质", @"Position nature"), MYLocalizedString(@"职位类别", @"Job category"), MYLocalizedString(@"招聘人数", @"Recruitment number"), MYLocalizedString(@"工作地区", @"Working area"), MYLocalizedString(@"有效时间", @"Effective time"),
                    MYLocalizedString(@"薪资待遇", @"Salary"),MYLocalizedString(@"学历要求", @"Education requirements"), MYLocalizedString(@"工作经验", @"Work experience"), MYLocalizedString(@"联系人", @"Contacts"), MYLocalizedString(@"联系电话", @"Contact phone"),MYLocalizedString(@"联系邮箱", @"Email"), nil];
    tixin = [[NSArray alloc] initWithObjects:MYLocalizedString(@"请输入职位名称", @"Please enter position name"), MYLocalizedString(@"请选择职位性质", @"Please select position nature"), MYLocalizedString(@"请选择招聘职位", @"Please select job category"), MYLocalizedString(@"请输入招聘人数", @"Please enter recruitment number"), MYLocalizedString(@"请选择工作地区", @"Please select working area"), MYLocalizedString(@"请选择有效期", @"Please select validity period"), MYLocalizedString(@"请选择薪资待遇", @"Please select salary"),  MYLocalizedString(@"请选择学历", @"Please select education requirements"), MYLocalizedString(@"请选择工作经验", @"Please select work experience"),  MYLocalizedString(@"请输入职位描述", @"Please enter job description"), MYLocalizedString(@"请填写联系人", @"Please enter contacts"), MYLocalizedString(@"请填写联系电话", @"Please enter contact phone"),MYLocalizedString(@"请输入邮箱", @"Please enter email"), nil];
    array = [[NSMutableArray alloc] init];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        int t = i + 1;
        
        if (i == 7 || i==9 || i==10){
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 5)];
            [sep setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
            [content addSubview:sep];
            
            height += 5;
        }
        else{
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, height-1, [InitData Width] - 30, 1)];
            [sep setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
            [content addSubview:sep];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = t;
        [content addSubview:view];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cellHeight - 10) / 2, 10, 10)];
        [imgView setImage:[UIImage imageNamed:@"asterisk.png"]];
        [view addSubview:imgView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        if (i == 5){
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = [tixin objectAtIndex:i];
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            [array addObject:label2];
            if (job.olddeadline != nil) {
                label2.text = [oldInfo objectAtIndex:i];
            }
        }
        else if (i == 0 || i == 3 || i== 10 || i == 11 || i== 12){// ||  i == 6
            UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            textfield.delegate = self;
            textfield.placeholder = [tixin objectAtIndex:i];
            textfield.font = font2;
            textfield.textAlignment = NSTextAlignmentRight;
            [view addSubview:textfield];
            [array addObject:textfield];
            if (job != nil){
                textfield.text = [oldInfo objectAtIndex:i];
            }
            
            UIButton *imgBut = [UIButton buttonWithType:UIButtonTypeCustom ];
            [imgBut setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [imgBut addTarget:self action:@selector(cancelButClicked:) forControlEvents:UIControlEventTouchUpInside];
            [imgBut setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [view addSubview:imgBut];
        }
        else{
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedThis:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = [tixin objectAtIndex:i];
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            [array addObject:label2];
            if (job != nil){
                label2.text = [oldInfo objectAtIndex:i];
                label2.tag = [[oldInfoID objectAtIndex:i] intValue];
            }
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [view addSubview:img];
        }
        height += cellHeight;
    }
    [content setContentSize:CGSizeMake([InitData Width], height)];
}

- (void) addInfo:(T_AddJob*) data{
    
    oldInfo = [[NSMutableArray alloc] init];
    oldInfoID = [[NSMutableArray alloc] init];
    
    
    if (data.jobs_name != nil)
        [oldInfo addObject:data.jobs_name];
    else
        [oldInfo addObject:@""];
    
    if (data.nature_cn != nil)
        [oldInfo addObject:data.nature_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.category_cn != nil)
        [oldInfo addObject: data.category_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.amount >= 0)
        [oldInfo addObject:[NSString stringWithFormat:@"%d", data.amount]];
    else
        [oldInfo addObject:@""];
    
    if (data.district_cn != nil)
        [oldInfo addObject:data.district_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.olddeadline != nil){
        NSDate *date = [InitData dateFromNum:data.olddeadline];
        NSString *str = [InitData stringFromDate:date];
        [oldInfo addObject:str];//转换成时间
    }
    else
        [oldInfo addObject:@""];
    
   /* if (data.days >= 0)
        [oldInfo addObject:[NSString stringWithFormat:@"%d",0]];
    else
        [oldInfo addObject:@""];*/
    
    
    if (data.wage_cn != nil)
        [oldInfo addObject:data.wage_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.education_cn != nil)
        [oldInfo addObject:data.education_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.experience_cn != nil)
        [oldInfo addObject:data.experience_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.contents != nil){
        [oldInfo addObject:[NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), [data.contents length]]];
    }
    else
        [oldInfo addObject:@""];
    
    if (data.contact != nil)
        [oldInfo addObject:data.contact];
    else
        [oldInfo addObject:@""];
    
    if (data.telephone != nil)
        [oldInfo addObject:data.telephone];
    else
        [oldInfo addObject:@""];
    
    if (data.email != nil)
        [oldInfo addObject:data.email];
    else
        [oldInfo addObject:@""];
    
    [oldInfoID addObject:@""];
    [oldInfoID addObject:[NSNumber numberWithInt:data.nature]];
    [oldInfoID addObject:[NSNumber numberWithInt:data.category]];
    [oldInfoID addObject:@""];
    [oldInfoID addObject:[NSNumber numberWithInt:data.district]];
    [oldInfoID addObject:@""];
    //[oldInfoID addObject:@""];
    [oldInfoID addObject:[NSNumber numberWithInt:data.wage]];
    [oldInfoID addObject:[NSNumber numberWithInt:data.education]];
    [oldInfoID addObject:[NSNumber numberWithInt:data.experience]];
    [oldInfoID addObject:@""];
}

- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
    selected = (int)recognizer.view.tag - 1;
    
    if (selected == 9){
        IntruduceViewController *intru = [[IntruduceViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:intru];
        intru.delegate = self;
        [intru setTitle:MYLocalizedString(@"职位描述", @"Job description")];
        if (job != nil && job.contents != nil && ![job.contents isEqualToString:@""])
            [intru setContent:job.contents];
        return;
    }
    
    NSString *title;
    NSString *req;
    switch (selected) {
        case 1:
            req = @"QS_jobs_nature";
            title = MYLocalizedString(@"职位性质分类", @"Job nature classification");
           
            break;
        case 2:
            req = @"jobs";
            title = MYLocalizedString(@"职位类别", @"Job category");
            break;
            
        case 4:
            req = @"district";
            title = MYLocalizedString(@"工作地区", @"Working area");
            break;
        case 6:
            req = @"QS_wage";
            title = MYLocalizedString(@"薪资待遇", @"Salary");
            break;
        case 7:
            req = @"QS_education";
            title = MYLocalizedString(@"学历要求", @"Education requirements");
            break;
        case 8:
            req = @"QS_experience";
            title = MYLocalizedString(@"工作经验", @"Work experience");
            break;
            
        default:
            return;
    }
    if (selected == 4 || selected == 2) {
        MutableMenuViewController *mutab = [[MutableMenuViewController alloc] init];
        mutab.delegate = self;
        [mutab setHanshuName:req];
        [self.myNavigationController pushAndDisplayViewController:mutab];
        [mutab setTitle:title];
        return;
    }
    
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        
        subMenuArray = [[[ITF_Company alloc] init] classify:req andParentid:0];
        
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
            [edu setTitle:title];
        });
    });
}

- (void) cancelButClicked:(UIButton*) but{
    UIView *view = but.superview;
    if ([[view subviews] count] > 2){
        UITextField *textfield = [[view subviews] objectAtIndex:2];
        textfield.text = @"";
    }
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) save{
    for (int i=0; i<[array count]; i++) {
        if (i == 5)// || i == 6
            continue;
        if (i == 0 || i == 3 || i == 5 || i==10 || i == 11 || i==12){
            UITextField *textf = (UITextField*)[array objectAtIndex:i];
            if ((i == 3 || i == 5) && ![InitData judgeInt:textf.text]){
                [InitData netAlert:[tixin objectAtIndex:i]];
                return;
            }
            if (![textf.text isEqualToString:@""] && ![textf.text isEqualToString:[tixin objectAtIndex:i]])
                continue;
        }
        else{
            
            UILabel *textf = (UILabel*)[array objectAtIndex:i];
            if (![textf.text isEqualToString:@""] && ![textf.text isEqualToString:[tixin objectAtIndex:i]])
                continue;
        }
        
        [InitData netAlert:[tixin objectAtIndex:i]];
        return;
    }
    if (job == nil)
        job = [[T_AddJob alloc] init];
    
    job.jobs_name = ((UITextField*)[array objectAtIndex:0]).text;
    job.nature = ((UILabel*)[array objectAtIndex:1]).tag;
    job.nature_cn = ((UILabel*)[array objectAtIndex:1]).text;
    job.amount = [((UILabel*)[array objectAtIndex:3]).text intValue];
  //  job.days = [((UILabel*)[array objectAtIndex:6]).text intValue];
  
    job.wage = ((UILabel*)[array objectAtIndex:6]).tag;
    job.wage_cn = ((UILabel*)[array objectAtIndex:6]).text;
    job.education = ((UILabel*)[array objectAtIndex:7]).tag;
    job.education_cn = ((UILabel*)[array objectAtIndex:7]).text;
    job.experience = ((UILabel*)[array objectAtIndex:8]).tag;
    job.experience_cn = ((UILabel*)[array objectAtIndex:8]).text;
    job.contact = ((UILabel*)[array objectAtIndex:10]).text;
    job.telephone = ((UILabel*)[array objectAtIndex:11]).text;
    job.email = ((UILabel*)[array objectAtIndex:12]).text;
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_AddJob *tjob = [[[ITF_Company alloc] init] editJobsByUser:user andJid:Jid AddJob:job];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (tjob != nil)
                [self.myNavigationController dismissViewController];

        });
    });
}

#pragma mark delegate
- (void) selectIndex:(int)index{

    UILabel *label = [array objectAtIndex:selected];
    T_category *cat = [subMenuArray objectAtIndex:index];
    label.text = cat.c_name;
    label.tag = cat.c_id;

}
- (void) MutableMenuSelectedId:(int)c_id andIdString:(NSString *)idString andTitle:(NSString *)title andTitleString:(NSString *)titleString{
    NSArray *tarray = [idString componentsSeparatedByString:@"."];
    if (job == nil)
        job = [[T_AddJob alloc] init];
    if (selected == 4){
        job.district = [[tarray objectAtIndex:0] intValue];
        job.sdistrict = [[tarray objectAtIndex:1] intValue];
        job.district_cn = titleString;
        UILabel *label = (UILabel*)[array objectAtIndex:selected];
        label.text = titleString;
        return;
    }
    job.topclass = [[tarray objectAtIndex:0] intValue];
    job.category = [[tarray objectAtIndex:1] intValue];
    job.subclass = [[tarray objectAtIndex:2] intValue];
    job.category_cn = title;
    UILabel *label = (UILabel*)[array objectAtIndex:selected];
    label.text = title;
}

- (void) IntruduceGetContent:(NSString *)contents andGetNum:(NSInteger)num{
    UILabel *label = [array objectAtIndex:9];
    label.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), (long)num];
    job.contents = contents;
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
