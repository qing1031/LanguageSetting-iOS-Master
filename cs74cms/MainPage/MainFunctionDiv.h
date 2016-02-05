//
//  MainFunction.h
//  74cms
//
//  Created by LPY on 15-4-10.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainFunctionDivDelegate <NSObject>

-(void) selectThis:(int) tag;

@end

@interface MainFunctionDiv : UIView

@property(nonatomic, retain) id<MainFunctionDivDelegate> delegate;

- (void) setImage:(NSString*) img andTitle:(NSString*) title;
@property (nonatomic, strong) UILabel *titleLabel;

@end
