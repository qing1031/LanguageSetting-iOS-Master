//
//  QuickLoginViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/9.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "FindPwdViewController.h"
#import "InitData.h"
#import "ITF_Apply.h"
#import "SetPwdViewController.h"


@interface FindPwdViewController ()<UITextFieldDelegate>{
    UITextField *phoneNumber;
    UITextField *authenticate;
    
    UILabel *timeLab;
    UIButton *getNumber;
    
    int secondsCountDown;
    NSTimer *countDownTimer;
    
    int sign;//0 手机   1邮箱
}

@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] == 0)
        [self drawView];
    [self.myNavigationController setTitle:MYLocalizedString(@"找回密码", @"Retrieve password")];
}
- (void) setSign:(int) tsign{
    sign = tsign;
}
- (void)drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    float height = 45;
    //用户名
    UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    [userNameView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:userNameView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, height)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    label1.text = MYLocalizedString(@"邮箱", @"Email");
    if (sign == 0)
        label1.text = MYLocalizedString(@"手机号", @"Phone number");
    [userNameView addSubview:label1];
    
    phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(105, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    phoneNumber.tag = 300;
    phoneNumber.delegate = self;
    phoneNumber.backgroundColor = [UIColor whiteColor];
    phoneNumber.placeholder = MYLocalizedString(@"请输入已注册的邮箱", @"Please enter a registered email address");
    if (sign == 0)
        phoneNumber.placeholder = MYLocalizedString(@"请输入手机号", @"Please enter your phone number");
    phoneNumber.delegate = self;
    phoneNumber.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumber.font = [UIFont systemFontOfSize:phoneNumber.frame.size.height / 2.8];
    [userNameView addSubview:phoneNumber];
    
    UIButton *cancelBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut1 addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut1 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [userNameView addSubview:cancelBut1];
    
    
    //密码框
    UIView *vuthView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 1, [InitData Width], height)];
    [vuthView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:vuthView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, height)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    label2.text = MYLocalizedString(@"验证码", @"Verification code");
    [vuthView addSubview:label2];
    
    authenticate = [[UITextField alloc] initWithFrame:CGRectMake(105, (height - 40) / 2, [InitData Width] - 180, 40)];
    authenticate.tag = 301;
    authenticate.delegate = self;
    authenticate.backgroundColor = [UIColor whiteColor];
    authenticate.placeholder = MYLocalizedString(@"请输入验证码", @"Please enter the verification code");
    authenticate.delegate = self;
    authenticate.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    authenticate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    authenticate.font = [UIFont systemFontOfSize:authenticate.frame.size.height / 2.8];
    [vuthView addSubview:authenticate];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 105,8, 1, 32)];
    view.backgroundColor = self.view.backgroundColor;
    [vuthView addSubview:view];
    
    
    timeLab = [[UILabel alloc] init];
    timeLab.text = MYLocalizedString(@"获取验证码", @"Get verification code");
    // timeLab.backgroundColor = [UIColor redColor];
    timeLab.textColor = [UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1];
    [timeLab setFrame:CGRectMake([InitData Width] -103, (height - 25) / 2, 88, 25)];
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [vuthView addSubview:timeLab];
    
    getNumber = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // [getNumber setTitle:@"获取验证码" forState:UIControlStateNormal];
    getNumber.backgroundColor = [UIColor clearColor];
    [getNumber setTitleColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1] forState:UIControlStateNormal];
    [getNumber setFrame:CGRectMake([InitData Width] -100, (height - 25) / 2, 80, 25)];
    getNumber.titleLabel.font = [UIFont systemFontOfSize:getNumber.frame.size.height / 1.8];
    [getNumber addTarget:self action:@selector(getNumber:) forControlEvents:UIControlEventTouchUpInside];
    [vuthView addSubview:getNumber];
    
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, height, 20, height + 1)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, height, 20, height + 1)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    //登录按钮
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"下一步", @"Next step") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 2 + 20, [InitData Width] - 40, 35)];
    [loginBut addTarget:self action:@selector(submitButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    
}


#pragma mark delegate
- (void)  cancelClick{
    phoneNumber.text = @"";
}
- (void) submitButClick{
    if ([authenticate.text isEqualToString:@""]){
        [InitData netAlert:MYLocalizedString(@"验证码不能为空!", @"Verification code cannot be empty!")];
        return;
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        BOOL res =  [[[ITF_Apply alloc] init] setPwdByType:sign andPhone:nil andCode:authenticate.text andPwd:nil andPwd_two:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (res){
                SetPwdViewController *set = [[SetPwdViewController alloc] init];
                [set setSign:sign andPhone:phoneNumber.text];
                [self.myNavigationController pushAndDisplayViewController:set];
            }
        });
    });
}

- (void) timeFireMethod{
    secondsCountDown--;
    NSString *str = [NSString stringWithFormat:MYLocalizedString(@"已发送(%d秒)", @"Has been sent (%d seconds)"),secondsCountDown];
    // [getNumber setTitle:str forState:UIControlStateNormal];
    timeLab.text = str;
    if (secondsCountDown <= 0){
        timeLab.text = MYLocalizedString(@"获取验证码", @"Get verification code");
        getNumber.userInteractionEnabled = YES;
        [countDownTimer invalidate];//定时器取消
        countDownTimer = nil;
    }
}
- (void) getNumber:(UIButton *) but{
    //NSLog(@"%s", __func__);
    BOOL res = [[[ITF_Apply alloc] init] setPwdByType:sign andPhone:phoneNumber.text andCode:nil andPwd:nil andPwd_two:nil];
 
    if (res && but.userInteractionEnabled == YES){
        but.userInteractionEnabled = NO;
        timeLab.text = MYLocalizedString(@"已发送(60秒)", @"Has been sent (60 seconds)");
        secondsCountDown = 60.;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
}
- (void) phoneCancel{
    authenticate.text = @"";
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
