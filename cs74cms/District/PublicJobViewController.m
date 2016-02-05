//
//  PublicResumeViewController.m
//  cs74cms
//
//  Created by lyp on 15/5/13.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "PublicJobViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "MutableMenuViewController.h"
#import "IntruduceViewController.h"
#import "ITF_Other.h"
#import "T_category.h"

@interface PublicJobViewController ()<UITextFieldDelegate, EduDelegate, MutableMenuDelegate,IntruduceDelegate>{
    int selected;//标记选中了哪个
    
    NSArray *tixin;
    NSMutableArray *array;
    NSMutableArray *oldArray;
    NSMutableArray *subMenuArray;
    
    T_AddJob *job;
    int Mid;
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
}

@end

@implementation PublicJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0){

        [self registerKeyBoardNotification];
    }
}
- (void) setMid:(int) tMid{
    Mid = tMid;
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <=  0){
        
        if (Mid > 0){
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            job = [[[ITF_Other alloc] init] simpleZhaopinOperationByID:Mid andAddjob:nil];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addData];
                [InitData haveLoaded:self.view];
                [self drawView];
                [self.myNavigationController setTitle:MYLocalizedString(@"发布微招聘", @"Release micro recruit")];
            });
        });
        }
        else{
            [self drawView];
            [self.myNavigationController setTitle:MYLocalizedString(@"编辑微招聘", @"Edit micro recruit")];
        }
    }
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
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
- (void) addData{
    oldArray = [[NSMutableArray alloc] init];
    
    if (job.companyname != nil) {
        [oldArray addObject:job.companyname];
    }
    else
        [oldArray addObject:@""];
    
    if (job.jobs_name != nil) {
        [oldArray addObject:job.jobs_name];
    }
    else
        [oldArray addObject:@""];
    
    if (job.amount >= 0) {
        [oldArray addObject:[NSString stringWithFormat:@"%d",job.amount]];
    }
    else
        [oldArray addObject:@""];
    
    if (job.district_cn != nil) {
        [oldArray addObject:job.district_cn];
    }
    else
        [oldArray addObject:@""];
    
    if (job.days >= 0) {
        [oldArray addObject:[NSString stringWithFormat:@"%d", job.days]];
    }
    else
        [oldArray addObject:@""];
    
    if (job.contents != nil) {
        NSString *str = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu个字", @"Already input %lu words"), job.contents.length];
        [oldArray addObject:str];
    }
    else
        [oldArray addObject:@""];
    
    if (job.contact != nil) {
        [oldArray addObject:job.contact];
    }
    else
        [oldArray addObject:@""];
    
    if (job.telephone != nil) {
        [oldArray addObject:job.telephone];
    }
    else
        [oldArray addObject:@""];
    
    if (job.email != nil) {
        [oldArray addObject:job.email];
    }
    else
        [oldArray addObject:@""];
}

- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    float cellHeight = ([InitData Height] - 16) / 11;
    float height = 0;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"公司名称", @"Company name"), MYLocalizedString(@"职位名称", @"Position name"), MYLocalizedString(@"招聘人数", @"Recruitment number"), MYLocalizedString(@"工作地区", @"Working area"), MYLocalizedString(@"有效期", @"Validity period"), MYLocalizedString(@"任职要求", @"Job requirements"), MYLocalizedString(@"联系人", @"Contacts"), MYLocalizedString(@"联系电话", @"Contact phone"),MYLocalizedString(@"管理密码", @"Manage password"), nil];
    tixin = [[NSArray alloc] initWithObjects:MYLocalizedString(@"请输入企业名称", @"Please enter company name"), MYLocalizedString(@"职位名称", @"Position name"), MYLocalizedString(@"请输入招聘人数", @"Please enter recruitment number"), MYLocalizedString(@"请选择工作地区", @"Please select working area"), MYLocalizedString(@"请选择有效期", @"Please select validity period"), MYLocalizedString(@"请填写任职要求", @"Please enter job requirements"), MYLocalizedString(@"请填写联系人", @"Please enter contacts"), MYLocalizedString(@"请填写联系电话", @"Please enter contact phone"),MYLocalizedString(@"请输入管理密码", @"Please enter manage password"), nil];
    array = [[NSMutableArray alloc] init];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        int t = i + 1;
        
        if (i == 6 ||i == 8){
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

        if (i == 3 || i == 4 || i == 5) {
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedThis:)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            label2.text = [tixin objectAtIndex:i];
            label2.textColor = color2;
            label2.font = font2;
            label2.textAlignment = NSTextAlignmentRight;
            [view addSubview:label2];
            if (oldArray != nil)
                label2.text = [oldArray objectAtIndex:i];
            
            [array addObject:label2];
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 25) / 2, 20, 25)];
            [view addSubview:img];
        }
        else{
            UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            textfield.delegate = self;
            textfield.placeholder = [tixin objectAtIndex:i];
            textfield.font = font2;
            textfield.textAlignment = NSTextAlignmentRight;
            [view addSubview:textfield];
            if (i == 8)
                textfield.secureTextEntry = YES;
            if (oldArray != nil)
                textfield.text = [oldArray objectAtIndex:i];
            if (i == 7 && job != nil){
                textfield.userInteractionEnabled = job.demo == 1?YES:NO;
            }
            
            [array addObject:textfield];
            
            UIButton *imgBut = [UIButton buttonWithType:UIButtonTypeCustom ];
            [imgBut setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [imgBut addTarget:self action:@selector(cancelButClicked:) forControlEvents:UIControlEventTouchUpInside];
            [imgBut setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [view addSubview:imgBut];
        }

        height += cellHeight;
    }
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, [InitData Width], [InitData Height] - height)];
    sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [self.view addSubview:sep];
}

