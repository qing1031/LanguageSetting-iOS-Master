//
//  ChangeResumeViewController.m
//  74cms
//
//  Created by LPY on 15-4-15.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "ChangeResumeViewController.h"
#import "InitData.h"
#import "SelfEvaluationViewController.h"
#import "EducationArrayViewController.h"
#import "EducationViewController.h"
#import "WordViewController.h"
#import "TrainViewController.h"
#import "InfoViewController.h"
#import "../CutImageViewController.h"
#import "IntentionCenterViewController.h"
#import "Preview1ViewController.h"
#import "T_Interface.h"
#import "DealCacheController.h"

#define TAGBEGIN 200

@interface ChangeResumeViewController ()<cutImageDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>{
    UITextField *resumeNameField;
    UIButton *editBut;
    UIButton *imgBut;
    
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    
    //图片2进制路径
    NSString* filePath;
    
    T_ResumeComplete *resCom;//简历完整度
}

@end

@implementation ChangeResumeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) getImg{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSData *data = [[[DealCacheController  alloc] init] getImageData:resCom.photo_img];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:data];
            [imgBut setImage:img forState:UIControlStateNormal];
        });
    });
}

- (void) drawTopView{
    
    float width = 56, height = 68;
    NSString *resumeName = resCom.title;
    NSString *updataTime = [NSString stringWithFormat:MYLocalizedString(@"刷新时间  %@", @"Refresh time %@"),  resCom.refreshtime];
    float complete = resCom.complete_precent / 100.;


    //照片
    imgBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBut setFrame:CGRectMake(30, 10, width, height)];
    [imgBut addTarget:self action:@selector(getPicture) forControlEvents:UIControlEventTouchUpInside];
    [self getImg];
    
    
    //简历名称
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(100, 15);
    if ([resumeName respondsToSelector:@selector(sizeWithFont:forWidth:lineBreakMode:)]){
        size = [resumeName sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }
    resumeNameField = [[UITextField alloc] initWithFrame:CGRectMake([InitData Width] * 0.35, 10, size.width, size.height)];
    resumeNameField.text = resumeName;
    resumeNameField.font = font;
    resumeNameField.returnKeyType = UIReturnKeyDone;
    resumeNameField.delegate = self;
    resumeNameField.userInteractionEnabled = NO;
    
    //编辑按钮
    editBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBut setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
    [editBut addTarget:self action:@selector(editButClicked) forControlEvents:UIControlEventTouchUpInside];
    [editBut setFrame:CGRectMake([InitData Width] * 0.35 + size.width, 10, 20, 20)];
    [self.view addSubview:editBut];
    
    //更新时间
    UILabel *updataTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(resumeNameField.frame.origin.x, 35, 200, 20)];
    updataTimeLabel.text = updataTime;
    updataTimeLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    updataTimeLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:updataTimeLabel];
    
    //完整度3个字
    UILabel *completeLabel = [[UILabel alloc] initWithFrame:CGRectMake(resumeNameField.frame.origin.x, 60, 50, 20)];
    completeLabel.text = MYLocalizedString(@"完 整 度", @"Finishing degree");
    completeLabel.textColor = updataTimeLabel.textColor;
    completeLabel.font = updataTimeLabel.font;
    [self.view addSubview:completeLabel];
    
    //完整度图
    UIView *completeView = [[UIView alloc] initWithFrame:CGRectMake(completeLabel.frame.origin.x + 60, completeLabel.frame.origin.y + 3, 80, 18)];
    [completeView setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    completeView.layer.cornerRadius = 3;
    [self.view addSubview:completeView];
    
    UIView *completed = [[UIView alloc] initWithFrame:CGRectMake(0, 0, completeView.frame.size.width * complete, completeView.frame.size.height)];
    [completed setBackgroundColor:[UIColor colorWithRed:243.0 / 255 green:134.0/255 blue:58.0/255 alpha:1]];
    completed.layer.cornerRadius = 3;
    [completeView addSubview:completed];
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, completeView.frame.size.width, completeView.frame.size.height)];
    number.text = [NSString stringWithFormat:@"%.0f%%", complete * 100];
    number.font = [UIFont systemFontOfSize:12];
    number.textAlignment = NSTextAlignmentCenter;
    number.textColor = completeLabel.textColor;
    [completeView addSubview:number];
    
    //
  /*  UIControl *bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    [bgControl addTarget:self action:@selector(spaceClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];*/

    [self.view addSubview:imgBut];

    [self.view addSubview:resumeNameField];
    
    [self.view addSubview:editBut];
}

