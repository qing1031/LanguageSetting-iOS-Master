//
//  T_ApplyJob.m
//  cs74cms
//
//  Created by lyp on 15/5/25.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "T_ApplyJob.h"

@implementation T_ApplyJob

@synthesize did;
@synthesize resume_id;
@synthesize personal_uid;
@synthesize jobs_id;

//apply_addtime
@synthesize apply_addtime;
@synthesize down_addtime;

//对方是否查看(是/否) 2/1
@synthesize personal_look;

//对方回复状态编号  0->待反馈  1->符合要求  2->不合适  3->以后联系
@synthesize is_reply;

//职位名称
@synthesize jobs_name;

//公司名称
@synthesize companyname;

//反馈状态
@synthesize replay_status;


//简历名字隐私设置状态码
@synthesize display_name;
//简历名字
@synthesize fullname;

@synthesize sex_cn;

@synthesize birthdate;

@synthesize education_cn;

@synthesize experience_cn;
//意向职位
@synthesize intention_jobs;

@synthesize demo;

@end
