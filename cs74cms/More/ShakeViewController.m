//
//  ShakeViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/10.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ShakeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "InitData.h"
#import "ITF_Other.h"
#import "JobListViewController.h"


@interface ShakeViewController ()<CLLocationManagerDelegate>{
    SystemSoundID soundID;
    
    UIImageView *imgUp;
    UIImageView *imgDown;
    
    BOOL run;//标记是否执行摇一摇
}

@property (nonatomic, retain) CLLocationManager* locationMgr;
@property (nonatomic, retain) CLGeocoder* clGeocoder;// iso 5.0及5.0以上SDK版本使

@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //添加声音
    // aiLoad.hidden=YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shakeAction) name:@"shake" object:nil];
    
    
    imgUp = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 225) / 2, [InitData Height] / 2 - 127, 225, 127)];
    [imgUp setImage:[UIImage imageNamed:@"shake_logo_up.png"]];
    [self.view addSubview:imgUp];
    
    imgDown = [[UIImageView alloc] initWithFrame:CGRectMake(([InitData Width] - 225) / 2, [InitData Height] / 2, 225, 127)];
    [imgDown setImage:[UIImage imageNamed:@"shake_logo_down.png"]];
    [self.view addSubview:imgDown];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    [but setFrame:CGRectMake(40, 40, 40, 40)];
    [but setBackgroundColor:[UIColor whiteColor]];
    [but addTarget:self action:@selector(shakeAction) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:but];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewCanBeSee{
    run = YES;
}
- (void) viewCannotBeSee{
    run = NO;
}


- (void) getValue{
    self.locationMgr = [[CLLocationManager alloc] init];
    
    //设置代理
    self.locationMgr.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationMgr.distanceFilter = 1000.0f;
    
    //开始定位
    [self.locationMgr startUpdatingLocation];
}

//添加
#pragma mark - 摇一摇动画效果
- (void)addAnimations
{
    
    //让imgup上下移动
    CABasicAnimation *translation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    float height2 = imgUp.frame.origin.y + imgUp.frame.size.height / 2;
    translation2.fromValue = [NSValue valueWithCGPoint:CGPointMake([InitData Width] / 2, height2)];
    translation2.toValue = [NSValue valueWithCGPoint:CGPointMake([InitData Width] / 2, height2 - 80)];
    translation2.duration = 0.4;
    translation2.repeatCount = 1;
    translation2.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    float height = imgDown.frame.origin.y + imgDown.frame.size.height / 2;
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake([InitData Width] / 2, height)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake([InitData Width] / 2, height + 80)];
    translation.duration = 0.4;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    
    [imgDown.layer addAnimation:translation forKey:@"translation"];
    [imgUp.layer addAnimation:translation2 forKey:@"translation2"];
    
    //    [aiLoad stopAnimating];
    //    aiLoad.hidden=YES;
    
}

#pragma mark delegate

// iso 6.0以上SDK版本使用，包括6.0。//37.806178 112.579169
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationMgr stopUpdatingLocation];
    CLLocation *cl = [locations objectAtIndex:0];
   // NSLog(@"纬度--%f",cl.coordinate.latitude);
   // NSLog(@"经度--%f",cl.coordinate.longitude);
   // NSString *str = [NSString stringWithFormat:@"纬度--%f 经度--%f", cl.coordinate.latitude, cl.coordinate.longitude];
   // [InitData netAlert:str];
    //不可从主线程取值
    [self getDataByLat:cl.coordinate.latitude andLon:cl.coordinate.longitude];
    //[self getDataByLat:37.701126 andLon:112.723032];
}

- (void) getDataByLat:(float) lat andLon:(float)lon{
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSMutableArray * tarray = [[[ITF_Other alloc] init] shakeByMap_x:lon andMap_y:lat];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            JobListViewController *jobList = [[JobListViewController alloc] init];
            [jobList setDataSource:tarray];
            [self.myNavigationController pushAndDisplayViewController:jobList];
        });
    });
}

//获取定位失败回调方法
#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [InitData netAlert:MYLocalizedString(@"无法获取您的位置！", @"Could not get your location!")];
}

- (void) shakeAction{
    if (!run)
        return;

    [self getValue];
    
    
    [self addAnimations];
    AudioServicesPlaySystemSound(soundID);
    
    
}

@end
