//
//  ManageTableViewCell.h
//  74cms
//
//  Created by lyp on 15/5/6.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageTableViewCellDelegate <NSObject>

- (void) managetableViewCellSelected:(int) index;

@end

@interface ManageTableViewCell : UITableViewCell{
    UILabel *title;
    UIView *separe;
    UILabel *num;
    UILabel *message;
    UILabel *time;
    UILabel *value;
}

@property(nonatomic, retain) id<ManageTableViewCellDelegate> delegate;

- (void) setTitle:(NSString*) str;

- (void) setMessage:(NSString*) str;

- (void) setTime:(NSString*) str;

- (void) setValue:(NSString*) str;

- (void) setNum:(int) t;

- (void) subMenu;



@property(nonatomic, retain) UIView *menu;


@end
