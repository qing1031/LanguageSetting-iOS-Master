//
//  AppDelegate.m
//  cs74cms
//
//  Created by lyp on 15/5/8.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

/*
 修改了  发布职位 后 用户点击过多 重复发布 的问题
 */

#import "AppDelegate.h"

#import "RootViewController.h"
#import "CustomNavigationController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "WelcomeViewController.h"

#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#define BaiduKey @"XEK99nOMi0M9IqtuTtpeEqhX"

//极光推送
#import "APService.h"


//第三方登陆
#import "WeiboSDK.h"
#define kAppKey @"3339821704"
#define kRedirectURI @"http://www.sina.com"

#import <TencentOpenAPI/TencentOAuth.h>

#import <TAESDK/TAESDK.h>

#import "ITF_Apply.h"


@interface AppDelegate(){
    CustomNavigationController *navigationController;
    
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

 
    //交表归零
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
   
    //百度地图的开发
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"v1.0" forKey:@"version"];
    
    NSString *device_lang = [[[NSLocale preferredLanguages] objectAtIndex:0] substringWithRange:NSMakeRange(0, 2)];
    NSString *app_lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    
    if (app_lang == NULL) {
        NSString *lang = ([device_lang isEqualToString:@"zh"]) ? @"zh" : @"en";
        [[NSUserDefaults standardUserDefaults] setObject:lang forKey:@"language"];
    }
    
    NSLog(@"language : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"language"]);
    
    NSLog(@"MYLocalizedString Test : %@", MYLocalizedString(@"确定", @"Test Localization"));
    
    // 支持shake
    [[UIApplication sharedApplication]setApplicationSupportsShakeToEdit:YES];
    //成为第一响应者
    [self becomeFirstResponder];
    
    //苹果自己的推送
    //[self addNotification];
    [self addAppKey];
    
    //初始化数据
    [[InitData alloc] initData];
    
   //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"welcome"];
    //[InitData setUser:nil];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"welcome"];
    
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    if ( str == nil){
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"welcome"];
        
        [welcome settype:0];
    }
    else{
        [welcome settype:1];

    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:welcome];
    nav.navigationBarHidden = YES;
   // nav.view.frame = CGRectMake(0, 0, nav.view.frame.size.width, nav.view.frame.size.height);
    
    [self.window setRootViewController:nav];
    
    
    //下面开始极光推送
    [self addJPush:launchOptions];
    
    return YES;
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    if (motion==UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shake" object:self];
    }
}

-(void) resetApp {
    WelcomeViewController* controller = [[WelcomeViewController alloc] init];
    
    _window.rootViewController = controller;
}

- (void) addJPush:(NSDictionary*) launchOptions{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"push"] isEqualToString:@"yes"])
        return;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"push"] == nil)
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"push"];
        
        
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
    // Required
    [APService setupWithOption:launchOptions];
}
/*
#pragma mark push
- (void) addNotification{
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge										 |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
        
    }
}*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
   // NSLog(@"---Token--%@", pToken);
    [APService registerDeviceToken:pToken];
    NSString *str  = [APService registrationID];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"registerID"];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
  /*  NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];*/
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
   // NSLog(@"Regist fail%@",error);
}
#pragma mark login
- (void) addAppKey{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    
    [[TaeSDK sharedInstance] setAppVersion:@"1.5.2"];//设置app版本号，可以在百川服务端查询对应版本的日志统计信息，比如crash率,crash日志，DAU等，默认SDK会取app的Bundle Version
    
    //[[TaeSDK sharedInstance] setDebugLogOpen:YES];//打开SDK警告提示以及日志输出，方便排查错误，app发布时务必关闭此开关
    
   // [[TaeSDK sharedInstance]setCloudPushSDKOpen:YES];//开启阿里云云推送功能，默认不开启
    
    [[TaeSDK sharedInstance] closeCrashHandler];//关闭SDK设置的crashHandler
    //sdk初始化
    [[TaeSDK sharedInstance] asyncInit:^{
        NSLog(MYLocalizedString(@"初始化成功", @"Initial success"));
    } failedCallback:^(NSError *error) {
        NSLog(MYLocalizedString(@"初始化失败:%@", @"Initialization failed:%@"),error);
    }];
    
}
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if  ([WeiboSDK handleOpenURL:url delegate:(id)self])
        return YES;
    if ([TencentOAuth HandleOpenURL:url])
        return YES;
    if ([[TaeSDK sharedInstance] handleOpenURL:url])
        return YES;
    return NO;
}
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if  ([WeiboSDK handleOpenURL:url delegate:(id)self])
        return YES;
    if ([TencentOAuth HandleOpenURL:url])
        return YES;
    if ([[TaeSDK sharedInstance] handleOpenURL:url])
        return YES;
    return NO;
}

//微博返回数据
- (void) didReceiveWeiboResponse:(WBAuthorizeResponse*) response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
   /*     NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", @"响应状态", (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  @"响应UserInfo数据", response.userInfo, MYLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:MYLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
       // self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
       // self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        [alert show];*/
        
        T_User *user = [[[ITF_Apply alloc] init] getSinaUserInfoByToken:[(WBAuthorizeResponse *)response accessToken] andUid:[(WBAuthorizeResponse *)response userID]];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user.userpwd, @"uid", user.username, @"nick", nil];
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"weibo" object:nil userInfo:dic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   // [BMKMapViewwillBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  //  [BMKMapViewdidForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //消息数目清空
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
