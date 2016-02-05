//
//  ITF_Other.h
//  cs74cms
//
//  Created by lyp on 15/6/2.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T_Jobfair.h"
#import "T_News.h"
#import "T_AddJob.h"
#import "T_Resume.h"
#import "T_AboutUs.h"
#import "T_User.h"

@interface ITF_Other : NSObject

//获得分类
- (NSMutableArray*) classify:(NSString*) categorytype andParentid:(int) parentid;

//搜索简历
- (NSMutableArray*) searchResumeByStart:(int) start andRow:(int) row andJobs:(NSString*) jobs andDistrict:(NSString*) district andExperience:(int) exp andEducation:(int) edu andKey:(NSString*) key andCurrent:(int) current;

//搜索职位
- (NSMutableArray*) searchJobByStart:(int) start andRow:(int) row andJobs:(NSString*) jobs andDistrict:(NSString*) district andTrade:(NSString*) trade andSettr:(int) settr andWage:(int) wage andExperience:(int) exp andEducation:(int) edu andKey:(NSString*) key;

//招聘会搜索
- (NSMutableArray*) jobfairByStart:(int) start andRow:(int) row andSettr:(int) settr;

//招聘会详情
- (T_Jobfair*) jobfairShowByID:(int)ID;

//新闻资讯
- (NSMutableArray*) newsByStart:(int) start andRow:(int) row andType_id:(int) Typeid;

//新闻资讯内容
- (T_News*) newsShowByID:(int)ID;

//微招聘
- (NSMutableArray*) simpleZhaoPinByStart:(int) start andRow:(int) row andKey:(NSString*) key;

//微简历
- (NSMutableArray*) SimpleResumeByStart:(int) start andRow:(int) row andKey:(NSString*) key;

//微招聘操作
- (T_AddJob*) simpleZhaopinOperationByID:(int) ID andAddjob:(T_AddJob*) job;

//微招聘操作
- (T_AddJob*) simpleZhaopinShowByID:(int) ID;

//微简历操作
- (T_Resume*) simpleResumeOperationByID:(int) ID andResume:(T_Resume*) job;

//微简历内容
- (T_Resume*) simpleResumeShowByID:(int) ID;

//反馈
- (int) suggestByInfotype:(int) type andFeedback:(NSString*) feed andTel:(NSString*) tel;

//关于 1。关于  2.版本号(不能用)
- (T_AboutUs*) aboutUsByActType:(int) type;

- (NSString*) upgrade:(NSString*) version;

//摇一摇
- (NSMutableArray*) shakeByMap_x:(float) x andMap_y:(float) y;

//获取热门关键词
- (NSMutableArray*) getHotWord;

@end
