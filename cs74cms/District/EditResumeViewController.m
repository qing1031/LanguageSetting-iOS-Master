//
//  PublicResumeViewController.m
//  cs74cms
//
//  Created by lyp on 15/5/13.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EditResumeViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "MutableMenuViewController.h"
#import "IntruduceViewController.h"
#import "ITF_Other.h"
#import "T_category.h"

@interface EditResumeViewController ()<UITextFieldDelegate, EduDelegate,MutableMenuDelegate, IntruduceDelegate>{
    int selected;//标记选中了哪个
    
    
    UIButton *menBut;
    UIButton *womenBut;
    
    UIDatePicker *datePicker;
    
    NSMutableArray *array;
    NSArray *tixin;
    NSMutableArray *subMenuArray;
    NSMutableArray *oldInfoArray;
    
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
    
    T_Resume *resume;
    int Mid;
}

@end

@implementation EditResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0){
        [self registerKeyBoardNotification];
    }
}
- (void) setMid:(int)tMid{
    Mid = tMid;
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <=  0 && Mid > 0){
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            resume = [[[ITF_Other alloc] init] simpleResumeOperationByID:Mid andResume:nil];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                if (resume != nil){
                    [self getInfo];
                    [self drawView];
                }

            });
        });
            
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"编辑微简历", @"Edit your resume")];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getInfo{
    oldInfoArray = [[NSMutableArray alloc] init];

    
    if (resume.fullname != nil)
        [oldInfoArray addObject:resume.fullname];
    else
        [oldInfoArray addObject:@""];
    
    if (resume.sex == 1)
        menBut.selected = YES;
    else{
        womenBut.selected = YES;
    }
    [oldInfoArray addObject:@""];
    
    if (resume.birthdate != nil)
        [oldInfoArray addObject:resume.birthdate];
    else
        [oldInfoArray addObject:@""];
    
    if (resume.experience_cn != nil)
        [oldInfoArray addObject:resume.experience_cn];
    else
        [oldInfoArray addObject:@""];
    
    if (resume.intention_jobs != nil)
        [oldInfoArray addObject:resume.intention_jobs];
    else
        [oldInfoArray addObject:@""];

    if (resume.district_cn != nil)
        [oldInfoArray addObject:resume.district_cn];
    else
        [oldInfoArray addObject:@""];

    if (resume.addtime != nil)
        [oldInfoArray addObject:resume.addtime];
    else
        [oldInfoArray addObject:@""];
    

    [oldInfoArray addObject:@"0"];
    
    if (resume.specialty != nil)
        [oldInfoArray addObject:[NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"),resume.specialty.length]];
    else
        [oldInfoArray addObject:@""];
    
    if (resume.telephone != nil)
        [oldInfoArray addObject:resume.telephone];
    else
        [oldInfoArray addObject:@""];
    
    if (resume.email != nil)
        [oldInfoArray addObject:resume.email];
    else
        [oldInfoArray addObject:@""];
}

- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    array = [[NSMutableArray alloc] init];
    float cellHeight = ([InitData Height] - 16) / 11;
    float height = 0;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"姓    名", @"Name"), MYLocalizedString(@"性    别", @"Gender"), MYLocalizedString(@"出生日期", @"Birthday"), MYLocalizedString(@"工作经验", @"Work experience"), MYLocalizedString(@"意向职位", @"Intentional position"), MYLocalizedString(@"意向地区", @"Intentional district"), MYLocalizedString(@"有效期", @"Validity period"), MYLocalizedString(@"延长时间", @"Extended time"), MYLocalizedString(@"自我描述", @"Self description"), MYLocalizedString(@"联系电话", @"Phone number"),MYLocalizedString(@"管理密码", @"Manage password"), nil];
    tixin = [[NSArray alloc] initWithObjects:MYLocalizedString(@"请输入姓名", @"Please enter your name"), MYLocalizedString(@"请选择性别", @"Please select gender"),MYLocalizedString(@"请选择出生日期", @"Please select your birthday"), MYLocalizedString(@"请选择工作经验", @"Please select work experience"), MYLocalizedString(@"请输入意向职位", @"Please enter a position of intention"), MYLocalizedString(@"请选择意向地区", @"Please select the intended area"), MYLocalizedString(@"请选择有效期", @"Please select a valid period"), MYLocalizedString(@"请输入延长时间", @"Please enter the extension time"), MYLocalizedString(@"请输入自我描述", @"Please enter a self description"), MYLocalizedString(@"请输入联系电话", @"Please enter phone number"), MYLocalizedString(@"请输入管理密码", @"Please enter management password"), nil];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        int t = i + 1;
        
        if (i == 9 || i == 10){
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, [InitData Width], 8)];
            sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
            [bgView addSubview:sep];
            height += 8;
        }
        else{
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, height - 1, [InitData Width] - 30, 1)];
            sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
            [bgView addSubview:sep];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = t;
        [bgView addSubview:view];
        
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        if (i == 6){
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = resume.addtime;
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            
            [array addObject:label2];
        }
        
        else if (i == 1){
            menBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [menBut setImage:[UIImage imageNamed:@"menUnselect.png"] forState:UIControlStateNormal];
            [menBut setImage:[UIImage imageNamed:@"menSelected.png"] forState:UIControlStateSelected];
            menBut.tag = 1001;
            [menBut addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [menBut setFrame:CGRectMake([InitData Width] - 106, (cellHeight - 20) / 2, 35, 20)];
            [menBut setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [view addSubview:menBut];
            
            UILabel *nan = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 85, (cellHeight - 15) / 2, 15, 15)];
            nan.text = @"男";
            nan.textColor = color2;
            nan.font = font2;
            [view addSubview:nan];
            
            [array addObject:menBut];
            
            
            
            womenBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [womenBut setImage:[UIImage imageNamed:@"womenUnselect.png"] forState:UIControlStateNormal];
            [womenBut setImage:[UIImage imageNamed:@"womenSelected"] forState:UIControlStateSelected];
            womenBut.tag = 1002;
            [womenBut addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [womenBut setFrame:CGRectMake([InitData Width] - 55, (cellHeight - 20) / 2, 32, 20)];
            [womenBut setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [view addSubview:womenBut];
            
            UILabel *nv = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 35, (cellHeight - 15) / 2, 15, 15)];
            nv.text = @"女";
            nv.textColor = color2;
            nv.font = font2;
            [view addSubview:nv];
            
            if (resume.sex == 1)
                menBut.selected = YES;
            else
                womenBut.selected = YES;
        }
        else if (i == 0 || i == 4 || i == 7 || i == 9 || i== 10){
            UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            textfield.delegate = self;
            textfield.placeholder = [tixin objectAtIndex:i];
            textfield.font = font2;
            textfield.textAlignment = NSTextAlignmentRight;
            [view addSubview:textfield];
            if (i == 10)
                textfield.secureTextEntry = YES;
            else if (oldInfoArray != nil && [oldInfoArray count] >= i)
                textfield.text = [oldInfoArray objectAtIndex:i];
            
            [array addObject:textfield];
            
            UIButton *imgBut = [UIButton buttonWithType:UIButtonTypeCustom ];
            [imgBut setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [imgBut addTarget:self action:@selector(cancelButClicked:) forControlEvents:UIControlEventTouchUpInside];
            [imgBut setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            imgBut.tag = i + 1;
            [view addSubview:imgBut];
        }
        else{
            if (i == 2){
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker:)];
                recognizer.numberOfTapsRequired = 1;
                [view addGestureRecognizer:recognizer];
            }
            else{
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedThis:)];
                recognizer.numberOfTapsRequired = 1;
                [view addGestureRecognizer:recognizer];
            }
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = [tixin objectAtIndex:i];
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            if (oldInfoArray != nil && [oldInfoArray count] >= i)
                label2.text = [oldInfoArray objectAtIndex:i];
            
            if (i == 3)
                label2.tag = resume.experience;
            
            [array addObject:label2];
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 25) / 2, 20, 25)];
            [view addSubview:img];
        }
        height += cellHeight;
    }
}

