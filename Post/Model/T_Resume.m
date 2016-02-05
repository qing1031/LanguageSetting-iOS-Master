//
//  T_Resume.m
//  cs74cms
//
//  Created by lyp on 15/5/14.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "T_Resume.h"

@implementation T_Resume

@synthesize ID;//
@synthesize subsite_id;//分站id
@synthesize uid;//会员uid
@synthesize display;//是否显示
@synthesize display_name;//显示简历名称
@synthesize audit;//简历审核

@synthesize title;//简历标题
@synthesize fullname;//

@synthesize sex;//
@synthesize sex_cn;

@synthesize nature;//工作性质
@synthesize nature_cn;

@synthesize trade;//行业
@synthesize trade_cn;

@synthesize birthdate;//出生日期
@synthesize age;

@synthesize residence;//现居住地
@synthesize residence_cn;

@synthesize height;//身高

@synthesize marriage;//婚否（1,2）婚否（未婚，已婚）
@synthesize marriage_cn;

@synthesize experience;//工作经验
@synthesize experience_cn;

@synthesize district;//地区大类
@synthesize district_cn;//期望工作地区
@synthesize sdistrict;//地区小类


@synthesize wage;//期望薪资
@synthesize wage_cn;

@synthesize householdaddress;//户口所在地
@synthesize householdaddress_cn;

@synthesize education;//学历
@synthesize education_cn;

@synthesize major;//专业
@synthesize major_cn;

@synthesize current;//目前状态
@synthesize current_cn;

@synthesize tag;//简历标签
@synthesize tag_cn;

@synthesize telephone;//电话

@synthesize email;//邮箱

@synthesize email_notify;//邮件接收通知

@synthesize intention_jobs;//期望职位

@synthesize specialty;//自我描述

@synthesize photo;//是否为照片简历

@synthesize photo_img;//照片

@synthesize photo_audit;//照片审核

//@synthesize photo_display;//是否显示照片

@synthesize addtime;//添加时间

@synthesize refreshtime;//简历刷新时间

@synthesize entrust;//简历委托

@synthesize talent;//高级人才

@synthesize level;//简历等级（优良差）

@synthesize complete_percent;//简历完整度

@synthesize key;//全文搜索关键字

@synthesize click;//查看次数

@synthesize tpl;//模板

@synthesize demo;
@end
