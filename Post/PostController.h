//
//  PostController.h
//  LG_lianxi3
//
//  Created by cyios on 14-3-27.
//  Copyright (c) 2014年 nhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostController : NSObject<NSURLConnectionDataDelegate, NSXMLParserDelegate>

//post方法
-(NSDictionary*)connectUrlData:(NSString *)method programs:(NSString *)program;

//文件传输
-(NSDictionary*)connectUrlData:(NSString *)method programs:(NSDictionary *)parameters andImg:(UIImage*) img;

//get方法
-(NSDictionary*)connectUrlThouthGetByData:(NSString *)method programs:(NSString *)program;

-(NSString *)stringFromDate:(NSDate *)date;
@end
