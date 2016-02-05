//
//  ContectUserViewController.m
//  cs74cms
//
//  Created by lyp on 15/7/18.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ContectUserViewController.h"
#import "ITF_Apply.h"
#import "InitData.h"
#import "UserCenterViewController.h"
#import "CompanyCenterViewController.h"

@interface ContectUserViewController (){
    NSArray *tixin;
    NSMutableArray *array;
    int type;
    NSString *openId;
    NSString *nick;
}

@end

@implementation ContectUserViewController

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
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"账号绑定",@"Account binding")];
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
    NSArray *imgArr = [NSArray arrayWithObjects:@"username.jpg", @"pwd.png", nil];
    tixin = [NSArray arrayWithObjects:MYLocalizedString(@"请输入用户名",@"Please enter a user name"), MYLocalizedString(@"请输入密码",@"Please enter a password"), nil];
    array = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i=0; i<2; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, cellHeight - 1, [InitData Width] - 30, 1)];
        sep.backgroundColor = self.view.backgroundColor;
        [view addSubview:sep];

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 150, cellHeight)];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
        textField.placeholder = [tixin objectAtIndex:i];
        [view addSubview:textField];
        [array addObject:textField];
        
        if (i == 1)
            textField.secureTextEntry = YES;
        
        UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom ];
        [img setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
        [img addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        img.tag = i + 1;
        [view addSubview:img];

        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (cellHeight - 25) / 2, 25, 25)];
        [imgView setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]]];
        [view addSubview:imgView];
        
        height += cellHeight;
    }
    
    //  UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBut setTitle:MYLocalizedString(@"立即绑定", @"Immediate binding") forState:UIControlStateNormal];
    [loginBut setBackgroundColor:[UIColor colorWithRed:61.0 / 255 green:132.0/255 blue:184.0/255 alpha:1]];
    loginBut.layer.cornerRadius = 8;
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut setFrame:CGRectMake(20, height + 20, [InitData Width] - 40, 30)];
    [loginBut addTarget:self action:@selector(loginButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBut];
    height += 20 + 30 + 20;
}

- (void) cancelClick:(UIButton*) but{
    int index = but.tag - 1;
    UITextField *textfield = [array objectAtIndex:index];
    textfield.text = @"";
}
- (void) loginButClick{
    for (int i=0; i<[array count]; i++){
        UITextField *label = [array objectAtIndex:i];
        if ([label.text isEqualToString:[tixin objectAtIndex:i]]){
            [InitData netAlert:[tixin objectAtIndex:i]];
            return;
        }
    }
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [[[ITF_Apply alloc] init] connectAgencyBytype:0 andUId:openId andNick:nick andIdold:YES andUtype:0 andUserpwd:((UITextField*)[array objectAtIndex:1]).text andEmail:nil andMobile:nil andUsername:((UITextField*)[array objectAtIndex:0]).text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (user != nil &&user.ID > 0){
                user.openID = openId;
                [InitData setUser:user];
            user.openID = openId;
            [InitData setUser:user];
            if (user.utype == 2){

                [self.myNavigationController popAndPushViewController:[[UserCenterViewController alloc] init]];
               
            }
            else{

                [self.myNavigationController popAndPushViewController:[[CompanyCenterViewController alloc] init]];
                
            }
            }
        });
    });
}

@end
