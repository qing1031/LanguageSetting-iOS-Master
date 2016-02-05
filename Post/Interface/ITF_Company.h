//
//  ITF_Company.h
//  cs74cms
//
//  Created by lyp on 15/5/27.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T_User.h"
#import "T_Company.h"
#import "T_AddJob.h"
#import "T_Verify.h"
#import "T_CompanyCenter.h"

@interface ITF_Company : NSObject
//login in
- (T_User*) loginByUsername:(NSString *) username andPassword:(NSString*) password andMobile:(NSString*) mobile andVeritycode:(NSString*) code;

//login out
- (BOOL) loginOutByUsername:(NSString*) username andPassword:(NSString*) pwd;

//第三方登陆
- (T_User*) loginByOPenID:(NSString*) openID;

//获得分类
- (NSMutableArray*) classify:(NSString*) categorytype andParentid:(int) parentid;

//编辑企业资料
- (T_Company*) companyProfileByUser:(T_User*) user andCompany:(T_Company*) company;

//发布职位   1/2(积分/套餐)
- (int) companyAddJobsByUser:(T_User*) user andAddJob:(T_AddJob*) job;

//职位列表
- (NSMutableArray*) jobListByUser:(T_User*) user andStart:(int) start andRow:(int) row;

//编辑职位
- (T_AddJob*) editJobsByUser:(T_User*) user andJid:(int) jid AddJob:(T_AddJob*) job;

//预览职位
- (T_AddJob*) jobsShowByID:(int) ID;

//预览公司信息
- (T_Company*) companyShowByID:(int) ID andJid:(int) JID;

//企业其他职位列表
- (NSMutableArray*) companyJobListByID:(int) ID andJID:(int) JID andStart:(int) start andRow:(int) row;

//刷新职位
- (NSString*) refreshJobByUser:(T_User*)user andJid:(int) JID;

//申请的职位
- (NSMutableArray*) jobsApplyByUser:(T_User*)user andJID:(int) JID andStart:(int) start andRow:(int) row;

//删除职位
- (BOOL) deleteJobsBy:(T_User*)user andJid:(int) JID;


//公司的所有应聘简历
- (NSMutableArray*) allJobsApplyByUser:(T_User*)user andStart:(int) start andRow:(int) row andJid:(int) JID andRemarkid:(int) remarkid andExperience:(int) expid;

//公司的所有应聘简历中的下拉列表 0应聘职位   1 简历备注
- (NSMutableArray*) auditJobByUser:(T_User*)user andActtype:(int) type;

//已下载的简历
- (NSMutableArray*) downResumeByUser:(T_User*)user andStart:(int) start andRow:(int) row;

//面试邀请
- (NSMutableArray*) interviewByUser:(T_User*) user andStart:(int) start andRow:(int) row;

//收藏简历
- (NSMutableArray*) favoritesByUser:(T_User*) user andStart:(int) start andRow:(int) row;

//公司安全认证
- (T_Verify*) companyVerifyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andMobile:(NSString*) telephone andVerifycode:(NSString*) verifycode;

//修改密码
- (BOOL) editPasswordByUser:(T_User*) user andOldPwd:(NSString*) oldpwd andPwdOne:(NSString*) one andPwdTwo:(NSString*) two;

//企业logo
- (NSString*) companyPhotoByUsername:(NSString*) username andUserpwd:(NSString*) pwd andUploadefile:(UIImage*) img;

//企业会员中心信息
- (T_CompanyCenter*) getCompanyCenterInfoByUser:(T_User*) user;

@end
