//
//  T_Training.h
//  cs74cms
//
//  Created by lyp on 15/5/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Training : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, assign) int pid;
@property(nonatomic, assign) int uid;


@property(nonatomic, strong) NSString *starttime;
@property(nonatomic, strong) NSString *endtime;
@property(nonatomic, assign) int todate;

//培训机构名称
@property(nonatomic, strong) NSString* agency;

//培训课程名称
@property(nonatomic, strong) NSString *course;

//培训内容
@property(nonatomic, strong) NSString * description;

@end
