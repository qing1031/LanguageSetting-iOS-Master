//
//  T_Interface.m
//  74cms
//
//  Created by LPY on 15-4-8.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "T_Interface.h"
#import "PostController.h"
#import "InitData.h"
#import "T_ApplyJob.h"
#import "T_CareMe.h"
#import "T_Interview.h"
#import "T_Collection.h"
#import "T_Pms.h"

@implementation T_Interface


//login in
- (T_User*) loginByUsername:(NSString *) username andPassword:(NSString*) password andMobile:(NSString*) mobile andVeritycode:(NSString*) code
{
    
    
    PostController *post = [[PostController alloc] init];
    NSMutableString *programs = [NSMutableString stringWithString:@"mact=login&&phonekey=123456"];
    
    if (username != nil && password != nil){
        [programs appendFormat:@"&&act=%@", @"username_login"];
        [programs appendFormat:@"&&username=%@&&password=%@",username,password];
    }
    else if (code != nil){
        [programs appendFormat:@"&&act=%@", @"phone_login"];
        [programs appendFormat:@"&&mobile=%@",mobile];
        [programs appendFormat:@"&&verifycode=%@",code];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"send_code"];
        [programs appendFormat:@"&&mobile=%@",mobile];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] != nil){
        [programs appendFormat:@"&&imei=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]];
        [programs appendFormat:@"&&reg_type=%d", 4];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] ==0 || res[@"data"] == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    NSMutableDictionary *list = [res objectForKey:@"data"];
    T_User *user = [[T_User alloc] init];
    
    if ([list objectForKey:@"uid"]!= nil && [list objectForKey:@"uid"])
        user.ID = [[list objectForKey:@"uid"] intValue];
        
    if ([list objectForKey:@"username"]!= nil)
        user.username = [list objectForKey:@"username"];
        
    if ([list objectForKey:@"userpwd"]!= nil){
        user.userpwd = [list objectForKey:@"userpwd"];
    }
    user.userpwd = password;
        
    if ([list objectForKey:@"utype"]!= nil)
        user.utype = [[list objectForKey:@"utype"] intValue];
        
    if ([list objectForKey:@"profile"]!= nil)
        user.profile = [[list objectForKey:@"profile"] intValue];
        
    if ([list objectForKey:@"apply_resume_num"]!= nil)
        user.apply_resume_num = [list objectForKey:@"apply_resume_num"] ;
        
    if ([list objectForKey:@"pms_num"]!= nil)
        user.pms_num = [[list objectForKey:@"pms_num"] intValue] ;
    
    if ([list objectForKey:@"logo"] != nil)
        user.logo = [list objectForKey:@"logo"];
    
    if ([list objectForKey:@"photo_img"] != nil)
        user.photo_img = [list objectForKey:@"photo_img"];
    
    return user;
}

- (T_User*) loginByOPenID:(NSString*) openID
{
    PostController *post = [[PostController alloc] init];
    NSMutableString *programs = [NSMutableString stringWithString:@"mact=login&&phonekey=123456"];
    

    [programs appendFormat:@"&&act=%@", @"username_login"];
    [programs appendFormat:@"&&agency_id=%@", openID];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] != nil){
        [programs appendFormat:@"&&imei=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]];
        [programs appendFormat:@"&&reg_type=%d", 4];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] ==0 || res[@"data"] == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    NSMutableDictionary *list = [res objectForKey:@"data"];
    T_User *user = [[T_User alloc] init];
    
    if ([list objectForKey:@"uid"]!= nil && [list objectForKey:@"uid"])
        user.ID = [[list objectForKey:@"uid"] intValue];
    
    if ([list objectForKey:@"username"]!= nil)
        user.username = [list objectForKey:@"username"];
    
    if ([list objectForKey:@"userpwd"]!= nil){
        user.userpwd = [list objectForKey:@"userpwd"];
    }
    
    if ([list objectForKey:@"utype"]!= nil)
        user.utype = [[list objectForKey:@"utype"] intValue];
    
    if ([list objectForKey:@"profile"]!= nil)
        user.profile = [[list objectForKey:@"profile"] intValue];
    
    if ([list objectForKey:@"apply_resume_num"]!= nil)
        user.apply_resume_num = [list objectForKey:@"apply_resume_num"] ;
    
    if ([list objectForKey:@"pms_num"]!= nil)
        user.pms_num = [[list objectForKey:@"pms_num"] intValue] ;
    
    if ([list objectForKey:@"logo"] != nil)
        user.logo = [list objectForKey:@"logo"];
    
    if ([list objectForKey:@"photo_img"] != nil)
        user.photo_img = [list objectForKey:@"photo_img"];
    
    return user;
}

//login out
- (BOOL) loginOutByUsername:(NSString*) username andPassword:(NSString*) pwd{
    PostController *post = [[PostController alloc] init];
    NSMutableString *programs = [NSMutableString stringWithString:@"mact=loginout&&phonekey=123456"];
    
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return false;
    
    if ([res[@"status"] intValue] ==0 || res[@"data"] == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return false;
    }

    return true;
}