- (void) drawMainContent{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, [InitData Width], [InitData Height] - 90)];
    [bgView setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    [self.view addSubview:bgView];
    
    
    float cellHeight = (bgView.frame.size.height - 6 - 20) / 8;
    float height = 0;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"个人信息", @"Personal information"), MYLocalizedString(@"求职意向", @"Intentional position"), MYLocalizedString(@"自我评价", @"Self evaluation"), MYLocalizedString(@"教育经历", @"Education experience"), MYLocalizedString(@"工作经历", @"Work experience"),MYLocalizedString(@"培训经历", @"Training experience"), nil];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:resCom.info?MYLocalizedString(@"完整", @"Complete"):MYLocalizedString(@"不完整", @"Incomplete"), resCom.hope?MYLocalizedString(@"完整", @"Complete"):MYLocalizedString(@"不完整", @"Incomplete"), resCom.specialty?MYLocalizedString(@"完整", @"Complete"):MYLocalizedString(@"不完整", @"Incomplete"), resCom.education?MYLocalizedString(@"完整", @"Complete"):MYLocalizedString(@"不完整", @"Incomplete"),resCom.work ?MYLocalizedString(@"完整", @"Complete"):MYLocalizedString(@"不完整", @"Incomplete"), resCom.training?MYLocalizedString(@"完整", @"Complete"):MYLocalizedString(@"不完整", @"Incomplete"), nil];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 100, 30)];
    title1.text = MYLocalizedString(@"基本信息", @"Base information");
    title1.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:title1];
    height += 30;
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        if (i == 3){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 100, 30)];
            label.text = MYLocalizedString(@"其他信息", @"Other information");
            label.font = title1.font;
            [bgView addSubview:label];
            height += 30 - 1;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = TAGBEGIN + i;
       // view.userInteractionEnabled = YES;
        [bgView addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
        label2.text = [arr2 objectAtIndex:i];
        label2.textColor = color2;
        if ([label2.text isEqualToString:@"不完整"]){
            label2.textColor = [UIColor colorWithRed:243.0 / 255 green:134.0/255 blue:58.0/255 alpha:1];
        }
        label2.font = font2;
        label2.textAlignment = NSTextAlignmentRight;
        [view addSubview:label2];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 35, (cellHeight - 30) / 2, 20, 30)];
        [view addSubview:img];
        
        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 15, (cellHeight + 1) * 3)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, 30, 15, (cellHeight + 1) * 3)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + (cellHeight + 1) * 3, 15, (cellHeight + 1) * 2)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, 60 + (cellHeight + 1) * 3, 15, (cellHeight + 1) * 2)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view4];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, height + 8, 10, 10)];
    [imgView setImage:[UIImage imageNamed:@"tixin.png"]];
    [bgView addSubview:imgView];
    
    UILabel *tixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width + 3, imgView.frame.origin.y - 3, 300, 15)];
    tixinLabel.text = MYLocalizedString(@"如需填写更多内容请到骑士人才系统官网完善", @"If you need to fill in more content, please go to the official website of the knight talent system to improve");
    tixinLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0/255 blue:102.0/255 alpha:1];
    tixinLabel.font = [UIFont systemFontOfSize:10];
    [bgView addSubview:tixinLabel];

}

- (void) drawView{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        resCom = [[[T_Interface alloc] init] personalResumeEditResumeByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid]];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];

            [self drawTopView];
            [self drawMainContent];
            
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
        [self drawView];
    
    [self.myNavigationController setTitle:MYLocalizedString(@"我的简历", @"My resume")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.titleLabel.font = [UIFont systemFontOfSize:15];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"预览", @"Preview") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}

- (void) viewCannotBeSee{
  /*  for (int i=[[self.view subviews] count] - 1; i>=0; i--){
        [InitData distory:[[self.view subviews] objectAtIndex:i ]];
    }*/
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) editButClicked{
    if (resumeNameField.userInteractionEnabled == YES){
        [self spaceClicked];
        
        T_User *user = [InitData getUser];
        NSString *string = [[[T_Interface alloc] init] resumeTitleByUsername:user.username andUserpwd:user.userpwd andPid:resCom.ID andTitle:resumeNameField.text];
        if (string == nil){//如果保存没成功，变回原来的名字
            resumeNameField.text = resCom.title;
        }
        else{
            resCom.title = resumeNameField.text;
        }
        return;
    }
    resumeNameField.userInteractionEnabled = YES;
    
    float x = resumeNameField.frame.origin.x;
    float y = resumeNameField.frame.origin.y;
    float height = resumeNameField.frame.size.height;
    float width = resumeNameField.frame.size.width;
    if (resumeNameField.userInteractionEnabled == YES){
        resumeNameField.frame = CGRectMake(x, y, 150, height);
        resumeNameField.borderStyle = UITextBorderStyleRoundedRect;
        
        [editBut setFrame:CGRectMake(editBut.frame.origin.x + (150 - width), editBut.frame.origin.y, editBut.frame.size.width, editBut.frame.size.height)];
        
    }
    
}

