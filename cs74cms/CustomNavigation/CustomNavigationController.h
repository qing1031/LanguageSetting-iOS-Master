//
//  CustomNavigationController.h
//  74cms
//
//  Created by LPY on 15-4-8.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarView.h"

@interface CustomNavigationController : UIViewController<NavigationBarViewDelegate>
{
    NavigationBarView *navBar;
    UIView *navBarView;
    NSMutableArray *controllers;
    UIView *showContentView;//表示正在展示的view
}

- (id) initWithRootViewController:(UIViewController*)rootView;

- (void) pushAndDisplayViewController: (UIViewController*) view;

- (void) dismissViewController;

- (void) setTitle:(NSString *)title;

- (void) setNavigationBarColor:(UIColor*) color;

- (void) setLeftBtn:(UIButton*) btn;

//子菜单点击事件
//- (void) subMenuClicked:(UIButton*) but;

@end