- (int) createUsername:(NSString*) username andUserPwd:(NSString*) pwd andResume:(T_Resume*) resume{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=create_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&act=%@", @"add"];

    [programs appendFormat:@"&&fullname=%@&&sex_cn=%@&&birthdate=%@&&education=%d&&education_cn=%@&&major=%d&&major_cn=%@&&experience=%d&&experience_cn=%@&&residence=%@&&telephone=%@&&email=%@&&current=%d&&current_cn=%@&&nature=%d&&nature_cn=%@&&district=%@&&district_cn=%@&&trade=%@&&trade_cn=%@&&intention_jobs_id=%@&&intention_jobs=%@&&wage=%d&&wage_cn=%@",resume.fullname, resume.sex_cn, resume.birthdate, resume.education, resume.education_cn, resume.major,resume.major_cn, resume.experience, resume.experience_cn, resume.residence_cn, resume.telephone, resume.email, resume.current, resume.current_cn, resume.nature, resume.nature_cn, resume.districtIdString, resume.district_cn, resume.tradeIdString, resume.trade_cn, resume.intention_jobs_id_string, resume.intention_jobs, resume.wage, resume.wage_cn];


    NSDictionary *list=[post connectUrlData:[InitData Path] programs:programs];
    
    if (list == nil)
        return 0;
    
    if ([list[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:list[@"errormsg"]];
        });
        return 0;
    }
    
    return [list[@"data"][@"pid"] intValue];
}

- (T_Resume*) getResumeByUsername:(NSString*) username andUserPwd:(NSString*) pwd andResume:(T_Resume*) resume{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=create_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&act=%@", @"get"];
    
    
    NSDictionary *list=[post connectUrlData:[InitData Path] programs:programs];
    
    if (list == nil)
        return nil;
    
    if ([list[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:list[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getResume:list[@"data"]];
}

//会员中的个人资料
- (T_Resume*) personalUserInfo:(NSString*) username andUserPwd:(NSString*) pwd andResume:(T_Resume*) resume{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=pre_user_info&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    
    if (resume != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        [programs appendFormat:@"&&realname=%@", resume.fullname];
        [programs appendFormat:@"&&sex_cn=%@", resume.sex_cn];
        [programs appendFormat:@"&&birthdate=%@", resume.birthdate];
        [programs appendFormat:@"&&education=%d", resume.education];
        [programs appendFormat:@"&&education_cn=%@", resume.education_cn];
        [programs appendFormat:@"&&major=%d", resume.major];
        [programs appendFormat:@"&&major_cn=%@", resume.major_cn];
        [programs appendFormat:@"&&experience=%d", resume.experience];
        [programs appendFormat:@"&&experience_cn=%@", resume.experience_cn];
        [programs appendFormat:@"&&residence=%@", resume.residence_cn];
        [programs appendFormat:@"&&phone=%@", resume.telephone];
        [programs appendFormat:@"&&email=%@", resume.email];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    T_Resume *data = [[T_Resume alloc] init];
    if (resume != nil){
        if (res[@"status"] != 0) {
            return data;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        
        return nil;
    }
    
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]])
        return nil;
    NSDictionary *list = res[@"data"];

    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"realname"] != nil)
        data.fullname = list[@"realname"];
    
    if (list[@"sex"] != nil)
        data.sex = [list[@"sex"] intValue];
    
    if (list[@"sex_cn"] != nil)
        data.sex_cn = list[@"sex_cn"];
    
    if (list[@"birthday"] != nil)
        data.birthdate = list[@"birthday"];
    
    if (list[@"education"] != nil)
        data.education = [list[@"education"] intValue];
    
    if (list[@"education_cn"] != nil)
        data.education_cn = list[@"education_cn"];
    
    if (list[@"major"] != nil)
        data.major = [list[@"major"] intValue];
    
    if (list[@"major_cn"] != nil)
        data.major_cn = list[@"major_cn"];
    
    if (list[@"experience"] != nil)
        data.experience = [list[@"experience"] intValue];
    
    if (list[@"experience_cn"] != nil)
        data.experience_cn = list[@"experience_cn"];
    
    if (list[@"residence"] != nil)
        data.residence_cn = list[@"residence"];
    
    if (list[@"phone"] != nil)
        data.telephone = list[@"phone"];
    
    if (list[@"email"] != nil)
        data.email = list[@"email"];
    
    return data;
}


