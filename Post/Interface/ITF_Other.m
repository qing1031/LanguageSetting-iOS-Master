//
//  ITF_Other.m
//  cs74cms
//
//  Created by lyp on 15/6/2.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ITF_Other.h"
#import "PostController.h"
#import "InitData.h"
#import "T_ApplyJob.h"
#import "T_Simple.h"
#import "T_category.h"


@implementation ITF_Other

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
        
        if ([list objectForKey:@"validity"]!= nil)
            cat.c_name = [list objectForKey:@"validity"];
        
        if ([list objectForKey:@"id"]!= nil)
            cat.c_id = [[list objectForKey:@"id"] intValue];
        [ans addObject:cat];
    }
    
    return ans;
}


//搜索简历
- (NSMutableArray*) searchResumeByStart:(int) start andRow:(int) row andJobs:(NSString*) jobs andDistrict:(NSString*) district andExperience:(int) exp andEducation:(int) edu andKey:(NSString*) key andCurrent:(int) current{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=resume&&phonekey=123456"];

    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&jobcategory=%@", jobs];
    [programs appendFormat:@"&&citycategory=%@", district];
    [programs appendFormat:@"&&experience=%d", exp];
    [programs appendFormat:@"&&education=%d", edu];
    [programs appendFormat:@"&&key=%@", key];
    [programs appendFormat:@"&&current=%d", current];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getApplyJobs:res[@"data"]];
}

//搜索职位
- (NSMutableArray*) searchJobByStart:(int) start andRow:(int) row andJobs:(NSString*) jobs andDistrict:(NSString*) district andTrade:(NSString*) trade andSettr:(int) settr andWage:(int) wage andExperience:(int) exp andEducation:(int) edu andKey:(NSString*) key{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=jobs&&phonekey=123456"];
    
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&jobcategory=%@", jobs];
    [programs appendFormat:@"&&citycategory=%@", district];
    
    [programs appendFormat:@"&&trade=%@", trade];
    [programs appendFormat:@"&&settr=%d", settr];
    [programs appendFormat:@"&&wage=%d", wage];
    
    [programs appendFormat:@"&&experience=%d", exp];
    [programs appendFormat:@"&&education=%d", edu];
    [programs appendFormat:@"&&key=%@", key];
    
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getJobs:res[@"data"]];
}

//招聘会搜索
- (NSMutableArray*) jobfairByStart:(int) start andRow:(int) row andSettr:(int) settr{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=jobfair&&phonekey=123456"];
    
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&settr=%d", settr];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getJobfair:res[@"data"]];
}

