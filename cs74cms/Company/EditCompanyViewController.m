//
//  EditCompanyViewController.m
//  74cms
//
//  Created by lyp on 15/5/5.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EditCompanyViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "IntruduceViewController.h"
#import "CompanyCenterViewController.h"
#import "ITF_Company.h"
#import "T_category.h"
#import "MutableMenuViewController.h"

@interface EditCompanyViewController ()<UITextFieldDelegate, EduDelegate,IntruduceDelegate, EduDelegate, MutableMenuDelegate>{
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
    
    int selected;//由哪个页面跳到子类
    
    NSMutableArray *oldInfo;
    NSMutableArray *oldInfoID;
    
    NSMutableArray *subMenuArray;//存放子菜单的选项
    NSMutableArray* array;//存放子菜单选择的控件
    NSArray *tixin;//提示语句
    
    T_Company *company;
}

@end

@implementation EditCompanyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0){

        [self getInfo];
    }
    
    [self registerKeyBoardNotification];
}
- (void) setEditable:(BOOL) able{
    UITextField *text = [array objectAtIndex:0];
    text.userInteractionEnabled = able;
}

- (void) viewCanBeSee{

    [self.myNavigationController setTitle:MYLocalizedString(@"编辑企业资料", @"Editing enterprise information")];
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

- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    bgView.backgroundColor = [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1];
    [self.view addSubview:bgView];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [InitData Width] - 40, 30)];
    title1.text = MYLocalizedString(@"基本信息", @"Base information");
    title1.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:title1];
    
    float cellHeight = ([InitData Height] - 60 - 9) / 10;
    float height = 30;
    array = [[NSMutableArray alloc] init];
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"企业名称", @"Enterprise name"), MYLocalizedString(@"企业性质", @"Enterprise nature"), MYLocalizedString(@"所属行业", @"Owned industry"), MYLocalizedString(@"企业规模", @"Enterprise scale"), MYLocalizedString(@"所在地区", @"Local area"), MYLocalizedString(@"详细地址", @"Address in detail"), MYLocalizedString(@"公司简介", @"Company profile"), MYLocalizedString(@"联系人", @"Contacts"), MYLocalizedString(@"联系电话", @"Phone number"), MYLocalizedString(@"联系邮箱", @"Email"), nil];
    tixin = [[NSArray alloc] initWithObjects:MYLocalizedString(@"请输入企业名称", @"Please enter the enterprise name"), MYLocalizedString(@"请输入企业性质", @"Please enter enterprise nature"), MYLocalizedString(@"请输入企业所属行业", @"Please enter owned industry"), MYLocalizedString(@"请输入企业规模", @"Please enter enterprise scale"), MYLocalizedString(@"请输入企业所在地", @"Please enter local area"), MYLocalizedString(@"请输入企业详细地址", @"Please enter address in detail"), MYLocalizedString(@"请输入企业介绍", @"Please enter company profile"), MYLocalizedString(@"请输入联系人", @"Please enter contacts"), MYLocalizedString(@"请输入联系电话", @"Please enter phone number"), MYLocalizedString(@"请输入邮箱", @"Please enter email"), nil];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<10; i++){
        int t = i + 1;

        if (i == 7){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 100, 30)];
            label.text = MYLocalizedString(@"联系电话", @"Phone number");
           // [label setBackgroundColor:[UIColor redColor]];
            label.font = title1.font;
            [bgView addSubview:label];
            height += 30;
            //view.tag += 1;//有问题
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = t;
        [bgView addSubview:view];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cellHeight - 10) / 2, 10, 10)];
        [imgView setImage:[UIImage imageNamed:@"asterisk.png"]];
        [view addSubview:imgView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];

        if (i == 0 || i == 5 || i == 7 || i == 8 || i== 9){
            UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
            textfield.delegate = self;
            textfield.placeholder = [tixin objectAtIndex:i];
            textfield.font = font2;
            textfield.textAlignment = NSTextAlignmentRight;
            [view addSubview:textfield];
            [array addObject:textfield];
            if (oldInfo != nil)
                textfield.text = [oldInfo objectAtIndex:i];
            
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
            if (oldInfo!= nil){
                label2.text = [oldInfo objectAtIndex:i];
                label2.tag = [[oldInfoID objectAtIndex:i] intValue];
            }
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 25) / 2, 20, 25)];
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
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, (cellHeight + 1) * 9 - 3, 20, (cellHeight + 1) * 2)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, (cellHeight + 1) * 9 - 3, 20, (cellHeight + 1) * 2)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view4];
}