#pragma mark event
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

- (void)sexSelected:(UIButton*)but{
    if (but.tag == 1001){//men
        menBut.selected = YES;
        womenBut.selected = NO;
        
    }
    else{
        menBut.selected = NO;
        womenBut.selected = YES;
    }
}

- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
    if (recognizer.view.tag - 1 == 8){
        IntruduceViewController *intro = [[IntruduceViewController alloc] init];
        intro.delegate = self;
        [self.myNavigationController pushAndDisplayViewController:intro];
        [intro setTitle:MYLocalizedString(@"自我描述", @"Self description")];
        if (resume != nil && resume.specialty != nil && ![resume.specialty isEqualToString:@""])
            [intro setContent:resume.specialty];
        return;
    }
    selected = (int) recognizer.view.tag - 1;
    NSString *req;
    switch (selected) {
        case 3:
            req = @"QS_experience";
            break;
        case 5:
            req = @"district";
            break;
        case 6:
            req = @"simple";
            break;
            
        default:
            break;
    }
    if (selected == 5){
        MutableMenuViewController *menu = [[MutableMenuViewController alloc] init];
        [menu setHanshuName:@"district"];
        menu.delegate = self;
        [self.myNavigationController pushAndDisplayViewController:menu];
        return;
    }
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        subMenuArray = [[[ITF_Other alloc] init] classify:req andParentid:0];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            NSMutableArray *tarray = [[NSMutableArray alloc] init];
            for (int i=0; i<[subMenuArray count]; i++){
                T_category *cat = [subMenuArray objectAtIndex:i];
                [tarray addObject:cat.c_name];
            }
            EduViewController *edu = [[EduViewController alloc] init];
            [edu setViewWithNSArray:tarray];
            edu.delegate= self;
            [self.myNavigationController pushAndDisplayViewController:edu];
            
        });
    });
}

