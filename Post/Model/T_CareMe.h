//
//  T_CareMe.h
//  cs74cms
//
//  Created by lyp on 15/5/25.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_CareMe : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, assign) int resume_id;
@property (nonatomic, assign) int uid;

//apply_addtime
@property(nonatomic, strong) NSString* addtime;


//公司名称
@property(nonatomic, assign) int companyid;
@property(nonatomic, strong) NSString *companyname;

//企业所属行业
@property(nonatomic, strong) NSString *trade_cn;

//企业所在地区
@property(nonatomic, strong) NSString *district_cn;

//企业是否下载了该简历
@property(nonatomic, strong) NSString *is_down;

@end
