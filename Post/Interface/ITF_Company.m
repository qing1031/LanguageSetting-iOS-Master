//
//  ITF_Company.m
//  cs74cms
//
//  Created by lyp on 15/5/27.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ITF_Company.h"
#import "PostController.h"
#import "InitData.h"
#import "T_category.h"
#import "T_ApplyJob.h"




@implementation ITF_Company

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
    
    if ([list objectForKey:@"userpwd"]!= nil)
        user.userpwd = [list objectForKey:@"userpwd"] ;
    user.userpwd = [NSString stringWithFormat:@"%@", password];
    
    if ([list objectForKey:@"utype"]!= nil)
        user.utype = [[list objectForKey:@"utype"] intValue];
    
    if ([list objectForKey:@"profile"]!= nil)
        user.profile = [[list objectForKey:@"profile"] intValue];
    
    if ([list objectForKey:@"apply_resume_num"]!= nil)
        user.apply_resume_num = [list objectForKey:@"apply_resume_num"] ;
    
    if ([list objectForKey:@"pms_num"]!= nil)
        user.pms_num = [[list objectForKey:@"pms_num"] intValue];
    
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
        return nil;
    
    if ([res[@"status"] intValue] ==0 || res[@"data"] == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return false;
    }
    
    return true;
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
    if ( [res[@"data"] isEqual:[NSNull null]])
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

- (T_Company*) companyProfileByUser:(T_User*) user andCompany:(T_Company*) company{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=profile&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    if (company == nil){
        [programs appendFormat:@"&&act=%@", @"get"];
    }
    else{
        [programs appendFormat:@"&&companyname=%@", company.companyname];
        [programs appendFormat:@"&&nature=%d", company.nature];
        [programs appendFormat:@"&&nature_cn=%@", company.nature_cn];
        [programs appendFormat:@"&&trade=%d", company.trade];
        [programs appendFormat:@"&&trade_cn=%@", company.trade_cn];
        [programs appendFormat:@"&&scale=%d", company.scale];
        [programs appendFormat:@"&&scale_cn=%@", company.scale_cn];
        [programs appendFormat:@"&&district=%d", company.district];
        [programs appendFormat:@"&&sdistrict=%d", company.sdistrict];
        [programs appendFormat:@"&&district_cn=%@", company.district_cn];
        
        [programs appendFormat:@"&&address=%@", company.address];
        [programs appendFormat:@"&&contents=%@", company.contents];
        [programs appendFormat:@"&&contact=%@", company.contact];
        [programs appendFormat:@"&&telephone=%@", company.telephone];
        [programs appendFormat:@"&&email=%@", company.email];
        
        if (company.ID > 0){
            [programs appendFormat:@"&&act=%@", @"save"];
        }
        else{
            [programs appendFormat:@"&&act=%@", @"add"];
        }
    }
    
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    if (company != nil)
        return [[T_Company alloc] init];
    
    
    return [self getCompany:[res objectForKey:@"data"]];
}

- (int) companyAddJobsByUser:(T_User*) user andAddJob:(T_AddJob*) job{
    
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=add_jobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    if (job != nil){
    [programs appendFormat:@"&&act=%@", @"save"];
    
    [programs appendFormat:@"&&add_mode=%d", job.add_mode];
    //[programs appendFormat:@"&&days=%d", job.days];
    [programs appendFormat:@"&&jobs_name=%@", job.jobs_name];
    [programs appendFormat:@"&&nature=%d", job.nature];
    [programs appendFormat:@"&&nature_cn=%@", job.nature_cn];
    
        [programs appendFormat:@"&&topclass=%d", job.topclass];
        [programs appendFormat:@"&&category=%d", job.category];
        [programs appendFormat:@"&&subclass=%d", job.subclass];
    [programs appendFormat:@"&&category_cn=%@", job.category_cn];
    
    [programs appendFormat:@"&&amount=%d", job.amount];
    
        [programs appendFormat:@"&&district=%d", job.district];
        [programs appendFormat:@"&&sdistrict=%d",job.sdistrict];
        [programs appendFormat:@"&&district_cn=%@", job.district_cn];
        
        [programs appendFormat:@"&&wage=%d", job.wage];
        [programs appendFormat:@"&&wage_cn=%@", job.wage_cn];
    
    [programs appendFormat:@"&&education=%d", job.education];
    [programs appendFormat:@"&&education_cn=%@", job.education_cn];
    
    [programs appendFormat:@"&&experience=%d", job.experience];
    [programs appendFormat:@"&&experience_cn=%@", job.experience_cn];
    
    [programs appendFormat:@"&&contents=%@", job.contents];
    
        [programs appendFormat:@"&&contact=%@", job.contact];
        [programs appendFormat:@"&&telephone=%@", job.telephone];
        [programs appendFormat:@"&&email=%@", job.email];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"add"];
    }
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return 0;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    if (job == nil)
        return [res[@"data"][@"add_mode"] intValue];
        
    return [res[@"data"][@"pid"] intValue];
}


