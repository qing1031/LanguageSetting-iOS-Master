//
//  T_ApplyJob.h
//  cs74cms
//
//  Created by lyp on 15/5/25.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_ApplyJob : NSObject

@property(nonatomic, assign) int did;
@property(nonatomic, assign) int resume_id;
@property (nonatomic, assign) int personal_uid;
@property(nonatomic, assign) int jobs_id;

//apply_addtime
@property(nonatomic, strong) NSString* apply_addtime;
@property(nonatomic, strong) NSString* down_addtime;

//对方是否查看(是/否) 2/1
@property(nonatomic, assign) int personal_look;

//对方回复状态编号  0->待反馈  1->符合要求  2->不合适  3->以后联系
@property(nonatomic, assign) int is_reply;

//职位名称
@property(nonatomic, strong) NSString * jobs_name;

//公司名称
@property(nonatomic, strong) NSString *companyname;

//反馈状态
@property(nonatomic, strong) NSString *replay_status;


//简历名字隐私设置状态码
@property(nonatomic, strong) NSString *display_name;


@property(nonatomic, strong) NSString *fullname;

@property(nonatomic, strong) NSString *sex_cn;

@property(nonatomic, strong) NSString *birthdate;

@property(nonatomic, strong) NSString *education_cn;

@property(nonatomic, strong) NSString *experience_cn;
//意向职位
@property(nonatomic, strong) NSString *intention_jobs;

@property(nonatomic, strong) NSString *demo;

@end
