//
//  T_Company.h
//  cs74cms
//
//  Created by lyp on 15/5/27.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Company : NSObject

@property(nonatomic, assign) int ID;

@property(nonatomic, assign) int uid;

@property(nonatomic, strong) NSString *companyname;

//企业性质
@property(nonatomic, assign) int nature;
@property(nonatomic, strong) NSString *nature_cn;

//所属行业
@property(nonatomic, assign) int trade;
@property(nonatomic, strong) NSString *trade_cn;

//企业规模
@property(nonatomic, assign) int scale;
@property(nonatomic, strong) NSString *scale_cn;

//地区
@property(nonatomic, assign) int district;
@property(nonatomic, assign) int sdistrict;
@property(nonatomic, strong) NSString *district_cn;

//详细地址
@property(nonatomic, strong) NSString *address;
@property(nonatomic, assign) float lat;
@property(nonatomic, assign) float lon;

//公司简介
@property(nonatomic, strong) NSString *contents;

//联系人
@property(nonatomic, strong) NSString *contact;

//联系电话
@property(nonatomic, strong) NSString *telephone;

//邮箱
@property(nonatomic, strong) NSString *email;

@property(nonatomic, assign) int countJobs;//应聘简历数(未看的)

@end