- (NSMutableArray*) jobListByUser:(T_User*) user andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=jobs_list&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0) {

        return nil;
    }
    
    if ([res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_AddJob *data = [[T_AddJob alloc] init];
        
        if (list[@"id"] != nil)
            data.ID = [list[@"id"] intValue];

        if (list[@"uid"] != nil)
            data.uid = [list[@"uid"] intValue];
        
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        
        if (list[@"addtime"] != nil)
            data.addtime = list[@"addtime"];
        
        if (list[@"click"] != nil)
            data.click = [list[@"click"] intValue];
        
        if (list[@"nature_cn"] != nil)
            data.nature_cn = list[@"nature_cn"];
        if (list[@"district_cn"] != nil)
            data.district_cn = list[@"district_cn"];
        if (list[@"countresume"] != nil)
            data.countresume = [list[@"countresume"] intValue];
        
        [ans addObject:data];
    }
    return ans;
}


- (T_AddJob*) editJobsByUser:(T_User*) user andJid:(int) jid AddJob:(T_AddJob*) job{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=edit_jobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    if (job == nil){
        [programs appendFormat:@"&&act=%@", @"editjobs"];
        [programs appendFormat:@"&&id=%d", jid];
    
    }else{
        [programs appendFormat:@"&&act=%@", @"editjobs_save"];
        [programs appendFormat:@"&&id=%d", job.ID];
        
        [programs appendFormat:@"&&add_mode=%d", job.add_mode];
      //  [programs appendFormat:@"&&days=%d", job.days];//增加天数
        [programs appendFormat:@"&&jobs_name=%@", job.jobs_name];
        [programs appendFormat:@"&&nature=%d", job.nature];
        [programs appendFormat:@"&&nature_cn=%@", job.nature_cn];
        
        [programs appendFormat:@"&&topclass=%d", job.topclass];
        [programs appendFormat:@"&&category=%d", job.category];
        [programs appendFormat:@"&&subclass=%d", job.subclass];
        [programs appendFormat:@"&&category_cn=%@", job.category_cn];
        
        [programs appendFormat:@"&&amount=%d", job.amount];
        
        [programs appendFormat:@"&&district=%d", job.district];
        [programs appendFormat:@"&&sdistrict=%d",job.sdistrict];
        [programs appendFormat:@"&&district_cn=%@", job.district_cn];
        
        [programs appendFormat:@"&&wage=%d", job.wage];
        [programs appendFormat:@"&&wage_cn=%@", job.wage_cn];
        
        [programs appendFormat:@"&&education=%d", job.education];
        [programs appendFormat:@"&&education_cn=%@", job.education_cn];
        
        [programs appendFormat:@"&&experience=%d", job.experience];
        [programs appendFormat:@"&&experience_cn=%@", job.experience_cn];
        
        [programs appendFormat:@"&&contents=%@", job.contents];
        
        [programs appendFormat:@"&&contact=%@", job.contact];
        [programs appendFormat:@"&&telephone=%@", job.telephone];
        [programs appendFormat:@"&&email=%@", job.email];
        [programs appendFormat:@"&&olddeadline=%@", job.olddeadline];
    }

    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getJob:res[@"data"]];
}

- (T_AddJob*) jobsShowByID:(int) ID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=jobs_show&&phonekey=123456"];
    [programs appendFormat:@"&&id=%d", ID];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getJob:res[@"data"]];
}

- (T_Company*) companyShowByID:(int) ID andJid:(int) JID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=company_show&&phonekey=123456"];
    [programs appendFormat:@"&&id=%d", ID];
    [programs appendFormat:@"&&jid=%d", JID];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getCompany:res[@"data"]];
}