//简历的个人资料
- (T_Resume*) resumeUserInfo:(NSString*) username andUserPwd:(NSString*) pwd andPid:(int) pid andResume:(T_Resume*) resume{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_baseinfo&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (resume != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        [programs appendFormat:@"&&fullname=%@", resume.fullname];
        [programs appendFormat:@"&&sex_cn=%@", resume.sex_cn];
        [programs appendFormat:@"&&birthdate=%@", resume.birthdate];
        [programs appendFormat:@"&&education=%d", resume.education];
        [programs appendFormat:@"&&education_cn=%@", resume.education_cn];
        [programs appendFormat:@"&&major=%d", resume.major];
        [programs appendFormat:@"&&major_cn=%@", resume.major_cn];
        [programs appendFormat:@"&&experience=%d", resume.experience];
        [programs appendFormat:@"&&experience_cn=%@", resume.experience_cn];
        [programs appendFormat:@"&&residence=%@", resume.residence_cn];
        [programs appendFormat:@"&&telephone=%@", resume.telephone];
        [programs appendFormat:@"&&email=%@", resume.email];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    T_Resume *data = [[T_Resume alloc] init];
    if (resume != nil){
        if (res[@"status"] != 0) {
            return data;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    
    if (res[@"status"] == 0 || [res[@"data"] isEqual:[NSNull null]])
        return nil;
    return data = [self getResume:res[@"data"]];
}


- (NSMutableArray*) classify:(NSString*) categorytype andParentid:(int) parentid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=classify&&phonekey=123456"];
    [programs appendFormat:@"&&categorytype=%@", categorytype];
    [programs appendFormat:@"&&parentid=%d", parentid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        return nil;
    }
    if ([res[@"data"] isEqual:[NSNull null]])
         return nil;
    
    NSMutableArray *array = [res objectForKey:@"data"];
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    
    if ([array count] == 0)
        return nil;
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        
        T_category *cat = [[T_category alloc] init];
        cat.level = 0;
        cat.open = NO;

        if ([list objectForKey:@"id"]!= nil && [list objectForKey:@"id"])
            cat.c_id = [[list objectForKey:@"id"] intValue];
    
        if ([list objectForKey:@"parentid"]!= nil && [list objectForKey:@"parentid"])
            cat.c_parentid = [[list objectForKey:@"parentid"] intValue];
    
        if ([list objectForKey:@"categoryname"]!= nil)
            cat.c_name = [list objectForKey:@"categoryname"];

        [ans addObject:cat];
    }
    
    return ans;
}

- (NSMutableArray*) personalResumeListByUsername:(NSString*) username andPassword:(NSString*) pwd{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=resume_list&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]])
        return nil;
    
    NSMutableArray *array = [res objectForKey:@"data"];
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    
    if ([array count] == 0)
        return nil;
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        
        T_ResumeList *data = [[T_ResumeList alloc] init];
        
        if ([list objectForKey:@"id"]!= nil && [list objectForKey:@"id"] != 0)
            data.ID = [[list objectForKey:@"id"] intValue];
        
        if ([list objectForKey:@"uid"]!= nil && [list objectForKey:@"uid"] != 0)
            data.uid = [[list objectForKey:@"uid"] intValue];
        
        if ([list objectForKey:@"title"]!= nil)
            data.title = [list objectForKey:@"title"];
        
        if ([list objectForKey:@"display"]!= nil)
            data.display = [[list objectForKey:@"display"] intValue];
        
        if ([list objectForKey:@"refreshtime"]!= nil)
            data.refreshtime = [list objectForKey:@"refreshtime"];
        
        if ([list objectForKey:@"addtime"]!= nil)
            data.addtime = [list objectForKey:@"addtime"];

        if ([list objectForKey:@"photo"]!= nil)
            data.photo = [[list objectForKey:@"photo"] intValue];
        
        if ([list objectForKey:@"photo_img"]!= nil)
            data.photo_img = [list objectForKey:@"photo_img"];
        
        if ([list objectForKey:@"countapply"]!= nil)
            data.countapply = [[list objectForKey:@"countapply"] intValue];

        if ([list objectForKey:@"countattention"]!= nil)
            data.countattention = [[list objectForKey:@"countattention"] intValue];
        
        if ([list objectForKey:@"countinterview"]!= nil)
            data.countinterview = [[list objectForKey:@"countinterview"] intValue];
        
        
        
        [ans addObject:data];
    }
    
    return ans;
}


- (T_ResumeComplete*) personalResumeEditResumeByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    if ([res[@"data"] isEqual:[NSNull null]])
        return nil;
    
    T_ResumeComplete *data = [[T_ResumeComplete alloc] init];
    
    NSDictionary *list = res[@"data"];
    
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"title"] != nil)
        data.title = list[@"title"];
    
    if (list[@"refreshtime"] != nil)
        data.refreshtime = list[@"refreshtime"];
    
    if (list[@"complete_percent"] != nil)
        data.complete_precent = [list[@"complete_percent"] intValue];
    
    if (list[@"photo"] != nil)
        data.photo = [list[@"photo"] boolValue];
    
    if (list[@"photo_img"] != nil)
        data.photo_img = list[@"photo_img"];
    
    if (list[@"info"] != nil)
        data.info = [list[@"info"] boolValue];
    
    if (list[@"hope"] != nil)
        data.hope = [list[@"hope"] boolValue];
    
    if (list[@"specialty"] != nil)
        data.specialty = [list[@"specialty"] boolValue];
    
    if (list[@"education"] != nil)
        data.education = [list[@"education"] boolValue];
    
    if (list[@"work"] != nil)
        data.work= [list[@"work"] boolValue];
    
    if (list[@"training"] != nil)
        data.training = [list[@"training"] boolValue];
    
    return data;
}

- (T_Resume*) PersonalSpecialtyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andSpecialty:(NSString*) str{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_specialty&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (str != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        [programs appendFormat:@"&&specialty=%@", str];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    T_Resume *data = [[T_Resume alloc] init];
    if (str != nil){
        if (res[@"status"] != 0) {
            return data;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]])
        return nil;
    NSDictionary *list = res[@"data"];
    
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"specialty"] != nil)
        data.specialty = list[@"specialty"];

    return data;
}

- (NSString*) resumeTitleByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andTitle:(NSString*) title{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_title&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (title != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        [programs appendFormat:@"&&title=%@", title];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    T_Resume *data = [[T_Resume alloc] init];
    if (title != nil){
        if (res[@"status"] != 0) {
            return @"";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]])
        return nil;
    NSDictionary *list = res[@"data"];
    
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"title"] != nil)
        data.specialty = list[@"title"];
    
    return data.title;
}

