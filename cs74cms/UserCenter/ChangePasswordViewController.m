//
//  ChangePasswordViewController.m
//  74cms
//
//  Created by LPY on 15-4-11.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "ITF_Company.h"

@interface ChangePasswordViewController (){
    UITextField *pastPassword;
    UITextField *newPassword;
    UITextField *repeatnew;
    
    int type;
}

@end

@implementation ChangePasswordViewController

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
    UIView *pastPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    [pastPasswordView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:pastPasswordView];
    
    UILabel *pastLabel = [[UILabel alloc] init];
    pastLabel.text = MYLocalizedString(@"旧密码", @"Old password");
    pastLabel.font = [UIFont systemFontOfSize:15];
    pastLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0/255 blue:51.0/255 alpha:1];
    [pastLabel setFrame:CGRectMake(20, (height - 30) / 2, 55, 30)];
    [pastPasswordView addSubview:pastLabel];
    
    pastPassword = [[UITextField alloc] initWithFrame:CGRectMake(90, (height - 40) / 2, [InitData Width] - 120, 40)];
    pastPassword.tag = 300;
    pastPassword.backgroundColor = [UIColor whiteColor];
    pastPassword.placeholder = MYLocalizedString(@"请输入6-18位密码", @"Please enter a 6-18 character password");
    pastPassword.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    pastPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pastPassword.font = [UIFont systemFontOfSize:pastPassword.frame.size.height / 2.7];
    pastPassword.secureTextEntry = YES;
    [pastPasswordView addSubview:pastPassword];

    
    
    //密码框
    UIView *newPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 1, [InitData Width], height)];
    [newPasswordView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:newPasswordView];
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.text = MYLocalizedString(@"新密码", @"New password");
    newLabel.font = pastLabel.font;
    newLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0/255 blue:51.0/255 alpha:1];
    [newLabel setFrame:CGRectMake(20, (height - 30) / 2, 55, 30)];
    [newPasswordView addSubview:newLabel];
    
    newPassword = [[UITextField alloc] initWithFrame:CGRectMake(90, (height - 40) / 2, [InitData Width] - 120, 40)];
    newPassword.tag = 301;
    newPassword.backgroundColor = [UIColor whiteColor];
    newPassword.placeholder = MYLocalizedString(@"请输入6-18位密码", @"Please enter a 6-18 character password");
    newPassword.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    newPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newPassword.font = [UIFont systemFontOfSize:newPassword.frame.size.height / 2.7];
    newPassword.secureTextEntry = YES;
    [newPasswordView addSubview:newPassword];
    
    
    //密码框
    UIView *repeatView = [[UIView alloc] initWithFrame:CGRectMake(0, height * 2 + 2, [InitData Width], height)];
    [repeatView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:repeatView];
    
    UILabel *repeatLabel = [[UILabel alloc] init];
    repeatLabel.text = MYLocalizedString(@"确认密码", @"Confirm password");
    repeatLabel.font = pastLabel.font;
    repeatLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0/255 blue:51.0/255 alpha:1];
    [repeatLabel setFrame:CGRectMake(20, (height - 30) / 2, 60, 30)];
    [repeatView addSubview:repeatLabel];
    
    repeatnew = [[UITextField alloc] initWithFrame:CGRectMake(90, (height - 40) / 2, [InitData Width] - 120, 40)];
    repeatnew.tag = 301;
    repeatnew.backgroundColor = [UIColor whiteColor];
    repeatnew.placeholder = MYLocalizedString(@"请输入6-18位密码", @"Please enter a 6-18 character password");
    repeatnew.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    repeatnew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    repeatnew.font = [UIFont systemFontOfSize:repeatnew.frame.size.height / 2.7];
    repeatnew.secureTextEntry = YES;
    [repeatView addSubview:repeatnew];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, height, 20, 2 + height)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, height, 20, 2 + height)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    //登录按钮
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"确定", @"Done") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 3 + 20, [InitData Width] - 40, 30)];
    [loginBut addTarget:self action:@selector(sureButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event

-(void) sureButClick{
    if (pastPassword.text.length < 6 ||pastPassword.text.length > 18
        ||![InitData stringIsalnum:newPassword.text] ||![InitData stringIsalnum:pastPassword.text]
        || newPassword.text.length < 6 || newPassword.text.length > 18){
        [InitData netAlert:MYLocalizedString(@"请输入6-18位数字或字母", @"Please enter 6-18 character numbers or letters")];
        return;
    }
    if (![newPassword.text isEqualToString:repeatnew.text]){
        [InitData netAlert:MYLocalizedString(@"确认密码必须与新密码相同", @"Confirm that the password must be the same as the new password")];
        return;
    }

     /***************************************添加代码**************************************************/
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        BOOL ok;
        switch (type) {
            case 0:
                ok = [[[T_Interface alloc] init] editPasswordByUsername:user.username andUserpwd:user.userpwd andOldPwd: pastPassword.text andPwdOne:newPassword.text andPwdTwo:repeatnew.text];
                break;
                
            default:
                ok = [[[ITF_Company alloc] init] editPasswordByUser:user andOldPwd:pastPassword.text andPwdOne:newPassword.text andPwdTwo:repeatnew.text];
                break;
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (ok){
                [self.myNavigationController dismissViewController];
                user.userpwd = newPassword.text;
                [InitData setUser:user];
            }
        });
    });
}
-(void) spaceClicked{
    [pastPassword resignFirstResponder];
    [newPassword resignFirstResponder];
    [repeatnew resignFirstResponder];
}

@end
