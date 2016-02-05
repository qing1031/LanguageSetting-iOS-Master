//
//  T_Education.h
//  cs74cms
//
//  Created by lyp on 15/5/19.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Education : NSObject

@property (nonatomic, assign) int ID;//该条教育经历编号
@property (nonatomic, assign) int pid;//简历编号
@property(nonatomic, assign) int uid;

@property(nonatomic, strong) NSString* starttime;

@property(nonatomic, strong) NSString* endtime;
@property(nonatomic, assign) int todate;//若选了至今则传todate=1就行 不需要传endtime了

@property(nonatomic, strong) NSString * school;

@property(nonatomic, strong) NSString * speciality;//专业名称


@property(nonatomic, assign) int education;
@property(nonatomic, strong) NSString * education_cn;


@end
