//
//  ITF_Apply.h
//  cs74cms
//
//  Created by lyp on 15/6/6.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T_User.h"
#import "T_Verify.h"
#import "T_Ads.h"


@interface ITF_Apply : NSObject

//申请职位
- (NSMutableArray*) applyJobByUser:(T_User*) user andJid:(int) Jid andRid:(int) Rid;

//收藏职位
- (int) collectJobByUser:(T_User*) user andJid:(int) Jid;

//下载简历
- (int) downloadResumeByUser:(T_User*)user andRid:(int) rid;

//收藏简历
- (int) collectResumeByUser:(T_User*)user andRid:(int) rid;

//邮箱注册
- (T_User*) emailRegisterByType:(int) type andUsername:(NSString*) username andEmail:(NSString*) email andPwd:(NSString*) one andPwdtwo:(NSString*) two;

//手机注册
- (T_User*) phoneRegisterByType:(int) type andVerifycode:(NSString*) verity andMobile:(NSString*) mobile andPwd:(NSString*) pwd;

//发送验证码
- (T_Verify*) sendCodeByType:(int) type andMobile:(NSString*) mobile;

//添加备注
- (int) companyReplyByUser:(T_User*) user andPid:(int) Pid andJid:(int) Jid andReplyId:(int) Rid andReplyIdCn:(NSString*) rcn;

//添加广告
- (T_Ads*) getAds;

//s首页轮播出
- (NSMutableArray*) getIndexfocus;

//地图搜索
- (NSMutableArray*) mapSearchByLat:(float) lat andLon:(float) lon andJobs:(NSString*) jobcategory andTrade:(NSString*) trade andSettr:(int) settr andDistance:(int) dis;

//找回密码
- (BOOL) setPwdByType:(int) type andPhone:(NSString*) phone andCode:(NSString*) code andPwd:(NSString*) one andPwd_two:(NSString*) two;


//第三方登录接口 ,0qq,  1sina,  2taobao     utype = 1企业  2个人
- (T_User*) connectAgencyBytype:(int) type andUId:(NSString*)uid andNick:(NSString*) nick andIdold:(BOOL)isold andUtype:(int) utype andUserpwd:(NSString*) pwd andEmail:(NSString*) email andMobile:(NSString*) mobile andUsername:(NSString*) username;



//新浪微博获取用户数据
- (T_User*) getSinaUserInfoByToken:(NSString*) token andUid:(NSString*) uid;

@end
