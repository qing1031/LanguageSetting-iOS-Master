//
//  MapBigViewController.h
//  cs74cms
//
//  Created by lyp on 15/6/12.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

@interface MapBigViewController : SuperViewController

//搜索中心周围的工作
- (void) setCenter:(CLLocationCoordinate2D) pt andTrade:(NSString*) tradeStr andJob:(NSString*) jobStr andSettr:(int) settrs;


//只添加一个中心
- (void) setLat:(float)lat andLon:(float)lon andIsJob:(BOOL) tjob;


@end
