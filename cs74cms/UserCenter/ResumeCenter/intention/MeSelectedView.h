//
//  MeSelectedView.h
//  74cms
//
//  Created by lyp on 15/4/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeSelectedDelegate <NSObject>

- (void) deleteItem:(int)t;

@end

@interface MeSelectedView : UIView

@property(nonatomic, retain) id<MeSelectedDelegate> delegate;

- (void) addString:(NSString*) str;

- (int) selectedCount;

- (NSMutableArray*) selectedItem;

@end
