//
//  CreateResumeViewController.m
//  74cms
//
//  Created by LPY on 15-4-14.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "ResumeCenterViewController.h"
#import "InitData.h"
#import "CreateResumeViewController.h"
#import "ResumeCenterView.h"
#import "CustomAlertView.h"
#import "ColloctionViewController.h"
#import "ShieldingViewController.h"
#import "Preview1ViewController.h"
#import "ChangeResumeViewController.h"
#import "../../CutImageViewController.h"
#import "T_Interface.h"

@interface ResumeCenterViewController ()<UIScrollViewDelegate, ResumeCenterViewDelegate,CustomAlertViewDelegate,cutImageDelegate>{
    NSMutableArray *array;//存放简历表
    
    UIScrollView *mainScrollView;
    UIPageControl *pageControl;
    
    UIButton *imgBut;
    
    int currentPage;//当前页
    
    //图片2进制路径
    NSString* filePath;
    
    int customSign;
}

@end

@implementation ResumeCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) mainView{
    
    if (array == nil || [array count] == 0){
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(([InitData Width] - 142) / 2, ([InitData Height] - 172 - 50) / 2, 142, 172)];
        [but setImage:[UIImage imageNamed:@"chuangjianjianli.jpg"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(createClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        UIColor *color = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0/255 alpha:1];
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, but.frame.size.height + but.frame.origin.y + 17, [InitData Width], 15)];
        label1.text = MYLocalizedString(@"您还没有简历", @"You don't have a resume.");
        label1.textColor = color;
        label1.font = [UIFont systemFontOfSize:13];
        label1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label1];

        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.frame.size.height + label1.frame.origin.y, [InitData Width], 15)];
        label2.text = MYLocalizedString(@"填写好简历，找到适合自己的工作", @"Fill out your resume and find a job that suits you.");
        label2.textColor = color;
        label2.font = label1.font;
        label2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label2];
        return;
    }
    
    currentPage = 0;
    [self addScrollView];
    [self addPageView];
    [self addResume];
    
}
- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    
    //获取数据
    T_User *user = [InitData getUser];
  //  if (array == nil){
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            NSMutableArray * tarray = [[[T_Interface alloc] init] personalResumeListByUsername:user.username andPassword:user.userpwd];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                if (tarray != nil ) {
                    if ([tarray count] > 0){
                        user.profile = YES;
                        [InitData setUser:user];
                    }
                    array  = tarray;
                    [self mainView];
                }
            });
        });
    //}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    array = nil;
    
   // if ([[self.view subviews] count] == 0)
    //    [self drawView];
}
- (void) viewCanBeSee{
 //   if ([[self.view subviews] count] == 0)
    array = nil;
    [self drawView];
    [self.myNavigationController setTitle:MYLocalizedString(@"简历中心", @"Resume Center")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:MYLocalizedString(@"创建", @"Create") forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:15];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    [but addTarget:self action:@selector(createClicked) forControlEvents:UIControlEventTouchUpInside];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}

- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
    
    UIView *sup = [self.view superview];
    sup.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --

- (void) updateResume{
    self.view.userInteractionEnabled = NO;
    UIView *sup = [self.view superview];
    sup.userInteractionEnabled = NO;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] / 2 - 75, ([InitData Height] - 30) / 2, 150, 40)];
    [view setBackgroundColor:[UIColor blackColor]];
    view.layer.cornerRadius = 3;
    [self.view addSubview:view];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity setCenter:CGPointMake(25, 20)];
    [view addSubview:activity];
    [activity startAnimating];
   
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 110, 40)];
    title.textColor = [UIColor whiteColor];
    title.text = MYLocalizedString(@"正在刷新简历...", @"Refreshing resume...");
    title.font = [UIFont systemFontOfSize:14];
    [view addSubview:title];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_Resume *res = [array objectAtIndex:currentPage];
        NSString *msg = [[[T_Interface alloc] init] resumeRefreshByUsername:user.username andUserpwd:user.userpwd andPid:res.ID];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (msg == nil){
                ResumeCenterView *resCenView = [[mainScrollView subviews] objectAtIndex:currentPage + 1];
                [resCenView setUpdateTime:[InitData stringFromDate:[NSDate date]]];
  
                [activity stopAnimating];
                [activity removeFromSuperview];
                [title setFrame:CGRectMake(20, 0, 56, 40)];
                title.text = MYLocalizedString(@"刷新简历", @"Refresh resume");
                [view setFrame:CGRectMake([InitData Width]/2 - 48 , view.frame.origin.y, 96, 40)];
                [UIView animateWithDuration:2 animations:^{
                     view.alpha = 0;
                    }completion:^(BOOL finished){
                   [title removeFromSuperview];
                   [view removeFromSuperview];
                }];
                self.view.userInteractionEnabled = YES;
                sup.userInteractionEnabled = YES;
            }
            else{
                [InitData netAlert:msg];
            }
           
        });
    });
}

