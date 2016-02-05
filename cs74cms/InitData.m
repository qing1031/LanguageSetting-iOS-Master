//
//  InitDataController.m
//  myFirstPro
//
//  Created by zwh on 14-3-26.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import "InitData.h"


// 获取当前设备可用内存及所占内存的头文件
#import <sys/sysctl.h>
#import <mach/mach.h>

//存在网络
static BOOL netIsExit, netIsOk, wifi, wan;

//屏幕信息
static double allWidth;
static double allHeight;

//状态栏的高度
static double stateBarHeight;

//导航栏的高度
static double navControllerHeight;
static double navControllerY;
static double navBarHight;

//可操作的区域
static CGPoint origin;
static double width;
static double height;

//底部标签栏的大小
static double tabBarY;
static double tabBarHeight;
static double tabBarDown;

//子菜单的大小
static double subMenuViewX;
static double subMenuViewY;
static double subMenuViewCellHeight;
static double subMenuViewWidth;
static double subMenuAnimateTime;


//样片界面
static double themeImageHeight;



static T_User *user;
static int pid;


//图片路径
static NSString *path;
static NSString *homeDBPath;
static NSString *appleDownLoadPath;
static NSString *androidDownLoadPath;


static UIView *activityView;

@implementation InitData

@synthesize netDelegate;

+ (NSString*) Path{
    return path;
}
+ (NSString*) HomeDBPath{
    return homeDBPath;
}
+ (void) setAppleDownLoadPath:(NSString*) path{
    appleDownLoadPath = path;
}
+ (NSString*) getAppleDownLoadPath{
    return appleDownLoadPath;
}
+ (void) setAndroidDownLoadPath: (NSString*) path{
    androidDownLoadPath = path;
}
+ (NSString*) getAndroidDownLoadPath{
    return androidDownLoadPath;
}
// 获取当前设备可用内存(单位：MB）
+ (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}
// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}


//常用用户信息
+ (T_User*) setUser:(T_User*) tuser{
    if (tuser == nil || tuser.username != nil ){//&& tuser.userpwd != nil)
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tuser];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"user"];
    }
    return user = tuser;
}

