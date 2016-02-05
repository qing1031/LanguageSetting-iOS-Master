//
//  PushSetViewController.m
//  74cms
//
//  Created by lyp on 15/4/29.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "PushSetViewController.h"
#import "InitData.h"

#import "APService.h"

@interface PushSetViewController ()

@end

@implementation PushSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, 15, [InitData Width] + 2, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [UIColor colorWithRed:201./255 green:201./255 blue:201./255 alpha:1].CGColor;
    view.layer.borderWidth = 1;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 170, 30)];
    label.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.text = MYLocalizedString(@"推送通知", @"Push notifications");
    [view addSubview:label];
    
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake([InitData Width] - 20 - 100, 10, 100, 30)];
    [but setImage:[UIImage imageNamed:@"push_setting1.png"] forState:UIControlStateSelected];
    [but setImage:[UIImage imageNamed:@"push_setting2.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(canPush:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
    
  /*  if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == 0)
        but.selected = NO;
    else
        but.selected = YES;
   */
    but.selected = [self isAllowedNotification];
    
    UILabel *tixin = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 300, 50)];
    tixin.textColor = label.textColor;
    tixin.font = [UIFont systemFontOfSize:12];
    tixin.text = MYLocalizedString(@"打开该功能,系统将接收推送消息", @"Open the function, the system will receive push messages");
    tixin.numberOfLines = 0;
    [self.view addSubview:tixin];
}
/**
 2  *  check if user allow local notification of system setting
 3  *
 4  *  @return YES-allowed,otherwise,NO.
 5  */
- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}

- (void) canPush:(UIButton*) but{
    but.selected = !but.selected;
    
    if (but.selected){
       // [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
#else
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
        
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone
                                               categories:nil];
        }
#else
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone
                                           categories:nil];
#endif
    }
}

@end
