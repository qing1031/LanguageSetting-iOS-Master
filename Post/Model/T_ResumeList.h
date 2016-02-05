//
//  T_ResumeList.h
//  cs74cms
//
//  Created by lyp on 15/5/16.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_ResumeList : NSObject

@property(nonatomic, assign) int ID;//

@property(nonatomic, assign) int uid;//会员uid

@property(nonatomic, strong) NSString* title;//简历标题

@property(nonatomic, assign) int display;//隐私设置

@property(nonatomic, assign) int photo;//是否为照片简历

@property(nonatomic, strong) NSString* photo_img;//照片

@property(nonatomic, assign) int photo_display;//是否显示照片

@property(nonatomic, strong) NSString *addtime;//添加时间

@property(nonatomic, strong) NSString *refreshtime;//简历刷新时间



@property(nonatomic, assign) int countapply;//已申请职位数

@property(nonatomic, assign) int countattention;//谁在关注我

@property(nonatomic, assign) int countinterview;//面试邀请数

@property(nonatomic, assign) int nun;//面试邀请数

@end
