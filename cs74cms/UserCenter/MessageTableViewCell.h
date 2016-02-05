//
//  MessageTableViewCell.h
//  74cms
//
//  Created by LPY on 15-4-13.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageTableViewCellDelegate <NSObject>

//-(void) deletClicked:(int) tag;

@end

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic,retain) id<MessageTableViewCellDelegate> delegate;

- (void) setTitle:(NSString*) str;

- (void) setMessage:(NSString*) str;

- (void) setTime:(NSString*) str;

- (void) setState:(NSString*) str;

@end
