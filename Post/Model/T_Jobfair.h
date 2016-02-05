//
//  T_Jobfair.h
//  cs74cms
//
//  Created by lyp on 15/6/3.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Jobfair : NSObject


@property(nonatomic, assign) int ID;

@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* address;
@property(nonatomic, strong) NSString* holddate_start;

@property(nonatomic, strong) NSString* holddate_end;
@property(nonatomic, strong) NSString* introduction;
@property(nonatomic, strong) NSArray* trade_cn;
@property(nonatomic, strong) NSString* contact;
@property(nonatomic, strong) NSString* phone;

@property(nonatomic, assign) float lat;
@property(nonatomic, assign) float lon;

@end
