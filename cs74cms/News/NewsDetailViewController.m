//
//  NewsDetailViewController.m
//  74cms
//
//  Created by lyp on 15/5/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "InitData.h"
#import "ITF_Other.h"

@interface NewsDetailViewController ()<UIWebViewDelegate>{
    int newID;
    T_News *news;
}

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void) viewCanBeSee{

    [self.myNavigationController setTitle: MYLocalizedString(@"资讯详情", @"Information details") ];
    
   /* UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 20, 20)];
    but.selected = NO;
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];*/
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    webView.delegate = self;
    [self.view addSubview:webView];
   
    
   // webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    NSURL *url;
   // if (newID == 3)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?mact=news_show&&phonekey=123456&&id=%d",[InitData Path], newID]];
   // else
   //     url = [NSURL URLWithString:@"http://www.cnblogs.com/zhuqil/archive/2011/07/28/2119923.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
 
   /* [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 5.0;"];
    NSString *js_fit_code = [NSString stringWithFormat:@"var meta = document.createElement('meta');"
                             "meta.name = 'viewport';"
                             "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes';"
                             "document.getElementsByTagName('head')[0].appendChild(meta);"];
    [webView stringByEvaluatingJavaScriptFromString:js_fit_code];*/
    webView.scalesPageToFit = YES; //yes:根据webview自适应，NO：根据内容自适应
    /*
    NSArray *subViews = webView.subviews;
    for (UIView* subView in subViews){
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView*)subView).showsVerticalScrollIndicator = NO;
            ((UIScrollView*)subView).showsHorizontalScrollIndicator = NO;
            [((UIScrollView*)subView) setContentSize:CGSizeMake( [InitData Width], [InitData Height])];
            [((UIScrollView*)subView) setBounces:NO];
        }
    }*/
}
/*
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //make sure that the page scales when it is loaded :-)
    //theWebView.scalesPageToFit = YES;
    [theWebView setScalesPageToFit:YES];
    return YES;
}

//webview委托   高度自适应
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    
   // CGSize newsize=CGSizeMake(320, 356+webView.frame.size.height);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setNewsID:(int) tnewID{
    newID = tnewID;
}

/*
- (void) drawView{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [InitData Width] - 40, 15)];
    title.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    title.font = [UIFont systemFontOfSize:15];
    title.text =[NSString stringWithFormat: @"[%@]%@", news.type, news.title];
    [self.view addSubview:title];
    

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 43, 18, 18)];
    [imgView setImage:[UIImage imageNamed:@"watch.png"]];
    [self.view addSubview:imgView];
    
    UILabel *updateTime = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, 140, 15)];
    updateTime.text = news.addtime;
    updateTime.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    updateTime.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:updateTime];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 46, 25, 12)];
    [imgView2 setImage:[UIImage imageNamed:@"eye.png"]];
    [self.view addSubview:imgView2];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(195, 45, 100, 15)];
    time.text = [NSString stringWithFormat:@"浏览%d次",news.click];
    time.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    time.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:time];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, 70, [InitData Width] - 30, 1)];
    sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [self.view addSubview:sep];
    
    float height = 70;
    
    if (news.small_img != nil){
    UIImageView *insertView = [[UIImageView alloc] initWithFrame:CGRectMake(20, height+10, [InitData Width] - 40, 140)];
    [insertView setImage:[UIImage imageNamed:@"detail.png"]];
    [self.view addSubview:insertView];
        height += 140;
    }
    height += 10;
    
    UITextView *mainText = [[UITextView alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, [InitData Height] - height)];
    mainText.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    mainText.font = [UIFont systemFontOfSize:14];
    mainText.text = news.content;//@"\t如果你作为iOS开发者已经有一段时间，可能会有一套属于自己的类和工具函数，它们在你的大多数项目中被重用。\n\t重用代码的最简单方法是简单的 拷贝/粘贴 源文件。然而，这种方法很快就会成为维护时的噩梦。因为每个app都有自己的一份代码副本,你很难在修复bug或者升级时保证所有副本的同步。\n\t 这就是静态库要拯救你的。一个静态库是若干个类,函数,定义和资源的包装，你可以将其打包并很容易的在项目之间共享。\n\t在本教程中，你将用两种方法亲手创建你自己的通用静态库。\n\t如果你作为iOS开发者已经有一段时间，可能会有一套属于自己的类和工具函数，它们在你的大多数项目中被重用。\n\t重用代码的最简单方法是简单的 拷贝/粘贴 源文件。然而，这种方法很快就会成为维护时的噩梦。因为每个app都有自己的一份代码副本,你很难在修复bug或者升级时保证所有副本的同步。\n\t 这就是静态库要拯救你的。一个静态库是若干个类,函数,定义和资源的包装，你可以将其打包并很容易的在项目之间共享。\n\t在本教程中，你将用两种方法亲手创建你自己的通用静态库。";
    mainText.editable = NO;
    mainText.textAlignment = NSTextAlignmentJustified;
    mainText.showsVerticalScrollIndicator = NO;
    mainText.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:mainText];
}
*/

@end
