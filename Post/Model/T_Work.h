//
//  T_Work.h
//  cs74cms
//
//  Created by lyp on 15/5/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Work : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, assign) int pid;
@property(nonatomic, assign) int uid;


@property(nonatomic, strong) NSString *starttime;
@property(nonatomic, strong) NSString *endtime;
@property(nonatomic, assign) int todate;

//公司名称
@property(nonatomic, strong) NSString* companyName;

//职位名称
@property(nonatomic, strong) NSString *jobs;

//工作职责
@property(nonatomic, strong) NSString * achievements;

@end
