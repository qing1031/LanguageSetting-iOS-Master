//
//  WelcomeViewController.m
//  cs74cms
//
//  Created by lyp on 15/6/18.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "WelcomeViewController.h"
#import "InitData.h"
#import "ITF_Apply.h"
#import "DealCacheController.h"
#import "RootViewController.h"
#import "CustomNavigationController.h"

#define INTERVALE 5

@interface WelcomeViewController ()<UIScrollViewDelegate>{
    UIScrollView *mainView;
    NSTimer *timer;
    int currentPage;
    float height;
    
    int type;
}

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//这句话很关键，不加出线空白
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollview{
    height = [InitData AllHeight];
    
    mainView = [[UIScrollView alloc] init];
    [mainView setFrame:CGRectMake(0, 0, [InitData Width], height)];
    mainView.delegate = self;
    //  [mainView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:mainView];
    
    for (int i=0; i<3; i++){
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i + 1]];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] * i,0, [InitData Width], height)];
        [imgview setImage:img];
        [mainView addSubview:imgview];
    }
    
    [mainView setPagingEnabled:YES];
    [mainView setContentSize:CGSizeMake([InitData Width] * 3, height)];
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    
    UIButton *but =[UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake([InitData Width] * 2 + [InitData Width] / 640 * 80, height /1136 * 940, [InitData Width] / 640 * 480, height /1134 * 75)];
    [but addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:but];
    
     timer = [NSTimer scheduledTimerWithTimeInterval:INTERVALE target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}
- (void) ads{
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_Ads *ads = [[[ITF_Apply alloc] init] getAds];
        UIImage *img;
        if (ads != nil){
            NSData *data = [[[DealCacheController alloc] init] getImageData:ads.img_path];
            img = [UIImage imageWithData:data];
        }
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (ads != nil){
                [self addAds:img];
            }
            else
                [self nextPage];
        });
    });
}
- (void) addAds:(UIImage*) img{
    height = [InitData AllHeight];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], height)];
    [imgView setImage:img];
    [self.view addSubview:imgView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (void) settype:(int) ttype{
    type = ttype;
    if (ttype == 0){
        [self scrollview];
    }
    else{
        [self ads];
    }
}

- (void)runTimePage
{
    currentPage ++;
    if (currentPage >= 3){
        [self nextPage];
        return;
    }
    
    [self turnPage];
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = currentPage; // 获取当前的page
    [mainView scrollRectToVisible:CGRectMake([InitData Width]*page,0,[InitData Width],height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = sender.frame.size.width;
    int page = floor((mainView.contentOffset.x - pagewidth/3)/pagewidth)+1;
    page --;  // 默认从第二页开始
    currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = mainView.frame.size.width;
    int tcurrentPage = floor((mainView.contentOffset.x - pagewidth/ 3) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    
    if (tcurrentPage==0)
    {
        [mainView scrollRectToVisible:CGRectMake(0,0,[InitData Width],height) animated:NO]; // 序号0 最后1页
    }
    else if (tcurrentPage==3)
    {
        [self nextPage];
        [mainView scrollRectToVisible:CGRectMake([InitData Width] * 2,0,[InitData Width],height) animated:NO]; // 最后+1,循环第1页
    }
}

- (void) nextPage{
    [timer invalidate];
    timer = nil;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"welcome"] isEqualToString:@"1"] || type == 1){
        RootViewController *root = [[RootViewController alloc] init];
        CustomNavigationController*navigationController = [[CustomNavigationController alloc] initWithRootViewController:root];
        //[self.window setRootViewController:navigationController];
        
       // [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        [self.navigationController pushViewController:navigationController animated:YES];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"welcome"];
    }
}

@end
