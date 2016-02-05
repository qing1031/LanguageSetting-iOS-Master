//
//  MoreCenterViewController.m
//  74cms
//
//  Created by lyp on 15/4/29.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MoreCenterViewController.h"
#import "InitData.h"
#import "SkinViewController.h"
#import "FeekbackViewController.h"
#import "AboutUsViewController.h"
#import "PushSetViewController.h"
#import "ShakeViewController.h"
#import "DealCacheController.h"
#import "ITF_Other.h"


@interface MoreCenterViewController (){
    UILabel *cache;
    
    NSString *newVersion;
}

@end

@implementation MoreCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"更多", @"More")];
    [self.myNavigationController setRightBtn:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void) getVersion:(UIView*) view{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:@"version"];
        newVersion = [[[ITF_Other alloc] init] upgrade:version];
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 140, 0, 100, 40)];
            label.textColor = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentRight;
            [view addSubview:label];
            
            if (newVersion != nil){

                label.text= @"有新版本可用";
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 150, 5, 30, 30)];
                imgView.image = [UIImage imageNamed:@"version.png"];
                [view addSubview:imgView];
            }
            else{
                label.text = @"当前是最新版本";
            }
        });
    });
}*/
- (void) drawView{
    float cellHeight = 40;
    float height = 0;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"摇一摇", @"Shake "), MYLocalizedString(@"推送设置", @"Push setting"), MYLocalizedString(@"更换皮肤", @"Change skin"), MYLocalizedString(@"清除缓存", @"Clear cache"), MYLocalizedString(@"用户反馈", @"More"), MYLocalizedString(@"关于我们", @"About us"), nil];
    //, @"当前版本"
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];

    for (int i=0; i<[arr count]; i++){
        if (i == 4){
            height += 6;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        
        if (i == 3){
            cache = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 140, (40 - 15) / 2, 100, 15)];
            cache.textColor = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
            cache.font = [UIFont systemFontOfSize:13];
            cache.textAlignment = NSTextAlignmentRight;
            [view addSubview:cache];
            [self getMemory];
        }
     /*   else if (i == 4){
            [self getVersion:view];
        }*/
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 35, (cellHeight - 30) / 2, 20, 30)];
        [view addSubview:img];

        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 15, (cellHeight + 1) * 3)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, 30, 15, (cellHeight + 1) * 3)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, (cellHeight + 1) * 5, 15, cellHeight)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, (cellHeight + 1) * 5, 15, cellHeight)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view4];
    
  /*  UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"quit.png"] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"quit_Click.png"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(quitClicked) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake([InitData Width] / 2 - 150, height + 10, 300, 35)];
    [self.view addSubview:but];*/
}

#pragma mark  event
- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    long index = recognizer.view.tag - 1;
    switch (index) {
        case 0:
            [self.myNavigationController pushAndDisplayViewController:[[ShakeViewController alloc] init]];
            break;
        case 1:
            [self.myNavigationController pushAndDisplayViewController:[[PushSetViewController alloc] init] ];
            break;
        case 2:
            [self.myNavigationController pushAndDisplayViewController:[[SkinViewController alloc] init]];
            break;
        case 3:
            [self deleteMemory];
            [self getMemory];
            break;
        case 4:/*
            if (newVersion != nil && newVersion.length > 3){
                NSURL* requestUrl = [[NSURL alloc] initWithString:newVersion];
                [[UIApplication sharedApplication] openURL:requestUrl];
            }
       
          break;
        case 5: */
            [self.myNavigationController pushAndDisplayViewController:[[FeekbackViewController alloc] init]];
            break;
        default:
            [self.myNavigationController pushAndDisplayViewController:[[AboutUsViewController alloc] init]];
            break;
    }
}


//缓存操作
- (void) getMemory{
    //不可从主线程取值

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        float ff = [[[DealCacheController alloc] init] getCacheLengh];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            cache.text = [NSString stringWithFormat:@"%.2lfKB", ff];

        });
    });
    return ;
}
- (void) deleteMemory{
    [[[DealCacheController alloc] init] cleanCache];
    [InitData netAlert: MYLocalizedString(@"缓存清理成功！", @"cache cleanup success!")];
}
@end
