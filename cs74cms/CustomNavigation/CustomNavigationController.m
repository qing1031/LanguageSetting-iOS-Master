//
//  CustomNavigationController.m
//  74cms
//
//  Created by LPY on 15-4-8.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "CustomNavigationController.h"
#import "InitData.h"
#import "SuperViewController.h"

#import "LoginViewController.h"

@interface CustomNavigationController ()<SuperViewControllerDelegate>{
    
    NSCondition *condition;
    
    UIView *controllView;
    
    UIButton *returnBut;
}

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithRootViewController:(UIViewController*)rootView{
    self = [super init];
    if (self){
        //由于子菜单的出现有动画，需要一个线程控制器
        condition = [[NSCondition alloc] init];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        showContentView = [[UIView alloc] init];//[[UIViewController alloc] init].view;
        //由于在视图控制器中的 view 会把状态栏的一条空出来， 所以需要把 内容view 的框架向上定义一个状态栏高度,在高度中所以要加一个状态栏的高度
        [showContentView setFrame:CGRectMake(0, [InitData NavControllerHeight] - [InitData StateBarHeight], [InitData Width], [InitData AllHeight])];//allHeight[InitData Height] + [InitData StateBarHeight]

        [self.view addSubview:showContentView];
        [showContentView setBackgroundColor:[UIColor whiteColor]];
        
        navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData NavControllerHeight])];
        navBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color.jpg"]];
        [self.view addSubview:navBarView];
        navBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, navBarView.frame.size.height - [InitData NavBarHight], [InitData Width], [InitData NavBarHight])];
        [navBar setDelegate:self];
        [navBarView addSubview:navBar];
       // [navBar setTitle:@"ddddd"];
        
        returnBut = [ UIButton buttonWithType:UIButtonTypeCustom];
        [returnBut setImage:[UIImage imageNamed:@"returnBut.png"] forState:UIControlStateNormal];
        [returnBut setFrame:CGRectMake(10, ([InitData NavBarHight] - 40) / 2, 40, 40)];
        [returnBut addTarget:self action:@selector(returnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:returnBut];
        returnBut.hidden = YES;
        
        if (controllers == nil){
            controllers = [[NSMutableArray alloc] init];
        }
        
        [self pushAndDisplayViewController:rootView];
    }
    return self;
}
- (void) setNavigaionBarHidden:(BOOL) hidden{
    if (hidden){
        [showContentView setFrame:CGRectMake(0, 0, [InitData Width], [InitData AllHeight])];//allHeight
        
        [navBarView setFrame:CGRectMake(0, -[InitData NavControllerHeight], [InitData Width], [InitData NavControllerHeight])];
        return;
    }
    [showContentView setFrame:CGRectMake(0, [InitData NavControllerHeight] - [InitData StateBarHeight], [InitData Width], [InitData Height] + [InitData StateBarHeight])];//allHeight

    [navBarView setFrame:CGRectMake(0, 0, [InitData Width], [InitData NavControllerHeight])];
}

- (void) setRightBtn:(NSArray*) btnArray{
    [navBar setRightBtn:btnArray];
}

- (void) setTitle:(NSString *)title{
    [navBar setTitle:title];
}

- (void) setNavigationBarColor:(UIColor*) color
{
    [navBar setBackgroundColor:color];
    [navBarView setBackgroundColor:color];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(relogin) name:@"relogin" object:nil];
}