+ (T_User*) getUser{
    if (user == nil){
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
        user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return user;
}

+ (int) setPid:(int) t{
    return pid = t;
}

+ (int) getPid{
    return pid;
}

+ (double)AllWidth{
    return allWidth;
}
+ (double)AllHeight{
    return allHeight;
}

//状态栏的高度
+ (double) StateBarHeight{
    return stateBarHeight;
}

//导航栏的高度
+ (double) NavControllerHeight{
    return navControllerHeight;
}
+ (double) NavControllerY{
    return navControllerY;
}
+ (double) NavBarHight{
    return navBarHight;
}

//可操作的区域
+ (CGPoint) Origin{
    return origin;
}
+ (double) Width{
    return width;
}
+ (double) Height{
    return height;
}

//底部标签栏的大小
+ (double) TabBarY{
    return tabBarY;
}
+ (double) TabBarHeight{
    return tabBarHeight;
}
+ (double) TabBarDown{
    return tabBarDown;
}

//子菜单的大小
+ (double) SubMenuViewX{
    return subMenuViewX;
}
+ (double) SubMenuViewY{
    return subMenuViewY;
}
+ (double) SubMenuViewCellHeight{
    return subMenuViewCellHeight;
}
+ (double) SubMenuViewWidth{
    return subMenuViewWidth;
}
+ (double) SubMenuAnimateTime{
    return subMenuAnimateTime;
}
//样片界面
+ (double) ThemeImageHeight{
    return themeImageHeight;
}
- (void) initData{
   // NSInteger number = [DeviceInfo currentResolution];
    //整个屏幕的信息,除去状态栏
    CGSize size = [UIScreen mainScreen].applicationFrame.size;////[DeviceInfo deviceSize:[DeviceInfo currentResolution]];//CGSizeMake(320, 480);[UIScreen mainScreen].bounds.size;//
    allWidth = size.width;
    allHeight = size.height;
    
    //状态栏的高度
    stateBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //导航栏的信息
   // size = [InitData calculateImageSize:CGSizeMake(allWidth, allHeight) imageSize:[UIImage imageNamed:@"红色搜索框"].size priorDirection:X];
    navBarHight = navControllerHeight = 35;
    navControllerY = 0;
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if ([phoneVersion characterAtIndex:0] == '6'){
        
    }else{
        allHeight += stateBarHeight;
        navControllerY = stateBarHeight;
        navControllerHeight += navControllerY ;
        stateBarHeight = 0;
    }
    //NSLog(@"%f %f %f", [UIScreen mainScreen].bounds.size.height, allWidth, allHeight);
    
    //底部标签栏的大小
    tabBarHeight = 0;//allHeight * 145 / 1135;
    tabBarY =  allHeight - tabBarHeight;
    tabBarDown = allHeight * 10 / 460;

    
    //页面的框架
    origin.x = 0;
    origin.y = navControllerY + navBarHight;
    height = tabBarY - navControllerHeight;
    width = allWidth;
    
    //子菜单的大小
    subMenuViewWidth = allWidth * 262 / 640;
    subMenuViewX = allWidth - subMenuViewWidth - 8;
    subMenuViewY = navControllerY + navControllerHeight;
    subMenuViewCellHeight = 40;//allHeight * 448 / 1135 / 5;
    subMenuAnimateTime = 0.2;
    
    //样片界面
    themeImageHeight = [InitData calculateImageSize:CGSizeMake(width, height) imageSize:[UIImage imageNamed:@"罗亚罗浮宫"].size priorDirection:X].height;
    
    path = @"http://newtest.74cms.com/lj/xiaojun3d_xin/phone/index.php";
    //@"http://may.74cms.com/phone/index.php";//@"http://74cms36.74cms.com/android/";
   // homeDBPath = //@"http://115.28.44.99:8099/StudioAssistant/interface/wsmobile.asmx/";
   // @"http://192.168.1.2/StudioAssistant/interface/wsmobile.asmx/";
    
    appleDownLoadPath = nil;
    androidDownLoadPath = nil;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"skinColor"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"black" forKey:@"skinColor"];
    }
    
    
    //正在加载数据
    activityView = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] / 2 - 75, ([InitData Height] - 40) / 2, 150, 40)];
    [activityView setBackgroundColor:[UIColor blackColor]];
    activityView.layer.cornerRadius = 3;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity setCenter:CGPointMake(25, 20)];
    [activityView addSubview:activity];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 110, 40)];
    title.textColor = [UIColor whiteColor];
    title.text = MYLocalizedString(@"正在加载数据...", @"Loading data...");
    title.font = [UIFont systemFontOfSize:14];
    [activityView addSubview:title];
}

+ (CGSize) calculateImageSize:(CGSize)size imageSize:(CGSize)imageSize priorDirection:(Direction) dir{
    if (!imageSize.height || !imageSize.width)
        return CGSizeMake(0, 0);
    if (dir == X){
        double hight = size.width  * imageSize.height / imageSize.width;
        return CGSizeMake(size.width, hight);
    }
    double twidth = size.height * imageSize.width / imageSize.height;
    return CGSizeMake(twidth, size.height);
}

/**
 *功能：网络提醒功能
 */
+(void)netAlert:(NSString*)message
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:MYLocalizedString(@"提示", @"Prompt") message:message delegate:nil cancelButtonTitle:MYLocalizedString(@"确定", @"Done") otherButtonTitles:nil, nil];
    
    [alertView show];
}

+ (BOOL) judgeInt:(NSString*) str{
    for (int i=0; i<str.length; i++){
        if ([str characterAtIndex:i] <'0' || [str characterAtIndex:i] > '9')
            return false;
    }
    return true;
}

#pragma mark -network
/**
 *功能：用于更新网络的状态
 */
