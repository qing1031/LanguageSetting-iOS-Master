//
//  T_Simple.h
//  cs74cms
//
//  Created by lyp on 15/6/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Simple : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, strong) NSString* jobname;
@property(nonatomic, strong) NSString* comname;
@property(nonatomic, strong) NSString* refreshtime;
@property(nonatomic, strong) NSString* sdistrict_cn;

@property(nonatomic, strong) NSString* uname;
@property(nonatomic, assign) int age;
@property(nonatomic, strong) NSString* sex_cn;
@property(nonatomic, strong) NSString* category;//意向职位
@property(nonatomic, strong) NSString* experience_cn;


@end