#pragma mark event
- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
    selected = (int) recognizer.view.tag - 1;
    switch (selected) {
        case 3:{
            MutableMenuViewController *menu = [[MutableMenuViewController alloc] init];
            [menu setHanshuName:@"district"];
            menu.delegate = self;
            [self.myNavigationController pushAndDisplayViewController:menu];
        }
            break;
        case 4:{
            
            [InitData isLoading:self.view];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //后台代码
                subMenuArray = [[[ITF_Other alloc] init] classify:@"simple" andParentid:0];
                
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
            break;
        case 5:{
            IntruduceViewController *intro = [[IntruduceViewController alloc] init];
            intro.delegate = self;
            [self.myNavigationController pushAndDisplayViewController:intro];
            [intro setTitle:MYLocalizedString(@"任职要求", @"Job requirements")];
            if (job != nil && job.contents != nil && ![job.contents isEqualToString:@""])
                [intro setContent:job.contents];
        }
            break;
            
        default:
            break;
    }
}

- (void) save:(UIButton*) but{
    for (int i=0; i<[array count]; i++){
        if (i == 3 || i == 4 || i == 5){
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
    
    if (job == nil)
        job = [[T_AddJob alloc] init];
    job.companyname = ((UILabel*)[array objectAtIndex:0]).text;
    job.jobs_name = ((UILabel*)[array objectAtIndex:1]).text;
    
    job.amount = [((UILabel*)[array objectAtIndex:2]).text intValue];
   // job.days = [((UILabel*)[array objectAtIndex:4]).text intValue];
    job.contact =((UILabel*)[array objectAtIndex:6]).text;
    job.telephone =((UILabel*)[array objectAtIndex:7]).text;
    job.email =((UILabel*)[array objectAtIndex:8]).text;
    
    [InitData isLoading:self.view];
    but.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_AddJob *tjob = [[[ITF_Other alloc] init] simpleZhaopinOperationByID:Mid andAddjob:job];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            but.userInteractionEnabled = YES;
            if (tjob != nil){
                [self.myNavigationController dismissViewController];
            }
        });
    });

}
- (void) cancelButClicked:(UIButton*) but{
    UIView *view = but.superview;
    if ([[view subviews] count] > 2){
        UITextField *textfield = [[view subviews] objectAtIndex:1];
        textfield.text = @"";
    }
}

#pragma mark delegate

- (void) selectIndex:(int)index{
    if (job == nil)
        job = [[T_AddJob alloc] init];
    T_category *cat = [subMenuArray objectAtIndex:index];
    job.days = cat.c_id;
    UILabel *label = [array objectAtIndex:4];
    label.text = cat.c_name;
}

- (void) MutableMenuSelectedThisIdString:(NSString *)c_id andTitleString:(NSString *)str{
    if (job == nil)
        job = [[T_AddJob alloc] init];
    if (selected == 3) {
        NSArray *idarr = [c_id componentsSeparatedByString:@"."];
        job.district = [[idarr objectAtIndex:0] intValue];
        job.sdistrict = [[idarr objectAtIndex:1] intValue];
        job.district_cn = str;
    }
    
    UILabel *label = [array objectAtIndex:3];
    label.text = str;
}
- (void) IntruduceGetContent:(NSString *)contents andGetNum:(NSInteger)num{
    UILabel *label = [array objectAtIndex:5];
    label.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), num];
    if (job == nil)
        job = [[T_AddJob alloc] init];
    job.contents = contents;
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