#pragma mark event
- (void) save{
    Preview1ViewController *preview1 = [[Preview1ViewController alloc] init];
    [preview1 setPid:[InitData getPid]];
    [self.myNavigationController pushAndDisplayViewController:preview1];
    [preview1 setTitle:resCom.title];
}
- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
   
    // NSLog(@"%s : %d", __func__, t);
    if (self.myNavigationController == nil)
        return;
    switch (recognizer.view.tag) {
        case TAGBEGIN + 0:{
            InfoViewController *info = [[InfoViewController alloc] init];
            [info setPid: resCom.ID];
            [self.myNavigationController pushAndDisplayViewController:info];
        }
            break;
        case TAGBEGIN + 1:{
            IntentionCenterViewController * intent = [[IntentionCenterViewController alloc] init];
            [intent setPid:resCom.ID];
            [self.myNavigationController pushAndDisplayViewController:intent];
        }
            break;
        case TAGBEGIN + 2:{
            SelfEvaluationViewController *selfEvalua = [[SelfEvaluationViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:selfEvalua];
            [selfEvalua setPid:resCom.ID];
        }
            break;
        case TAGBEGIN + 3:
            if (!resCom.education){
                [self.myNavigationController pushAndDisplayViewController:[[EducationViewController alloc] init]];
            }
            else{
                EducationArrayViewController *edu = [[EducationArrayViewController alloc] init];
                [edu setPid:resCom.ID andType: (int)recognizer.view.tag - TAGBEGIN];
                
                [self.myNavigationController pushAndDisplayViewController:edu];
            }
            break;
        case TAGBEGIN + 4:
            if (!resCom.work){
                [self.myNavigationController pushAndDisplayViewController:[[WordViewController alloc] init]];
            }
            else{
                EducationArrayViewController *edu = [[EducationArrayViewController alloc] init];
                [edu setPid:resCom.ID andType: (int)recognizer.view.tag - TAGBEGIN];
                
                [self.myNavigationController pushAndDisplayViewController:edu];
            }
            break;
        case TAGBEGIN + 5:
            if (!resCom.training){
                [self.myNavigationController pushAndDisplayViewController:[[TrainViewController alloc] init]];
               
            }
            else{
            
            EducationArrayViewController *edu = [[EducationArrayViewController alloc] init];
            [edu setPid:resCom.ID andType: (int)recognizer.view.tag - TAGBEGIN];
            
            [self.myNavigationController pushAndDisplayViewController:edu];
        } break;

    }
}

- (void) spaceClicked{
    [resumeNameField resignFirstResponder];

    resumeNameField.borderStyle = UITextBorderStyleNone;
    CGSize size = CGSizeMake(100, 15);
    if ([resumeNameField.text respondsToSelector:@selector(sizeWithFont:forWidth:lineBreakMode:)]){
        size = [resumeNameField.text sizeWithFont:resumeNameField.font constrainedToSize:CGSizeMake(self.view.frame.size.width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    float x = resumeNameField.frame.origin.x;
    float y = resumeNameField.frame.origin.y;
    float height = resumeNameField.frame.size.height;
    float width = resumeNameField.frame.size.width;
    if (resumeNameField.userInteractionEnabled == YES){
        resumeNameField.frame = CGRectMake(x, y, size.width, height);
        
        [editBut setFrame:CGRectMake(editBut.frame.origin.x + (size.width - width), editBut.frame.origin.y, editBut.frame.size.width, editBut.frame.size.height)];
        
    }
    resumeNameField.userInteractionEnabled = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
  //  [self spaceClicked];
    [self editButClicked];
    return YES;
}

- (void) getPicture{
    CutImageViewController *cut = [[CutImageViewController alloc] init];
    [cut getPicture];
    cut.delegate = self;
    [self.myNavigationController pushAndDisplayViewController:cut];
}


#pragma mark delegate
- (void) getCutImage:(UIImage *)img{
    if (img == nil)
        return;
    //CGSize size = [InitData calculateImageSize:imgBut.frame.size imageSize:img.size priorDirection:Y];
   // [imgBut setFrame:CGRectMake(([InitData Width] - size.width) / 2, imgBut.frame.origin.y, size.width, size.height)];
    
    //传值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        BOOL res = [[[T_Interface alloc] init] personalPhotoByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andUploadefile:img];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (res){
                [imgBut setImage:img forState:UIControlStateNormal];
            }
            
        });
    });
}
@end
