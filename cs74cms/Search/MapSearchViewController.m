//
//  ViewController.m
//  cs74cms
//
//  Created by lyp on 15/5/23.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MapSearchViewController.h"
#import "InitData.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#import "ChoiceIndustryViewController.h"
#import "EduViewController.h"

#import "MapBigViewController.h"


#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]


@interface MapSearchViewController ()<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKMapViewDelegate
,MutableChoiceDelegate
,EduDelegate>{
   // BMKMapView *mapView;
    BMKLocationService * locService;
    
    BMKMapView *mapView;
    
    int selected;
    
    NSString *trade;
    NSString *jobCategory;
    int settr;

}

@end

@implementation MapSearchViewController

- (void) viewCanBeSee{
    [self.myNavigationController setTitle:MYLocalizedString(@"地图搜索", @"Search by map")];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    //基础地图
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height] / 2)];
    mapView.zoomLevel = 15;//定位地图到指定中心3-19级 10级 太原很小  19级具体到街   15级
    [self.view addSubview: mapView];
    
    [self baseView];
    
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    //[BMKLocationServicesetLocationDistanceFilter:100.f];

    if (SystemVersion >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
}
- (void) stopLoaction{
    [locService stopUserLocationService];
}


- (void) baseView{
    NSArray *titleArr = [NSArray arrayWithObjects:MYLocalizedString(@"行业选择", @"Industry choice"), MYLocalizedString(@"职能选择", @"Function selection"), MYLocalizedString(@"发布日期", @"Release date"), nil];
    NSArray *mesArr = [NSArray arrayWithObjects:MYLocalizedString(@"所有行业", @"All industry"), MYLocalizedString(@"所有职能", @"All functions"), MYLocalizedString(@"所有日期", @"All date"), nil];
    float height = [InitData Height] / 2 + 1;
    float cellHeight = 40;
    for (int i=0; i<[titleArr count]; i++){
        if (i > 0){
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, height - 1, [InitData Width] - 30, 1)];
            sep.backgroundColor = self.view.backgroundColor;
            [self.view addSubview:sep];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [InitData Width] / 2, cellHeight)];
        label1.font = [UIFont systemFontOfSize:15];
        label1.textColor = [UIColor colorWithRed:120./255 green:120./255 blue:120./255 alpha:1];
        label1.text = [titleArr objectAtIndex:i];
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
        label2.text = [mesArr objectAtIndex:i];
        label2.textColor = [UIColor colorWithRed:163./255 green:163./255 blue:163./255 alpha:1];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textAlignment = NSTextAlignmentRight;
        [view addSubview:label2];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 25) / 2, 20, 25)];
        [view addSubview:img];
        height += cellHeight;
        
    }
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(15, height + 8, [InitData Width] - 30, 35)];
    [but addTarget:self action:@selector(searchButClicked) forControlEvents:UIControlEventTouchUpInside];
    [but setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"butColor.png"]]];
    [but setTitle:MYLocalizedString(@"搜索", @"Search") forState:UIControlStateNormal];
    but.layer.cornerRadius = 5;
    [self.view addSubview:but];
}
#pragma mark event

- (void) searchButClicked{
    MapBigViewController *big = [[MapBigViewController alloc] init];
    [big setCenter:mapView.centerCoordinate andTrade:trade andJob:jobCategory andSettr:settr];
    [self.myNavigationController pushAndDisplayViewController:big];
}
- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    selected = recognizer.view.tag - 1;
    
    NSString *req;
    NSString *title;
    switch (selected) {
        case 0:
            req = @"QS_trade";
            title =  MYLocalizedString(@"行业", @"Industry");
            break;
        case 1:
            req = @"jobs";
            title = MYLocalizedString(@"职能", @"Function");
            break;
        default:
            title = MYLocalizedString(@"发布日期", @"Release date");
            break;
    }
    if (selected < 2){
        ChoiceIndustryViewController *mutable = [[ChoiceIndustryViewController alloc] init];
        mutable.delegate = self;
        [mutable setHanshuName:req];
        [mutable setSign:selected + 1];
        [self.myNavigationController pushAndDisplayViewController:mutable];
        
    }
    else{
        NSArray* subMenuArray = [NSArray arrayWithObjects:MYLocalizedString(@"近三天", @"In 3 days"), MYLocalizedString(@"近一周", @"In one week"), MYLocalizedString(@"近半月", @"In half month"), MYLocalizedString(@"近一月", @"In one month"), nil];
        EduViewController *edu = [[EduViewController alloc] init];
        [edu setViewWithNSArray:subMenuArray];
        edu.delegate = self;
        
        [self.myNavigationController pushAndDisplayViewController:edu];
    }
    
}

- (void) mutableChoiceByContent:(NSString *)content andId:(NSString *)idStr{
    UIView *view = [[self.view subviews] objectAtIndex:selected * 2 + 1];
    if ([[view subviews] count] > 2){
        UILabel *label = [[view subviews] objectAtIndex:1];
        label.text = content;
    }
    if (selected == 0){
        trade = idStr;
    }
    else{
        jobCategory = idStr;
    }
}
- (void) selectIndex:(int)index{
    NSArray* subMenuArray = [NSArray arrayWithObjects: MYLocalizedString(@"近三天", @"In 3 days"), MYLocalizedString(@"近一周", @"In one week"), MYLocalizedString(@"近半月", @"In half month"), MYLocalizedString(@"近一月", @"In one month"), nil];
    UIView *view = [[self.view subviews] objectAtIndex:selected * 2 + 1];
    if ([[view subviews] count] > 2){
        UILabel *label = [[view subviews] objectAtIndex:1];
        label.text = [subMenuArray objectAtIndex:index];
    }
        
    NSArray *tarray = [NSArray arrayWithObjects:@"3", @"7", @"15", @"30", nil];
    settr = [[tarray objectAtIndex:index] intValue];
}

#pragma mark delegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
   // NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self stopLoaction];
    locService.delegate = nil;
    
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    //37.806178 112.579169
    
    pt=(CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
   
   // pt=(CLLocationCoordinate2D){37.701126, 112.723032};
    mapView.centerCoordinate = pt;
    
    //下面开始反检索
    BMKReverseGeoCodeOption *opt = [[BMKReverseGeoCodeOption  alloc] init];
    opt.reverseGeoPoint = pt;
    
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init];
    search.delegate = self;
   // BOOL flag =
    [search reverseGeoCode:opt];
}
- (void) didFailToLocateUserWithError:(NSError *)error{
    [self stopLoaction];
}

- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
   // NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
   // [_mapView removeAnnotations:array];
  //  array = [NSArray arrayWithArray:_mapView.overlays];
  //  [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mapView addAnnotation:item];
        
        //设置中心点
        mapView.centerCoordinate = result.location;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 20)];
        label.backgroundColor = [UIColor colorWithRed:35./255 green:35./255 blue:35./255 alpha:0.8];
        [self.view addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [NSString stringWithFormat: MYLocalizedString(@"      中心位置:%@", @"Center location:%@"), result.address];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    mapView.delegate = nil;
    mapView = nil;
    
    [self stopLoaction];
    locService.delegate = nil;
    locService = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
   // [mapView viewWillAppear];
   // mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
  //  [mapView viewWillDisappear];
  //  mapView.delegate = nil; // 不用时，置nil
}*/
@end