//求职意向 接口
- (T_Resume*)resumeIntentionByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andResume:(T_Resume*) resume{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_intention&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    if (resume != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        [programs appendFormat:@"&&current=%d", resume.current];
        [programs appendFormat:@"&&current_cn=%@", resume.current_cn];
        [programs appendFormat:@"&&nature=%d", resume.nature];
        [programs appendFormat:@"&&nature_cn=%@", resume.nature_cn];
        [programs appendFormat:@"&&district_id=%@", resume.districtIdString];
        [programs appendFormat:@"&&district_cn=%@", resume.district_cn];
        [programs appendFormat:@"&&trade=%@", resume.tradeIdString];
        [programs appendFormat:@"&&trade_cn=%@", resume.trade_cn];
        [programs appendFormat:@"&&intention_jobs_id=%@", resume.intention_jobs_id_string];
        [programs appendFormat:@"&&intention_jobs=%@", resume.intention_jobs];
        [programs appendFormat:@"&&wage=%d", resume.wage];
        [programs appendFormat:@"&&wage_cn=%@", resume.wage_cn];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    T_Resume *data = [[T_Resume alloc] init];
    if (resume != nil){
        if (res[@"status"] != 0) {
            return data;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]])
        return nil;
    
    return [self getIntention:res[@"data"] andResume:data];
}

- (NSMutableArray*) resumeEducationByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andEductaion:(T_Education*) edu{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_education&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (edu.starttime != nil){

        [programs appendFormat:@"&&startime=%@", edu.starttime];
        if (edu.todate!= 1) {
            [programs appendFormat:@"&&endtime=%@", edu.endtime];
        }else{
            [programs appendFormat:@"&&todate=%d", edu.todate];
        }

        [programs appendFormat:@"&&school=%@", edu.school];
        [programs appendFormat:@"&&speciality=%@", edu.speciality];
        [programs appendFormat:@"&&education=%d", edu.education];
        [programs appendFormat:@"&&education_cn=%@", edu.education_cn];
    
        if (edu.ID != 0){
            [programs appendFormat:@"&&act=%@", @"save"];
            [programs appendFormat:@"&&eid=%d", edu.ID];
        }
        else{
            [programs appendFormat:@"&&act=%@", @"add"];
        }
    }
    else if (edu.ID != 0){
        [programs appendFormat:@"&&act=%@", @"delete"];
        [programs appendFormat:@"&&eid=%d", edu.ID];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    if (edu.starttime != nil || edu.ID != 0){
            return [[NSMutableArray alloc] init];
    }
    
    return [self getEducationArray:res[@"data"]];
}


- (NSMutableArray*) resumeWorkByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andWork:(T_Work*) data{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_work&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (data.starttime != nil){
        
        [programs appendFormat:@"&&startime=%@", data.starttime];
        if (data.todate!= 1) {
            [programs appendFormat:@"&&endtime=%@", data.endtime];
        }else{
            [programs appendFormat:@"&&todate=%d", data.todate];
        }
        
        [programs appendFormat:@"&&companyname=%@", data.companyName];
        [programs appendFormat:@"&&jobs=%@", data.jobs];
        [programs appendFormat:@"&&achievements=%@", data.achievements];
        
        if (data.ID != 0){
            [programs appendFormat:@"&&act=%@", @"save"];
            [programs appendFormat:@"&&wid=%d", data.ID];
        }
        else{
            [programs appendFormat:@"&&act=%@", @"add"];
        }
    }
    else if (data.ID != 0){
        [programs appendFormat:@"&&act=%@", @"delete"];
        [programs appendFormat:@"&&wid=%d", data.ID];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    if (data.starttime != nil || data.ID != 0){
        return [[NSMutableArray alloc] init];
    }
    
    return [self getWorkArray: res[@"data"]];
 }


- (NSMutableArray*) resumeTrainByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andTraining:(T_Training*) data{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_resume_training&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (data.starttime != nil){
        
        [programs appendFormat:@"&&startime=%@", data.starttime];
        if (data.todate!= 1) {
            [programs appendFormat:@"&&endtime=%@", data.endtime];
        }else{
            [programs appendFormat:@"&&todate=%d", data.todate];
        }
        
        [programs appendFormat:@"&&agency=%@", data.agency];
        [programs appendFormat:@"&&course=%@", data.course];
        [programs appendFormat:@"&&description=%@", data.description];
        
        if (data.ID != 0){
            [programs appendFormat:@"&&act=%@", @"save"];
            [programs appendFormat:@"&&tid=%d", data.ID];
        }
        else{
            [programs appendFormat:@"&&act=%@", @"add"];
        }
    }
    else if (data.ID != 0){
        [programs appendFormat:@"&&act=%@", @"delete"];
        [programs appendFormat:@"&&tid=%d", data.ID];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    if (data.starttime != nil || data.ID != 0){
        return [[NSMutableArray alloc] init];
    }
    
    return [self getTrainArray:res[@"data"]];
}




- (T_ResumeTotal*) resumeShowByPid:(int) pid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=show_resume&&phonekey=123456"];
    [programs appendFormat:@"&&pid=%d", pid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    if ( [res[@"data"] isEqual:[NSNull null]])
        return  nil;
    
    NSDictionary *dic = res[@"data"];
    
    T_ResumeTotal *resTotal = [[T_ResumeTotal alloc] init];
    if (![dic[@"info"] isEqual:[NSNull null]]){
        resTotal.resumeInfo = [self getResume:dic[@"info"]];
        resTotal.resumeInfo = [self getIntention:dic[@"info"] andResume:resTotal.resumeInfo];
    }
    
    if (![dic[@"work"] isEqual:[NSNull null]])
        resTotal.workArray = [self getWorkArray:dic[@"work"]];
    
    if (![dic[@"education"] isEqual:[NSNull null]])
        resTotal.eduArray = [self getEducationArray:dic[@"education"]];
    
    if (![dic[@"training"] isEqual:[NSNull null]])
        resTotal.trainingArray = [self getTrainArray:dic[@"training"]];
    
    if (![dic[@"credent"] isEqual:[NSNull null]])
        resTotal.credent = dic[@"credent"];
    
    if (![dic[@"language"] isEqual:[NSNull null]])
        resTotal.language = dic[@"language"];
    
    if (dic[@"contact"] != nil && ![dic[@"contact"] isEqual:[NSNull null]] && ![dic[@"contact"] isKindOfClass:[NSString class]]){
        NSDictionary *tdic = dic[@"contact"];
        resTotal.contact = [[T_Contact alloc] init];
        resTotal.contact.telephone = tdic[@"telephone"];
        resTotal.contact.email = tdic[@"email"];
    }
    
    return resTotal;
}
- (NSString*) resumeRefreshByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=refresh_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 1)
        return nil;

    return res[@"errormsg"];
}
//1公开  2保密
- (int) resumeSetDisplayByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andDisplay:(int) display{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=resume_set_display&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (display > 0){
        [programs appendFormat:@"&&act=%@", @"set"];
        [programs appendFormat:@"&&display=%d", display];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return 0;
    
    if ([res[@"status"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    if (display > 0)
        return display;
    if ([res[@"data"] isEqual:[NSNull null]])
        return 0;
    
    return [res[@"data"][@"display"] intValue];
}

- (BOOL) resumeDeleteByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=delete_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return NO;
    
    return [res[@"status"] boolValue];
}

- (NSMutableArray*) resumeShieldCompanyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int)pid andShieldCompany:(T_ShieldCompany*) com{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=shield_company&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    
    if (com != nil){
        if (com.comkeyword!= nil && com.ID == 0){
            [programs appendFormat:@"&&act=%@", @"add"];
            [programs appendFormat:@"&&comkeyword=%@", com.comkeyword];
        }
        else{
            [programs appendFormat:@"&&act=%@", @"delete"];
            [programs appendFormat:@"&&sid=%d", com.ID];
        }
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0) {
        return nil;
    }
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    if (com  != nil)
        return ans;
    

    NSArray *array = res[@"data"];
    if ([array count] == 0)
        return nil;
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        T_ShieldCompany *data = [[T_ShieldCompany alloc] init];
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    if (list[@"pid"] != nil)
        data.pid = [list[@"pid"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"comkeyword"] != nil)
        data.comkeyword = list[@"comkeyword"];
        [ans addObject:data];
    }
    
    return ans;
}

- (NSMutableArray *) resumeApplyJobsByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=apply_jobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];

    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_ApplyJob *data = [[T_ApplyJob alloc] init];
        
        if (list[@"did"] != nil)
            data.did = [list[@"did"] intValue];
        if (list[@"resume_id"] != nil)
            data.resume_id = [list[@"resume_id"] intValue];
        if (list[@"personal_uid"] != nil)
            data.personal_uid = [list[@"personal_uid"] intValue];
        if (list[@"jobs_id"] != nil)
            data.jobs_id = [list[@"jobs_id"] intValue];
        if (list[@"apply_addtime"] != nil)
            data.apply_addtime = list[@"apply_addtime"];
        if (list[@"personal_look"] != nil)
            data.personal_look = [list[@"personal_look"] intValue];
        if (list[@"is_reply"] != nil)
            data.is_reply = [list[@"is_reply"] intValue];
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        if (list[@"company_name"] != nil)
            data.companyname = list[@"company_name"];
        if (list[@"reply_status"] != nil)
            data.replay_status = list[@"reply_status"];
        [ans addObject:data];
    }
    return ans;
}