+ (BOOL) NetIsExit{
    Reachability* curReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    netIsExit = false;
    
    netIsOk = false;
    
    wifi = false;
    
    wan = false;
	
    switch (netStatus)
    {
        case NotReachable:
        {
            netIsOk = false;
            
            break;
        }
            
        case ReachableViaWWAN:
        {
            wifi = true;
            
            break;
        }
        case ReachableViaWiFi:
        {
            wan = true;
            
            break;
        }
    }
    
    netIsExit = netIsOk || wifi || wan;
    
    if(!netIsExit){
        dispatch_async(dispatch_get_main_queue(), ^{
           [self netAlert:MYLocalizedString(@"当前网络不可用，请检查网络连接！", @"The current network is not available. Please check your network connection!")];
        });
    }
    
    return netIsExit;
}

//Called by Reachability whenever status changes.
/*
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
    
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
	[self updateInterfaceWithReachability: curReach];
    
    [self dealData];
}
-(void)dealData
{
    static int number = 0;
    
    if(number<1)
    {
        //调用代理方法
        [netDelegate UpData];
    }
    
    number++;
    
    if(number>=3)
    {
        number = 0;
    }
}


- (void) initNet{
    //网络测试
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

    
    netIsExit = false;//主要测试网络是否畅通，状态：false不通， true通
    
    netIsOk = false;
    
    wifi = false;
    
    wan = false;
    
    //初始化网络
    hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
    
	[hostReach startNotifier];
    
	[self updateInterfaceWithReachability: hostReach];
	
    internetReach = [Reachability reachabilityForInternetConnection];
    
	[internetReach startNotifier];
    
	[self updateInterfaceWithReachability: internetReach];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
    
	[wifiReach startNotifier];
    
	[self updateInterfaceWithReachability: wifiReach];
}
*/

//销毁内存
+ (void) distory:(UIView *) view{
    if (view == nil) {
        return;
    }
    int count = (int)[[view subviews] count];
    if (count > 0) {
        for (int i=count - 1; i>=0; i--){
            [self distory:[[view subviews] objectAtIndex:i]];
        }
    }
    if (view.superview != nil && [view respondsToSelector:@selector(removeFromSuperview)])
        [view removeFromSuperview];
}

+ (BOOL) stringIsalnum:(NSString*) str{
    for (int i=0; i<str.length; i++){
        char c = [str characterAtIndex:i];
        if (isalnum(c) == 0)
            return NO;
    }
    return YES;
}
+(BOOL) stringIsPhoneNumber:(NSString*) str{
    NSString *emailRegex = @"^1(3|5|4|7|8)\\d{9}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}
+ (BOOL) stringIsEmail:(NSString*) str{

    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$" ;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

+ (UIColor*) getSkinColor{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey: @"skinColor"];
    if ([str isEqualToString:@"blue"]){
        return [UIColor colorWithRed:51./255 green:128./255 blue:216./255 alpha:1];
    }
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];

}
+ (NSDate*) dateFromString:(NSString*) str{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [format dateFromString:str];
    return date;
}
+ (NSString*) stringFromDate:(NSDate*) date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSString * str = [format stringFromDate:date];
    return str;
}


+ (void) isLoading:(UIView*) superview{
    if ([activityView superview] != nil){
        [activityView removeFromSuperview];
    }
    superview.userInteractionEnabled = NO;
    [superview  addSubview:activityView];
    if ([[activityView subviews] count] >= 1){
        UIActivityIndicatorView *activity = [[activityView subviews] objectAtIndex:0];
        if ([activity respondsToSelector:@selector(startAnimating)])
            [activity startAnimating];
    }
}

+ (void) haveLoaded:(UIView*) superview{
    UIActivityIndicatorView  * activity = [[activityView subviews] objectAtIndex:0];
    [activity stopAnimating];
    [activityView removeFromSuperview];
    superview.userInteractionEnabled = YES;
}


//时间戳变成时间
+ (NSDate*) dateFromNum:(NSString*) str{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str integerValue]];
   // NSLog(@"date1:%@",date);
    return date;
}

+ (NSMutableAttributedString*) getMutableAttributedStringWithString:(NSString*) str{
    if (str == nil)
        str = @"";
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment                = NSTextAlignmentJustified;    // To justified text
    paragraphStyles.firstLineHeadIndent      = 0.05;    // IMP: must have a value to make it work
    NSDictionary *attributes                 = @{NSParagraphStyleAttributeName: paragraphStyles};
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attributes];
    return AttributedStr;
}







@end