- (void) addResume{
    NSString *title;
    
    //多添加首尾两个页面以实现无缝循环
    for (int i=0; i<=[array count] + 1; i++){
        int t = 0;
        if (i != [array count] + 1 && i != 0) {
            t = i - 1;
        }
        
        else if (i == 0){
            t = (int)array.count - 1;
            
        }
        else{
            t = 0;
        }
        title = [array objectAtIndex:t];
        ResumeCenterView *view = [[ResumeCenterView alloc] initWithFrame:CGRectMake([InitData Width] * i, 0, [InitData Width], [InitData Height])];
        view.delegate = self;
        T_ResumeList * res = [array objectAtIndex:t];
        [view setTitle:res.title];
        [view setCreatTime:res.addtime];
        [view setUpdateTime:res.refreshtime];
        [view setPrivacySetTitle:res.display == 1?MYLocalizedString(@"公开", @"Public"):MYLocalizedString(@"隐私", @"Privacy")];
        [view setHaveApply:[NSString stringWithFormat:@"%d", res.countapply]];
        [view setCareMe:[NSString stringWithFormat:@"%d", res.countattention]];
        [view setInvite:[NSString stringWithFormat:@"%d", res.countinterview]];
      //  if (res.display == 1){
            [view setPicture:res.photo_img];
         //   NSLog(@"%@", res.photo_img);
      //  }
        [mainScrollView addSubview:view];
    }
    
    [mainScrollView setContentOffset:CGPointMake(0, 0)];
    [mainScrollView scrollRectToVisible:CGRectMake([InitData Width], 0, [InitData Width], [InitData Height]) animated:NO];
    
}


- (void) addScrollView{
    if (mainScrollView != nil){
        [self distorySubview];
      //  [mainScrollView removeFromSuperview];
      //  mainScrollView = nil;
    }
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    
    mainScrollView.directionalLockEnabled = YES;
    mainScrollView.pagingEnabled = YES;//翻页效果
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    CGSize size = CGSizeMake([InitData Width] * ([array count] + 2), [InitData Height]);
    [mainScrollView setContentSize:size];
    [self.view addSubview:mainScrollView];
}
- (void) addPageView{
    float cellHeight = 15;
    float width = (cellHeight + 20) * [array count] - 20;
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([InitData Width] - width) / 2, [InitData Height] - 50, width, 20)];
    pageControl.numberOfPages = [array count];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
  //  [UIColor colorWithRed:96./255 green:118./255 blue:155./255 alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];//
    [pageControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
}

- (void) distorySubview{
    NSArray *tarray = [self.view subviews];
    for (UIView *view in tarray)
    {
        [view removeFromSuperview];
    }
    mainScrollView = nil;
}
#pragma mark delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = mainScrollView.frame.size.width;
    int page = floor((mainScrollView.contentOffset.x - pageWidth / ([array count] + 2)) /pageWidth) + 1;
    page --;
    pageControl.currentPage = page;
    currentPage = page;
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pagewidth = mainScrollView.frame.size.width;
    int currentPaget = floor((mainScrollView.contentOffset.x - pagewidth/ ([array count]+2)) / pagewidth) + 1;
    
    float width = mainScrollView.frame.size.width;
    float h = mainScrollView.frame.size.height;
    if (currentPaget == 0)
    {
        [mainScrollView scrollRectToVisible:CGRectMake(width * [array count],0,width,h) animated:NO]; // 序号0 最后1页
    }
    else if (currentPaget == ([array count] + 1))
    {
        [mainScrollView scrollRectToVisible:CGRectMake(width,0,width,h) animated:NO]; // 最后+1,循环第1页
    }
}