- (NSMutableArray*) companyJobListByID:(int) ID andJID:(int) JID andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=companyjobs_list&&phonekey=123456"];
    [programs appendFormat:@"&&id=%d", ID];
    [programs appendFormat:@"&&jid=%d", JID];
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
        T_AddJob *data = [[T_AddJob alloc] init];
        
        if (list[@"id"] != nil)
            data.ID = [list[@"id"] intValue];
        
        if (list[@"uid"] != nil)
            data.uid = [list[@"uid"] intValue];
        
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        
        if (list[@"refreshtime"] != nil)
            data.refreshtime = list[@"refreshtime"];
        
        if (list[@"click"] != nil)
            data.click = [list[@"click"] intValue];
        
        if (list[@"education_cn"] != nil)
            data.education_cn = list[@"education_cn"];
        if (list[@"district_cn"] != nil)
            data.district_cn = list[@"district_cn"];
        
        if (list[@"experience_cn"] != nil)
            data.experience_cn = list[@"experience_cn"];
        if (list[@"wage_cn"] != nil)
            data.wage_cn = list[@"wage_cn"];
        
        if (res[@"total"] != nil)
            data.demo = [res[@"total"] intValue];
        
        [ans addObject:data];
    }
    return ans;

}

- (NSString*) refreshJobByUser:(T_User*)user andJid:(int) JID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=refresh_job&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&id=%d", JID];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        
        return nil;
    }
    
    return res[@"errormsg"];
}

- (NSMutableArray*) jobsApplyByUser:(T_User*)user andJID:(int) JID andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=jobs_apply&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&id=%d", JID];
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
        
        if (list[@"jobs_id"] != nil)
            data.jobs_id = [list[@"jobs_id"] intValue];
        
        if (list[@"apply_addtime"] != nil)
            data.apply_addtime = list[@"apply_addtime"];
        
        if (list[@"is_reply"] != nil)
            data.is_reply = [list[@"is_reply"] intValue];
        
        if (list[@"personal_look"] != nil)
            data.personal_look = [list[@"personal_look"] intValue];
        
        if (list[@"id"] != nil && ![list[@"id"] isEqual:[NSNull null]])
            data.resume_id = [list[@"id"] intValue];
        
        if (list[@"display_name"] != nil)
            data.display_name = list[@"display_name"];
        
        if (list[@"fullname"] != nil)
            data.fullname = list[@"fullname"];
        
        if (list[@"sex_cn"] != nil)
            data.sex_cn = list[@"sex_cn"];
        
        if (list[@"birthdate"] != nil)
            data.birthdate = list[@"birthdate"];
        
        if (list[@"education_cn"] != nil)
            data.education_cn = list[@"education_cn"];
        
        if (list[@"experience_cn"] != nil)
            data.experience_cn = list[@"experience_cn"];
        
        if (list[@"intention_jobs"] != nil)
            data.intention_jobs = list[@"intention_jobs"];
        
        if (list[@"reply_status"] != nil)
            data.replay_status = list[@"reply_status"];
        
        [ans addObject:data];
    }
    return ans;
    
}

- (BOOL) deleteJobsBy:(T_User*)user andJid:(int) JID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=delete_jobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&id=%d", JID];
    
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

//公司的所有应聘简历
- (NSMutableArray*) allJobsApplyByUser:(T_User*)user andStart:(int) start andRow:(int) row andJid:(int) JID andRemarkid:(int) remarkid andExperience:(int) expid {
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=com_apply_jobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&jid=%d", JID];
    [programs appendFormat:@"&&remarkid=%d", remarkid];
    [programs appendFormat:@"&&experience=%d", expid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        
        
        return nil;
    }
    return [self getApplyJobs:res[@"data"]];
}

//公司的所有应聘简历中的下拉列表 0应聘职位   1 简历备注
- (NSMutableArray*) auditJobByUser:(T_User*)user andActtype:(int) type {
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=auditjobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    if (type == 0)
        [programs appendFormat:@"&&act=%@", @"auditjobs"];
    else
        [programs appendFormat:@"&&act=%@", @"remark"];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    NSArray *result = res[@"data"];
    
    for (NSDictionary *list in result){
        T_category *data = [[T_category alloc] init];
        
        if (list[@"reply_id"] != nil)
            data.c_id = [list[@"reply_id"] intValue];
        
        if (list[@"id"] != nil)
            data.c_id = [list[@"id"] intValue];
        
        if (list[@"reply_id_cn"] != nil)
            data.c_name = list[@"reply_id_cn"];
        
        if (list[@"jobs_name"] != nil)
            data.c_name = list[@"jobs_name"];
        
        [ans addObject:data];
    }
    return ans;
    
}
//已下载的简历
- (NSMutableArray*) downResumeByUser:(T_User*)user andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=down_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }

    return [self getApplyJobs:res[@"data"]];
}

