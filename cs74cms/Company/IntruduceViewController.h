//
//  IntruduceViewController.h
//  74cms
//
//  Created by lyp on 15/5/5.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"

@protocol IntruduceDelegate <NSObject>

- (void) IntruduceGetContent:(NSString*) contents andGetNum:(NSInteger) num;

@end

@interface IntruduceViewController : SuperViewController

@property(nonatomic, retain) id<IntruduceDelegate> delegate;

- (void) setContent:(NSString*) str;

@end
