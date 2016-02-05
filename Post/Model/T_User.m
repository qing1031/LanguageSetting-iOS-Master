//
//  T_User.m
//  cs74cms
//
//  Created by lyp on 15/5/12.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "T_User.h"

@implementation T_User

@synthesize username;
@synthesize userpwd;

@synthesize openID;


@synthesize utype;
@synthesize profile;
@synthesize apply_resume_num;
@synthesize pms_num;
@synthesize photo_img;
@synthesize logo;

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:username forKey:@"username"];
    [aCoder encodeObject:userpwd forKey:@"userpwd"];
    [aCoder encodeObject:openID forKey:@"openID"];
    [aCoder encodeObject:[NSNumber numberWithInt:utype] forKey:@"utype"];
    [aCoder encodeObject:[NSNumber numberWithBool:profile] forKey:@"profile"];
    [aCoder encodeObject:apply_resume_num forKey:@"apply_resume_num"];
    [aCoder encodeObject:[NSNumber numberWithInt:pms_num] forKey:@"pms_num"];
    [aCoder encodeObject:photo_img forKey:@"photo_img"];
    [aCoder encodeObject:logo forKey:@"logo"];
}
- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.userpwd = [aDecoder decodeObjectForKey: @"userpwd"];
        self.openID = [aDecoder decodeObjectForKey: @"openID"];
        self.utype = [[aDecoder decodeObjectForKey: @"utype"] intValue];
        self.profile = [[aDecoder decodeObjectForKey: @"profile"] boolValue];
        self.apply_resume_num = [aDecoder decodeObjectForKey :@"apply_resume_num"];
        self.pms_num = [[aDecoder decodeObjectForKey: @"pms_num"] intValue];
        self.photo_img = [aDecoder decodeObjectForKey: @"photo_img"];
        self.logo = [aDecoder decodeObjectForKey: @"logo"];
    }
    return self;
}


@end