//招聘会详情
- (T_Jobfair*) jobfairShowByID:(int)ID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=jobfair_show&&phonekey=123456"];
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
    T_Jobfair *data = [[T_Jobfair alloc] init];
    NSDictionary *list = res[@"data"];
    
    if (list[@"id"] != nil)
        data.ID= [list[@"id"] intValue];
    
    if (list[@"title"] != nil)
        data.title = list[@"title"];
    
    if (list[@"address"] != nil)
        data.address = list[@"address"];
    
    if (list[@"holddate_start"] != nil)
        data.holddate_start = list[@"holddate_start"];
    
    if (list[@"holddate_end"] != nil)
        data.holddate_end = list[@"holddate_end"];
    
    if (list[@"introduction"] != nil)
        data.introduction = list[@"introduction"];
    
    if (list[@"trade_cn"] != nil)
        data.trade_cn = list[@"trade_cn"];
    
    if (list[@"contact"] != nil)
        data.contact = list[@"contact"];
    
    if (list[@"phone"] != nil)
        data.phone = list[@"phone"];
    
    if (list[@"map_x"] != nil)
        data.lon = [list[@"map_x"] floatValue];
    if (list[@"map_y"] != nil)
        data.lat = [[list objectForKey:@"map_y"] floatValue];

    return data;
}
//新闻资讯
- (NSMutableArray*) newsByStart:(int) start andRow:(int) row andType_id:(int) Typeid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=news_list&&phonekey=123456"];
    
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&type_id=%d", Typeid];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getNews:res[@"data"]];
}
//新闻资讯内容
- (T_News*) newsShowByID:(int)ID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=news_show&&phonekey=123456"];

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
    T_News *data = [[T_News alloc] init];
    NSDictionary *list = [res objectForKey:@"data"];
    
    if (list[@"id"] != nil)
        data.ID= [list[@"id"] intValue];
    
    if (list[@"type_id"] != nil)
        data.type = list[@"type_id"];
    
    if (list[@"title"] != nil)
        data.title = list[@"title"];
    
    if (list[@"content"] != nil)
        data.content = list[@"content"];
    
    if (![list[@"Small_img"] isEqual:[NSNull null]])
        data.small_img = list[@"Small_img"];
    
    if (![list[@"addtime"] isEqual:[NSNull null]])
        data.addtime = list[@"addtime"];
    if (![list[@"click"] isEqual:[NSNull null]])
        data.click = [list[@"click"] intValue];
    
    return data;
}
//微招聘
- (NSMutableArray*) simpleZhaoPinByStart:(int) start andRow:(int) row andKey:(NSString*) key{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=simple_list&&phonekey=123456"];
    
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&key=%@", key];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getSimple:res[@"data"]];
}
//微简历
- (NSMutableArray*) SimpleResumeByStart:(int) start andRow:(int) row andKey:(NSString*) key{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=simple_resume_list&&phonekey=123456"];
    
    [programs appendFormat:@"&&start=%d", start];
    [programs appendFormat:@"&&row=%d", row];
    [programs appendFormat:@"&&key=%@", key];
    
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0 || [res[@"data"] isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    return [self getSimple:res[@"data"]];
}
//微招聘操作
- (T_AddJob*) simpleZhaopinOperationByID:(int) ID andAddjob:(T_AddJob*) job{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=simple_operation&&phonekey=123456"];

    
    if (job != nil && ID == 0){
        [programs appendFormat:@"&&act=%@", @"add"];
        
        [programs appendFormat:@"&&comname=%@", job.companyname];
        [programs appendFormat:@"&&jobname=%@", job.jobs_name];
        
        [programs appendFormat:@"&&amount=%d", job.amount];
        
        [programs appendFormat:@"&&district=%d", job.district];
        
        [programs appendFormat:@"&&sdistrict=%d",job.sdistrict];
        NSArray *arr = [job.district_cn componentsSeparatedByString:@"/"];
        if ([arr count] > 1) {
            [programs appendFormat:@"&&district_cn=%@", [arr objectAtIndex:0]];
            [programs appendFormat:@"&&sdistrict_cn=%@", [arr objectAtIndex:1]];
        }
        
        [programs appendFormat:@"&&detailed=%@", job.contents];
        
        [programs appendFormat:@"&&contact=%@", job.contact];
        [programs appendFormat:@"&&tel=%@", job.telephone];
        [programs appendFormat:@"&&pwd=%@", job.email];
        [programs appendFormat:@"&&validity=%d", job.days];
    }
    else if (job != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        
        [programs appendFormat:@"&&id=%d", ID];
        
        [programs appendFormat:@"&&comname=%@", job.companyname];
        [programs appendFormat:@"&&jobname=%@", job.jobs_name];
        
        [programs appendFormat:@"&&amount=%d", job.amount];
        
        [programs appendFormat:@"&&district=%d", job.district];
        
        [programs appendFormat:@"&&sdistrict=%d",job.sdistrict];
        NSArray *arr = [job.district_cn componentsSeparatedByString:@"/"];
        if ([arr count] > 1){
            [programs appendFormat:@"&&district_cn=%@", [arr objectAtIndex:0]];
            [programs appendFormat:@"&&sdistrict_cn=%@", [arr objectAtIndex:1]];
        }
        
        
        [programs appendFormat:@"&&detailed=%@", job.contents];
        
        [programs appendFormat:@"&&contact=%@", job.contact];
        [programs appendFormat:@"&&tel=%@", job.telephone];
        [programs appendFormat:@"&&pwd=%@", job.email];
        [programs appendFormat:@"&&days=%d", job.days];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
        
        [programs appendFormat:@"&&id=%d", ID];
    }
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    if (job != nil)
        return [[T_AddJob alloc] init];
    
    return [self getaddJob:res[@"data"]];
}
//微招聘操作
- (T_AddJob*) simpleZhaopinShowByID:(int) ID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=simple_show&&phonekey=123456"];
        
    [programs appendFormat:@"&&id=%d", ID];
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [self getaddJob:res[@"data"]];
}
//微简历操作
- (T_Resume*) simpleResumeOperationByID:(int) ID andResume:(T_Resume*) job{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=simple_resume_operation&&phonekey=123456"];
    
    
    if (job != nil && ID == 0){
        [programs appendFormat:@"&&act=%@", @"add"];
        
        [programs appendFormat:@"&&uname=%@", job.fullname];
        [programs appendFormat:@"&&sex=%d", job.sex];
        
        [programs appendFormat:@"&&sex_cn=%@", job.sex_cn];
        
        [programs appendFormat:@"&&birthday=%@", job.birthdate];
        
        [programs appendFormat:@"&&experience=%d",job.experience];
        
        [programs appendFormat:@"&&experience_cn=%@", job.experience_cn];
        
        [programs appendFormat:@"&&category=%@", job.intention_jobs];
        
        [programs appendFormat:@"&&district=%d", job.district];
        
        [programs appendFormat:@"&&sdistrict=%d",job.sdistrict];
        NSArray *arr = [job.district_cn componentsSeparatedByString:@"/"];
        if ([arr count] > 1){
            [programs appendFormat:@"&&district_cn=%@", [arr objectAtIndex:0]];
            [programs appendFormat:@"&&sdistrict_cn=%@", [arr objectAtIndex:1]];
        }
        [programs appendFormat:@"&&detailed=%@", job.specialty];
        [programs appendFormat:@"&&tel=%@", job.telephone];
        [programs appendFormat:@"&&pwd=%@", job.email];
        [programs appendFormat:@"&&validity=%d", job.tpl];//有效期
    }
    else if (job != nil){
        [programs appendFormat:@"&&act=%@", @"save"];
        
        [programs appendFormat:@"&&id=%d", ID];
        [programs appendFormat:@"&&uname=%@", job.fullname];
        [programs appendFormat:@"&&sex=%d", job.sex];
        
        [programs appendFormat:@"&&sex_cn=%@", job.sex_cn];
        
        [programs appendFormat:@"&&birthday=%@", job.birthdate];
        
        [programs appendFormat:@"&&experience=%d",job.experience];
        
        [programs appendFormat:@"&&experience_cn=%@", job.experience_cn];
        
        [programs appendFormat:@"&&category=%@", job.intention_jobs];
        
        [programs appendFormat:@"&&district=%d", job.district];
        
        [programs appendFormat:@"&&sdistrict=%d",job.sdistrict];
        NSArray *arr = [job.district_cn componentsSeparatedByString:@"/"];
        if ([arr count] > 1){
            [programs appendFormat:@"&&district_cn=%@", [arr objectAtIndex:0]];
            [programs appendFormat:@"&&sdistrict_cn=%@", [arr objectAtIndex:1]];
        }
        [programs appendFormat:@"&&detailed=%@", job.specialty];
        [programs appendFormat:@"&&tel=%@", job.telephone];
        [programs appendFormat:@"&&pwd=%@", job.email];
        [programs appendFormat:@"&&days=%d", job.tpl];//有效期

    }
    else{
        [programs appendFormat:@"&&act=%@", @"get"];
        
        [programs appendFormat:@"&&id=%d", ID];
    }
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    if (job != nil)
        return [[T_Resume alloc] init];
    
    return [self getResume:res[@"data"]];
}

