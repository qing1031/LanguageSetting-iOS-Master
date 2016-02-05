//
//  AuthenticationViewController.m
//  74cms
//
//  Created by LPY on 15-4-11.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "ITF_Company.h"

@interface AuthenticationViewController ()<UITextFieldDelegate>{
    UITextField *phoneNumber;
    UITextField *authenticate;
    UILabel *message;
    
    UIButton *getNumber;
    UILabel *timeLab;
    int secondsCountDown;   //倒计时
    NSTimer *countDownTimer;
    
    T_Verify *verify;
    int type;//0 个人认证   1企业认证
}

@end

@implementation AuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setType:(int) ttype{
    type = ttype;
}
- (void)drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    
    
    float height = 45;
    //用户名
    UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    [userNameView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:userNameView];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = MYLocalizedString(@"手机号", @"Phone number");
    phoneLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0/255 blue:51.0/255 alpha:1];
    [phoneLabel setFrame:CGRectMake(20, 0, 55, height)];
    phoneLabel.font = [UIFont systemFontOfSize:phoneLabel.frame.size.height / 2.7];
    [userNameView addSubview:phoneLabel];
    
    
    phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    phoneNumber.tag = 300;
    phoneNumber.delegate = self;
    phoneNumber.backgroundColor = [UIColor whiteColor];
    phoneNumber.placeholder = MYLocalizedString(@"请输入手机号", @"Please enter your phone number");
    phoneNumber.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumber.font = [UIFont systemFontOfSize:phoneNumber.frame.size.height / 2.8];
    [userNameView addSubview:phoneNumber];
    if (verify != nil && ![verify.mobile isEqualToString:@""])
        phoneNumber.text = verify.mobile;
    
    UIButton *cancelBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut1 addTarget:self action:@selector(phoneCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut1 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [userNameView addSubview:cancelBut1];
    
    
    //密码框
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 1, [InitData Width], height)];
    [passWordView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:passWordView];
    
    UILabel *authLabel = [[UILabel alloc] init];
    authLabel.text = MYLocalizedString(@"验证码", @"Verification code");
    authLabel.font = phoneLabel.font;
    authLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0/255 blue:51.0/255 alpha:1];
    [authLabel setFrame:CGRectMake(20, (height - 30) / 2, 55, 30)];
    [passWordView addSubview:authLabel];
    
    authenticate = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 180, 40)];
    authenticate.tag = 301;
    authenticate.delegate = self;
    authenticate.backgroundColor = [UIColor whiteColor];
    authenticate.placeholder = MYLocalizedString(@"请输入验证码", @"Please enter the verification code");
    authenticate.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    authenticate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    authenticate.font = [UIFont systemFontOfSize:authenticate.frame.size.height / 2.8];
    [passWordView addSubview:authenticate];
    
    UIView *separete = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 103, 8, 1, 32)];
    [separete setBackgroundColor:self.view.backgroundColor];
    [passWordView addSubview:separete];
    
    timeLab = [[UILabel alloc] init];
    timeLab.text = MYLocalizedString(@"获取验证码", @"Get verification code");
   // timeLab.backgroundColor = [UIColor redColor];
    timeLab.textColor = [UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1];
    [timeLab setFrame:CGRectMake([InitData Width] -100, (height - 25) / 2, 85, 25)];
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [passWordView addSubview:timeLab];


    
    getNumber = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // [getNumber setTitle:@"获取验证码" forState:UIControlStateNormal];
    getNumber.backgroundColor = [UIColor clearColor];
    [getNumber setTitleColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1] forState:UIControlStateNormal];
    [getNumber setFrame:CGRectMake([InitData Width] -100, (height - 25) / 2, 80, 25)];
    getNumber.titleLabel.font = [UIFont systemFontOfSize:getNumber.frame.size.height / 1.8];
    [getNumber addTarget:self action:@selector(getNumber:) forControlEvents:UIControlEventTouchUpInside];
    [passWordView addSubview:getNumber];
  

    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, height, 20, 1)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, height, 20, 1)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    //登录按钮
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"提交", @"Submit") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 2 + 20, [InitData Width] - 40, 30)];
    [loginBut addTarget:self action:@selector(submitButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tixin.png"]];
    [imgView setFrame:CGRectMake(20, loginBut.frame.size.height + loginBut.frame.origin.y + 10, 15, 15)];
    [self.view addSubview:imgView];
    
    message = [[UILabel alloc] initWithFrame:CGRectMake(38, imgView.frame.origin.y, [InitData Width] - 50, 15)];
    message.font = [UIFont systemFontOfSize:11];
    message.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    message.text = MYLocalizedString(@"手机认证成功后可接受HR来电，还可以用来登录。", @"After the success of mobile phone authentication can accept HR calls, but also can be used to log on.");
    [self.view addSubview:message];
    
    if (verify != nil && verify.mobile_audit != 0)
        message.text = MYLocalizedString(@"你已经认证过手机号，如需更改请重新认证新手机号。", @"You have authenticated the phone number, if you need to change please re certification of the new phone number.");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewCanBeSee{
    if ([[self.view subviews] count] == 0){
        
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            T_User *user =[InitData getUser];
            
            switch (type) {
                case 0:{
                    verify = [[[T_Interface alloc] init] personalVerifyByUsername:user.username andUserpwd:user.userpwd andMobile:nil andVerifycode:nil];
                }
                    break;
                    
                case 1:{
                    verify = [[[ITF_Company alloc] init] companyVerifyByUsername:user.username andUserpwd:user.userpwd andMobile:nil andVerifycode:nil];
                }
                    break;
            }
            
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                [self drawView];
                if (verify.mobile_audit == 1)
                    [self.myNavigationController setTitle:MYLocalizedString(@"更改手机认证", @"Change mobile phone authentication")];
            });
        });

    }

    [self.myNavigationController setTitle:MYLocalizedString(@"手机认证", @"Mobile phone authentication")];
}
- (void) viewCannotBeSee{
    if (countDownTimer !=  nil){
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event
- (void) submitButClick{
    if ([authenticate.text  isEqual: @""]){
        [InitData netAlert:MYLocalizedString(@"验证码不能为空！", @"Verification code cannot be empty!")];
        return;
    }
    T_User *user = [InitData getUser];
    T_Verify *tv;
    switch (type) {
        case 0:
            tv = [[[T_Interface alloc] init] personalVerifyByUsername:user.username andUserpwd:user.userpwd andMobile:nil andVerifycode:authenticate.text];
            break;
            
        default:
            tv = [[[ITF_Company alloc] init] companyVerifyByUsername:user.username andUserpwd:user.userpwd andMobile:nil andVerifycode:authenticate.text];
            break;
    }
    
    if (tv != nil){
        message.text = MYLocalizedString(@"你已经认证过手机号，如需更改请重新认证新手机号。", @"You have authenticated the phone number, if you want to change please recertificate the new phone number.");
        secondsCountDown = 1;
        [self timeFireMethod];
        [InitData netAlert:MYLocalizedString(@"认证成功！", @"Certificate success!")];
        
    }
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
    T_User *user = [InitData getUser];
    T_Verify *tv;
    switch (type) {
        case 0:
            tv = [[[T_Interface alloc] init] personalVerifyByUsername:user.username andUserpwd:user.userpwd andMobile:phoneNumber.text andVerifycode:nil];
            break;
            
        default:
            tv = [[[ITF_Company alloc] init] companyVerifyByUsername:user.username andUserpwd:user.userpwd andMobile:phoneNumber.text andVerifycode:nil];
            break;
    }
    
    if (tv == nil){
        return;
    }
    if (tv != nil && but.userInteractionEnabled == YES){
        but.userInteractionEnabled = NO;
        timeLab.text = MYLocalizedString(@"已发送(60秒)", @"Has been sent (60 seconds)");
        secondsCountDown = 60.;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
}
- (void) phoneCancel{
    phoneNumber.text = @"";
}

- (void) spaceClicked{
    [phoneNumber resignFirstResponder];
    [authenticate resignFirstResponder];
}

#pragma mark delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