- (NSMutableArray *) resumeAttentionMeByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=attention_me&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_CareMe *data = [[T_CareMe alloc] init];
        
        if (list[@"id"] != nil)
            data.ID = [list[@"id"] intValue];
        if (list[@"resumeid"] != nil)
            data.resume_id = [list[@"resumeid"] intValue];
        if (list[@"uid"] != nil)
            data.uid = [list[@"uid"] intValue];

        if (list[@"addtime"] != nil)
            data.addtime = list[@"addtime"];

        if (list[@"companyname"] != nil)
            data.companyname = list[@"companyname"];
        if (list[@"trade_cn"] != nil)
            data.trade_cn = list[@"trade_cn"];
        if (list[@"district_cn"] != nil)
            data.district_cn = list[@"district_cn"];
        if (list[@"is_down"] != nil)
            data.is_down = list[@"is_down"];
        if (list[@"companyid"] != nil)
            data.companyid = [list[@"companyid"] intValue];
        [ans addObject:data];
    }
    return ans;
}

- (NSMutableArray *) resumeInterviewByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=interview&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&pid=%d", pid];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_Interview *data = [[T_Interview alloc] init];
        
        if (list[@"did"] != nil)
            data.did = [list[@"did"] intValue];
        if (list[@"resume_id"] != nil)
            data.resume_id = [list[@"resume_id"] intValue];
        
        if (list[@"jobs_id"] != nil)
            data.jobs_id = [list[@"jobs_id"] intValue];
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        if (list[@"interview_addtime"] != nil)
            data.interview_addtime = list[@"interview_addtime"];
        
        if (list[@"company_id"] != nil)
            data.company_id = [list[@"company_id"] intValue];
        if (list[@"company_name"] != nil)
            data.company_name = list[@"company_name"];
        
        [ans addObject:data];
    }
    return ans;
}


