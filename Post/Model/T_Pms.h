//
//  T_Pms.h
//  cs74cms
//
//  Created by lyp on 15/5/25.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_Pms : NSObject

@property(nonatomic, assign) int pmid;

//信息来源uid
@property(nonatomic, assign) int msgfromuidid;

//消息去向uid
@property(nonatomic, assign) int msgtouid;

//消息时间
@property(nonatomic, strong) NSString* dateline;

//消息内容
@property (nonatomic, strong) NSString * message;


@end
