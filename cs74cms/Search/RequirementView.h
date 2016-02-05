//
//  RequirementView.h
//  74cms
//
//  Created by lyp on 15/4/30.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequirementDelegate <NSObject>

- (void) requirementThis:(int) index;

@end

@interface RequirementView : UIView

@property(nonatomic, retain) id<RequirementDelegate> delegate;


- (void) setWithArray:(NSArray*) array;

@end
