//
//  T_CompanyCenter.h
//  cs74cms
//
//  Created by lyp on 15/7/11.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_CompanyCenter : NSObject

@property(nonatomic, strong) NSString * logo;
@property(nonatomic, strong) NSString * companyName;
@property(nonatomic, strong) NSString * natureCn;
@property(nonatomic, strong) NSString * scaleCn;
@property(nonatomic, strong) NSString * tradeCn;
@property(nonatomic, strong) NSString * address;
@property(nonatomic, assign) int comeResume;
@property(nonatomic, assign) int downResume;
@property(nonatomic, assign) int interResume;
@property(nonatomic, assign) int favResume;
@property(nonatomic, assign) int mobileAudit;
@property(nonatomic, assign) int audit;

//是否完善过企业资料
@property(nonatomic, assign) int profile;

@end
