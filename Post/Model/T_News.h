//
//  T_News.h
//  cs74cms
//
//  Created by lyp on 15/6/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_News : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, assign) int type_id;
@property(nonatomic, strong) NSString* type;

@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* small_img;

@property(nonatomic, strong) NSString* addtime;
@property(nonatomic, assign) int click;

@end
