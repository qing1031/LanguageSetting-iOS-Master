//
//  ITF_Apply.m
//  cs74cms
//
//  Created by lyp on 15/6/6.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ITF_Apply.h"
#import "T_ApplyJob.h"
#import "PostController.h"
#import "InitData.h"
#import "T_MapJob.h"


@implementation ITF_Apply

- (NSMutableArray*) applyJobByUser:(T_User*) user andJid:(int) Jid andRid:(int) Rid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=user_apply_jobs&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    if (Jid > 0 && Rid > 0){
        [programs appendFormat:@"&&act=%@", @"app_save"];
        [programs appendFormat:@"&&rid=%d", Rid];
        [programs appendFormat:@"&&jid=%d", Jid];
    }
    else{
        [programs appendFormat:@"&&act=%@", @"app"];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }

    NSMutableArray * ans = [[NSMutableArray alloc] init];
    if (Jid > 0 && Rid > 0){
        return ans;
    }
    
    NSMutableArray *array = [res objectForKey:@"data"];

    
    if ([array count] == 0)
        return nil;
    
    for (int i=0; i<[array count]; i++){
        NSDictionary *list = [array objectAtIndex:i];
        
        T_ApplyJob *data = [[T_ApplyJob alloc] init];

        
        if ([list objectForKey:@"id"]!= nil && [list objectForKey:@"id"])
            data.resume_id = [[list objectForKey:@"id"] intValue];
        
        if ([list objectForKey:@"title"]!= nil)
            data.fullname = [list objectForKey:@"title"];
        
        [ans addObject:data];
    }
    
    return ans;
}
- (int) collectJobByUser:(T_User*) user andJid:(int) Jid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=user_favorites_job&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];

    [programs appendFormat:@"&&jid=%d", Jid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return 0;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [res[@"data"][@"did"] intValue];
}
//下载简历
- (int) downloadResumeByUser:(T_User*)user andRid:(int) rid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=user_download_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    [programs appendFormat:@"&&rid=%d", rid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return 0;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [res[@"data"][@"did"] intValue];
}

//收藏简历
- (int) collectResumeByUser:(T_User*)user andRid:(int) rid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=user_favorites_resume&&phonekey=123456"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&userpwd=%@", user.userpwd];
    
    [programs appendFormat:@"&&rid=%d", rid];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return 0;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [res[@"data"][@"did"] intValue];
}
- (T_User*) emailRegisterByType:(int) type andUsername:(NSString*) username andEmail:(NSString*) email andPwd:(NSString*) one andPwdtwo:(NSString*) two{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=reg&&phonekey=123456"];
    
    [programs appendFormat:@"&&utype=%d", type];
    [programs appendFormat:@"&&act=%@", @"email_reg"];
    
    [programs appendFormat:@"&&username=%@", username];
    [programs appendFormat:@"&&email=%@", email];
    [programs appendFormat:@"&&password=%@", one];
    [programs appendFormat:@"&&password_two=%@", two];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] != nil){
        [programs appendFormat:@"&&imei=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]];
        [programs appendFormat:@"&&reg_type=%d", 4];
    }
        
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    NSDictionary *list = res[@"data"];
    T_User *data = [[T_User alloc] init];
    
    if (list[@"uid"] != nil)
        data.ID = [list[@"uid"] intValue];
    
    if (list[@"username"] != nil)
        data.username = list[@"username"];
    
    if (list[@"utype"] != nil)
        data.utype = [list[@"utype"] intValue];
    
    return data;
}