#pragma mark delegate
- (void) selectIndex:(int)index{
    T_category *cat = [subMenuArray objectAtIndex:index];
    UILabel *label = [array objectAtIndex:selected];
    label.text = cat.c_name;
    label.tag = cat.c_id;
}
- (void) MutableMenuSelectedThisIdString:(NSString *)c_id andTitleString:(NSString *)str{
    UILabel *label = [array objectAtIndex:selected];
    label.text = str;
    
    NSArray *tarray = [c_id componentsSeparatedByString:@"."];
    if (resume == nil)
        resume = [[T_Resume alloc] init];
    resume.district = [[tarray objectAtIndex:0] intValue];
    resume.sdistrict = [[tarray objectAtIndex:1] intValue];
    resume.district_cn = str;
}
- (void) IntruduceGetContent:(NSString *)contents andGetNum:(NSInteger)num{
    if (resume == nil)
        resume = [[T_Resume alloc] init];
    resume.specialty = contents;
    UILabel *label = [array objectAtIndex:7];
    label.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), num];
}

- (void) cancelButClicked:(UIButton*) but{
    UITextField *textField = [array objectAtIndex:but.tag - 1];
    textField.text = @"";
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
    if (!menBut.selected && !womenBut.selected){
        [InitData netAlert:[tixin objectAtIndex:1]];
        return;
    }
    for (int i=0; i<[array count]; i++){
        if (i == 1)
            continue;
        if (i == 2 || i == 3 || i == 6 || i == 5 || i == 6 || i == 8){
            UILabel *label = [array objectAtIndex:i];
            if ([label.text isEqualToString:[tixin objectAtIndex:i]]){
                [InitData netAlert:[tixin objectAtIndex:i]];
                return;
            }
        }
        else{
            UITextField *text = [array objectAtIndex:i];
            if ([text.text isEqualToString:[tixin objectAtIndex:i]] || [text.text isEqualToString:@""]){
                [InitData netAlert:[tixin objectAtIndex:i]];
                return;
            }
        }
    }
    
    if (resume == nil)
        resume = [[T_Resume alloc] init];
    resume.fullname = ((UILabel*)[array objectAtIndex:0]).text;
    if (menBut.selected){
        resume.sex = 1;
        resume.sex_cn = @"男";
    }
    resume.birthdate = ((UILabel*)[array objectAtIndex:2]).text;
    resume.experience = ((UILabel*)[array objectAtIndex:3]).tag;
    resume.experience_cn = ((UILabel*)[array objectAtIndex:3]).text;
    resume.intention_jobs = ((UILabel*)[array objectAtIndex:4]).text;
    resume.demo = [((UILabel*)[array objectAtIndex:7]).text intValue];
    resume.telephone =((UILabel*)[array objectAtIndex:9]).text;
    resume.email =((UILabel*)[array objectAtIndex:10]).text;
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_Resume *tresume = [[[ITF_Other alloc] init] simpleResumeOperationByID:Mid andResume:resume];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (tresume != nil){
                [self.myNavigationController dismissViewController];
            }
        });
    });
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
