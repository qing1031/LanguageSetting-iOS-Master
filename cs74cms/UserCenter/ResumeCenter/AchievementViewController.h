//
//  AchievementViewController.h
//  cs74cms
//
//  Created by lyp on 15/5/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"

@protocol AchievementDelegate <NSObject>

- (void) achievementScanf:(NSString*) str;

@end


@interface AchievementViewController : SuperViewController

@property(nonatomic, retain) id<AchievementDelegate> delegate;

- (void) setTitle:(NSString *)title andTishi:(NSString*) tishi;

- (void) setContent:(NSString*) str;

@end
