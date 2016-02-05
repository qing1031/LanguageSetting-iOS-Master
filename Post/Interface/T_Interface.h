//
//  T_Interface.h
//  74cms
//
//  Created by LPY on 15-4-8.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T_User.h"
#import "T_Resume.h"
#import "T_category.h"
#import "T_ResumeList.h"
#import "T_ResumeComplete.h"
#import "T_Education.h"
#import "T_Training.h"
#import "T_Work.h"
#import "T_ResumeTotal.h"
#import "T_ShieldCompany.h"
#import "T_Verify.h"
#import "T_Pms.h"
#import "T_UserCenter.h"

@interface T_Interface : NSObject

//login in
- (T_User*) loginByUsername:(NSString *) username andPassword:(NSString*) password andMobile:(NSString*) mobile andVeritycode:(NSString*) code;

//login out
- (BOOL) loginOutByUsername:(NSString*) username andPassword:(NSString*) pwd;

//第三方登陆
- (T_User*) loginByOPenID:(NSString*) openID;

//创建简历
- (int) createUsername:(NSString*) username andUserPwd:(NSString*) pwd andResume:(T_Resume*) resume;

//获得简历的默认的基本信息
- (T_Resume*) getResumeByUsername:(NSString*) username andUserPwd:(NSString*) pwd andResume:(T_Resume*) resume;

//获取保存个人信息
- (T_Resume*) personalUserInfo:(NSString*) username andUserPwd:(NSString*) pwd andResume:(T_Resume*) resume;

//简历的个人资料
- (T_Resume*) resumeUserInfo:(NSString*) username andUserPwd:(NSString*) pwd andPid:(int) pid andResume:(T_Resume*) resume;

//获得分类
- (NSMutableArray*) classify:(NSString*) categorytype andParentid:(int) parentid;

//简历列表接口
- (NSMutableArray*) personalResumeListByUsername:(NSString*) username andPassword:(NSString*) pwd;

//简历的完整度
- (T_ResumeComplete*) personalResumeEditResumeByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid;

//自我评价
- (T_Resume*) PersonalSpecialtyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andSpecialty:(NSString*) str;

//简历标题
- (NSString*) resumeTitleByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andTitle:(NSString*) title;

//求职意向 接口
- (T_Resume*)resumeIntentionByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andResume:(T_Resume*) resume;

//教育经历
- (NSMutableArray*) resumeEducationByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andEductaion:(T_Education*) edu;

//工作经历
- (NSMutableArray*) resumeWorkByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andWork:(T_Work*) data;

//培训经历
- (NSMutableArray*) resumeTrainByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andTraining:(T_Training*) data;

//预览简历
- (T_ResumeTotal*) resumeShowByPid:(int) pid;

//刷新简历
- (NSString*) resumeRefreshByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid;


//保密设置     1公开  2保密
- (int) resumeSetDisplayByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andDisplay:(int) display;

//删除简历
- (BOOL) resumeDeleteByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid;

//屏蔽企业
- (NSMutableArray*) resumeShieldCompanyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andShieldCompany:(T_ShieldCompany*) com;

//申请的职位
- (NSMutableArray *) resumeApplyJobsByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andStart:(int) start andRow:(int) row;

//谁关注我
- (NSMutableArray *) resumeAttentionMeByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andStart:(int) start andRow:(int) row;


//面试邀请
- (NSMutableArray *) resumeInterviewByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andStart:(int) start andRow:(int) row;

//我的收藏
- (NSMutableArray *) resumeFavoritesByUsername:(NSString*) username andUserpwd:(NSString*) pwd andStart:(int) start andRow:(int) row;

//消息提醒
- (NSMutableArray *) pmsByUsername:(NSString*) username andUserpwd:(NSString*) pwd andStart:(int) start andRow:(int) row andPMid:(int) pmid;

//消息详情
- (T_Pms*) pmsDetailByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPMid:(int) pmid;


//修改密码
- (BOOL) editPasswordByUsername:(NSString*) username andUserpwd:(NSString*) pwd andOldPwd:(NSString*) oldpwd andPwdOne:(NSString*) pwdOne andPwdTwo:(NSString*) pwdTwo;

//手机认证
- (T_Verify*) personalVerifyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andMobile:(NSString*) telephone andVerifycode:(NSString*) verifycode;
//上传头像
- (BOOL) personalPhotoByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andUploadefile:(UIImage*) img;

//个人会员中心信息
- (T_UserCenter*) getUserCenterInfByUser:(T_User*) user;
@end