//微简历内容
- (T_Resume*) simpleResumeShowByID:(int) ID{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=simple_resume_show&&phonekey=123456"];
        
    [programs appendFormat:@"&&id=%d", ID];

    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [self getResume:res[@"data"]];
}
- (int) suggestByInfotype:(int) type andFeedback:(NSString*) feed andTel:(NSString*) tel{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=suggest&&phonekey=123456"];
    
    [programs appendFormat:@"&&infotype=%d", type];
    [programs appendFormat:@"&&feedback=%@", feed];
    [programs appendFormat:@"&&tel=%@", tel];
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return 0;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [res[@"data"][@"id"] intValue];
}
- (T_AboutUs*) aboutUsByActType:(int) type{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=about_us&&phonekey=123456"];
    
    if (type == 0)
        [programs appendFormat:@"&&act=%@", @"about"];
    else
        [programs appendFormat:@"&&act=%@", @"version"];

    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    T_AboutUs *data = [[T_AboutUs alloc] init];
    if ([res[@"data"] isKindOfClass:[NSString class]]){
        data.version = res[@"data"];
        return data;
    }
    
    NSDictionary *list = res[@"data"];
    
    if (list[@"sitename"] != nil)
        data.sitename = list[@"sitename"];
    
    if (list[@"website"] != nil)
        data.website = list[@"website"];
    
    if (list[@"introduce"] != nil)
        data.introduce = list[@"introduce"];
    
    if (list[@"tel"] != nil)
        data.tel = list[@"tel"];
    
    return data;
}

- (NSString*) upgrade:(NSString*) version{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=upgrade_ios&&phonekey=123456"];
    
    [programs appendFormat:@"&&version=%@", version];

    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
      /*  dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });*/
        return nil;
    }
    T_AboutUs *data = [[T_AboutUs alloc] init];
    if ([res[@"data"] isKindOfClass:[NSString class]]){
        data.version = res[@"data"];
        return nil;
    }
    
    if (res[@"data"] != nil && res[@"data"] != [NSNull null]){
        NSString *vers = res[@"data"];
        if (![vers isEqualToString:@""])
            return vers;
    }
    
    return nil;
}