- (void) privacySet{
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    NSArray * arr = [NSArray arrayWithObjects:MYLocalizedString(@"公开", @"Public"), MYLocalizedString(@"保密", @"Secrecy"), nil];
    [alertView setDirection:Y andTitle:MYLocalizedString(@"隐私设置", @"Privacy settings") andMessage:nil andArray:arr];
    alertView.delegate = self;
    [self.view addSubview:alertView];
    customSign = 0;
}

- (void) change:(UIPageControl*) pageControl{
   // NSLog(@"%d", pageControl.se)
}

- (void) deleteResume:(int) index{
    if ([array count] == 1){
        [InitData netAlert:MYLocalizedString(@"只有一份简历， 不可删除！", @"Only one resume, can not be deleted!")];
        return;
    }
    
    CustomAlertView *alerView = [[CustomAlertView alloc] init];
    NSString *tishi = MYLocalizedString(@"确定要删除当前简历吗？", @"Are you sure you want to delete the current resume?");
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"确认", @"Confirm"), MYLocalizedString(@"取消", @"Cancle"), nil];
    [alerView setDirection:X andTitle:MYLocalizedString(@"消息确认", @"Message acknowledgement") andMessage:tishi andArray:arr];
    alerView.delegate = self;
    [self.view addSubview:alerView];
    customSign = 1;
}

- (void) deleteResumeFromData{
        [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_Resume *res = [array objectAtIndex:currentPage];
        BOOL ok = [[[T_Interface alloc] init] resumeDeleteByUsername:user.username andUserpwd:user.userpwd andPid:res.ID];
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (ok){
                [self deleteOk:currentPage];
            }

        });
    });
}
- (void) deleteOk:(int) index{
    if (currentPage == [array count] - 1)
        currentPage --;
        
    
    for (int i = (int)[[mainScrollView subviews] count] - 1; i> index; i--){
        UIView *view = [[mainScrollView subviews] objectAtIndex:i];
        [view setFrame:CGRectMake([InitData Width] * (i - 1), 0, [InitData Width], [InitData Height])];
    }
    UIView *view = [[mainScrollView subviews] objectAtIndex:index];
    [InitData distory:view];
    [array removeObjectAtIndex:index];
    [mainScrollView setContentSize:CGSizeMake([InitData Width] * ([array count] + 2), [InitData Height])];
    

    pageControl.currentPage = currentPage;
    pageControl.numberOfPages = [array count];

    if ([array count] == 0){
        [InitData distory:mainScrollView];
        [self drawView];
    }
}
- (void) butClicked:(int) index{
    T_ResumeList * resume = [array objectAtIndex:currentPage];
    switch (index) {
        case 0:
            if (array != nil && [array count] > index){

                ChangeResumeViewController *change = [[ChangeResumeViewController alloc] init];
                [InitData setPid:resume.ID];
                [self.myNavigationController pushAndDisplayViewController:change];
            }
            break;
        case 1:{
            Preview1ViewController *preview1 = [[Preview1ViewController alloc] init];
            [preview1 setPid:resume.ID];
            [self.myNavigationController pushAndDisplayViewController:preview1];
            [preview1 setTitle:resume.title];
        }
            break;
        case 2:
            [self updateResume];
            break;
        case 3:
            [self privacySet];
            break;
        case 4:{
            ShieldingViewController *shield = [[ShieldingViewController alloc] init];
            [shield setPid:resume.ID];
            [self.myNavigationController pushAndDisplayViewController:shield];
        }
            break;
        case 5:
            [self deleteResume:currentPage];
            break;
            
        default:
            break;
    }
}

