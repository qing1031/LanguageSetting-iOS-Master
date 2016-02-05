//
//  SetPwdViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/18.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SetPwdViewController.h"
#import "InitData.h"
#import "ITF_Apply.h"
#import "CustomAlertView.h"

@interface SetPwdViewController ()<UITextFieldDelegate, CustomAlertViewDelegate>{
    int sign;
    NSString *phone;
    
    UITextField *oneField;
    UITextField *twoField;
}

@end

@implementation SetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setSign:(int) tsign andPhone:(NSString*) tphone{
    sign = tsign;
    phone = tphone;
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] == 0){
        [self drawView];
    }
}

- (void) drawView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 280, 35)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    label.text = MYLocalizedString(@"您已通过邮箱验证，请输入新密码", @"You have verified through the email, please enter a new password") ;
    if (sign == 0)
        label.text = MYLocalizedString(@"您已通过手机号验证，请输入新密码", @"You have verified through the phone number, please enter a new password");
    [self.view addSubview:label];
    
    float height = 45;
    
    
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 35, [InitData Width], height)];
    [View setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:View];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, height)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    label1.text = MYLocalizedString(@"新密码", @"New password");
    [View addSubview:label1];
    
    oneField = [[UITextField alloc] initWithFrame:CGRectMake(105, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    oneField.tag = 300;
    oneField.delegate = self;
    oneField.backgroundColor = [UIColor whiteColor];
    oneField.placeholder = MYLocalizedString(@"请输入已注册的邮箱", @"Please enter a registered email address");
    oneField.secureTextEntry = YES;
    oneField.delegate = self;
    oneField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    oneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    oneField.font = [UIFont systemFontOfSize:oneField.frame.size.height / 2.8];
    [View addSubview:oneField];
    
    UIButton *cancelBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut1 addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut1 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [View addSubview:cancelBut1];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(20, height + 34, [InitData Width] - 40, 1)];
    sep.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:sep];
    
    UIView *View2 = [[UIView alloc] initWithFrame:CGRectMake(0, 35 + height, [InitData Width], height)];
    [View2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:View2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, height)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    label2.text = MYLocalizedString(@"确认密码", @"Confirm password");
    [View2 addSubview:label2];
    
    twoField = [[UITextField alloc] initWithFrame:CGRectMake(105, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    twoField.tag = 300;
    twoField.delegate = self;
    twoField.backgroundColor = [UIColor whiteColor];
    twoField.placeholder = MYLocalizedString(@"请输入已注册的邮箱", @"Please enter a registered email address");
    twoField.secureTextEntry = YES;
    twoField.delegate = self;
    twoField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    twoField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    twoField.font = [UIFont systemFontOfSize:oneField.frame.size.height / 2.8];
    [View2 addSubview:twoField];
    
    UIButton *cancelBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut2 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut2 addTarget:self action:@selector(cancelClick2) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut2 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [View2 addSubview:cancelBut2];
    
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"重置密码", @"Reset password") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 2 + 55, [InitData Width] - 40, 35)];
    [loginBut addTarget:self action:@selector(submitButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
}

- (void) submitButClick{
    if ([oneField.text isEqualToString:@""]){
        [InitData netAlert:MYLocalizedString(@"密码不能为空!", @"Password can not be empty!")];
        return;
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        BOOL res =  [[[ITF_Apply alloc] init] setPwdByType:sign andPhone:phone andCode:nil andPwd:oneField.text andPwd_two:twoField.text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (res){
                CustomAlertView *alert = [[CustomAlertView alloc] init];
                NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"确定", @"Done"), nil];
                [alert setDirection:Y andTitle:MYLocalizedString(@"提示", @"Prompt") andMessage:MYLocalizedString(@"重置密码成功， 请重新登录", @"Reset password successful, please re login") andArray:arr];
                alert.delegate = self;
                [self.view addSubview:alert];
            }
        });
    });
}

- (void) cancelClick{
    oneField.text = @"";
}
- (void) cancelClick2{
    twoField.text = @"";
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma  mark delegate
- (void) customAlertViewbuttonClicked:(int)index{
    if (index == 0){
        [self.myNavigationController popViewControllers:2];
    }
}

@end
