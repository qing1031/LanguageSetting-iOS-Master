//
//  ChoiceIndustryViewController.m
//  74cms
//
//  Created by lyp on 15/4/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ChoiceIndustryViewController.h"
#import "InitData.h"
#import "MeSelectedView.h"
#import "MutableMenuViewController.h"

//定位
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#import "T_Interface.h"

@interface ChoiceIndustryViewController ()<MeSelectedDelegate, MutableMenuDelegate
,BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    MeSelectedView *meSelected;
    UIView *content;
    MutableMenuViewController *mutableMenu;
    
    int cnt;
    NSMutableArray *array;//存储行业集

    
    BOOL hidden;
    
    int sign;//标记， 0地区 1行业 2职能
    NSString *titleString;
    
    NSMutableArray *seletedArr;//存储选中的
    NSMutableArray *idArr;
    
    //定位
    BMKLocationService * locService;
}

@end

@implementation ChoiceIndustryViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([[self.view subviews] count] <= 0)
        [self drawView];
}

- (void) setTitle:(NSString *)title{
    //[self.myNavigationController setTitle:title];
    titleString = title;
    if (self.myNavigationController != nil)
        [self.myNavigationController setTitle:title];
    
    UIView * topview = [[self.view subviews] objectAtIndex:0];
    UILabel *leftLab = [[topview subviews] objectAtIndex:0];
    
    sign = 0;
    if ([title isEqualToString:MYLocalizedString(@"选择职能", @"Select function")]){
        sign = 2;
        leftLab.text = MYLocalizedString(@"已选职能", @"Selected function");
    }
    else if ([title isEqualToString:MYLocalizedString(@"选择行业", @"Select industry")]){
        sign = 1;
        leftLab.text = MYLocalizedString(@"已选行业", @"Selected industry");
    }
}

- (void) setSign:(int) tsign{
    sign = tsign;
    
    UIView * topview = [[self.view subviews] objectAtIndex:0];
    UILabel *leftLab = [[topview subviews] objectAtIndex:0];
    
    if (sign == 2){
        titleString = MYLocalizedString(@"选择职能", @"Select function");
        leftLab.text = MYLocalizedString(@"已选职能", @"Selected function");
    }
    else if (sign == 1){
        titleString = MYLocalizedString(@"选择行业", @"Select industry");
        leftLab.text = MYLocalizedString(@"已选行业", @"Selected industry");
    }
}

- (void) viewCanBeSee{
    
    if ([[self.view subviews] count] <= 0)
        [self drawView];
    if (titleString != nil && ![titleString isEqualToString:@""])
        [self.myNavigationController setTitle:titleString];

    UIButton *remark = [UIButton buttonWithType:UIButtonTypeCustom];
    [remark setTitle:MYLocalizedString(@"确定", @"Done") forState:UIControlStateNormal];
    [remark addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [remark setFrame:CGRectMake(0, 0, 40, 40)];
    remark.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObjects:remark, nil];
    [self.myNavigationController setRightBtn:arr];
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenThis:)];
    recognizer.numberOfTapsRequired = 1;
    [topView addGestureRecognizer:recognizer];
    
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 20)];
    leftLab.font = [UIFont systemFontOfSize:15];
    leftLab.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    leftLab.text = MYLocalizedString(@"已选地区", @"Selected district");
    [topView addSubview:leftLab];

    
    UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 100, 10, 65, 20)];
    rightLab.textColor = leftLab.textColor;
    rightLab.font = leftLab.font;
    rightLab.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  展开", @"%d/3  Open"), cnt];
    [topView addSubview:rightLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 30, 13, 15, 15)];
    [imgView setImage:[UIImage imageNamed:@"unfold.png"]];
    [topView addSubview:imgView];
    
    meSelected = [[MeSelectedView alloc] initWithFrame:CGRectMake(-1, 40, [InitData Width] + 2, 1)];
    [self.view addSubview:meSelected];
    meSelected.delegate = self;
    cnt = 0;
    hidden = NO;
    
    if (!hidden)
        [imgView setImage:[UIImage imageNamed:@"pack_up.png"]];

}

