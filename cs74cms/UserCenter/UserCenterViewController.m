//
//  UserCenterViewController.m
//  74cms
//
//  Created by LPY on 15-4-10.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "UserCenterViewController.h"
#import "InitData.h"
#import "ChangePasswordViewController.h"
#import "AuthenticationViewController.h"
#import "InfoViewController.h"
#import "MessageViewController.h"
#import "ColloctionViewController.h"
#import "ResumeCenterViewController.h"
#import "CustomAlertView.h"
#import "CutImageViewController.h"
#import "T_Interface.h"
#import "DealCacheController.h"
#import "CreateResumeViewController.h"

#define TAGBEGIN 200

@interface UserCenterViewController ()<cutImageDelegate>{
    int number;
    
    UIButton *imgBut;
    
    UILabel *authenLabel;//认证状态
    UILabel *numberLabel;//消息提醒
    UILabel *collectLabel;
}

@end

@implementation UserCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) drawView
{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.myNavigationController setTitle:MYLocalizedString(@"会员中心", @"Member Center")];
    
    
    UIImageView *topView = [[UIImageView alloc] init];
    topView.userInteractionEnabled = YES;
    UIImage *img = [UIImage imageNamed:@"background.png"];
    CGSize size = [InitData calculateImageSize:CGSizeMake([InitData Width], [InitData Height]) imageSize:img.size priorDirection:X];
    [topView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [topView setImage:img];
    [self.view addSubview:topView];
    
    float height = 166 / 2;
    imgBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBut setFrame:CGRectMake([InitData Width] / 2 - height / 2,(size.height - height ) / 2 - 5, height, height)];
    [imgBut setBackgroundImage:[UIImage imageNamed:@"center_person.png"] forState:UIControlStateNormal];
    [imgBut addTarget:self action:@selector(getPicture:) forControlEvents:UIControlEventTouchUpInside];
    imgBut.layer.cornerRadius = height / 2;
    imgBut.layer.masksToBounds = YES;
  //  [imgBut setBackgroundColor:[UIColor redColor]];
    imgBut.layer.borderColor = [UIColor whiteColor].CGColor;
    imgBut.layer.borderWidth = 2;
    imgBut.clipsToBounds = YES;
    [topView addSubview:imgBut];
    [self downLoadPic];
    
    T_User *user = [InitData getUser];
    UILabel *userName = [[UILabel alloc] init];
    userName.text = user.username;
    userName.backgroundColor = [UIColor clearColor];
    userName.layer.backgroundColor =[UIColor whiteColor].CGColor;
    [userName setFrame:CGRectMake(10,(size.height - height ) / 2 + height, [InitData Width] - 20, 20)];
    userName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userName];
    
    
    float top = size.height;
    float cellHeight = ([InitData Height] - top - 25 - 7) / 7 ;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, top -1, [InitData Width],[InitData Height] - top)];
    [bgView setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    [self.view addSubview:bgView];
    NSArray * name = [NSArray arrayWithObjects:MYLocalizedString(@"个人信息", @"Personal information"), MYLocalizedString(@"简历中心", @"Resume center"), MYLocalizedString(@"我的收藏", @"My collection"), MYLocalizedString(@"消息提醒", @"Message alert"), MYLocalizedString(@"手机认证", @"Mobile phone authentication"), MYLocalizedString(@"修改密码", @"Modify password"), MYLocalizedString(@"退出登录", @"Exit login"), nil];
    float s1 = 0, e1 = 0 , s2 = 0, e2 = 0;
    for (int i=0; i<7; i++){
        float y = (i + 1)/5 * 10 + (i + 1) % 5 + cellHeight * i;
        switch (i) {
            case 0:
                s1 = y-1;break;
            case 3:
                e1 = y + cellHeight;break;
            case 4:
                s2 = y;break;
            case 6:
                e2 = y + cellHeight;break;
            default:
                break;
        }
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(3, y, [InitData Width] - 6, cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = TAGBEGIN + i;
        [bgView addSubview:view];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, [InitData Width] / 2, cellHeight - 10)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 355 alpha:1];
        nameLabel.text = name[i];
        [view addSubview:nameLabel];
        if (i==2){
            collectLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 40, cellHeight / 3 - 2, 0, cellHeight / 3 + 5)];
            collectLabel.text = [NSString stringWithFormat:@"%d", user.pms_num];
            collectLabel.textColor = [UIColor whiteColor];
            collectLabel.layer.cornerRadius = 7;
            collectLabel.layer.masksToBounds = YES;
            collectLabel.textAlignment = NSTextAlignmentCenter;
            collectLabel.layer.borderColor = [[UIColor colorWithRed:236.0 / 255 green:72.0 / 255 blue:72.0 / 255 alpha:1] CGColor];
            collectLabel.layer.borderWidth = 1;
            [collectLabel setBackgroundColor:[UIColor colorWithRed:236.0 / 255 green:72.0 / 255 blue:72.0 / 255 alpha:1]];
            [view addSubview:collectLabel];
        }
        if (i == 3){
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 40, cellHeight / 3 - 2, 0, cellHeight / 3 + 5)];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.layer.cornerRadius = 7;
            numberLabel.layer.masksToBounds = YES;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.layer.borderColor = [[UIColor colorWithRed:236.0 / 255 green:72.0 / 255 blue:72.0 / 255 alpha:1] CGColor];
            numberLabel.layer.borderWidth = 1;
            [numberLabel setBackgroundColor:[UIColor colorWithRed:236.0 / 255 green:72.0 / 255 blue:72.0 / 255 alpha:1]];
            [view addSubview:numberLabel];
        }
        if (i == 4){
            authenLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 130 - 40, 0, 130, view.frame.size.height)];
            authenLabel.textColor = [UIColor colorWithRed:228.0 / 255 green:48.0 / 255 blue:56.0 / 355 alpha:1];
            authenLabel.font = [UIFont systemFontOfSize:14];
            authenLabel.textAlignment = NSTextAlignmentRight;
            authenLabel.text = @"";
            [view addSubview:authenLabel];
            
        }
        
        UIImageView *goView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 40, (cellHeight - 25) / 2, 20, 25)];
        goView.image = [UIImage imageNamed:@"go.png"];
        [view addSubview:goView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
    }
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, s1, 7, e1 - s1)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 7, s1, 7, e1 - s1)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, s2, 7, e2 - s2)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 7, s2, 7, e2 - s2)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view4];
}

