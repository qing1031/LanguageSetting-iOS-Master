//
//  QuickLoginViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/9.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "T_Verify.h"
#import "UserCenterViewController.h"
#import "EditCompanyViewController.h"
#import "CompanyCenterViewController.h"
//#import "ResumeCenter/CreateResumeViewController.m"
#import "CreateResumeViewController.h"


@interface QuickLoginViewController ()<UITextFieldDelegate>{
    UITextField *phoneNumber;
    UITextField *authenticate;
    
    UILabel *timeLab;
    UIButton *getNumber;
    
    int secondsCountDown;
    NSTimer *countDownTimer;
    
    int sign;
}

@end

@implementation QuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] == 0)
        [self drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] == 0)
        [self drawView];
    [self.myNavigationController setTitle:MYLocalizedString(@"快捷登录", @"Quick login")];
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
    
    
    phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(25, (height - 40) / 2, [InitData Width] - 140, 40)];
    phoneNumber.tag = 300;
    phoneNumber.delegate = self;
    phoneNumber.backgroundColor = [UIColor whiteColor];
    phoneNumber.placeholder =MYLocalizedString(@"请输入手机号", @"Please enter your phone number");
    phoneNumber.adjustsFontSizeToFitWidth = YES;
    phoneNumber.delegate = self;
    phoneNumber.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumber.font = [UIFont systemFontOfSize:phoneNumber.frame.size.height / 2.8];
    [userNameView addSubview:phoneNumber];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 103,8, 1, 32)];
    view.backgroundColor = self.view.backgroundColor;
    [userNameView addSubview:view];
    
    
    timeLab = [[UILabel alloc] init];
    timeLab.text =MYLocalizedString(@"获取验证码", @"Get verification code");
    // timeLab.backgroundColor = [UIColor redColor];
    timeLab.textColor = [UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1];
    [timeLab setFrame:CGRectMake([InitData Width] -100, (height - 25) / 2, 85, 25)];
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.numberOfLines = 0;
    timeLab.adjustsFontSizeToFitWidth = YES;
    timeLab.textAlignment = NSTextAlignmentCenter;
    [userNameView addSubview:timeLab];
    
    getNumber = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // [getNumber setTitle:@"获取验证码" forState:UIControlStateNormal];
    getNumber.backgroundColor = [UIColor clearColor];
    [getNumber setTitleColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1] forState:UIControlStateNormal];
    [getNumber setFrame:CGRectMake([InitData Width] -100, (height - 25) / 2, 80, 25)];
    getNumber.titleLabel.font = [UIFont systemFontOfSize:getNumber.frame.size.height / 1.8];
    [getNumber addTarget:self action:@selector(getNumber:) forControlEvents:UIControlEventTouchUpInside];
    [userNameView addSubview:getNumber];
    
    //密码框
    UIView *vuthView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 1, [InitData Width], height)];
    [vuthView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:vuthView];
    
    authenticate = [[UITextField alloc] initWithFrame:CGRectMake(25, (height - 40) / 2, [InitData Width] - 10, 40)];
    authenticate.tag = 301;
    authenticate.delegate = self;
    authenticate.backgroundColor = [UIColor whiteColor];
    authenticate.placeholder =MYLocalizedString(@"请输入验证码", @"Please enter the verification code");
    authenticate.delegate = self;
    authenticate.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    authenticate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    authenticate.font = [UIFont systemFontOfSize:authenticate.frame.size.height / 2.8];
    [vuthView addSubview:authenticate];
    
    UIButton *cancelBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut1 addTarget:self action:@selector(phoneCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut1 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [vuthView addSubview:cancelBut1];
    
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, height, 20, height + 1)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, height, 20, height + 1)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    //登录按钮
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"登录", @"Login") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 2 + 20, [InitData Width] - 40, 35)];
    [loginBut addTarget:self action:@selector(submitButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    
}


#pragma mark delegate
- (void) submitButClick{
    if ([authenticate.text isEqualToString:@""]){
        [InitData netAlert:MYLocalizedString(@"验证码不能为空!", @"Verification code cannot be empty!")];
        return;
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [[[T_Interface alloc] init] loginByUsername:nil andPassword:nil andMobile:phoneNumber.text andVeritycode:authenticate.text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (user){
                [InitData setUser:user];
                if (sign > 0){
                    [self.myNavigationController popViewControllers:2];
                    return;
                }
                [self.myNavigationController popViewControllers:2];
                if (user.utype == 2){
                    if (user.profile)
                        [self.myNavigationController pushAndDisplayViewController:[[UserCenterViewController alloc] init]];
                    else
                        [self.myNavigationController pushAndDisplayViewController:[[CreateResumeViewController alloc] init]];
                }
                else{
                    if (user.profile)
                        [self.myNavigationController pushAndDisplayViewController:[[CompanyCenterViewController alloc] init]];
                    else
                        [self.myNavigationController pushAndDisplayViewController:[[EditCompanyViewController alloc] init]];
                }
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
        timeLab.text =MYLocalizedString(@"获取验证码", @"Get verification code");
        getNumber.userInteractionEnabled = YES;
        [countDownTimer invalidate];//定时器取消
        countDownTimer = nil;
    }
}
- (void) getNumber:(UIButton *) but{
    //NSLog(@"%s", __func__);
    T_User *user = [[[T_Interface alloc] init] loginByUsername:nil andPassword:nil andMobile:phoneNumber.text andVeritycode:nil];
    
    if (user != nil && but.userInteractionEnabled == YES){
        but.userInteractionEnabled = NO;
        timeLab.text =MYLocalizedString(@"已发送(60秒)", @"Has been sent (60 seconds)");
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