//面试邀请
- (NSMutableArray*) interviewByUser:(T_User*) user andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=com_interview&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    return [self getApplyJobs:res[@"data"]];
}
//收藏简历
- (NSMutableArray*) favoritesByUser:(T_User*) user andStart:(int) start andRow:(int) row{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=com_favorites&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        return nil;
    }
    
    return [self getApplyJobs:res[@"data"]];
}
//公司安全认证
- (T_Verify*) companyVerifyByUsername:(NSString*) username andUserpwd:(NSString*) pwd andMobile:(NSString*) telephone andVerifycode:(NSString*) verifycode{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=com_verify&&phonekey=123456"];
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
    if (telephone != nil&&[res[@"status"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        
        return nil;
    }
    
    return verify;
}
//修改密码
- (BOOL) editPasswordByUser:(T_User*) user andOldPwd:(NSString*) oldpwd andPwdOne:(NSString*) one andPwdTwo:(NSString*) two{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=com_edit_password&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    [programs appendFormat:@"&&oldpassword=%@", oldpwd];
    [programs appendFormat:@"&&password_one=%@", one];
    [programs appendFormat:@"&&password_two=%@",two];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return NO;
    if ([res[@"status"] intValue] == 0 ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return NO;
    }
    
    return YES;
}

//企业logo
- (NSString*) companyPhotoByUsername:(NSString*) username andUserpwd:(NSString*) pwd andUploadefile:(UIImage*) img{
    PostController *post = [[PostController alloc] init];
    
    NSDictionary *programs = @{@"phonekey":@"123456",
                     @"mact":@"logo",
                     @"username":username,
                     @"userpwd":pwd,
                     };
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs: programs andImg:img];
    
    if (res == nil)
        return nil;
    return res[@"errormsg"];
}

- (T_CompanyCenter*) getCompanyCenterInfoByUser:(T_User*) user{
    
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=company_index&&phonekey=123456"];
   // [programs appendFormat:@"&&username=%@", user.username];
  //  [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return NO;
    if ([res[@"status"] intValue] == 0 ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return NO;
    }
    
    T_CompanyCenter *data = [[T_CompanyCenter alloc] init];
    NSDictionary *list = res[@"data"];
    
    if (list[@"logo"] != nil)
        data.logo = list[@"logo"];
    if (list[@"companyname"] != nil)
        data.companyName = list[@"companyname"];
    if (list[@"nature_cn"] != nil)
        data.natureCn = list[@"nature_cn"];
    if (list[@"scale_cn"] != nil)
        data.scaleCn = list[@"scale_cn"];
    if (list[@"trade_cn"] != nil)
        data.tradeCn = list[@"trade_cn"];
    if (list[@"address"] != nil)
        data.address = list[@"address"];
    if (list[@"come_resume"] != nil)
        data.comeResume = [list[@"come_resume"] intValue];
    if (list[@"down_resume"] != nil)
        data.downResume = [list[@"down_resume"] intValue];
    if (list[@"inter_resume"] != nil)
        data.interResume = [list[@"inter_resume"] intValue];
    if (list[@"fav_resume"] != nil)
        data.favResume = [list[@"fav_resume"] intValue];
    if (list[@"mobile_audit"] != nil)
        data.mobileAudit = [list[@"mobile_audit"] intValue];
    if (list[@"audit"] != nil){
        NSString *string = list[@"audit"];
        if (string != nil && ![string isEqual:[NSNull null]])
            data.audit = [list[@"audit"] intValue];
    }
    if (list[@"profile"] != nil)
        data.profile = [list[@"profile"] intValue];
    
    return data;
}




- (NSMutableArray*) getApplyJobs:(NSArray*) result{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    for (NSDictionary *list in result){
        T_ApplyJob *data = [[T_ApplyJob alloc] init];
        
        if (list[@"did"] != nil)
            data.did = [list[@"did"] intValue];
        
        if (list[@"jobs_id"] != nil)
            data.jobs_id = [list[@"jobs_id"] intValue];
        
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        
        
        if (list[@"apply_addtime"] != nil){
            int length = ((NSString*)list[@"apply_addtime"]).length;
            data.apply_addtime = [list[@"apply_addtime"] substringToIndex:length > 10?length:10];
        }
        
        if (list[@"interview_addtime"] != nil){
            int length = ((NSString*)list[@"interview_addtime"]).length;
            data.apply_addtime = [list[@"interview_addtime"] substringToIndex:length > 10?10:length];
        }
        if (list[@"favorites_addtime"] != nil){
            int length = ((NSString*)list[@"favorites_addtime"]).length;
            data.apply_addtime = [list[@"favorites_addtime"] substringToIndex: length> 10?10:length];
        }
        
        if (list[@"is_reply"] != nil)
            data.is_reply = [list[@"is_reply"] intValue];
        
        if (list[@"personal_look"] != nil)
            data.personal_look = [list[@"personal_look"] intValue];
        
        if (list[@"id"] != nil)
            data.resume_id = [list[@"id"] intValue];
        
        if (list[@"resume_id"] != nil)
            data.resume_id = [list[@"resume_id"] intValue];
        
        if (list[@"display_name"] != nil)
            data.display_name = list[@"display_name"];
        
        if (list[@"fullname"] != nil)
            data.fullname = list[@"fullname"];
        
        if (list[@"sex_cn"] != nil)
            data.sex_cn = list[@"sex_cn"];
        
        if (list[@"birthdate"] != nil)
            data.birthdate = list[@"birthdate"];
        
        if (list[@"education_cn"] != nil)
            data.education_cn = list[@"education_cn"];
        
        if (list[@"experience_cn"] != nil)
            data.experience_cn = list[@"experience_cn"];
        
        if (list[@"intention_jobs"] != nil)
            data.intention_jobs = list[@"intention_jobs"];
        
        if (list[@"reply_status"] != nil)
            data.replay_status = list[@"reply_status"];
        
        
        if (list[@"resume_name"] != nil)
            data.fullname = list[@"resume_name"];
        
        if (list[@"down_addtime"] != nil)
            data.down_addtime = [list[@"down_addtime"] substringToIndex:10];
        
        [ans addObject:data];
    }
    return ans;
}

- (T_AddJob*) getJob:(NSDictionary*) list{
    if (list == nil)
        return nil;
    T_AddJob *data = [[T_AddJob alloc] init];
    
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"uid"] != nil)
        data.uid = [list[@"uid"] intValue];
    
    if (list[@"jobs_name"] != nil)
        data.jobs_name = list[@"jobs_name"];
   
    //下面的3个字段， 只有预览职位中有
    if (list[@"company_id"] != nil)
        data.company_id = [list[@"company_id"] intValue];
    
    if (list[@"companyname"] != nil)
        data.companyname = list[@"companyname"];
    
    if (list[@"click"] != nil)
        data.click = [list[@"click"] intValue];
    
    
    if (list[@"nature"] != nil)
        data.nature = [list[@"nature"] intValue];
    
    if (list[@"nature_cn"] != nil)
        data.nature_cn = list[@"nature_cn"];
    
    if (list[@"topclass"] != nil)
        data.topclass = [list[@"topclass"] intValue];
    
    if (list[@"category"] != nil)
        data.category = [list[@"category"] intValue];
    
    if (list[@"subclass"] != nil)
        data.subclass = [list[@"subclass"] intValue];
    
    if (list[@"category_cn"] != nil)
        data.category_cn = list[@"category_cn"];
    
    if (list[@"amount"] != nil)
        data.amount = [list[@"amount"] intValue];
    
    if (list[@"district"] != nil)
        data.district = [list[@"district"] intValue];
    
    if (list[@"sdistrict"] != nil)
        data.sdistrict = [list[@"sdistrict"] intValue];
    
    if (list[@"district_cn"] != nil)
        data.district_cn = list[@"district_cn"];
    
    if (list[@"wage"] != nil)
        data.wage = [list[@"wage"] intValue];
    
    if (list[@"wage_cn"] != nil)
        data.wage_cn = list[@"wage_cn"];
    
    if (list[@"education"] != nil)
        data.education = [list[@"education"] intValue];
    
    if (list[@"education_cn"] != nil)
        data.education_cn = list[@"education_cn"];
    
    if (list[@"experience"] != nil)
        data.experience = [list[@"experience"] intValue];
    
    if (list[@"experience_cn"] != nil)
        data.experience_cn = list[@"experience_cn"];
    
    if (list[@"contents"] != nil)
        data.contents = list[@"contents"];
    
    if (list[@"add_mode"] != nil)
        data.add_mode = [list[@"add_mode"] intValue];
    
    if (list[@"deadline"] != nil)
        data.olddeadline = list[@"deadline"];
    
    if (list[@"deadline_days"] != nil)
        data.days = [list[@"deadline_days"] intValue];

    
    if (list[@"countresume"] != nil)
        data.countresume = [list[@"countresume"] intValue];
    
    if (list[@"contact"] != nil){
        if ([list[@"contact"] isKindOfClass:[NSDictionary class]]){
            list = list[@"contact"];
        }
        
        data.contact = list[@"contact"];
    }
    
    if (list[@"telephone"] != nil)
        data.telephone = list[@"telephone"];
    
    if (list[@"email"] != nil)
        data.email = list[@"email"];
    
    if (list[@"map_x"] != nil)
        data.lon = [list[@"map_x"] floatValue];
    
    if (list[@"map_y"] != nil)
        data.lat = [[list objectForKey:@"map_y"] floatValue];
    
    if (list[@"company_audit"] != nil)
        data.companyAudit = [list[@"company_audit"] intValue];
    
    return data;
}