- (void) viewCanBeSee{
 //   [self.myNavigationController setNavigationBarColor:[UIColor colorWithRed:63.0 / 225 green:149.0 / 255 blue:224.0 / 255 alpha:1]];
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }

    [self getUserInf];

    [self.myNavigationController setTitle:MYLocalizedString(@"会员中心", @"Member Center")];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    number = 2;
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getUserInf{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user =[InitData getUser];
        T_UserCenter *data = [[[T_Interface alloc] init] getUserCenterInfByUser:user];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (data.profile == 0){
                [self.myNavigationController popAndPushViewController:[[CreateResumeViewController alloc] init]];
                return ;
            }
            if (data.mobileAudit == 0 || data == nil){
                authenLabel.textColor = [UIColor colorWithRed:228.0 / 255 green:48.0 / 255 blue:56.0 / 355 alpha:1];
                authenLabel.text = MYLocalizedString(@"未认证手机", @"Not certified mobile phone");
            }
            else{
                authenLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 355 alpha:1];
                authenLabel.text = MYLocalizedString(@"手机已认证", @"Mobile phone has been certified");
            }
            
            if (data.favNum > 0){
                NSString *str = [NSString stringWithFormat:@"%d", data.favNum];
                CGSize size = [str sizeWithFont:collectLabel.font constrainedToSize:CGSizeMake(100, 25)];
                [collectLabel setFrame:CGRectMake([InitData Width] - 40 - size.width - 15, collectLabel.frame.origin.y, size.width + 15, collectLabel.frame.size.height)];
                collectLabel.text =str;
            }
            else{
                [collectLabel setFrame:CGRectMake([InitData Width] - 40, collectLabel.frame.origin.y, 0, collectLabel.frame.size.height)];
            }
            
            if (data.pmsNum > 0){
                NSString *str = [NSString stringWithFormat:@"%d", data.pmsNum];
                CGSize size = [str sizeWithFont:numberLabel.font constrainedToSize:CGSizeMake(100, 25)];
                [numberLabel setFrame:CGRectMake([InitData Width] - 40 - size.width - 15 ,numberLabel.frame.origin.y, size.width + 15, numberLabel.frame.size.height)];
                numberLabel.text =str;
            }
            else{
                [numberLabel setFrame:CGRectMake([InitData Width] - 40 ,numberLabel.frame.origin.y, 0, numberLabel.frame.size.height)];
            }

        });
    });
}


