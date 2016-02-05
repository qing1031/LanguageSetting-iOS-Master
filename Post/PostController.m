//
//  PostController.m
//  LG_lianxi3
//
//  Created by cyios on 14-3-27.
//  Copyright (c) 2014年 nhf. All rights reserved.
//

#import "PostController.h"
#import "InitData.h"

@implementation PostController

- (id) enReplaceString:(id) data{
    if (![data isKindOfClass:[NSString class]]) {
        return data;
    }
    NSString *dataStr = data;
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"@r@n"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@"@n"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\t" withString:@"@t"];
    return dataStr;
}

- (id) deReplaceString:(id) data{
    if (![data isKindOfClass:[NSString class]]) {
        return data;
    }
    NSString *dataStr = data;
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"@r@n" withString:@"\r\n"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"@n" withString:@"\n"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"@t" withString:@"\t"];
    return dataStr;
}

-(NSDictionary*)connectUrlData:(NSString *)method programs:(NSString *)program
{    
    if (![InitData NetIsExit])
        return nil;
    
    NSURL* webService = [NSURL URLWithString:[NSString stringWithFormat:@"%@", method]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:webService];
    NSLog(@"%@?%@", webService, program);
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    if(program != nil)
    {
        NSData* postProgramsData = [program dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postProgramsData];
    }
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!data){
        [InitData netAlert:MYLocalizedString(@"网络请求超时，请稍后重试!", @"Network request timeout, please try again later!")];
        return nil;
    }
    
    
    //消除转义字符
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dataStr = [self enReplaceString:dataStr];
    
    NSData* xmlData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if (xmlData == nil)
        return nil;
    
    //变为字典
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:xmlData options:kNilOptions error:&error];//NSJSONReadingMutableLeaves
    
    if ([dict[@"status"] intValue] == 2){//如果session实效， 重新登录一次
        T_User *user = [InitData getUser];
        BOOL res ;
        if (user.openID != nil)
            res = [self loginByUsername:nil andPassword:nil andOPenID:user.openID];
        else if (user.username != nil && user.userpwd != nil)
            res = [self loginByUsername:user.username andPassword:user.userpwd andOPenID:nil];
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:nil userInfo:nil];
            });
        }
        if (res)
            return [self connectUrlData:method programs:program];
    }
    
    NSMutableDictionary *result;
    if ([dict[@"data"] isKindOfClass:[NSArray class]])
        result = [self getContentDictionaryArray:dict];
    else
       result = [self getContentDictionary:dict];
    return result;
}

-(NSDictionary*)connectUrlThouthGetByData:(NSString *)method programs:(NSString *)program
{
    if (![InitData NetIsExit])
        return nil;
    
    NSURL* webService = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", method, program]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:webService];
   //NSLog(@"%@", webService);
    [request setHTTPMethod:@"Get"];
    [request setTimeoutInterval:30];

    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //消除转义字符
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dataStr = [self enReplaceString:dataStr];
    
    NSData* xmlData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if (xmlData == nil)
        return nil;
    
    //变为字典
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:xmlData options:kNilOptions error:&error];//NSJSONReadingMutableLeaves

    return dict;
}