- (T_Company*) getCompany:(NSDictionary*) list{
    if (list == nil) {
        return nil;
    }
     T_Company *data = [[T_Company alloc] init];
    
    if ([list objectForKey:@"id"]!= nil)
        data.ID = [[list objectForKey:@"id"] intValue];
    
    if ([list objectForKey:@"uid"]!= nil)
        data.uid = [[list objectForKey:@"uid"] intValue];
    
    if ([list objectForKey:@"companyname"]!= nil)
        data.companyname = [list objectForKey:@"companyname"];
    
    if ([list objectForKey:@"nature"]!= nil)
        data.nature = [[list objectForKey:@"nature"] intValue];
    
    if ([list objectForKey:@"nature_cn"]!= nil)
        data.nature_cn = [list objectForKey:@"nature_cn"];
    
    if ([list objectForKey:@"trade"]!= nil)
        data.trade = [[list objectForKey:@"trade"] intValue];
    
    if ([list objectForKey:@"trade_cn"]!= nil)
        data.trade_cn = [list objectForKey:@"trade_cn"];
    
    if ([list objectForKey:@"scale"]!= nil)
        data.scale = [[list objectForKey:@"scale"] intValue];
    
    if ([list objectForKey:@"scale_cn"]!= nil)
        data.scale_cn = [list objectForKey:@"scale_cn"];

    if ([list objectForKey:@"district"]!= nil)
        data.district = [[list objectForKey:@"district"] intValue];
    
    if ([list objectForKey:@"sdistrict"]!= nil)
        data.sdistrict = [[list objectForKey:@"sdistrict"] intValue];
    
    if ([list objectForKey:@"district_cn"]!= nil)
        data.district_cn = [list objectForKey:@"district_cn"];
    
    if ([list objectForKey:@"address"]!= nil)
        data.address = [list objectForKey:@"address"];
    
    if ([list objectForKey:@"contents"]!= nil)
        data.contents = [list objectForKey:@"contents"];
    
    if (list[@"countjobs"] != nil ) {
        data.countJobs = [list[@"countjobs"] intValue];
    }
    if ([list objectForKey:@"contact"]!= nil){
        if ([list[@"contact"] isKindOfClass:[NSDictionary class]]){
            list = list[@"contact"];
        }
        data.contact = [list objectForKey:@"contact"];
    }
    
    if ([list objectForKey:@"telephone"]!= nil)
        data.telephone = [list objectForKey:@"telephone"];
    
    if ([list objectForKey:@"email"]!= nil)
        data.email = [list objectForKey:@"email"];
    
    if (list[@"map_x"] != nil)
        data.lon = [list[@"map_x"] floatValue];
    if (list[@"map_y"] != nil)
        data.lat = [[list objectForKey:@"map_y"] floatValue];
    
    return data;
}

@end
