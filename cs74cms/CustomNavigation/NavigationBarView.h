//
//  NavigationBarView.h
//  myFirstPro
//
//  Created by zwh on 14-3-24.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BTNNUM 100

@protocol NavigationBarViewDelegate <NSObject>

@optional
- (void) returnButtonClicked;
- (void) subMenuViewButtonClicked;
//- (void) rightBtnClicked:(id)sender;

@end



@interface NavigationBarView : UIView

@property (nonatomic, retain) id<NavigationBarViewDelegate> delegate;

- (void) setTitle:(NSString *)title;
- (void) setRightBtn:(NSArray*) array;

- (NSArray*) getRightBtn;

@end
