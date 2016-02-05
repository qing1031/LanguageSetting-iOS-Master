//
//  SuperViewController.h
//  myFirstPro
//
//  Created by zwh on 14-3-27.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

/*
 *所有要使用我的自定义导航栏的 UIViewController 均许继承自此类
 */

#import <UIKit/UIKit.h>

@protocol SuperViewControllerDelegate <NSObject>

@optional


//界面设置
- (void) setNavigationBarColor:(UIColor*) color;
- (void) setTitle:(NSString*) str;
- (void) setRightBtn:(NSArray*) btnArray;

- (NSArray*) getRightBtn;

- (void) hidenItsTabBar:(BOOL) hiden;

- (void) setNavigaionBarHidden:(BOOL) hidden;

//页面跳转控制
- (void) pushAndDisplayViewController:(UIViewController*)view;
- (void) popAndPushViewController:(UIViewController*) view;
- (void) dismissViewController;
- (void) popToRootViewController;
- (void) popViewControllers:(int) num;

@end


@interface SuperViewController : UIViewController

@property(nonatomic, retain) id<SuperViewControllerDelegate> myNavigationController;

//页面出现
- (void) viewCanBeSee;

//返回上一个页面
- (void) viewCannotBeSee;

//进入下个页面
- (void) nextViewController;

@end