//摇一摇
- (NSMutableArray*) shakeByMap_x:(float) x andMap_y:(float) y{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=shake&&phonekey=123456"];

    [programs appendFormat:@"&&map_x=%f", x];
    [programs appendFormat:@"&&map_y=%f", y];
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    
    
    for (NSDictionary *list in res[@"data"]){
        T_AddJob *data = [[T_AddJob alloc] init];
        if (list[@"id"] != nil)
            data.ID = [list[@"id"] intValue];
    
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
    
        if (list[@"companyname"] != nil)
            data.companyname = list[@"companyname"];
        
        if (list[@"wage_cn"] != nil)
            data.wage_cn = list[@"wage_cn"];
        
        if (list[@"refreshtime"] != nil)
            data.refreshtime = list[@"refreshtime"];
        
        [ans addObject:data];
    }
    
    return ans;
}


//获取热门关键词
- (NSMutableArray*) getHotWord{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=hotword&&phonekey=123456"];
    
    
    NSDictionary *res =[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    for (NSDictionary *list in res[@"data"]){
        if (list[@"w_word"] != nil){
            NSString *str = list[@"w_word"];
            [ans addObject:str];
        }
    }
    
    return ans;
}















- (T_Resume*) getResume:(NSDictionary*) list{
    T_Resume *resume = [[T_Resume alloc] init];
    
    if (list[@"id"] != nil)
        resume.ID = [list[@"id"] intValue];
    
    if (list[@"uname"] != nil)
        resume.fullname = list[@"uname"];

    if (list[@"sex"] != nil)
        resume.sex = [list[@"sex"] intValue];
    
    if (list[@"sex_cn"] != nil)
        resume.sex_cn = list[@"sex_cn"];
    
    if (list[@"age"] != nil)
        resume.birthdate = list[@"age"];

    if (list[@"experience"] != nil)
        resume.experience = [list[@"experience"] intValue];
    
    if (list[@"experience_cn"] != nil)
        resume.experience_cn = list[@"experience_cn"];
    
    if (list[@"category"] != nil)
        resume.intention_jobs = list[@"category"];
    
    if (list[@"district"] != nil)
        resume.district = [list[@"district"] intValue];
    
    if (list[@"sdistrict"] != nil)
        resume.sdistrict = [list[@"sdistrict"] intValue];
    
    if (list[@"district_cn"] != nil)
        resume.district_cn = list[@"district_cn"];
    
    if (list[@"sdistrict_cn"] != nil)
        resume.district_cn = [NSString stringWithFormat:@"%@/%@", resume.district_cn, list[@"sdistrict_cn"]];
    
    if (list[@"deadline"] != nil)
        resume.addtime = list[@"deadline"];
    
    if (list[@"refreshtime"] != nil)
        resume.refreshtime = list[@"refreshtime"];
    
    if (list[@"detailed"] != nil)
        resume.specialty = list[@"detailed"];
    
    if (list[@"tel"] != nil)
        resume.telephone = list[@"tel"];
    
    if (list[@"is_edit_tel"] != nil)
        resume.demo = [list[@"sdistrict_cn"] intValue];
    
    return resume;
}
- (T_AddJob*) getaddJob:(NSDictionary*) list{
    T_AddJob *data = [[T_AddJob alloc] init];
    
    if (list[@"id"] != nil)
        data.ID = [list[@"id"] intValue];
    
    if (list[@"jobname"] != nil)
        data.jobs_name = list[@"jobname"];
    
    if (list[@"comname"] != nil)
        data.companyname = list[@"comname"];
    if (list[@"district"] != nil)
        data.district = [list[@"district"] intValue];
    
    if (list[@"sdistrict"] != nil)
        data.sdistrict = [list[@"sdistrict"] intValue];
    
    if (list[@"district_cn"] != nil)
        data.district_cn = list[@"district_cn"];
    
    if (list[@"sdistrict_cn"] != nil)
        data.district_cn = [NSString stringWithFormat:@"%@/%@", data.district_cn, list[@"sdistrict_cn"]];
    
    if (list[@"amount"] != nil)
        data.amount = [list[@"amount"] intValue];
    if (list[@"deadline"] != nil)
        data.olddeadline = list[@"deadline"];
    if (list[@"refreshtime"] != nil)
        data.olddeadline = list[@"refreshtime"];
    if (list[@"click"] != nil)
        data.click = [list[@"click"] intValue];
    
    if (list[@"detailed"] != nil)
        data.contents = list[@"detailed"];
    if (list[@"contact"] != nil)
        data.contact = list[@"contact"];
    if (list[@"tel"] != nil)
        data.telephone = list[@"tel"];
    
    if (list[@"is_edit_tel"] != nil)
        data.demo = [list[@"is_edit_tel"] intValue];
    
    return data;
}
- (NSMutableArray*) getSimple:(NSArray*) result{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    for (NSDictionary *list in result){
        T_Simple *data = [[T_Simple alloc] init];
        
        if (list[@"id"] != nil)
            data.ID= [list[@"id"] intValue];
        
        if (list[@"jobname"] != nil)
            data.jobname =list[@"jobname"];
        
        if (list[@"comname"] != nil)
            data.comname = list[@"comname"];
        
        if (list[@"refreshtime"] != nil)
            data.refreshtime = list[@"refreshtime"];
        
        if (list[@"sdistrict_cn"] !=nil)
            data.sdistrict_cn = list[@"sdistrict_cn"];
        
        if (list[@"uname"] != nil)
            data.uname = list[@"uname"];
        
        if (list[@"age"] != nil)
            data.age = [list[@"age"] intValue];
        
        if (list[@"sex_cn"] != nil)
            data.sex_cn = list[@"sex_cn"];
        
        if (list[@"category"] != nil)
            data.category = list[@"category"];
        
        
        if (list[@"experience_cn"] != nil)
            data.experience_cn = list[@"experience_cn"];
        
        [ans addObject:data];
    }
    return ans;
}
- (NSMutableArray*) getNews:(NSArray*) result{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    for (NSDictionary *list in result){
        T_News *data = [[T_News alloc] init];
        
        if (list[@"id"] != nil)
            data.ID= [list[@"id"] intValue];
        
        if (list[@"type_id"] != nil)
            data.type =list[@"type_id"];
        
        if (list[@"title"] != nil)
            data.title = list[@"title"];
        
        if (list[@"content"] != nil)
            data.content = list[@"content"];
        
        if (list[@"Small_img"] != nil && ![list[@"Small_img"] isEqual:[NSNull null]])
            data.small_img = list[@"Small_img"];
        
        [ans addObject:data];
    }
    return ans;
}
- (NSMutableArray*) getJobfair:(NSArray*) result{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    for (NSDictionary *list in result){
        T_Jobfair *data = [[T_Jobfair alloc] init];
        
        if (list[@"id"] != nil)
            data.ID= [list[@"id"] intValue];
        
        if (list[@"title"] != nil)
            data.title = list[@"title"];
        
        if (list[@"address"] != nil)
            data.address = list[@"address"];
        
        if (list[@"holddate_start"] != nil)
            data.holddate_start = list[@"holddate_start"];
        
        [ans addObject:data];
    }
    return ans;
}

- (NSMutableArray*) getJobs:(NSArray*) result{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    for (NSDictionary *list in result){
        T_ApplyJob *data = [[T_ApplyJob alloc] init];
        
        if (list[@"id"] != nil)
            data.jobs_id= [list[@"id"] intValue];
        
        if (list[@"jobs_name"] != nil)
            data.jobs_name = list[@"jobs_name"];
        
        if (list[@"companyname"] != nil)
            data.companyname = list[@"companyname"];
        
        if (list[@"wage_cn"] != nil)
            data.demo = list[@"wage_cn"];
        
        if (list[@"refreshtime"] != nil)
            data.apply_addtime = list[@"refreshtime"];
        
        [ans addObject:data];
    }
    return ans;
}

- (NSMutableArray*) getApplyJobs:(NSArray*) result{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    for (NSDictionary *list in result){
        T_ApplyJob *data = [[T_ApplyJob alloc] init];

        
        if (list[@"id"] != nil)
            data.resume_id = [list[@"id"] intValue];

        
        if (list[@"fullname"] != nil)
            data.fullname = list[@"fullname"];
        
        if (list[@"residence"] != nil)
            data.demo = list[@"residence"];
        
        if (list[@"education_cn"] != nil)
            data.education_cn = list[@"education_cn"];
        
        if (list[@"experience_cn"] != nil)
            data.experience_cn = list[@"experience_cn"];
        
        if (list[@"intention_jobs"] != nil)
            data.intention_jobs = list[@"intention_jobs"];
        
        
        if (list[@"refreshtime"] != nil)
            data.apply_addtime = list[@"refreshtime"];

        [ans addObject:data];
    }
    return ans;
}



@end