- (T_User*) phoneRegisterByType:(int) type andVerifycode:(NSString*) verity andMobile:(NSString*) mobile andPwd:(NSString*) pwd{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=reg&&phonekey=123456"];
    
    [programs appendFormat:@"&&utype=%d", type];
    [programs appendFormat:@"&&act=%@", @"phone_reg"];
    
    [programs appendFormat:@"&&verifycode=%@", verity];
    [programs appendFormat:@"&&mobile=%@", mobile];
    [programs appendFormat:@"&&password=%@", pwd];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] != nil){
        [programs appendFormat:@"&&imei=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]];
        [programs appendFormat:@"&&reg_type=%d", 4];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    NSDictionary *list = res[@"data"];
    T_User *data = [[T_User alloc] init];
    
    if (list[@"uid"] != nil)
        data.ID = [list[@"uid"] intValue];
    
    if (list[@"username"] != nil)
        data.username = list[@"username"];
    
    if (list[@"utype"] != nil)
        data.utype = [list[@"utype"] intValue];
    
    return data;
}

- (T_Verify*) sendCodeByType:(int) type andMobile:(NSString*) mobile{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=reg&&phonekey=123456"];
    
    [programs appendFormat:@"&&act=%@", @"send_code"];
    [programs appendFormat:@"&&utype=%d", type];
    [programs appendFormat:@"&&mobile=%@", mobile];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    
    NSDictionary *list = res[@"data"];
    T_Verify *data = [[T_Verify alloc] init];
    
    if (list[@"mobile_rand"] != nil)
        data.rand = list[@"mobile_rand"];
    
    if (list[@"send_time"] != nil)
        data.time = list[@"send_time"];
    
    if (list[@"verify_mobile"] != nil)
        data.mobile = list[@"verify_mobile"];
    
    return data;
}

//添加备注
- (int) companyReplyByUser:(T_User*) user andPid:(int) Pid andJid:(int) Jid andReplyId:(int) Rid andReplyIdCn:(NSString*) rcn{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=reply&&phonekey=123456"];
    
    [programs appendFormat:@"&&act=%@", @"reply"];
    [programs appendFormat:@"&&username=%@", user.username];
    [programs appendFormat:@"&&password=%@", user.userpwd];
    [programs appendFormat:@"&&pid=%d", Pid];
    [programs appendFormat:@"&&jobs_id=%d", Jid];
    [programs appendFormat:@"&&reply_id=%d", Rid];
    [programs appendFormat:@"&&reply_id_cn=%@", rcn];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return 0;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    
    return [res[@"data"][@"reply_id"] intValue];
}

- (T_Ads*) getAds{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=ad&&phonekey=123456"];
    
    [programs appendFormat:@"&&act=%@", @"welcome"];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    T_Ads *data = [[T_Ads alloc] init];
    data.img_path = res[@"data"];
    
    return data;
}

- (NSMutableArray*) getIndexfocus{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=ad&&phonekey=123456"];
    
    [programs appendFormat:@"&&act=%@", @"indexfocus"];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return 0;
    }
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    NSArray *array = res[@"data"];
    for (NSDictionary *list in array){
        T_Ads *data = [[T_Ads alloc] init];
        if (list[@"id"] != nil)
            data.ID = [list[@"id"] intValue];
        if (list[@"img_path"] != nil)
            data.img_path = list[@"img_path"];
        if (list[@"img_url"] != nil)
            data.img_url = list[@"img_url"];
        [ans addObject:data];
    }
    
    return ans;
}

- (NSMutableArray*) mapSearchByLat:(float) lat andLon:(float) lon andJobs:(NSString*) jobcategory andTrade:(NSString*) trade andSettr:(int) settr andDistance:(int) dis {
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=map_search&&phonekey=123456"];
    
    if (jobcategory != nil)
        [programs appendFormat:@"&&jobcategory=%@", jobcategory];
    else
        [programs appendFormat:@"&&jobcategory="];
    if (trade != nil)
        [programs appendFormat:@"&&trade=%@", trade];
    else
        [programs appendFormat:@"&&trade="];
    [programs appendFormat:@"&&settr=%d", settr];
    [programs appendFormat:@"&&lat=%f", lat];
    [programs appendFormat:@"&&lon=%f", lon];
    [programs appendFormat:@"&&distance=%d", dis];
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    NSArray *array = res[@"data"];
    for (NSDictionary *list in array){
        T_MapJob *data = [[T_MapJob alloc] init];
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
        data.lon = [list[@"map_x"] floatValue];
        data.lat = [[list objectForKey:@"map_y"] floatValue];
        [ans addObject:data];
    }
    
    return ans;
}