- (NSMutableArray *) resumeFavoritesByUsername:(NSString*) username andUserpwd:(NSString*) pwd andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=favorites&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];

    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_Collection *data = [[T_Collection alloc] init];
        
        if (list[@"did"] != nil)
            data.did = [list[@"did"] intValue];
        if (list[@"resume_id"] != nil)
            data.resume_id = [list[@"resume_id"] intValue];
        
        if (list[@"jobs_id"] != nil)
            data.jobs_id = [list[@"jobs_id"] intValue];
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        if (list[@"addtime"] != nil)
            data.addtime = list[@"addtime"];
        
        if (list[@"wage_cn"] != nil)
            data.wage_cn = list[@"wage_cn"];
        if (list[@"company_name"] != nil)
            data.company_name = list[@"company_name"];
        
        [ans addObject:data];
    }
    return ans;
}


- (NSMutableArray *) pmsByUsername:(NSString*) username andUserpwd:(NSString*) pwd andStart:(int) start andRow:(int) row andPMid:(int) pmid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=pms&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    
    if (pmid == 0){
        [programs appendFormat:@"&&act=%@", @"get"];
        [programs appendFormat:@"&&start=%d", start];
        [programs appendFormat:@"&&row=%d", row];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"delete"];
        [programs appendFormat:@"&&pmid=%d", pmid];
    }
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    if ([res[@"status"] intValue] == 0) {
        return nil;
    }
    
    if (pmid > 0){
        return ans;
    }
    if ([res[@"data"] isEqual:[NSNull null]])
        return nil;

    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_Pms *data = [[T_Pms alloc] init];
        
        if (list[@"pmid"] != nil)
            data.pmid = [list[@"pmid"] intValue];
        if (list[@"msgfromuid"] != nil)
            data.msgfromuidid = [list[@"msgfromuid"] intValue];
        
        if (list[@"msgtouid"] != nil)
            data.msgtouid = [list[@"msgtouid"] intValue];
        
        if (list[@"message"] != nil)
            data.message = list[@"message"];
        if (list[@"dateline"] != nil)
            data.dateline = list[@"dateline"];
        
        [ans addObject:data];
    }
    return ans;
}
- (T_Pms*) pmsDetailByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPMid:(int) pmid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=pms&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    

    [programs appendFormat:@"&&act=%@", @"detail"];
    [programs appendFormat:@"&&pmid=%d", pmid];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    NSDictionary *list = res[@"data"];
    

        T_Pms *data = [[T_Pms alloc] init];
        
        if (list[@"pmid"] != nil)
            data.pmid = [list[@"pmid"] intValue];
        if (list[@"msgfromuid"] != nil)
            data.msgfromuidid = [list[@"msgfromuid"] intValue];
        
        if (list[@"msgtouid"] != nil)
            data.msgtouid = [list[@"msgtouid"] intValue];
        
        if (list[@"message"] != nil)
            data.message = list[@"message"];
        if (list[@"dateline"] != nil)
            data.dateline = list[@"dateline"];
    
    return data;
}

