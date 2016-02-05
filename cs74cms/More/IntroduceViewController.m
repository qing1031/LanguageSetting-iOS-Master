//
//  IntroduceViewController.m
//  74cms
//
//  Created by lyp on 15/4/29.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "IntroduceViewController.h"
#import "InitData.h"

@interface IntroduceViewController ()

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}

- (void) setIntroduce:(NSString*) str{
    if ([[self.view subviews] count] > 0){
        UILabel *label = [[self.view subviews] objectAtIndex:2];
        label.attributedText = [InitData getMutableAttributedStringWithString:str];
        
        CGSize size = [str sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height)];
    }
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle: MYLocalizedString(@"网站介绍", @"Web site introduction") ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) drawView{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [InitData Width] - 40, 15)];
    title.textColor = [UIColor orangeColor];//[UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
    title.font = [UIFont systemFontOfSize:15];
    title.text = MYLocalizedString(@"骑士人才系统", @"Knight talent system");
    [self.view addSubview:title];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 40, [InitData Width] - 30, 1)];
    [view setBackgroundColor:[UIColor colorWithRed:200./255 green:200./255 blue:200./255 alpha:1]];
    [self.view addSubview:view];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, [InitData Width] - 40, [InitData Height] - 50)];
    content.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    content.font = [UIFont systemFontOfSize:13];
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByCharWrapping;
    content.text = MYLocalizedString(@"太原迅易科技发展", @"Taiyuan Xun Yi science and technology development");
    [self.view addSubview:content];
}
@end
