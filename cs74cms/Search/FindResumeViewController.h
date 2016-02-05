//
//  FindResumeViewController.h
//  74cms
//
//  Created by lyp on 15/4/30.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"

@interface FindResumeViewController : SuperViewController

- (id) initWithString:(NSString*) str;

- (void) setType:(int) ttype;//0 搜索简历   1企业中的应聘简历  2搜索职位

- (void) setDistrict:(NSString*) distr andJobs:(NSString*) jobsStr andExperience:(int) experi andEducation:(int) education andKey:(NSString*) tkey;

- (void) setDistrict:(NSString*) distr andTrade:(NSString*) ttrade andJobs:(NSString*) jobsStr andPublishTime:(NSString*) tpublishTime andKey:(NSString*) tkey;
@end
