//
//  T_User.h
//  cs74cms
//
//  Created by lyp on 15/5/12.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_User : NSObject<NSCoding>

@property(assign,nonatomic) int ID;//标识
@property(strong,nonatomic) NSString* username;
@property(strong, nonatomic) NSString* userpwd;

@property(strong, nonatomic) NSString * openID;


//用户类型， 1企业，  2个人
@property(assign, nonatomic) int utype;

//判断是否有简历,完善过资料
@property(nonatomic, assign) bool profile;

//应聘简历数
@property(nonatomic, strong) NSString * apply_resume_num;

//消息数目
@property(nonatomic, assign) int pms_num;

@property(nonatomic, strong) NSString *photo_img;

@property(nonatomic, strong) NSString *logo;

@end
