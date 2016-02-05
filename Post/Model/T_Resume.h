//
//  T_Resume.h
//  cs74cms
//
//  Created by lyp on 15/5/14.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Resume : NSObject

@property(nonatomic, assign) int ID;//
@property(nonatomic, assign) int subsite_id;//分站id
@property(nonatomic, assign) int uid;//会员uid
@property(nonatomic, assign) int display;//是否显示
@property(nonatomic, assign) int display_name;//显示简历名称
@property(nonatomic, assign) int audit;//简历审核

@property(nonatomic, strong) NSString* title;//简历标题
@property(nonatomic, strong) NSString* fullname;//

@property(nonatomic, assign) int sex;//
@property(nonatomic, strong) NSString* sex_cn;

@property(nonatomic, assign) int nature;//工作性质
@property(nonatomic, strong) NSString* nature_cn;

@property(nonatomic, assign) int trade;//行业
@property(nonatomic, strong) NSString* trade_cn;
@property(nonatomic, strong) NSString *tradeIdString;

@property(nonatomic, strong) NSString* birthdate;//出生日期
@property(nonatomic, assign) int age;

@property(nonatomic, assign) int residence;//现居住地
@property(nonatomic, strong) NSString* residence_cn;

@property(nonatomic, assign) int height;//身高

@property(nonatomic, assign) int marriage;//婚否（1,2）婚否（未婚，已婚）
@property(nonatomic, strong) NSString* marriage_cn;

@property(nonatomic, assign) int experience;//工作经验
@property(nonatomic, strong) NSString* experience_cn;

@property(nonatomic, assign) int district;//地区大类
@property(nonatomic, strong) NSString* district_cn;//期望工作地区
@property(nonatomic, assign) int sdistrict;//地区小类
@property(nonatomic, strong) NSString* districtIdString;//期望工作地区


@property(nonatomic, assign) int wage;//期望薪资
@property(nonatomic, strong) NSString* wage_cn;

@property(nonatomic, assign) int householdaddress;//户口所在地
@property(nonatomic, strong) NSString* householdaddress_cn;

@property(nonatomic, assign) int education;//学历
@property(nonatomic, strong) NSString* education_cn;

@property(nonatomic, assign) int major;//专业
@property(nonatomic, strong) NSString* major_cn;

@property(nonatomic, assign) int current;//目前状态
@property(nonatomic, strong) NSString* current_cn;


@property(nonatomic, strong) NSString* tag;//简历标签
@property(nonatomic, strong) NSString * tag_cn;

@property(nonatomic, strong) NSString* telephone;//电话

@property(nonatomic, strong) NSString* email;//邮箱

@property(nonatomic, assign) int email_notify;//邮件接收通知

@property(nonatomic, assign) int intention_jobs_id;
@property(nonatomic, strong) NSString* intention_jobs;//期望职位
@property(nonatomic, strong) NSString* intention_jobs_id_string;//期望职位

@property(nonatomic, strong) NSString* specialty;//自我描述

@property(nonatomic, assign) int photo;//是否为照片简历

@property(nonatomic, strong) NSString* photo_img;//照片

@property(nonatomic, assign) NSString* photo_audit;//照片审核

//@property(nonatomic, assign) int photo_display;//是否显示照片

@property(nonatomic, strong) NSString *addtime;//添加时间

@property(nonatomic, strong) NSString *refreshtime;//简历刷新时间

@property(nonatomic, assign) int entrust;//简历委托

@property(nonatomic, assign) int talent;//高级人才

@property(nonatomic, assign) int level;//简历等级（优良差）

@property(nonatomic, assign) int complete_percent;//简历完整度

@property(nonatomic, assign) int key;//全文搜索关键字

@property(nonatomic, assign) int click;//查看次数

@property(nonatomic, assign) int tpl;//模板

@property(nonatomic, assign) int demo;

@end
