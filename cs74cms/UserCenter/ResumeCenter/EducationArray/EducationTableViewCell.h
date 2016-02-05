//
//  EducationTableViewCell.h
//  74cms
//
//  Created by lyp on 15/4/23.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EducationTableViewCellDelegate <NSObject>

- (void) longPressToDo:(long) tag;

@end

@interface EducationTableViewCell : UITableViewCell{
    BOOL sign;
}

@property(nonatomic, retain) id<EducationTableViewCellDelegate> delegate;

- (void) setTitle:(NSString*) title andStartTime:(NSString*) start andEndTime:(NSString*) end;

@end
