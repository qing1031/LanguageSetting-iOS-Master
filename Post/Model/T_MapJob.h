//
//  T_MapJob.h
//  cs74cms
//
//  Created by lyp on 15/6/12.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_MapJob : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, strong) NSString *jobs_name;
@property(nonatomic, strong) NSString* companyname;
@property(nonatomic, strong) NSString *wage_cn;
@property(nonatomic, strong) NSString* refreshtime;

@property(nonatomic, assign) float lat;
@property(nonatomic, assign) float lon;

@end
