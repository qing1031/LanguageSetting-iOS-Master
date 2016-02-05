//
//  MutableMenuViewController.h
//  cs74cms
//
//  Created by lyp on 15/5/15.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"

@protocol MutableMenuDelegate <NSObject>

@optional
- (void) MutableMenuSelectedThis:(int) c_id andString:(NSString*) str;

- (void) MutableMenuSelectedThisIdString:(NSString*) c_id andTitleString:(NSString*) str;

- (void) MutableMenuSelectedId:(int) c_id andIdString:(NSString *)idString andTitle:(NSString*)title andTitleString:(NSString *)titleString;
@end

@interface MutableMenuViewController : SuperViewController

@property(nonatomic, retain) id<MutableMenuDelegate> delegate;

- (void) setHanshuName:(NSString*) str;

- (void) setTableViewY:(CGFloat) y andHeight:(CGFloat) height;

- (void) setCanDuoXuan:(BOOL) duoxuan;

@end
