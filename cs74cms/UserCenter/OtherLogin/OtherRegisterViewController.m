//
//  OtherRegisterViewController.m
//  cs74cms
//
//  Created by lyp on 15/7/17.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "OtherRegisterViewController.h"
#import "InitData.h"
#import "EduViewController.h"
#import "ContectUserViewController.h"
#import "ITF_Apply.h"
#import "CreateResumeViewController.h"
#import "EditCompanyViewController.h"

@interface OtherRegisterViewController ()<EduDelegate, UITextFieldDelegate>{
    NSArray *tixin;
    
    NSMutableArray *array;
    int type;
    NSString *openId;
    NSString *nick;
}

@end

@implementation OtherRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewCanBeSee{
    [self.myNavigationController setTitle:MYLocalizedString(@"完善注册信息", @"Improve registration information")];
}
- (void) setType:(int) ttype andOpenID:(NSString*) topenid andNick:(NSString*) tnick{
    type = ttype;
    openId = topenid;
    nick = tnick;
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    float height = 0;
    float cellHeight = 45;
    NSArray *imgArr = [NSArray arrayWithObjects:@"utype.png", @"email.png",@"phone.png",@"pwd.png", nil];
    tixin = [NSArray arrayWithObjects:MYLocalizedString(@"请选择会员类型", @"Please select member type"), MYLocalizedString(@"请输入常用邮箱", @"Please enter a common email"), MYLocalizedString(@"请输入手机号", @"Please enter your phone number"), MYLocalizedString(@"请输入密码", @"Please enter a password"), nil];
    array = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i=0; i<4; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, cellHeight - 1, [InitData Width] - 30, 1)];
        sep.backgroundColor = self.view.backgroundColor;
        [view addSubview:sep];
        
        if (i == 0){
            
            UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 150, cellHeight)];
            textField.font = [UIFont systemFontOfSize:14];
            textField.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
            textField.text = [tixin objectAtIndex:i];
            [view addSubview:textField];
            [array addObject:textField];
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [view addSubview:img];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(utypeClick)];
            recognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:recognizer];
            
        }else{
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 150, cellHeight)];
            textField.font = [UIFont systemFontOfSize:14];
            textField.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
            textField.placeholder = [tixin objectAtIndex:i];
            [view addSubview:textField];
            textField.delegate = self;
            [array addObject:textField];
            
            if (i == 3)
                textField.secureTextEntry = YES;
            
            UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom ];
            [img setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
            [img addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
            img.tag = i + 1;
            [view addSubview:img];
        }
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (cellHeight - 25) / 2, 25, 25)];
        [imgView setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]]];
        [view addSubview:imgView];
        
        height += cellHeight;
    }
    
  //  UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"保存", @"Save") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height + 20, [InitData Width] - 40, 30)];
    [loginBut addTarget:self action:@selector(loginButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    height += 20 + 30 + 20;
    
    UIButton *contect = [UIButton buttonWithType:UIButtonTypeCustom];
    [contect setTitle:MYLocalizedString(@"已有账号,立即绑定>>", @"Existing account, immediate binding") forState:UIControlStateNormal];
    [contect setFrame:CGRectMake([InitData Width] - 20 -130, height, 130, 15)];
    [contect setTitleColor:[UIColor colorWithRed:235./255 green:114./255 blue:61./255 alpha:1] forState:UIControlStateNormal];
    contect.titleLabel.font = [UIFont systemFontOfSize:13];
    [contect addTarget:self action:@selector(contectUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contect];
}


#pragma mark event
- (void) contectUser{
    ContectUserViewController *contect = [[ContectUserViewController alloc] init];
    [self.myNavigationController pushAndDisplayViewController:contect];
    [contect setType:type andOpenID:openId andNick:nick];
}

- (void) cancelClick:(UIButton*) but{
    int index = but.tag - 1;
    UITextField *textfield = [array objectAtIndex:index];
    textfield.text = @"";
}


- (void) loginButClick{
    for (int i=0; i<[array count]; i++){
        UILabel *label = [array objectAtIndex:i];
        if ([label.text isEqualToString:[tixin objectAtIndex:i]]){
            [InitData netAlert:[tixin objectAtIndex:i]];
            return;
        }
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [[[ITF_Apply alloc] init] connectAgencyBytype:type andUId:openId andNick:nick andIdold:NO andUtype:((UILabel*)[array objectAtIndex:0]).tag andUserpwd:((UILabel*)[array objectAtIndex:3]).text andEmail:((UILabel*)[array objectAtIndex:1]).text andMobile:((UILabel*)[array objectAtIndex:2]).text andUsername:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (user != nil &&user.ID > 0){
                user.openID = openId;
                [InitData setUser:user];
                if (user.utype == 2){
                    CreateResumeViewController *info = [[CreateResumeViewController alloc] init];
                    [self.myNavigationController pushAndDisplayViewController:info];
                }
                else{
                    [self.myNavigationController popAndPushViewController:[[EditCompanyViewController alloc] init]];
                }
            }
        });
    });
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void) utypeClick{
    
    EduViewController *edu = [[EduViewController alloc] init];
    [self.myNavigationController pushAndDisplayViewController:edu];
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"企业会员", @"Enterprise member"),MYLocalizedString(@"个人会员", @"Individual member"), nil];
    [edu setViewWithNSArray:arr];
    edu.delegate = self;
}

- (void) selectIndex:(int)index{
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"企业会员", @"Enterprise member"),MYLocalizedString(@"个人会员", @"Individual member"), nil];
    
    UILabel *label = [array objectAtIndex:0];
    label.tag = index + 1;
    label.text = [arr objectAtIndex:index];
    
}
@end
