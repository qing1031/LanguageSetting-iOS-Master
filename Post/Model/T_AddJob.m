//
//  T_AddJob.m
//  cs74cms
//
//  Created by lyp on 15/5/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "T_AddJob.h"

@implementation T_AddJob

@synthesize ID;
@synthesize uid;
@synthesize click;//点击数
@synthesize countresume;//应聘简历数(未看的)

@synthesize company_id;
@synthesize companyname;

@synthesize add_mode;
@synthesize days;
@synthesize olddeadline;

@synthesize jobs_name;

//职位性质
@synthesize nature;
@synthesize nature_cn;

//职位类别名称
@synthesize topclass;
@synthesize category;
@synthesize subclass;
@synthesize category_cn;

@synthesize amount;

//地区分类名称
@synthesize district;
@synthesize sdistrict;
@synthesize district_cn;

//薪资待遇
@synthesize wage;
@synthesize wage_cn;

//学历要求
@synthesize education;
@synthesize education_cn;

//工作经验
@synthesize experience;
@synthesize experience_cn;

@synthesize contents;

@synthesize contact;
@synthesize telephone;
@synthesize email;


@synthesize addtime;
@synthesize refreshtime;

@synthesize demo;

@synthesize lat;
@synthesize lon;

@synthesize companyAudit;
@end
