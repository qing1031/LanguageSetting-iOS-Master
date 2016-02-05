//
//  LoginViewController.m
//  74cms
//
//  Created by LPY on 15-4-11.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "LoginViewController.h"
#import "InitData.h"
#import "RegisterMainViewController.h"
#import "UserCenterViewController.h"
#import "CompanyCenterViewController.h"
#import "EditCompanyViewController.h"
#import "CreateResumeViewController.h"
#import "QuickLoginViewController.h"
#import "T_Interface.h"
#import "ITF_Apply.h"

#import "FindPwdViewController.h"
#import "OtherRegisterViewController.h"

#import "WeiboSDK.h"
#define kRedirectURI @"http://www.sina.com"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#define TencentAppID @"1104728114"


#import <TAESDK/TAESDK.h>
#import <ALBBLoginSDK/ALBBLoginService.h>


@interface LoginViewController ()<UITextFieldDelegate, UIActionSheetDelegate, TencentSessionDelegate>{
    UITextField *userNameField;
    
    UITextField *passWordField;
    
    UIButton *select;
    
    int sign;
    
    UIActionSheet *myActionSheet;
    
    TencentOAuth *_tencentOAuth;
    
    NSString *openId;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setSign:(int) tsign{
    sign = tsign;
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
    userNameField.placeholder = MYLocalizedString(@"请输入用户名/邮箱/手机号", @"Please enter user name/email/phone number");
    userNameField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameField.font = [UIFont systemFontOfSize:userNameField.frame.size.height / 3];
    [userNameView addSubview:userNameField];
    
    UIButton *cancelBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut1 addTarget:self action:@selector(userNameCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut1 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [userNameView addSubview:cancelBut1];
    
    
    //密码框
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(0, height + 1, [InitData Width], height)];
    [passWordView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:passWordView];
    
    UIImageView *passWordImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.jpg"]];
    [passWordImg setFrame:CGRectMake(20, (height - 30) / 2, 30, 30)];
    [passWordView addSubview:passWordImg];
    
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(80, (height - 40) / 2, [InitData Width] - 80 * 2, 40)];
    passWordField.tag = 301;
    passWordField.backgroundColor = [UIColor whiteColor];
    passWordField.delegate = self;
    passWordField.placeholder = MYLocalizedString(@"请输入密码", @"Please enter a password");
    passWordField.secureTextEntry = YES;
    passWordField.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWordField.font = [UIFont systemFontOfSize:passWordField.frame.size.height / 3];
    [passWordView addSubview:passWordField];
    
    
    UIButton *cancelBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut2 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBut2 addTarget:self action:@selector(passWordCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBut2 setFrame:CGRectMake([InitData Width] - 50, (height - 25) / 2, 25, 25)];
    [passWordView addSubview:cancelBut2];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, height, 20, 1)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 20, height, 20, 1)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    //登录按钮
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"登录", @"Login") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height * 2 + 20, [InitData Width] - 40, 30)];
    [loginBut addTarget:self action:@selector(loginButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    
    //注册
  /*  select = [UIButton buttonWithType:UIButtonTypeCustom];
    [select setFrame:CGRectMake(20, height * 2 + 60 , 20, 20)];
    [select setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateSelected];
    [select setImage:[UIImage imageNamed:@"Unselected.png"] forState:UIControlStateNormal];
    select.selected = YES;
    [select addTarget:self action:@selector(selectRemeber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:select];
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(50, select.frame.origin.y, 80, 20)];
    label0.text = @"";
    label0.textColor = userNameField.textColor;
    label0.font = [UIFont systemFontOfSize:label0.frame.size.height / 1.6];
    [self.view addSubview:label0];
   */
    select = [UIButton buttonWithType:UIButtonTypeCustom];
    [select setTitle:MYLocalizedString(@"免费注册", @"Free registration") forState:UIControlStateNormal];
    [select setFrame:CGRectMake(20, height * 2 + 60, 120, 25)];
    select.titleLabel.font = [UIFont systemFontOfSize:13];
    [select setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [select addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:select];
    
    //忘记密码
    UIButton *forgetPassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetPassword setBackgroundColor:[UIColor clearColor]];
    [forgetPassword setTitle:MYLocalizedString(@"忘记密码?", @"Forget the password?") forState:UIControlStateNormal];
    [forgetPassword setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetPassword setFrame:CGRectMake([InitData Width] - 160, select.frame.origin.y, 140, 20)];
    forgetPassword.titleLabel.font = [UIFont systemFontOfSize:forgetPassword.frame.size.height / 1.6];
    [forgetPassword addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPassword];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, [InitData Height] * 0.5, [InitData Width] - 40, 0.5)];
    [view setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([InitData Width] - 150) / 2, view.frame.origin.y - 8, 150, 15)];
    label.textColor = view.backgroundColor;
    label.font = [UIFont systemFontOfSize:14];
    label.text = MYLocalizedString(@"使用第三方登录", @"Use third party login");
    [self.view addSubview:label];
    [label setBackgroundColor:self.view.backgroundColor];
    
    
    float y = view.frame.origin.y + 30;
    float seperate = 30;
    float cellHeight = ([InitData Width]- 4 * 30) /3;
    NSArray *imgArr = [NSArray arrayWithObjects:@"QQLogin.png",@"SinaLogin.png", @"TaoBaoLogin.png",nil ];
    for (int i =0; i<3; i++){
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = 3000 + i;
        [but setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
        [but setFrame:CGRectMake(i * cellHeight + (i + 1) * seperate, y, cellHeight, cellHeight)];
        [self.view addSubview:but];
    }
}

