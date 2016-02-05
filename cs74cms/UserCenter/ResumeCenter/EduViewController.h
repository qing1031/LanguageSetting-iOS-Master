//
//  EduViewController.h
//  74cms
//
//  Created by lyp on 15/4/21.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"

@protocol EduDelegate <NSObject>

@optional

- (void) selectString:(NSString*) str;
- (void) selectIndex:(int) index;

@end

@interface EduViewController : SuperViewController

@property(nonatomic, retain) id<EduDelegate> delegate;

- (void) setViewWithNSArray:(NSArray *) array;

@end
