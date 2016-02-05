//
//  T_UserCenter.h
//  cs74cms
//
//  Created by lyp on 15/7/11.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_UserCenter : NSObject

@property(nonatomic, strong) NSString * photoImg;
@property(nonatomic, assign) int pmsNum;
@property(nonatomic, assign) int favNum;
@property(nonatomic, assign) int mobileAudit;

//是否创建过简历 0-未创建  1-已创建
@property(nonatomic, assign) int profile;

@end
