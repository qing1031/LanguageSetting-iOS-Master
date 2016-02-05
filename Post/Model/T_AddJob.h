//
//  T_AddJob.h
//  cs74cms
//
//  Created by lyp on 15/5/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_AddJob : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, assign) int uid;
@property(nonatomic, assign) int click;//点击数
@property(nonatomic, assign) int countresume;//应聘简历数(未看的)


@property(nonatomic, assign) int company_id;//公司ID
@property(nonatomic, strong) NSString* companyname;

@property(nonatomic, assign) int add_mode;
@property(nonatomic, strong) NSString * olddeadline;//职位之前的到期时间(时间戳)
@property(nonatomic, assign) int days;

@property(nonatomic, strong) NSString * jobs_name;

//职位性质
@property(nonatomic, assign) int nature;
@property(nonatomic, strong) NSString * nature_cn;

//职位类别名称
@property(nonatomic, assign) int topclass;
@property(nonatomic, assign) int category;
@property(nonatomic, assign) int subclass;
@property(nonatomic, strong) NSString * category_cn;

@property(nonatomic, assign) int amount;

//地区分类名称
@property(nonatomic, assign) int district;
@property(nonatomic, assign) int sdistrict;
@property(nonatomic, strong) NSString * district_cn;

//薪资待遇
@property(nonatomic, assign) int wage;
@property(nonatomic, strong) NSString * wage_cn;

//学历要求
@property(nonatomic, assign) int education;
@property(nonatomic, strong) NSString * education_cn;

//工作经验
@property(nonatomic, assign) int experience;
@property(nonatomic, strong) NSString * experience_cn;

@property(nonatomic, strong) NSString * contents;

@property(nonatomic, strong) NSString * contact;
@property(nonatomic, strong) NSString * telephone;
@property(nonatomic, strong) NSString * email;

@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *refreshtime;

@property(nonatomic, assign) int demo;

@property(nonatomic, assign) float lat;
@property(nonatomic, assign) float lon;

@property(nonatomic, assign) int companyAudit;


@end