- (void) setHanshuName:(NSString*) str{
    
    
  //  UIView * topview = [[self.view subviews] objectAtIndex:0];
  //  UILabel *leftLab = [[topview subviews] objectAtIndex:0];
    
    sign = 999;
    if ([str isEqualToString:@"district"]){
        sign = 0;
    }
    else if ([str isEqualToString:@"QS_trade"]){
        sign = 1;
    }
    else if ([str isEqualToString:@"jobs"]){
        sign = 2;
    }
    
    content = [[UIView alloc] init];
    [content setFrame:CGRectMake(0, 41, [InitData Width], [InitData Height] - 40)];
    [content setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:content];
    
    float height = content.frame.size.height;
    float originY = 0;
    if (sign == 0){//地区添加定位
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
        label.text = MYLocalizedString(@"定位", @"Location");
        label.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        [content addSubview:label];
        
        UIButton *locBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [locBut setFrame:CGRectMake(50, 0, 30, 30)];
        [locBut setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [locBut addTarget:self action:@selector(locButClick) forControlEvents:UIControlEventTouchUpInside];
        [locBut setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        [content addSubview:locBut];
        height -=  30;
        originY = 30;
    }
   
    
    mutableMenu= [[MutableMenuViewController alloc] init];
    [mutableMenu setHanshuName:str];
    [mutableMenu setDelegate:self];
    [mutableMenu setCanDuoXuan:YES];
    [mutableMenu setTableViewY:originY andHeight:height];
    [content addSubview:mutableMenu.view];
}

- (void) hiddenThis:(UITapGestureRecognizer*) recognizer{

    UIView *topView = [[self.view subviews] objectAtIndex:0];
    UILabel *label = [[topView subviews] objectAtIndex:1];
    UIImageView *imgView = [[topView subviews] objectAtIndex:2];
    
    hidden = !hidden;
    if (hidden){
        label.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  展开", @"%d/3  Open"), cnt];
        [imgView setImage:[UIImage imageNamed:@"unfold.png"]];
    }
    else{
        label.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  收起", @"%d/3  Closed"), cnt];
        [imgView setImage:[UIImage imageNamed:@"pack_up.png"]];
    }
    
    if (cnt == 0)
        return;

    
    float y = content.frame.origin.y;
    
    y = hidden?  41:(meSelected.frame.size.height + 40);

    
    [content setFrame:CGRectMake(0, y, [InitData Width], [InitData Height] - y)];
    float height = content.frame.size.height;
    float originY = 0;
    if (sign == 0){
        height -= 30;
        originY = 30;
    }
    [mutableMenu setTableViewY:originY andHeight:height];
}



- (void) saveClicked{
    NSString *contentString = [seletedArr componentsJoinedByString:@","];
    NSString *idString = [idArr componentsJoinedByString:@","];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(mutableChoiceByContent:andId:)]){
        [self.delegate mutableChoiceByContent:contentString andId:idString];
    }
    [self.myNavigationController dismissViewController];
}
#pragma mark locaiton
- (void) locButClick{
    
    [InitData isLoading:self.view];
    
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
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
  //  NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    
    [self stopLoaction];
    locService.delegate = nil;
    
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    //37.806178 112.579169
    
    pt=(CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    
    // pt=(CLLocationCoordinate2D){37.701126, 112.723032};
  //  mapView.centerCoordinate = pt;
    
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
      //  BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
     //   item.coordinate = result.location;
     //   item.title = result.address;
       // [mapView addAnnotation:item];
        [self getCity:result.address];
    }
}

- (void) getCity:(NSString*) str{
    NSString * hanshuName = @"district";

    
 //   [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSMutableString *idStr;
        NSMutableString *cityStr;
        NSArray * tarray = [[[T_Interface alloc] init] classify:hanshuName andParentid:0];
        for (T_category *cat in tarray){
            if ([str rangeOfString:cat.c_name].location != NSNotFound){
                idStr = [[NSMutableString alloc] initWithFormat:@"%d",cat.c_id];
                cityStr = [[NSMutableString alloc] initWithString:cat.c_name];
                break;
            }
        }
        if (idStr != nil){
            NSArray * tarray = [[[T_Interface alloc] init] classify:hanshuName andParentid:[idStr intValue]];
            for (T_category *cat in tarray){
                if ([str rangeOfString:cat.c_name].location != NSNotFound){
                    [idStr appendFormat:@".%d", cat.c_id];
                    [cityStr appendFormat:@"/%@", cat.c_name];
                    break;
                }
            }
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (idStr != nil){
                [self MutableMenuSelectedId:0 andIdString:idStr andTitle:@"" andTitleString:cityStr];
            }
        });
    });
}

#pragma mark delegate

- (void) deleteItem:(int)t{
    cnt--;
   // NSString *str = [seletedArr objectAtIndex:t];
   // int index = (int)[array indexOfObject:str];
    [seletedArr removeObjectAtIndex:t];
    [idArr removeObjectAtIndex:t];
    
    float y = content.frame.origin.y;
    y = hidden? 41:( meSelected.frame.size.height + 40) ;
    
    [content setFrame:CGRectMake(0, y, [InitData Width], [InitData Height] - y)];
    float height = content.frame.size.height;
    float originY = 0;
    if (sign == 0){
        height -= 30;
        originY = 30;
    }
    [mutableMenu setTableViewY:originY andHeight:height];

    
    UIView *topView = [[self.view subviews] objectAtIndex:0];
    UILabel *label = [[topView subviews] objectAtIndex:1];
    
    if (hidden){
        label.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  展开", @"%d/3  Open"), cnt];
    }
    else{
        label.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  收起", @"%d/3  Closed"), cnt];
    }
}
- (void) MutableMenuSelectedId:(int)c_id andIdString:(NSString *)idString andTitle:(NSString *)title andTitleString:(NSString *)titlestring{
    if (cnt >= 3 || [seletedArr containsObject:titlestring] || [seletedArr containsObject:title]) {
        return;
    }
    
    if (sign == 0){
        [meSelected addString:titlestring];
    }
    else{
        [meSelected addString:title];
    }

    cnt++;
    
    float y = content.frame.origin.y;
    y = hidden? 41:( meSelected.frame.size.height + 40) ;
    
    [content setFrame:CGRectMake(0, y, [InitData Width], [InitData Height] - y)];
    float height = content.frame.size.height;
    float originY = 0;
    if (sign == 0){
        height -= 30;
        originY = 30;
    }
    [mutableMenu setTableViewY:originY andHeight:height];
    
    UIView *topView = [[self.view subviews] objectAtIndex:0];
    UILabel *label = [[topView subviews] objectAtIndex:1];
    
    if (hidden){
        label.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  展开", @"%d/3  Open"), cnt];
    }
    else{
        label.text = [NSString stringWithFormat:MYLocalizedString(@"%d/3  收起", @"%d/3  Closed"), cnt];
    }
    
    //添加到选中集
    if (seletedArr == nil){
        seletedArr = [[NSMutableArray alloc] init];
        idArr = [[NSMutableArray alloc] init];
    }
    if (sign == 0) {
        [seletedArr addObject:titlestring];
    }else{
        [seletedArr addObject:title];
    }
    [idArr addObject:idString];
}

@end