- (void) loginButClick{
    if ([userNameField.text isEqualToString: @""] || [passWordField.text isEqualToString: @""]){
        [InitData netAlert:MYLocalizedString(@"用户名与密码不能为空", @"User name and password can not be empty")];
        return;
    }
  
    [self login];
}

- (void) login{
    [InitData isLoading:self.view];
        //不可从主线程取值
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //后台代码
        T_User * user ;
        if (![userNameField.text isEqualToString:@""] && ![passWordField.text isEqualToString:@""])
            user = [[[T_Interface alloc] init] loginByUsername:userNameField.text andPassword:passWordField.text andMobile:nil andVeritycode:nil];
        else if (openId != nil){
            user = [[[T_Interface alloc] init] loginByOPenID:openId];
       }
            
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
 
            [InitData haveLoaded:self.view];
            if (user != nil){
                if (openId != nil)
                    user.openID = openId;
                if (user.userpwd == nil)
                    user.userpwd = @"";
                
                [InitData setUser:user];
                [self nextPage];
            }
        });
    });
}
- (void) nextPage{
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
    
    T_User *user = [InitData getUser];
    
    if (self.myNavigationController != nil){
        if (sign > 0){
            [self.myNavigationController dismissViewController];
            return;
        }
        if (user.utype == 2){
            if (user.profile || user.openID != nil)
                [self.myNavigationController popAndPushViewController:[[UserCenterViewController alloc] init]];
            else
                [self.myNavigationController popAndPushViewController:[[CreateResumeViewController alloc] init]];
        }
        else{
            if (user.profile || user.openID != nil)
                [self.myNavigationController popAndPushViewController:[[CompanyCenterViewController alloc] init]];
            else
                [self.myNavigationController popAndPushViewController:[[EditCompanyViewController alloc] init]];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboLogin:) name:@"weibo" object:nil];
    
    if ([[self.view subviews] count] == 0){
        [self drawView];
    }
    
}


- (void) viewCanBeSee{
    
    if ([[self.view subviews] count] == 0){
        [self drawView];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"登录", @"Login")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:MYLocalizedString(@"快捷登录", @"Quick login") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 80, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(quickLogin) forControlEvents:UIControlEventTouchUpInside];
    NSArray *butArr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:butArr];
    [self.myNavigationController setNavigationBarColor:[InitData getSkinColor]];
    
    
 /*   if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]!= nil) {
        userNameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userPwd"]!= nil) {
        passWordField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userPwd"];
    }*/
    if ([InitData getUser] != nil)
    {
        T_User *user = [InitData getUser];
        if (user.openID != nil) {
            openId = user.openID;
            [self login];
            return;
        }
        if (user.username != nil && user.userpwd != nil){//没有用户名，密码 不能自动登录
            userNameField.text = user.username;
            passWordField.text = user.userpwd;
            [self loginButClick];
        }
    }
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
    
    //取消响应
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event

- (void) quickLogin{
    QuickLoginViewController *quick = [[QuickLoginViewController alloc] init];
    [quick setSign:sign];
    [self.myNavigationController pushAndDisplayViewController:quick];
}

- (void) selectRemeber{
    select.selected = !select.selected;
}

- (void) userRegister{
    [self.myNavigationController pushAndDisplayViewController:[[RegisterMainViewController alloc] init]];
}