- (void) addInfo:(T_Company*) data{
    
    oldInfo = [[NSMutableArray alloc] init];
    oldInfoID = [[NSMutableArray alloc] init];
    
    
    if (data.companyname != nil)
        [oldInfo addObject:data.companyname];
    else
        [oldInfo addObject:@""];
    
    if (data.nature_cn != nil)
        [oldInfo addObject:data.nature_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.trade_cn != nil)
        [oldInfo addObject: data.trade_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.scale_cn != nil)
        [oldInfo addObject:data.scale_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.district_cn != nil)
        [oldInfo addObject:data.district_cn];
    else
        [oldInfo addObject:@""];
    
    if (data.address != nil)
        [oldInfo addObject:data.address];
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
  
    [oldInfoID addObject:[NSNumber numberWithInt:data.trade]];
    [oldInfoID addObject:[NSNumber numberWithInt:data.scale]];
    [oldInfoID addObject:[NSNumber numberWithInt:data.sdistrict]];
    [oldInfoID addObject:@""];
    [oldInfoID addObject:@""];
}

- (void) getInfo{
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];

        if (user.profile)//为0 为没有完善
            company = [[[ITF_Company alloc] init] companyProfileByUser:user andCompany:nil];
       // else
        //    company = [[[ITF_Company alloc] init] companyProfileByUser:user andCompany:company];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (company != nil) {
                [self addInfo:company];
            }
            [self drawView];
        });
    });
}




- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
    selected = (int)recognizer.view.tag - 1;
    
    if (selected == 6){
        IntruduceViewController *intru = [[IntruduceViewController alloc] init];
        [self.myNavigationController pushAndDisplayViewController:intru];
        intru.delegate = self;
        if (company != nil &&  company.contents != nil && ![company.contents isEqualToString:@""])
            [intru setContent:company.contents];
        return;
    }
    NSString *req;
    
    if (selected != 4){
        switch (selected) {
            case 1:
                req = @"QS_company_type";
                break;
            case 2:
                req =@"QS_trade";
                break;
            case 3:
                req = @"QS_scale";
                break;
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
            });
        });
        
        return;
    }
    req = @"district";

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
    BOOL sing = NO;
    if (company != nil && company.ID > 0)
        sing = YES;
    for (int i=0; i<[array count]; i++) {
        if (i == 0 || i == 5 || i == 7 || i==8 || i == 9){
            UITextField *textf = (UITextField*)[array objectAtIndex:i];
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
    

    if (company == nil)
        company = [[T_Company alloc] init];
    company.companyname = ((UITextField*)[array objectAtIndex:0]).text;
    company.nature = ((UILabel*)[array objectAtIndex:1]).tag;
    company.nature_cn = ((UILabel*)[array objectAtIndex:1]).text;
    company.trade = ((UILabel*)[array objectAtIndex:2]).tag;
    company.trade_cn = ((UILabel*)[array objectAtIndex:2]).text;
    company.scale = ((UILabel*)[array objectAtIndex:3]).tag;
    company.scale_cn = ((UILabel*)[array objectAtIndex:3]).text;
    //company.sdistrict = ((UILabel*)[array objectAtIndex:4]).tag;
    //company.district_cn = ((UILabel*)[array objectAtIndex:4]).text;
    company.address = ((UITextField*)[array objectAtIndex:5]).text;

    company.contact = ((UITextField*)[array objectAtIndex:7]).text;
    company.telephone = ((UITextField*)[array objectAtIndex:8]).text;
    company.email = ((UITextField*)[array objectAtIndex:9]).text;
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_Company *tmp = [[[ITF_Company alloc] init] companyProfileByUser:[InitData getUser] andCompany:company];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (tmp != nil){
                if  (sing){
                    [self.myNavigationController dismissViewController];
                }else
                    [self.myNavigationController popAndPushViewController:[[CompanyCenterViewController alloc] init]];
                T_User *user = [InitData getUser];
                user.profile = YES;
                [InitData setUser:user];
            }
        });
    });
}

#pragma mark delegate
- (void) selectIndex:(int)index{
    if ([array count] > selected){
        UILabel *label = [array objectAtIndex:selected];
        T_category *cat = [subMenuArray objectAtIndex:index];
        label.text = cat.c_name;
        label.tag = cat.c_id;
    }
}

- (void) MutableMenuSelectedThisIdString:(NSString *)c_id andTitleString:(NSString *)str{
    NSArray *tarray = [c_id componentsSeparatedByString:@"."];
    UILabel *label = [array objectAtIndex:selected];
    label.text = str;
    //label.tag = c_id;
    
    if (company == nil)
        company = [[T_Company alloc] init];
    if ([tarray count] >= 2){
        company.district_cn = str;
        company.district = [[tarray objectAtIndex:0] intValue];
        company.sdistrict = [[tarray objectAtIndex:1] intValue];
    }
}

- (void) IntruduceGetContent:(NSString *)contents andGetNum:(NSInteger)num{
    
    if (company == nil){
        company =[[T_Company alloc] init];
    }
    UILabel *label = [array objectAtIndex:6];
    label.text = [NSString stringWithFormat:MYLocalizedString(@"已输入%lu字", @"Already input %lu words"), num];
    company.contents = contents;
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
