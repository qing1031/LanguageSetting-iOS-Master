//
//  ChoiceIndustryViewController.h
//  74cms
//
//  Created by lyp on 15/4/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"

@protocol MutableChoiceDelegate <NSObject>

- (void) mutableChoiceByContent:(NSString*) content andId:(NSString*) idStr;

@end

@interface ChoiceIndustryViewController : SuperViewController

@property(nonatomic, retain) id<MutableChoiceDelegate> delegate;

- (void) setHanshuName:(NSString*) str;

//0地区 1行业 2职能
- (void) setSign:(int) tsign;
@end
