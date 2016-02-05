//
//  T_ResumeTotal.h
//  cs74cms
//
//  Created by lyp on 15/5/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "T_Resume.h"


@interface T_Contact : NSObject

@property(nonatomic, strong) NSString* telephone;
@property(nonatomic, strong) NSString* email;

@end

@interface T_ResumeTotal : NSObject

//简历基本信息(包括求职意向)
@property(nonatomic, strong) T_Resume* resumeInfo;

//该简历的教育经历
@property(nonatomic, strong) NSMutableArray *eduArray;

//该简历的工作经历
@property(nonatomic, strong) NSMutableArray *workArray;

//该简历的培训经历
@property(nonatomic,strong) NSMutableArray *trainingArray;

//该简历的语言能力
@property(nonatomic, strong) NSString *language;

//该简历的获取证书
@property(nonatomic, strong) NSString *credent;

//该简历的联系方式
@property(nonatomic, strong) T_Contact *contact;


@end
