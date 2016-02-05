//
//  MessageDetailViewController.m
//  cs74cms
//
//  Created by lyp on 15/7/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "T_Interface.h"
#import "InitData.h"
#import "T_Pms.h"

@interface MessageDetailViewController (){
    int messageID;
    T_Pms *pms;
}

@end

@implementation MessageDetailViewController

- (void) setMessageId:(int) messageId{
    messageID = messageId;
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        pms = [[[T_Interface alloc] init] pmsDetailByUsername:user.username andUserpwd:user.userpwd andPMid:messageId];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self drawView];
        });
    });
}
- (void) drawView{
    UIFont  *font = [UIFont systemFontOfSize:14];
    CGSize size = [pms.message sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 34, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], size.height + 55)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    
    UILabel *mess = [[UILabel alloc] initWithFrame:CGRectMake(17, 20, size.width, size.height)];
    mess.backgroundColor = [UIColor clearColor];
    mess.font = font;
    mess.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    mess.attributedText = [InitData getMutableAttributedStringWithString:pms.message];
    mess.numberOfLines = 0;
    [view addSubview:mess];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 100, size.height + 25, 80, 14)];
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = [UIColor colorWithRed:105./255 green:105./255 blue:105./255 alpha:1];
    time.text = pms.dateline;
    [view addSubview:time];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewCanBeSee{

    [self.myNavigationController setTitle:MYLocalizedString(@"消息提醒", @"Message alert")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:MYLocalizedString(@"删除", @"Delete") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(cleanButClick) forControlEvents:UIControlEventTouchUpInside];
    NSArray *butArr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:butArr];
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}
- (void) cleanButClick{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];

        NSMutableArray * tarray = [[[T_Interface alloc] init] pmsByUsername:user.username andUserpwd:user.userpwd andStart:0 andRow:0 andPMid:pms.pmid];

        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (tarray != nil){
                [InitData netAlert:MYLocalizedString(@"删除成功", @"Delete success")];
                [self.myNavigationController dismissViewController];
            }
        }
    );
    });
}

@end