- (BOOL) setPwdByType:(int) type andPhone:(NSString*) phone andCode:(NSString*) code andPwd:(NSString*) one andPwd_two:(NSString*) two{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"mact=setpwd&&phonekey=123456"];
    
    if (type == 0){
        [programs appendFormat:@"&&act=%@", @"phone"];
        if (phone != nil && one == nil){
            [programs appendFormat:@"&&pact=%@", @"send_code"];
            [programs appendFormat:@"&&mobile=%@", phone];
        }else if (code != nil){
            [programs appendFormat:@"&&pact=%@", @"verify_code"];
            [programs appendFormat:@"&&verifycode=%@", code];
        }else{
            [programs appendFormat:@"&&pact=%@", @"set_password"];
            [programs appendFormat:@"&&password=%@", one];
            [programs appendFormat:@"&&password_two=%@", two];
            [programs appendFormat:@"&&mobile=%@", phone];
        }
    }
    else{
        [programs appendFormat:@"&&act=%@", @"email"];
        if (phone != nil && one == nil){
            [programs appendFormat:@"&&pact=%@", @"send_code"];
            [programs appendFormat:@"&&email=%@", phone];
        }else if (code != nil){
            [programs appendFormat:@"&&pact=%@", @"verify_code"];
            [programs appendFormat:@"&&verifycode=%@", code];
        }else{
            [programs appendFormat:@"&&pact=%@", @"set_password"];
            [programs appendFormat:@"&&password=%@", one];
            [programs appendFormat:@"&&password_two=%@", two];
            [programs appendFormat:@"&&email=%@", phone];
        }
    }

    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
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
//第三方登录接口 ,0qq,  1sina,  2taobao     utype = 1企业  2个人
- (T_User*) connectAgencyBytype:(int) type andUId:(NSString*)uid andNick:(NSString*) nick andIdold:(BOOL)isold andUtype:(int) utype andUserpwd:(NSString*) pwd andEmail:(NSString*) email andMobile:(NSString*) mobile andUsername:(NSString*) username{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@"phonekey=123456"];
    
    if (type == 0){
        [programs appendFormat:@"&&mact=%@", @"qq_login"];
        if (utype == 0 && username == nil)
            [programs appendFormat:@"&&act=%@", @"qq"];
    }
    else if (type == 1){
        [programs appendFormat:@"&&mact=%@", @"sina_login"];
        if (utype == 0)
            [programs appendFormat:@"&&act=%@", @"sina"];

    }
    else if (type == 2){
        [programs appendFormat:@"&&mact=%@", @"taobao_login"];
        if (utype == 0)
            [programs appendFormat:@"&&act=%@", @"taobao"];
    }
    [programs appendFormat:@"&&nickname=%@", nick];
    [programs appendFormat:@"&&agency_id=%@", uid];
    
    if (utype > 0 || username != nil){
            if (isold){
                [programs appendFormat:@"&&act=%@", @"old"];
                [programs appendFormat:@"&&username=%@", username];
                [programs appendFormat:@"&&password=%@", pwd];
            }else{
                [programs appendFormat:@"&&act=%@", @"new"];
                [programs appendFormat:@"&&password=%@", pwd];
                [programs appendFormat:@"&&utype=%d", utype];
                [programs appendFormat:@"&&mobile=%@", mobile];
                [programs appendFormat:@"&&email=%@", email];
            }
        }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] != nil){
        [programs appendFormat:@"&&imei=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]];
        [programs appendFormat:@"&&reg_type=%d", 4];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if (res == nil)
        return nil;
    if ([res[@"status"] intValue] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData netAlert:res[@"errormsg"]];
        });
        return nil;
    }
    T_User *user = [[T_User alloc] init];
    if (![res[@"data"] isEqual:[NSNull null]]){
    
    NSDictionary *list = res[@"data"];
    if (list[@"uid"] != nil)
        user.ID = [list[@"uid"] intValue];
    if (list[@"username"] != nil)
        user.username = list[@"username"];
    if (list[@"utype"] != nil)
        user.utype = [list[@"utype"] intValue];
    }
    
    return user;
}

- (T_User*) getSinaUserInfoByToken:(NSString*) token andUid:(NSString*) uid{
    PostController *post = [[PostController alloc] init];
    
    NSMutableString *programs = [NSMutableString  stringWithString:@""];
    [programs appendFormat:@"&&access_token=%@", token];
    [programs appendFormat:@"&&uid=%@", uid];
    
    NSDictionary *res=[post connectUrlThouthGetByData:@"https://api.weibo.com/2/users/show.json" programs:programs ];
    
    if (res == nil)
        return nil;

    T_User *user = [[T_User alloc] init];
    user.userpwd = [res[@"id"] stringValue];
    user.username = res[@"screen_name"];
    
    
    return user;
}

@end