#pragma mark event

- (void) downLoadPic{
    //不可从主线程取值

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSString *str = [InitData getUser].photo_img;
        NSData *data;
        if (str != nil)
            data = [[[DealCacheController alloc] init] getImageData:str];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (str != nil && data != nil){
                
                UIImage *img = [UIImage imageWithData:data];
               // CGSize size = [InitData calculateImageSize:imgBut.frame.size imageSize:img.size priorDirection:Y];
                //[imgBut setFrame:CGRectMake(([InitData Width] - size.width) / 2, imgBut.frame.origin.y, size.width, size.height)];
                [imgBut setBackgroundImage:img forState:UIControlStateNormal];
               // imgBut.layer.cornerRadius = imgBut.frame.size.width / 2;
               // imgBut.layer.masksToBounds = YES;
            }
        });
    });
}

- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    //NSLog(@"%s :  %d", __func__, recognizer.view.tag);
    if (self.myNavigationController == nil)
        return;

    switch (recognizer.view.tag) {
        case TAGBEGIN:
            [self.myNavigationController pushAndDisplayViewController:[[InfoViewController alloc] init] ];
            break;
        case TAGBEGIN + 1:
            [self.myNavigationController pushAndDisplayViewController:[[ResumeCenterViewController alloc] init]];
            break;
        case TAGBEGIN + 2:{
            ColloctionViewController *colle = [[ColloctionViewController alloc] init];
            [colle setType:3 andPid:0];
            [self.myNavigationController pushAndDisplayViewController: colle];
        }
            break;
        case TAGBEGIN + 3:
           [self.myNavigationController pushAndDisplayViewController:[[MessageViewController alloc] init] ];
            break;
        case TAGBEGIN + 4:
            [self.myNavigationController pushAndDisplayViewController:[[AuthenticationViewController alloc] init] ];
            break;
        case TAGBEGIN + 5:
            [self.myNavigationController pushAndDisplayViewController:[[ChangePasswordViewController alloc] init] ];
            break;
        case TAGBEGIN + 6:{//退出登录
            T_User *user = [InitData getUser];
            if ([[[T_Interface alloc] init] loginOutByUsername:user.username andPassword:user.userpwd]) {
                [InitData setUser:nil];
                [self.myNavigationController dismissViewController];
            }
        }
            break;
        default:
            break;
    }

}
- (void) getPicture:(UIButton*) but{
    CutImageViewController *cut = [[CutImageViewController alloc] init];
    [cut getPicture];
    cut.delegate = self;
    [self.myNavigationController pushAndDisplayViewController:cut];
}


#pragma mark delegate
- (void) getCutImage:(UIImage *)img{
    if (img == nil)
        return;

    //传值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        BOOL res = [[[T_Interface alloc] init] personalPhotoByUsername:user.username andUserpwd:user.userpwd andPid:0 andUploadefile:img];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (res){
            //[InitData netAlert:str];
                
                //CGSize size = [InitData calculateImageSize:imgBut.frame.size imageSize:img.size priorDirection:Y];
               // [imgBut setFrame:CGRectMake(([InitData Width] - size.width) / 2, imgBut.frame.origin.y, size.width, size.height)];
                [imgBut setBackgroundImage:img forState:UIControlStateNormal];
            }
        });
    });

}

@end
