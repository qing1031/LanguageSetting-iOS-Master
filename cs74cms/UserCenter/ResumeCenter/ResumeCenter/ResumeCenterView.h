//
//  ResumeCenterView.h
//  74cms
//
//  Created by lyp on 15/4/22.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResumeCenterViewDelegate <NSObject>

- (void) privacySet;

- (void) butClicked:(int) index;

- (void) haveApplyClicked;

- (void) careMeClicked;

- (void) inviteClicked;

- (void) getPicture:(UIButton*) but;

@end

@interface ResumeCenterView : UIView

@property(nonatomic, retain) id<ResumeCenterViewDelegate> delegate;

- (void) setTitle:(NSString*) str;
- (void) setUpdateTime:(NSString*) str;
- (void) setCreatTime:(NSString*) str;
- (void) setPicture:(NSString*) str;
- (void) setHaveApply:(NSString*) str;
- (void) setCareMe:(NSString*) str;
- (void) setInvite:(NSString*) str;

- (void) setPrivacySetTitle:(NSString*) str;

@end
