//
//  T_ResumeComplete.h
//  cs74cms
//
//  Created by lyp on 15/5/16.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_ResumeComplete : NSObject

//简历id
@property(assign, nonatomic) int ID;

//会员id
@property(assign, nonatomic) int uid;

//标题
@property(nonatomic, strong) NSString * title;

//刷新时间
@property(nonatomic, strong) NSString *refreshtime;

//完整度
@property(nonatomic, assign) int complete_precent;

//是否有头像标识变量
@property(nonatomic, assign) BOOL photo;

//路径
@property(nonatomic, strong) NSString *photo_img;

//简历个人信息是否完善
@property(assign, nonatomic) BOOL info;

//简历求职意向是否完善
@property(assign, nonatomic) BOOL hope;

//简历自我评价是否完善
@property(assign, nonatomic) BOOL specialty;

//简历教育经历是否完善
@property(assign, nonatomic) BOOL education;

//简历工作经历是否完善
@property(assign, nonatomic) BOOL work;

//简历培训经历是否完善
@property(assign, nonatomic) BOOL training;

@end
