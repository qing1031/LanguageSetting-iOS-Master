//
//  T_Collction.h
//  cs74cms
//
//  Created by lyp on 15/5/25.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Collection : NSObject
@property(nonatomic, assign) int did;
@property(nonatomic, assign) int resume_id;


//apply_addtime
@property(nonatomic, strong) NSString* addtime;



@property(nonatomic, assign) int jobs_id;
//职位名称
@property(nonatomic, strong) NSString * jobs_name;

@property (nonatomic, strong) NSString * wage_cn;
//公司名称
@property(nonatomic, strong) NSString *company_name;

@end