- (void) haveApplyClicked{
    ColloctionViewController * next =[[ColloctionViewController alloc] init];
    T_Resume *res = [array objectAtIndex:currentPage];
    [next setType:0 andPid:res.ID];
    [self.myNavigationController pushAndDisplayViewController:next];
}

- (void) careMeClicked{
    ColloctionViewController * next =[[ColloctionViewController alloc] init];
    T_Resume *res = [array objectAtIndex:currentPage];
    [next setType:1 andPid:res.ID];
    [self.myNavigationController pushAndDisplayViewController:next];
}

- (void) inviteClicked{
    ColloctionViewController * next =[[ColloctionViewController alloc] init];
    T_Resume *res = [array objectAtIndex:currentPage];
    [next setType:2 andPid:res.ID];
    [self.myNavigationController pushAndDisplayViewController:next];
}

//自定义弹出框点击事件
- (void) customAlertViewbuttonClicked:(int)index{
    if (customSign == 0){
        [self displaySet:index];
        return;
    }
    switch (index) {
        case 0:{
            [self deleteResumeFromData];
            
        }
            break;
            
        default:
           // ((UIView*)[[tableView subviews] objectAtIndex:currentIndex]).tag = EDUARRTAG + currentIndex;
            break;
    }
    long cnt = [[self.view subviews] count];
    UIView *view =(UIView*)[[self.view subviews] objectAtIndex:cnt - 1];
    if ([view isKindOfClass:[CustomAlertView class]])
         [InitData distory:view];
}
- (void) displaySet:(int)index{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_Resume *res = [array objectAtIndex:currentPage];
        int t = [[[T_Interface alloc] init] resumeSetDisplayByUsername:user.username andUserpwd:user.userpwd andPid:res.ID andDisplay:index + 1];
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (t > 0){
                ResumeCenterView *tmp = (ResumeCenterView*)[[mainScrollView subviews] objectAtIndex:currentPage + 1];
                switch (index) {
                    case 0:
                        [tmp setPrivacySetTitle:MYLocalizedString(@"公开", @"Public")];
                        break;
            
                    default:
                        [tmp setPrivacySetTitle:MYLocalizedString(@"保密", @"Secrecy")];
                        break;
                }

                }
        });
    });
    return;
}


#pragma mark - event
- (void) createClicked{
    if ([array count] >= 3){
        [InitData netAlert:MYLocalizedString(@"最多可以创建3份简历！", @"Can create up to 3 resumes!")];
        return;
    }
    //if (array == nil || [array count] == 0)
    [self.myNavigationController pushAndDisplayViewController:[[CreateResumeViewController alloc] init]];
   /* else{
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            T_User *user = [InitData getUser];
            T_Resume *resume = [array objectAtIndex:0];
            //后台代码
            int pid = [[[T_Interface alloc] init] createUsername:user.username andUserPwd:user.userpwd andResume:resume];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                if (pid > 0){
                    [InitData setPid:pid];
                    [self.myNavigationController pushAndDisplayViewController:[[ChangeResumeViewController alloc] init]];
                }
            });
        });

    }*/
}

- (void) getPicture:(UIButton*) but{
    CutImageViewController *cut = [[CutImageViewController alloc] init];
    [cut getPicture];
    cut.delegate = self;
    [self.myNavigationController pushAndDisplayViewController:cut];
    imgBut = but;
}


#pragma mark delegate
- (void) getCutImage:(UIImage *)img{
    if (img == nil)
        return;
   // CGSize size = [InitData calculateImageSize:imgBut.frame.size imageSize:img.size priorDirection:Y];
   // [imgBut setFrame:CGRectMake(([InitData Width] - size.width) / 2, imgBut.frame.origin.y, size.width, size.height)];

    
    
    //传值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_ResumeList *resume = [array objectAtIndex:currentPage];
        BOOL res = [[[T_Interface alloc] init] personalPhotoByUsername:user.username andUserpwd:user.userpwd andPid:resume.ID andUploadefile:img];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (res){
                [imgBut setImage:img forState:UIControlStateNormal];
                //[InitData netAlert:str];
            }
            
        });
    });
    
}
@end
