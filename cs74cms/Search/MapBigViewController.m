//
//  MapBigViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/12.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MapBigViewController.h"
#import "InitData.h"
#import "ITF_Apply.h"
#import "T_MapJob.h"
#import "JobListViewController.h"
#import "JobDetailViewController.h"

@interface MapBigViewController ()<BMKMapViewDelegate>{
    CLLocationCoordinate2D center;
    NSString *trade;
    NSString *jobCategory;
    int settr;
    BOOL Isjob;
    
    BMKMapView *mapView;
    NSMutableArray *array;
}

@end

@implementation MapBigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //基础地图
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    mapView.delegate = self;
    mapView.zoomLevel = 15;//定位地图到指定中心3-19级 10级 太原很小  19级具体到街   15级
    [self.view addSubview: mapView];
    
    if (abs(center.longitude - 0) > 0.0001 ){
        mapView.centerCoordinate = center;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLat:(float)lat andLon:(float)lon andIsJob:(BOOL) tjob{
    center = (CLLocationCoordinate2D){lat, lon};
    Isjob = tjob;
}

- (void) setCenter:(CLLocationCoordinate2D) pt andTrade:(NSString*) tradeStr andJob:(NSString*) jobStr andSettr:(int) settrs{
    center = pt;
    trade = tradeStr;
    jobCategory = jobStr;
    settr = settrs;
    
    mapView.centerCoordinate = center;
}

- (void) viewCanBeSee{
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        if (!Isjob)
            array = [[[ITF_Apply alloc] init] mapSearchByLat:center.latitude andLon:center.longitude andJobs:jobCategory andTrade:trade andSettr:settr andDistance:0];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (array != nil) {
                [self addPointArr];
            }
            [self addCenter];

        });
    });
    
    if (Isjob){
        [self.myNavigationController setTitle:MYLocalizedString(@"地图定位", @"Map location")];
        return;
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"地图搜索", @"Search by map")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:MYLocalizedString(@"职位列表", @"Position list") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 80, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(listClick) forControlEvents:UIControlEventTouchUpInside];
    NSArray *butArr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:butArr];
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void) addPointArr{
    NSMutableArray *pointArr = [[NSMutableArray alloc] init];
    for (T_MapJob *job in array){
        [pointArr addObject:[self addPoint:job]];
    }
}
- (void) addCenter{
    T_MapJob *data = [[T_MapJob alloc] init];
    data.jobs_name = MYLocalizedString(@"您的位置", @"Your location");
    if (Isjob)
        data.jobs_name = MYLocalizedString(@"所在位置", @"Seat position");
    data.lat = center.latitude;
    data.lon = center.longitude;
    [self addPoint:data];
}
- (BMKPointAnnotation*) addPoint:(T_MapJob*) data {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = data.lat;
    coor.longitude = data.lon;
    annotation.coordinate = coor;
    annotation.title = data.jobs_name;
    [mapView addAnnotation:annotation];
    return annotation;
}

- (void) listClick{
    JobListViewController *jobList = [[JobListViewController alloc] init];
    [jobList setDataSource:array];
    [self.myNavigationController pushAndDisplayViewController:jobList];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
 {
     if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
         BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];//
         newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
         if ([annotation.title isEqualToString:MYLocalizedString(@"您的位置", @"Your location")])
             newAnnotationView.pinColor = BMKPinAnnotationColorRed;
         newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
         return newAnnotationView;
         
         //让标注在进入界面时就处于弹出气泡框的状态
         //[newAnnotationView setSelected:YES animated:YES];
     
     }
     return nil;
 }
//点击弹出的泡泡
- (void) mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    //NSLog(@"点击annotation view弹出的泡泡");
    if ([view.annotation.title isEqualToString:MYLocalizedString(@"您的位置", @"Your location")])
        return;
    CLLocationCoordinate2D cor = view.annotation.coordinate;
    int Jid = 0;
    for (T_MapJob *data in array){
        if (data.lat == cor.latitude && data.lon == cor.longitude){
            Jid = data.ID;
            break;
        }
    }
    JobDetailViewController *detail = [[JobDetailViewController alloc] init];
    [detail setJid:Jid];
    [self.myNavigationController pushAndDisplayViewController:detail];
}
@end