- (BOOL) editPasswordByUsername:(NSString*) username andUserpwd:(NSString*) pwd andOldPwd:(NSString*) oldpwd andPwdOne:(NSString*) pwdOne andPwdTwo:(NSString*) pwdTwo{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=per_edit_password&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    [programs appendFormat:@"&&oldpassword=%@", oldpwd];
    [programs appendFormat:@"&&password_one=%@", pwdOne];
    [programs appendFormat:@"&&password_two=%@", pwdTwo];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return NO;
    if ([res[@"status"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return NO;
    }
    
    return YES;
}
- (T_Verify*) personalVerifyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andMobile:(NSString*) telephone andVerifycode:(NSString*) verifycode{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=verify&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&userpwd=%@", pwd];
    
    if (telephone == nil && verifycode == nil){
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    else if (telephone == nil){
        [programs appendFormat:@"&&act=%@", @"verify_code"];
        [programs appendFormat:@"&&verifycode=%@", verifycode];
    }
    else if (verifycode == nil){
        [programs appendFormat:@"&&act=%@", @"send_code"];
        [programs appendFormat:@"&&mobile=%@", telephone];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if (telephone == nil &&[res[@"status"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    T_Verify *verify = [[T_Verify alloc] init];
    
    NSDictionary *list = res[@"data"];
    if (telephone == nil && verifycode == nil){
        if (list[@"mobile"] != nil)
            verify.mobile =list[@"mobile"];
        if (list[@"mobile_audit"] != nil)
            verify.mobile_audit = [list[@"mobile_audit"] intValue];
    }
    if (telephone != nil && [res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return verify;
}

- (BOOL) personalPhotoByUsername:(NSString*) username andUserpwd:(NSString*) pwd andPid:(int) pid andUploadefile:(UIImage*) img{
    PostController *post = [[PostController alloc] init];
    
    NSDictionary *programs;
    if (pid > 0){
        programs = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"123456",@"phonekey",
                    @"avatar_photo",@"mact",
                    username,@"username",
                    @"photo",@"act",
                    [NSString stringWithFormat:@"%d", pid],@"pid",
                    pwd,@"userpwd",
                      nil];
    }
    else{
        programs = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"123456",@"phonekey",
                    @"avatar_photo", @"mact",
                    username, @"username",
                    @"avatar",@"act",
                    pwd, @"userpwd",
                    
                    nil];
    }

    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs: programs andImg:img];
    
    if (res == nil)
        return NO;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return NO;
    }
    return YES;
}

- (T_UserCenter*) getUserCenterInfByUser:(T_User*) user{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=personal_index&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    T_UserCenter *data = [[T_UserCenter alloc] init];
    
    NSDictionary *list = res[@"data"];

    if (list[@"photo_img"] != nil)
        data.photoImg =list[@"photo_img"];
    
    if (list[@"pms_num"] != nil)
        data.pmsNum = [list[@"pms_num"] intValue];
    
    if (list[@"fav_num"] != nil)
        data.favNum = [list[@"fav_num"] intValue];
    
    if (list[@"mobile_audit"] != nil)
        data.mobileAudit = [list[@"mobile_audit"] intValue];
    
    if (list[@"profile"] != nil)
        data.profile = [list[@"profile"] intValue];
    
    return data;
}
































- (T_Resume*) getResume:(NSDictionary*) list{
    
    T_Resume *data = [[T_Resume alloc] init];
  
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"realname"])
        data.fullname = list[@"realname"];
    
    if (list[@"fullname"] != nil)
        data.fullname = list[@"fullname"];
    
    if (list[@"sex"] != nil)
        data.sex = [list[@"sex"] intValue];
    
    if (list[@"sex_cn"] != nil)
        data.sex_cn = list[@"sex_cn"];
    
    if (list[@"birthdate"] != nil)
        data.birthdate = list[@"birthdate"];
    
    if (list[@"birthday"] != nil)
        data.birthdate = list[@"birthday"];
    
    if (list[@"age"] != nil)
        data.age = [list[@"age"] intValue];
    
    if (list[@"education"] != nil)
        data.education = [list[@"education"] intValue];
    
    if (list[@"education_cn"] != nil)
        data.education_cn = list[@"education_cn"];
    
    if (list[@"major"] != nil)
        data.major = [list[@"major"] intValue];
    
    if (list[@"major_cn"] != nil)
        data.major_cn = list[@"major_cn"];
    
    if (list[@"experience"] != nil)
        data.experience = [list[@"experience"] intValue];
    
    if (list[@"experience_cn"] != nil)
        data.experience_cn = list[@"experience_cn"];
    
    if (list[@"residence"] != nil)
        data.residence_cn = list[@"residence"];
    
    if (list[@"telephone"] != nil)
        data.telephone = list[@"telephone"];
    
    if (list[@"phone"])
        data.telephone = list[@"phone"];
    
    if (list[@"email"] != nil)
        data.email = list[@"email"];
    
    if (list[@"photo"] != nil)
        data.photo = [list[@"photo"] intValue];
    
    if (list[@"photo_img"] != nil)
        data.photo_img = list[@"photo_img"];
    
    if (list[@"photo_display"] != nil)
        data.display = [list[@"photo_display"] intValue];
    
    if (list[@"refreshtime"] != nil)
        data.refreshtime = list[@"refreshtime"];
    
    if (list[@"specialty"] != nil)
        data.specialty = list[@"specialty"];
    
    if (list[@"tag"] != nil)
        data.tag = list[@"tag"];
    
    if (list[@"tag_cn"] != nil)
        data.tag_cn = list[@"tag_cn"];
    
    if (list[@"tagcn"] != nil){
        
    }
    
    return data;
}

- (T_Resume*) getIntention:(NSDictionary*) list andResume:(T_Resume*) data{
    if (data == nil)
        data = [[T_Resume alloc] init];
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"current"] != nil)
        data.current = [list[@"current"] intValue];
    
    if (list[@"current_cn"] != nil)
        data.current_cn = list[@"current_cn"];
    
    if (list[@"nature"] != nil)
        data.nature = [list[@"nature"] intValue];
    
    if (list[@"nature_cn"] != nil)
        data.nature_cn = list[@"nature_cn"];
    
    if (list[@"district_id"] != nil){

       // data.district = [list[@"district_id"] intValue];
        data.districtIdString = list[@"district_id"];
    }
    
    if (list[@"district_cn"] != nil)
        data.district_cn = list[@"district_cn"];
    
    if (list[@"trade"] != nil){
       // data.trade = [list[@"trade"] intValue];
        data.tradeIdString = list[@"trade"];
    }
    
    if (list[@"trade_cn"] != nil)
        data.trade_cn = list[@"trade_cn"];
    
    if (list[@"intention_jobs_id"] != nil){
       // data.intention_jobs_id = [list[@"intention_jobs_id"] intValue];
        data.intention_jobs_id_string = list[@"intention_jobs_id"];
    }
    
    if (list[@"intention_jobs"] != nil)
        data.intention_jobs = list[@"intention_jobs"];
    
    if (list[@"wage"] != nil)
        data.wage = [list[@"wage"] intValue];
    
    if (list[@"wage_cn"] != nil)
        data.wage_cn = list[@"wage_cn"];
    return data;
}
- (NSMutableArray*) getEducationArray:(NSArray*) array{
    
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        
        T_Education *data = [[T_Education alloc] init];
        
        if ([list objectForKey:@"id"]!= nil)
            data.ID = [[list objectForKey:@"id"] intValue];
        
        if ([list objectForKey:@"pid"]!= nil)
            data.pid = [[list objectForKey:@"pid"] intValue];
        
        if ([list objectForKey:@"uid"]!= nil)
            data.uid = [[list objectForKey:@"uid"] intValue];
        
        if ([list objectForKey:@"startyear"]!= nil)
            data.starttime = [NSString stringWithFormat:@"%@",[list objectForKey:@"startyear"]];
        
        if ([list objectForKey:@"startmonth"]!= nil)
            data.starttime = [NSString stringWithFormat:@"%@-%@", data.starttime, [list objectForKey:@"startmonth"]];
        
        if ([list objectForKey:@"endyear"]!= nil)
            data.endtime = [NSString stringWithFormat:@"%@",[list objectForKey:@"endyear"]];
        
        if ([list objectForKey:@"endmonth"]!= nil)
            data.endtime = [NSString stringWithFormat:@"%@-%@", data.endtime, [list objectForKey:@"endmonth"]];
        
        if ([list objectForKey:@"todate"] != nil && [[list objectForKey:@"todate"]intValue] == 1){
            data.endtime = @"至今";
        }
        
        if ([list objectForKey:@"school"]!= nil)
            data.school = [list objectForKey:@"school"];
        
        if ([list objectForKey:@"speciality"]!= nil)
            data.speciality = [list objectForKey:@"speciality"];
        
        if ([list objectForKey:@"education"]!= nil)
            data.education = [[list objectForKey:@"education"] intValue];
        
        if ([list objectForKey:@"education_cn"]!= nil)
            data.education_cn = [list objectForKey:@"education_cn"];
        
        [ans addObject:data];
    }
    return ans;
}
- (NSMutableArray *) getWorkArray:(NSArray*) array{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        
        T_Work *data = [[T_Work alloc] init];
        
        if ([list objectForKey:@"id"]!= nil)
            data.ID = [[list objectForKey:@"id"] intValue];
        
        if ([list objectForKey:@"pid"]!= nil)
            data.pid = [[list objectForKey:@"pid"] intValue];
        
        if ([list objectForKey:@"uid"]!= nil)
            data.uid = [[list objectForKey:@"uid"] intValue];
        
        if ([list objectForKey:@"startyear"]!= nil)
            data.starttime = [NSString stringWithFormat:@"%@",[list objectForKey:@"startyear"]];
        
        if ([list objectForKey:@"startmonth"]!= nil)
            data.starttime = [NSString stringWithFormat:@"%@-%@", data.starttime, [list objectForKey:@"startmonth"]];
        
        if ([list objectForKey:@"endyear"]!= nil)
            data.endtime = [NSString stringWithFormat:@"%@",[list objectForKey:@"endyear"]];
        
        if ([list objectForKey:@"endmonth"]!= nil)
            data.endtime = [NSString stringWithFormat:@"%@-%@", data.endtime, [list objectForKey:@"endmonth"]];
        
        if ([list objectForKey:@"todate"] != nil && [[list objectForKey:@"todate"]intValue] == 1){
            data.endtime = @"至今";
        }
        
        if ([list objectForKey:@"companyname"]!= nil)
            data.companyName = [list objectForKey:@"companyname"];
        
        if ([list objectForKey:@"jobs"]!= nil)
            data.jobs = [list objectForKey:@"jobs"];
        
        if ([list objectForKey:@"achievements"]!= nil)
            data.achievements = [list objectForKey:@"achievements"];
        
        [ans addObject:data];
    }
    
    return ans;
}
- (NSMutableArray*) getTrainArray:(NSArray*) array{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        
        T_Training *data = [[T_Training alloc] init];
        
        if ([list objectForKey:@"id"]!= nil)
            data.ID = [[list objectForKey:@"id"] intValue];
        
        if ([list objectForKey:@"pid"]!= nil)
            data.pid = [[list objectForKey:@"pid"] intValue];
        
        if ([list objectForKey:@"uid"]!= nil)
            data.uid = [[list objectForKey:@"uid"] intValue];
        
        if ([list objectForKey:@"startyear"]!= nil)
            data.starttime = [NSString stringWithFormat:@"%@",[list objectForKey:@"startyear"]];
        
        if ([list objectForKey:@"startmonth"]!= nil)
            data.starttime = [NSString stringWithFormat:@"%@-%@", data.starttime, [list objectForKey:@"startmonth"]];
        
        if ([list objectForKey:@"endyear"]!= nil)
            data.endtime = [NSString stringWithFormat:@"%@",[list objectForKey:@"endyear"]];
        
        if ([list objectForKey:@"endmonth"]!= nil)
            data.endtime = [NSString stringWithFormat:@"%@-%@", data.endtime, [list objectForKey:@"endmonth"]];
        
        if ([list objectForKey:@"todate"] != nil && [[list objectForKey:@"todate"]intValue] == 1){
            data.endtime = @"至今";
        }
        
        if ([list objectForKey:@"agency"]!= nil)
            data.agency= [list objectForKey:@"agency"];
        
        if ([list objectForKey:@"course"]!= nil)
            data.course = [list objectForKey:@"course"];
        
        if ([list objectForKey:@"description"]!= nil)
            data.description = [list objectForKey:@"description"];
        
        [ans addObject:data];
    }
    
    return ans;
}

@end
