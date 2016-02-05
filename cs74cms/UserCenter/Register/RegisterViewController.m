//
//  RegisterViewController.m
//  74cms
//
//  Created by LPY on 15-4-11.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "RegisterViewController.h"
#import "InitData.h"
//#import "InfoViewController.h"
#import "CreateResumeViewController.h"
#import "ITF_Apply.h"
#import "EditCompanyViewController.h"
#import "PhoneRegistViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>{
    UITextField *userNameField;
    UITextField *emailField;
    UITextField *passWordField;
    
    UITextField *againField;
    
    int type;
}

@end

@implementation RegisterViewController

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
- (void) drawView{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    
    
    float height = 45;
    //用户名
    UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    [userNameView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:userNameView];
    
    UIImageView *userNameImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username.jpg"]];
    [userNameImg setFrame:CGRectMake(20, (height - 30) / 2, 30, 30)];
    [userNameView addSubview:userNameImg];
    
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    userNameField.tag = 300;
    userNameField.delegate = self;
    userNameField.backgroundColor = [UIColor whiteColor];
    userNameField.placeholder = MYLocalizedString(@"请输入用户名", @"Please enter a user name");
    userNameField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameField.font = [UIFont systemFontOfSize:userNameField.frame.size.height / 3];
    [userNameView addSubview:userNameField];
    
    UIButton *cancelBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut1 addTarget:self action:@selector(userNameCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut1 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [userNameView addSubview:cancelBut1];
    
    
    
    //邮箱
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 1, [InitData Width], height)];
    [emailView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:emailView];
    
    UIImageView *emailImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
    [emailImg setFrame:CGRectMake(21, (height - 30) / 2-1, 28, 28)];
    [emailView addSubview:emailImg];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    emailField.tag = 303;
    emailField.delegate = self;
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.placeholder = MYLocalizedString(@"请输入常用邮箱", @"Please enter a common email");
    emailField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailField.font = [UIFont systemFontOfSize:emailField.frame.size.height / 3];
    [emailView addSubview:emailField];
    
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(emailCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [emailView addSubview:cancelBut];
    
    
    //密码框
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(0, (height + 1) * 2, [InitData Width], height)];
    [passWordView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:passWordView];
    
    UIImageView *passWordImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.jpg"]];
    [passWordImg setFrame:CGRectMake(20, (height - 30) / 2, 30, 30)];
    [passWordView addSubview:passWordImg];
    
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    passWordField.tag = 301;
    passWordField.backgroundColor = [UIColor whiteColor];
    passWordField.placeholder = MYLocalizedString(@"请输入6-18位密码", @"Please enter a 6-18 character password");
    passWordField.secureTextEntry = YES;
    passWordField.delegate = self;
    passWordField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWordField.font = [UIFont systemFontOfSize:passWordField.frame.size.height / 3];
    [passWordView addSubview:passWordField];
    
    UIButton *cancelBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut2 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut2 addTarget:self action:@selector(passWordCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut2 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [passWordView addSubview:cancelBut2];
    
    //密码框
    UIView *againView = [[UIView alloc] initWithFrame:CGRectMake(0, (height + 1) * 3, [InitData Width], height)];
    [againView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:againView];
    
    UIImageView *againImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.jpg"]];
    [againImg setFrame:CGRectMake(20, (height - 30) / 2, 30, 30)];
    [againView addSubview:againImg];

    againField = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    againField.tag = 301;
    againField.backgroundColor = [UIColor whiteColor];
    againField.placeholder = MYLocalizedString(@"请确认密码", @"Please confirm password");
    againField.secureTextEntry = YES;
    againField.delegate =self;
    againField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    againField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    againField.font = [UIFont systemFontOfSize:againField.frame.size.height / 3];
    [againView addSubview:againField];
    
    UIButton *cancelBut3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut3 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut3 addTarget:self action:@selector(againCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut3 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [againView addSubview:cancelBut3];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, height, 20, height * 3)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, height, 20, height * 3)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    //登录按钮
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"注册", @"Register") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 4 + 20, [InitData Width] - 40, 35)];
    [loginBut addTarget:self action:@selector(registerButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    
    
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    [login setFrame:CGRectMake([InitData Width] - 20 - 240, height * 5 + 10, 240, 40)];
    [login setTitle:MYLocalizedString(@"已有账号，立即登陆>>", @"Already account, immediately landed") forState:UIControlStateNormal];
    [login setTitleColor:[UIColor colorWithRed:235./255 green:112./255 blue:58./255 alpha:1] forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize:13];
    [login addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] == 0){
        [self drawView];
    }

}

- (void)viewCanBeSee{
    if ([[self.view subviews] count] == 0){
        [self drawView];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"注册", @"Register")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(phoneRegsiter) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"手机注册", @"Mobile registration") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 80, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    but.titleLabel.adjustsFontSizeToFitWidth = YES;
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


#pragma mark event

- (void) registerButClick{
     /***************************************添加代码**************************************************/
    
    if ([userNameField.text isEqualToString:@""]) {
        [InitData netAlert:MYLocalizedString(@"请输入用户名", @"Please enter a user name")];
        return;
    }
    if ([emailField.text isEqualToString:@""]){
        [InitData netAlert:MYLocalizedString(@"请输入常用邮箱", @"Please enter a common email")];
        return;
    }
    if ([passWordField.text isEqualToString:@""] || passWordField.text.length < 6){
        [InitData netAlert:MYLocalizedString(@"请输入6-18位密码", @"Please enter a 6-18 character password")];
        return;
    }
    if (![passWordField.text isEqualToString:againField.text]) {
        [InitData netAlert:MYLocalizedString(@"两次输入密码不同", @"The two input password is different")];
        return;
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [[[ITF_Apply alloc] init] emailRegisterByType:type andUsername:userNameField.text andEmail:emailField.text andPwd:passWordField.text andPwdtwo:againField.text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (user != nil){
                [InitData setUser:user];
                if (self.myNavigationController != nil){
                    if (type == 2)
                        [self.myNavigationController pushAndDisplayViewController:[[CreateResumeViewController alloc] init]];
                    else if (type == 1)
                        [self.myNavigationController pushAndDisplayViewController:[[EditCompanyViewController alloc] init]];
                }
            }

        });
    });
}

- (void) phoneRegsiter{
    PhoneRegistViewController *phone =[[PhoneRegistViewController alloc] init];
    [phone setType:type];
    [self.myNavigationController pushAndDisplayViewController:phone];
}
- (void) gotoLogin{
    [self.myNavigationController popViewControllers:2];
}
- (void) userNameCancel{
    userNameField.text = @"";
}
- (void) emailCancel{
    emailField.text = @"";
}
- (void) passWordCancel{
    passWordField.text = @"";
}

- (void) againCancel{
    againField.text = @"";
}

- (void) spaceClicked{
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
