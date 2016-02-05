//
//  T_Verify.h
//  cs74cms
//
//  Created by lyp on 15/5/26.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Verify : NSObject

@property(nonatomic, strong) NSString * mobile;//手机号

@property(nonatomic, assign) int mobile_audit;//手机认证状态(是/否)

@property(nonatomic, strong) NSString *rand;
@property(nonatomic, strong) NSString *time;

@end