- (NSMutableURLRequest *)postRequestWithMethod:(NSString*)method andParems:(NSDictionary *)postParems images: (NSArray *)images
{
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:method]];
    //分割符
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http 参数body的字符串
    NSMutableString *paraBody=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    //遍历keys
    for(int i = 0; i < [keys count] ; i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [paraBody appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [paraBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [paraBody appendFormat:@"%@\r\n",[postParems objectForKey:key]];
    }
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[paraBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (images != nil){
        int i = 0;
   // for (int i = 0; i < images.count; i++)
   // {

        NSMutableString *imageBody = [[NSMutableString alloc] init];
        NSData *imageData = nil;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(images[i]))
        {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(images[i]);
        }else
        {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(images[i], 1.0);
        }
        
        NSString *name = @"uploadedfile";//[NSString stringWithFormat:@"name%d",i];
        NSString *fileNmae = [NSString stringWithFormat:@"filename%d.png",i];
        //添加分界线，换行
        [imageBody appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [imageBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileNmae];
        //声明上传文件的格式
        [imageBody appendFormat:@"Content-Type: image/png\r\n\r\n"];//jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg
        //将image的data加入
        
        [myRequestData appendData:[imageBody dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[[NSData alloc] initWithData:imageData]];
        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  //  }
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    return request;
}

-(NSDictionary*)connectUrlData:(NSString *)method programs:(NSDictionary *)parameters andImg:(UIImage*) img
{
    if (![InitData NetIsExit])
        return nil;

    NSMutableURLRequest * request;
    if (img != nil)
        request = [self postRequestWithMethod:method andParems:parameters images:[NSArray arrayWithObject:img]];
    else
        request = [self postRequestWithMethod:method andParems:parameters images:nil];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //消除转义字符
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dataStr = [self enReplaceString:dataStr];
    
    NSData* xmlData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    //变为字典
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:xmlData options:kNilOptions error:&error];//NSJSONReadingMutableLeaves
    
    if ([dict[@"status"] intValue] == 2){//如果session实效， 重新登录一次
        T_User *user = [InitData getUser];
        BOOL res ;
        if (user.openID != nil)
            res = [self loginByUsername:nil andPassword:nil andOPenID:user.openID];
        else if (user.username != nil && user.userpwd != nil)
            res = [self loginByUsername:user.username andPassword:user.userpwd andOPenID:nil];
        if (res)
            return [self connectUrlData:method programs:parameters andImg:img];
    }
    
    NSMutableDictionary *result;
    if ([dict[@"data"] isKindOfClass:[NSArray class]])
        result = [self getContentDictionaryArray:dict];
    else
        result = [self getContentDictionary:dict];
    return result;
}

- (NSMutableDictionary*) getContentDictionary:(NSDictionary*) dict{
    if (dict == nil)
        return nil;
    
    if ([dict[@"data"] isKindOfClass:[NSString class]])
        return [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSDictionary *list = [dict objectForKey:@"data"];
    NSMutableDictionary *ans = [[NSMutableDictionary alloc] initWithDictionary:dict];
    //不是嵌套字典
    if ([list isEqual:[NSNull null]]){
        return ans;
    }
            
    //还原转义字符
    NSArray *keys = [list allKeys];
    int count = (int)[keys count];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < count; i++)
    {
        NSString *key = [keys objectAtIndex: i];
        NSString *value = [list objectForKey: key];
        if ([list[key] isKindOfClass:[NSString class]])
            value = [self deReplaceString:[list objectForKey: key]];
        [data setObject:value forKey:key];
     }
    ans[@"data"] = data;
    return ans;
}

- (NSMutableDictionary*)getContentDictionaryArray:(NSDictionary*) dict{
    if (dict == nil)
        return nil;
    
    NSArray *array = [dict objectForKey:@"data"];
    NSMutableDictionary *ans = [[NSMutableDictionary alloc] initWithDictionary:dict];
    //不是嵌套字典
    if ([array isEqual:[NSNull null]] || [array count] == 0){
        return ans;
    }
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *list in array){
        //还原转义字符
        NSArray *keys = [list allKeys];
        int count = (int)[keys count];
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < count; i++)
        {
            NSString *key = [keys objectAtIndex: i];
            NSString * value = [list objectForKey: key];
            if ([list[key] isKindOfClass:[NSString class]])// && ![list[key] isEqual:[NSNull null]]
                value = [self deReplaceString:[list objectForKey: key]];
            [result setObject:value forKey:key];
        }
        [data addObject:result];
    }
    ans[@"data"] = data;
    return ans;
}

-(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


- (BOOL) loginByUsername:(NSString *) username andPassword:(NSString*) password andOPenID:(NSString*)openID
{
    
    
    PostController *post = [[PostController alloc] init];
    NSMutableString *programs = [NSMutableString stringWithString:@"mact=login&&phonekey=123456"];
    [programs appendFormat:@"&&act=%@", @"username_login"];
    
    if (username != nil && password != nil && ![password isEqualToString:@""]){
        [programs appendFormat:@"&&username=%@&&password=%@",username,password];
    }
    else if (openID != nil){
            [programs appendFormat:@"&&agency_id=%@", openID];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"] != nil){
        [programs appendFormat:@"&&imei=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]];
        [programs appendFormat:@"&&reg_type=%d", 4];
    }
    
    NSDictionary *res=[post connectUrlData:[InitData Path] programs:programs];
    
    if ([res[@"status"] intValue] == 1){
        return YES;
    }
    return  NO;
}

@end
