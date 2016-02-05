//
//  T_category.h
//  cs74cms
//
//  Created by lyp on 15/5/14.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T_category : NSObject

@property(nonatomic, assign) int c_id;//
@property(nonatomic, assign) int c_parentid;
@property(nonatomic, strong) NSString* c_name;

@property(nonatomic, assign) int level;//菜单级别
@property(nonatomic, assign) BOOL open;//子菜单打开否

@end