- (void) otherLogin:(UIButton*) but{
 //   NSLog(@"%s", __func__);
    switch (but.tag) {
        case 3000:{
            [self qqLogin];
        }
                 /***************************************添加代码**************************************************/
            break;
        case 3001:{
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;//
            request.scope = @"all";
            request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
        }
            
            break;
            
        case 3002:
            [self taobaoLogin];
            
            break;
            
        default:
            break;
    }
}
//0qq,  1sina,  2taobao
- (void) agencyLoginByType:(int)type andOpenId:(NSString*) openID andNick:(NSString*) nick{
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [[[ITF_Apply alloc] init] connectAgencyBytype:type andUId:openID andNick:nick andIdold:NO andUtype:0 andUserpwd:nil andEmail:nil andMobile:nil andUsername:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (user != nil && user.username == nil){

                OtherRegisterViewController *res = [[OtherRegisterViewController alloc] init];
                [res setType:type andOpenID:openID andNick:nick];
                //[self.myNavigationController popAndPushViewController:res];
                [self.myNavigationController pushAndDisplayViewController:res];
            }
            else if (user.username != nil){
                user.openID = openID;
                user.userpwd = @"";
                [InitData setUser:user];
                [self nextPage];
            }
        });
    });
}

- (void) userNameCancel{
    userNameField.text = @"";
}
- (void) passWordCancel{
    passWordField.text = @"";
 
}

- (void) spaceClicked{
    
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
}
#pragma weibo
- (void) weiboLogin:(NSNotification*) info{
    [self agencyLoginByType:1 andOpenId:info.userInfo[@"uid"] andNick:info.userInfo[@"nick"]];
}

#pragma Tencent Delegate
- (void) qqLogin{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:TencentAppID andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];//@"get_user_info",@"get_simple_userinfo",@"add_t"
    _tencentOAuth.redirectURI = @"www.qq.com";
    [_tencentOAuth authorize:permissions inSafari:NO];
}
- (void)tencentDidLogin
{
    NSMutableString *mes = [NSMutableString stringWithString:MYLocalizedString(@"登录完成", @"Login complete")];
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        [mes appendString: _tencentOAuth.accessToken];
        openId = _tencentOAuth.openId;
       
        [_tencentOAuth getUserInfo];
    }
    else
    {
        [mes appendString:MYLocalizedString(@"登录不成功 没有获取accesstoken", @"Login unsuccessful did not get accesstoken")];
    }
    //[InitData netAlert:mes];
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{

}
- (void) tencentDidNotNetWork{
    [InitData netAlert:MYLocalizedString(@"暂无网络，请检查网络连接", @"No network, please check the network connection")];
}
-(void)getUserInfoResponse:(APIResponse *)response
{
    [self agencyLoginByType:0 andOpenId:openId andNick:[response.jsonResponse objectForKey:@"nickname"]];
    
   // NSLog(@"%@", response.jsonResponse );// ];
}
#pragma mark taobao
-(void)taobaoLogin{
    [self.myNavigationController setNavigaionBarHidden:YES];
    id<ALBBLoginService> loginService=[[TaeSDK sharedInstance]getService:@protocol(ALBBLoginService)];
    [loginService logout];
    if(![[TaeSession sharedInstance] isLogin]){
        [loginService showLogin:self successCallback:^(TaeSession *session){
          //  NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@",[session getUser],[session getLoginTime]];
          //  NSLog(@"%@", tip);
         //  [self.view setFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];//没用奇怪， 反正要跳到其他页面
            [self.myNavigationController setNavigaionBarHidden:NO];//没用奇怪， 反正要跳到其他页面， 7系统没问题，8系统顶到最上
            [self agencyLoginByType:2 andOpenId:[session getUser].userId andNick:[session getUser].nick];
        } failedCallback:^(NSError *error){
            //[self.view setFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
            [self.myNavigationController setNavigaionBarHidden:NO];
        }];
    }else{
    
    TaeSession *session=[TaeSession sharedInstance];
       // NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@",[session getUser],[session getLoginTime]];
       // NSLog(@"%@", tip);
        [self agencyLoginByType:2 andOpenId:[session getUser].userId andNick:[session getUser].nick];
    }
}


#pragma mark delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma findPassWord
- (void) forgetPassword{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:MYLocalizedString(@"取消", @"Cancle")
                     destructiveButtonTitle:nil
                     otherButtonTitles:MYLocalizedString(@"手机找回密码", @" Retrieve password from mobile"),  MYLocalizedString(@"邮箱找回密码", @" Retrieve password from email"),nil];
    
    [myActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        return;
    }
    
    FindPwdViewController *find = [[FindPwdViewController alloc]init];
    [find setSign:buttonIndex];
    [self.myNavigationController pushAndDisplayViewController:find];
}


@end
