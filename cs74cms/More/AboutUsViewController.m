//
//  AboutUsViewController.m
//  74cms
//
//  Created by lyp on 15/4/29.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "AboutUsViewController.h"
#import "InitData.h"
#import "IntroduceViewController.h"
#import "ITF_Other.h"
#import "GuideViewController.h"

@interface AboutUsViewController (){
    T_AboutUs *about;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        //不可从主线程取值
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            about = [[[ITF_Other alloc] init] aboutUsByActType:0];
            //T_AboutUs *tabout = [[[ITF_Other alloc] init] aboutUsByActType:1];
            about.version = [[NSUserDefaults standardUserDefaults] valueForKey:@"version"];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                if (about != nil)
                    [self drawView];
            });
        });
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"关于我们", @"About us") ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) drawView{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] / 2 - 30, 40, 60, 60)];
    [imgView setImage:[UIImage imageNamed:@"app_name.png"]];
    [self.view addSubview:imgView];
    
    UIColor *color = [UIColor colorWithRed:153./255 green:153./255 blue:153./255 alpha:1];
    UIFont *font = [UIFont systemFontOfSize:14];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, [InitData Width] - 60, 15)];
    label.textColor = color;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@%@", about.sitename, about.version];
    [self.view addSubview:label];
    
    float cellHeight = 40;
    float height = 160;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"欢迎页", @"Welcome page"),MYLocalizedString(@"网站介绍", @"Web site introduction"), MYLocalizedString(@"客服电话", @"Customer service telephone"), MYLocalizedString(@"官方网站", @"Official website"),  nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"", @"", about.tel, about.website, nil];
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    for (int i=0; i<[arr count]; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        view.tag = i + 1;
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(175, 0, 160, cellHeight)];
        label2.text = [arr2 objectAtIndex:i];
        label2.textColor = color2;
        label2.font = font1;
        [view addSubview:label2];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
        [view addSubview:img];
        
        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 170, 12, (cellHeight + 1) * 3)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 12, 170, 12, (cellHeight + 1) * 3)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
}
- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    long index = recognizer.view.tag - 1;
    switch (index) {
        case 0:{
            [self.myNavigationController pushAndDisplayViewController:[[GuideViewController alloc] init]];
            break;
        }
        case 1:{
            if (about.introduce == nil || [about.introduce isEqual:[NSNull null]])
                return;
            IntroduceViewController *intro = [[IntroduceViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:intro];
            [intro setIntroduce:about.introduce];
        }
            break;
        case 2:{
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@", about.tel]; //number为号码字符串
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        }
            break;
        case 3:{
             [ [ UIApplication sharedApplication ] openURL: [NSURL URLWithString: about.website]];
        }
            break;
            
        default:
            break;
    }
}

@end