- (void) relogin{
    
    dispatch_async(dispatch_get_main_queue(), ^{//保证线程安全
        
        [self popToRootViewController];
        [self pushAndDisplayViewController:[[LoginViewController alloc] init]];
        
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) displayViewAtIndex:(NSUInteger)index{
    if ([controllers count] > 1)
        returnBut.hidden = NO;
    
    UIViewController* viewController = (UIViewController*)[controllers objectAtIndex:index];
    
    if([viewController.view isDescendantOfView:showContentView]){
        [showContentView bringSubviewToFront:viewController.view];
       // [self viewCanBeSee];//主要用于在页面中隐藏标签栏
    }
    else{
        [showContentView addSubview:viewController.view];
      //  [self viewCanBeSee];//主要用于在页面中隐藏标签栏
    }
    if (viewController.title != nil){
        [self setTitle:viewController.title];
    }
}

#pragma mark - SuperViewControllerDelegate
- (void) dismissViewController{
    if ([controllers count] <= 1)
        return;
    if ([controllers count] == 2){
        returnBut.hidden = YES;
    }
    
    [self viewCannotBeSee];
    
    NSArray *arr = [showContentView subviews];
   // [[arr objectAtIndex:[arr count] - 1] removeFromSuperview];
    [[arr lastObject] removeFromSuperview];
   // arr = [showContentView subviews];

    [controllers removeObjectAtIndex:[controllers count] - 1];
    
    [self viewCanBeSee];
    
    //[self displayViewAtIndex:[controllers count] - 1];//这句没必要
}
- (void) popAndPushViewController:(UIViewController*) viewController{
    [self viewCannotBeSee];
    
    [[[showContentView subviews] objectAtIndex:[[showContentView subviews] count] - 1] removeFromSuperview];
    [controllers removeObjectAtIndex:[controllers count] - 1];
    
    //不必下面的方法释放，原因：父视图负责释放子视图
   /* UIView *view =[[showContentView subviews] objectAtIndex:[[showContentView subviews] count] - 1];
    [InitData distory:view];
   */
    
    //[self pushAndDisplayViewController:viewController];
    [controllers addObject:viewController];
    if ([viewController isKindOfClass:[SuperViewController class]]){//是否为 SuperViewController 类及其子类的对象
        ((SuperViewController*)viewController).myNavigationController = self;//为了在试图控制器中可以调用这个类的的方法
        //[self viewCanBeSee];//主要用于在页面中隐藏标签栏
    }
    [self displayViewAtIndex:[controllers count] - 1];
    
    [self viewCanBeSee];
}

- (void) pushAndDisplayViewController: (UIViewController*) view{
    if ([controllers count] >= 1){
        
        if ([view class] == [[controllers objectAtIndex:[controllers count] - 1] class]){
            return;
        }
        //[self nextViewController];
    
        [self viewCannotBeSee];
        
        returnBut.hidden = NO;
    }
    
    
    [controllers addObject:view];
    
    
    if ([view isKindOfClass:[SuperViewController class]]){//是否为 SuperViewController 类及其子类的对象
        ((SuperViewController*)view).myNavigationController = self;//为了在试图控制器中可以调用这个类的的方法
        //[self viewCanBeSee];//主要用于在页面中隐藏标签栏
    }
    
    [self displayViewAtIndex:[controllers count] - 1];
    
    [self viewCanBeSee];
}
- (void) popToRootViewController{
    while ([controllers count] > 1) {
     //   UIViewController *viewControl = [controllers objectAtIndex:[controllers count] - 1];
      //  if ([viewControl isKindOfClass:[ClientSampleViewController class]]){
      ////      [(ClientSampleViewController*)viewControl viewCannotBeSee];
      //  }
        [controllers removeLastObject];
        
      //  内存泄漏
        [[[showContentView subviews] objectAtIndex:[[showContentView subviews] count] - 1] removeFromSuperview];
        
       // UIView *view =[[showContentView subviews] objectAtIndex:[[showContentView subviews] count] - 1];
      //  [InitData distory:view];
    }
    //[self displayViewAtIndex:0];
}
- (void) popViewControllers:(int) num{
    while ([controllers count] > 1 && num > 0) {
        [self viewCannotBeSee];

        //  内存泄漏
        if ([[showContentView subviews] count] > 0){
            //int t = [[showContentView subviews] count];
            [[[showContentView subviews] objectAtIndex:[[showContentView subviews] count] - 1] removeFromSuperview];
        }
        
        [controllers removeLastObject];
        num --;
    }
    [self displayViewAtIndex:[controllers count] - 1];
    
    [self viewCanBeSee];
}


- (NSArray *) getRightBtn{
    return  [navBar getRightBtn];
}

#pragma mark - NavigationBarViewDelegate
- (void) returnButtonClicked{
    
    if ([controllers count] > 1){
        
        //[self viewCannotBeSee];
        
       // NSLog(@"有%d个页面", [[showContentView subviews] count]);
       // NSLog(@"栈中有%d个控制器", [controllers count]);
        [self dismissViewController];
        
    }
}

- (void)viewCanBeSee{
    UIViewController * viewController = [controllers objectAtIndex:[controllers count] - 1];
    if ([viewController isKindOfClass:[SuperViewController class]]) {
        [(SuperViewController*)viewController viewCanBeSee];
    }
}

- (void)viewCannotBeSee{
    UIViewController * viewController = [controllers objectAtIndex:[controllers count] - 1];
    if ([viewController isKindOfClass:[SuperViewController class]]) {
        [(SuperViewController*)viewController viewCannotBeSee];
    }
}

- (void) nextViewController{
    UIViewController * viewController = [controllers objectAtIndex:[controllers count] - 1];
    if ([viewController isKindOfClass:[SuperViewController class]]) {
        [(SuperViewController*)viewController nextViewController];
    }
}

- (void) distoryNavigation{
    for (int i=(int)[controllers count] - 1; i>=0; i--){
        [self viewCannotBeSee];
    }
    controllers = nil;
    navBar = nil;
    navBarView = nil;
    showContentView = nil;
    controllView = nil;
    [InitData distory:self.view];
}
/*
#pragma mark --
- (void) drawSubMenu{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.tag = 999;
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [showContentView addSubview:view];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distorySubMenu)];
    recognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:recognizer];
    
    
    UIView *subMenu = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 160, 0, 160, self.view.frame.size.height)];
    [subMenu setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:subMenu];
    
    NSArray *arr = [NSArray arrayWithObjects:@"新闻分类", @"职业指导", @"简历指南", @"面试宝典", @"职场八卦", @"劳动法苑", @"职场观察", nil];
    float height = 14;
    for (int i=0; i<[arr count]; i++){
        UIView *viewt = [[UIView alloc] initWithFrame:CGRectMake(0, height, 160, 45)];
        [viewt setBackgroundColor:[UIColor whiteColor]];
        [subMenu addSubview:viewt];
        viewt.tag = i + 1;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [viewt addGestureRecognizer:recognizer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,  14, 130, 15)];
        label.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        if (i == 0){
            label.font = [UIFont systemFontOfSize:16];
        }
        label.text = [arr objectAtIndex:i];
        [viewt addSubview:label];
        
        float x = i==[arr count] - 1?0:15;
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(x, 44, 160, 1)];
        [sep setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
        [viewt addSubview:sep];
        height += 45;
    }
};
- (void) subMenuClicked:(UIButton*) but{
    NSLog(@"%d", but.selected);
    if (but.selected == NO){
        [self drawSubMenu];
    }
    else{
        long t = [[showContentView subviews] count];
        UIView *view =[[showContentView subviews] objectAtIndex:t - 1];
        if (view.tag == 999){
            [InitData distory:view];
        }
    }
    but.selected = !but.selected;
}
- (void) distorySubMenu{
    long t = [[showContentView subviews] count];
    UIView *view =[[showContentView subviews] objectAtIndex:t - 1];
    if (view.tag == 999){
        [InitData distory:view];
    }
    NSArray *arr = [navBar getRightBtn];
    if ([arr count] > 0){
        UIButton *but = [arr objectAtIndex:0];
        but.selected = !but.selected;
    }
}
- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    [self distorySubMenu];
    
    long index = recognizer.view.tag - 1;
    switch (index) {
        case 1:
            [self pushAndDisplayViewController:[[GuideViewController alloc] init]
             ];
            break;
            
        default:
            break;
    }

}*/


@end
