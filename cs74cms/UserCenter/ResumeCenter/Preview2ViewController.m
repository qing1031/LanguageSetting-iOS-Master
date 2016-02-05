//
//  Preview2ViewController.m
//  74cms
//
//  Created by lyp on 15/4/27.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "Preview2ViewController.h"
#import "InitData.h"
#import "CustomAlertView.h"
#import "T_Interface.h"
#import "DealCacheController.h"
#import "ITF_Apply.h"
#import "LoginViewController.h"

#define default  MYLocalizedString(@"这个人很懒， 什么也没有留下！", @"The man is lazy, nothing left!");

@interface Preview2ViewController ()<CustomAlertViewDelegate>{
    float height;
    
    UIScrollView *mainScrollView;
    UIColor *textcolor;
    UIFont *font;
    
    UIFont *titleFont;
    T_ResumeTotal *resume;
    
    int Jid;
    
    UIButton *remark;
}

@end

@implementation Preview2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void) viewCanBeSee{
    
    [self.myNavigationController setTitle:MYLocalizedString(@"简历1", @"Resume1")];
    
    if ([InitData getUser] != nil && ((T_User*)[InitData getUser]).utype == 1 && Jid > 0){
        remark = [UIButton buttonWithType:UIButtonTypeCustom];
        [remark setTitle:MYLocalizedString(@"备注", @"Remarks") forState:UIControlStateNormal];
        [remark addTarget:self action:@selector(remarkClicked) forControlEvents:UIControlEventTouchUpInside];
        [remark setFrame:CGRectMake(0, 0, 40, 40)];
        remark.titleLabel.font = [UIFont systemFontOfSize:14];
        NSArray *arr = [NSArray arrayWithObjects:remark, nil];
        [self.myNavigationController setRightBtn:arr];
    }
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void) setTitle:(NSString *)title{
    [self.myNavigationController setTitle:title];
}
- (void) setJid:(int) jid{
    Jid = jid;
}
- (void) setPid:(int) pid{
    [InitData isLoading:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_Interface *interface = [[T_Interface alloc] init];
       // T_User *user = [InitData getUser];
        resume = [interface resumeShowByPid:pid];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            
            if ([[self.view subviews] count] > 0){
                for (int i=0; i<[[self.view subviews] count]; i++){
                    UIView *view = [[self.view subviews] objectAtIndex:i];
                    [view removeFromSuperview];
                }
            }
            
            [self drawView];
            
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重新加载页面
- (void) reloadThisView{
    [self setPid:resume.resumeInfo.ID];
}

- (void) drawView{
    textcolor = [UIColor colorWithRed:53.0/255 green:53./255 blue:53./255 alpha:1];
    font = [UIFont systemFontOfSize:12];
    titleFont = [UIFont systemFontOfSize:13];
    float th = [InitData Height] - 50;
    if (((T_User*)[InitData getUser]).utype == 2)
       th = [InitData Height];
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], th)];
    [mainScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mainScrollView];
    
    height = 0;
    [self topview];
    [self contact];
    [self intention];
    [self evaluation];
    [self education];
    [self work];
    [self train];
    [self base];
    
    CGSize size = CGSizeMake( [InitData Width], height);
    [mainScrollView setContentSize:size];
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.directionalLockEnabled = YES;
}
- (void) topview{
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 75, 30)];
    name.text = resume.resumeInfo.fullname;
    name.font = [UIFont systemFontOfSize:15];
    [mainScrollView addSubview:name];
    
    UILabel *updateTime = [[UILabel alloc]initWithFrame:CGRectMake(105, 20, 150, 30)];
    updateTime.text = [NSString stringWithFormat:@"%@%@", MYLocalizedString(@"更新于", @"Update on"), resume.resumeInfo.refreshtime];
    updateTime.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    updateTime.font = [UIFont systemFontOfSize:13];
    [mainScrollView addSubview:updateTime];
    
    UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, [InitData Width] - 40, 15)];
    sex.text = [NSString stringWithFormat:MYLocalizedString(@"%@|%d岁|%@|%@", @"%@|%dage|%@|%@"), resume.resumeInfo.sex_cn, resume.resumeInfo.age, resume.resumeInfo.education_cn, resume.resumeInfo.experience_cn];
    sex.font = font;
    sex.textColor = textcolor;
    [mainScrollView addSubview:sex];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 78, 70, 15)];
    label1.font = font;
    label1.textColor = textcolor;
    label1.text = MYLocalizedString(@"现居住地：", @"Current residence:");
    [mainScrollView addSubview:label1];
    
    UILabel *residence = [[UILabel alloc] initWithFrame:CGRectMake(80, 78, 150, 15)];
    residence.textColor = textcolor;
    residence.font =font;
    residence.text = MYLocalizedString(@"太原", @"Taiyuan");
    [mainScrollView addSubview:residence];
    if (resume.resumeInfo.district_cn != nil)
        residence.text = resume.resumeInfo.residence_cn;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 70, 15)];
    label2.font = font;
    label2.textColor = textcolor;
    label2.text = MYLocalizedString(@"求职状态：", @"Job status:");
    [mainScrollView addSubview:label2];
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 200, 15)];
    state.textColor = textcolor;
    state.font =font;
    state.text = resume.resumeInfo.current_cn;
    [mainScrollView addSubview:state];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 70, 30, 50, 58)];
    [imgView setImage:[UIImage imageNamed:@"photos.png"]];
    [mainScrollView addSubview:imgView];
    
    if (resume.resumeInfo.photo_img != nil && ![resume.resumeInfo.photo_img isEqualToString:@""])
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            NSData *data = [[[DealCacheController alloc] init] getImageData:resume.resumeInfo.photo_img];
            UIImage *img = [UIImage imageWithData:data];
            [imgView setImage:img];
            
        });
    height += 125;
}

- (void) contact{
    if (resume.contact == nil || resume.contact.telephone == nil || [resume.contact.telephone isEqualToString:@""])
        return;
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *contact = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [contact setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    contact.text = MYLocalizedString(@"  联系方式", @"Contact");
    contact.textColor = textcolor;
    contact.font = titleFont;
    [mainScrollView addSubview:contact];
    height += 25;
    
    UILabel *contact_con = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 70, 20)];
    contact_con.textColor = textcolor;
    contact_con.text = MYLocalizedString(@"联系电话:", @"Contact");
    contact_con.font = font;
    [mainScrollView addSubview:contact_con];
    
    UILabel *contact_con2 = [[UILabel alloc] initWithFrame:CGRectMake(75, height, 200, 20)];
    contact_con2.font = font;
    contact_con2.textColor = textcolor;
    contact_con2.text = resume.contact.telephone;
    [mainScrollView addSubview:contact_con2];
    height += 20;
    
    UILabel *emailLa = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 60, 20)];
    emailLa.textColor = textcolor;
    emailLa.font = font;
    emailLa.text = @"Email:";
    [mainScrollView addSubview:emailLa];
    
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(65, height, 200, 20)];
    email.text = resume.contact.email;
    email.textColor = textcolor;
    email.font = font;
    [mainScrollView addSubview:email];
    height += 25;
    
}

- (void) intention{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  求职意向", @"Job search intention");
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    UILabel *xingzi = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    xingzi.text = MYLocalizedString(@"工作性质：", @"Working property:");
    xingzi.textColor = textcolor;
    xingzi.font = titleFont;
    [mainScrollView addSubview:xingzi];
    
    UILabel *xingzi2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, [InitData Width] - 10, 20)];
    xingzi2.text = resume.resumeInfo.nature_cn;
    xingzi2.textColor = textcolor;
    xingzi2.font = font;
    [mainScrollView addSubview:xingzi2];
    height += 20;
    
    
    UILabel *hangye = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    hangye.text = MYLocalizedString(@"期望行业：", @"Expected industry:");
    hangye.textColor = textcolor;
    hangye.font = titleFont;
    [mainScrollView addSubview:hangye];
    
    CGSize size = [resume.resumeInfo.trade_cn sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 100, 150) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel *hangye2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height + 2, size.width, size.height)];
    hangye2.textColor = textcolor;
    hangye2.text = resume.resumeInfo.trade_cn;
    hangye2.font = font;
    hangye2.numberOfLines = 0;
    [mainScrollView addSubview:hangye2];
    height += size.height + 5;
    
    UILabel *didian = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    didian.text = MYLocalizedString(@"期望地点：", @"Expected location:");
    didian.textColor = textcolor;
    didian.font = titleFont;
    [mainScrollView addSubview:didian];
    
    CGSize size2 = [resume.resumeInfo.district_cn sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 100, 150) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel *didian2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height + 2, size2.width, size2.height)];
    didian2.textColor = textcolor;
    didian2.text = resume.resumeInfo.district_cn;
    didian2.font = font;
    didian2.numberOfLines = 0;
    [mainScrollView addSubview:didian2];
    height += size2.height + 5;
    
    UILabel *xinzi = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    xinzi.text = MYLocalizedString(@"期望薪资：", @"Expected salary:");
    xinzi.textColor = textcolor;
    xinzi.font = titleFont;
    [mainScrollView addSubview:xinzi];
    
    UILabel *xinzi2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 170, 20)];
    xinzi2.textColor = textcolor;
    xinzi2.text = resume.resumeInfo.wage_cn;
    xinzi2.font = font;
    [mainScrollView addSubview:xinzi2];
    height += 20;
    
    UILabel *zhineng = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    zhineng.text = MYLocalizedString(@"目标职能：", @"Objective function:");
    zhineng.textColor = textcolor;
    zhineng.font = titleFont;
    [mainScrollView addSubview:zhineng];
    
    CGSize size3 = [resume.resumeInfo.intention_jobs sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 100, 150) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel *zhineng2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height + 2, size3.width, size3.height)];
    zhineng2.textColor = textcolor;
    zhineng2.text = resume.resumeInfo.intention_jobs;
    zhineng2.font = font;
    zhineng2.numberOfLines = 0;
    [mainScrollView addSubview:zhineng2];
    height += size3.height + 5 + 5;
    
}

- (void) evaluation{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  自我评价", @"Self evaluation");
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    if ([resume.resumeInfo.specialty isEqualToString:@""])
        resume.resumeInfo.specialty = default;
    
    CGSize size = [resume.resumeInfo.specialty sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 40, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, size.height)];
    label.numberOfLines = 0;
    label.attributedText = [InitData getMutableAttributedStringWithString:resume.resumeInfo.specialty];
    label.textColor =textcolor;
    label.font = font;
    [mainScrollView addSubview:label];
    height += size.height + 10;
}

- (void) education{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  教育经历", @"Education experience");
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    for (T_Education* res in resume.eduArray){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
        label1.textColor = textcolor;
        label1.font = font;
        label1.text = [NSString stringWithFormat:MYLocalizedString(@"%@到%@  %@", @"%@to%@  %@"), res.starttime, res.endtime, res.school];
        [mainScrollView addSubview:label1];
        height += 22;
    }
    if (resume.eduArray == nil || [resume.eduArray count] == 0){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
        label1.textColor = textcolor;
        label1.font = font;
        label1.text = default;
        [mainScrollView addSubview:label1];
        height += 22;
    }
    height += 5;
}

- (void) work{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  工作经验", @"Work experience");
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    for (T_Work *work in resume.workArray){
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(20, height,[InitData Width] - 40, 20)];
        time.textColor = textcolor;
        time.font = font;
        time.text =[NSString stringWithFormat:MYLocalizedString(@"%@到%@  %@|%@", @"%@to%@  %@|%@"), work.starttime, work.endtime, work.companyName, work.jobs];
        [mainScrollView addSubview:time];
        height += 20;
        
        CGSize tsize = [work.achievements sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 40, 60) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, height, tsize.width, tsize.height)];
        content.textColor = textcolor;
        content.font = font;
        content.numberOfLines = 0;
        content.text = work.achievements;
        
        [mainScrollView addSubview:content];
        height += tsize.height + 5 + 5;
    }
    if (resume.workArray == nil || [resume.workArray count] == 0){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
        label1.textColor = textcolor;
        label1.font = font;
        label1.text = default;
        [mainScrollView addSubview:label1];
        height += 22;
    }
    height += 5;
}

- (void) train{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake( 5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  培训经历", @"Training experience");
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    for (T_Training *train in resume.trainingArray){
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
        time.textColor = textcolor;
        time.font = font;
        time.text = [NSString stringWithFormat:MYLocalizedString(@"%@到%@  %@|%@", @"%@to%@  %@|%@"), train.starttime, train.endtime, train.agency, train.course];
        [mainScrollView addSubview:time];
        height += 20;
        
        CGSize tsize = [train.description sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 40, 60) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, height, tsize.width, tsize.height)];
        content.textColor = textcolor;
        content.font = font;
        content.text = train.description;
        content.numberOfLines = -1;
        [mainScrollView addSubview:content];
        height += tsize.height + 5 + 5;
    }
    if (resume.trainingArray == nil || [resume.trainingArray count] == 0){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
        label1.textColor = textcolor;
        label1.font = font;
        label1.text = default;
        [mainScrollView addSubview:label1];
        height += 22;
    }
    height += 5;
}

- (void) base{
    if (((T_User*)[InitData getUser]).utype == 2)
        return;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [InitData Height] - 50, [InitData Width], 1)];
    [view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [self.view addSubview:view];
    
    UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
    [download setFrame:CGRectMake(0, [InitData Height] - 50, [InitData Width] - 60, 50)];
    [download setTitle:MYLocalizedString(@"下载简历", @"Download resume") forState:UIControlStateNormal];
    //download.titleLabel.textColor = [UIColor orangeColor];
    [download setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:download];
    
    if (resume.contact != nil && resume.contact.telephone != nil && download != nil && ![resume.contact.telephone isEqualToString:@""])
        [download setTitle:MYLocalizedString(@"已下载该简历", @"The resume has been downloaded") forState:UIControlStateNormal];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 60, [InitData Height] - 50, 1, 50)];
    [view2 setBackgroundColor:view.backgroundColor];
    [self.view addSubview:view2];
    
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    [collect setImage:[UIImage imageNamed:@"collect_star.png"] forState:UIControlStateNormal];
    [collect setImage:[UIImage imageNamed:@"clollect_stars.png"] forState:UIControlStateSelected];
    
   // [collect setImage:[UIImage imageNamed:@"smille_shop_no.png"] forState:UIControlStateNormal];
   // [collect setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateSelected];
    [collect setFrame:CGRectMake([InitData Width] - (60 - 15) / 2 - 28, [InitData Height] - 40, 40, 40)];
    [collect setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 25, 13)];
    [collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    collect.selected = NO;
    [self.view addSubview:collect];
    
    UILabel *collectlab = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 10 - 30, [InitData Height] - 23, 20, 10)];
    collectlab.textColor = textcolor;
    collectlab.font = [UIFont systemFontOfSize:10];
    collectlab.text = MYLocalizedString(@"收藏", @"Collect");
    [self.view addSubview:collectlab];
}

- (void) download:(UIButton*) but{
    if (but.selected == YES)
        return;
    
    if ([InitData getUser] == nil){
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setSign:1];
        [self.myNavigationController pushAndDisplayViewController:login];
        return;
    }
    if (((T_User*)[InitData getUser]).utype == 2){
        [InitData netAlert:MYLocalizedString(@"该种用户不能下载简历", @"This kind of user can not download resume")];
        return;
    }
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        int t = [[[ITF_Apply alloc] init] downloadResumeByUser:[InitData getUser] andRid:resume.resumeInfo.ID];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (t > 0){
                [InitData netAlert:MYLocalizedString(@"下载成功！", @"Download success!")];
                [but setTitle:MYLocalizedString(@"已下载该简历", @"The resume has been downloaded") forState:UIControlStateSelected];
                but.selected = YES;
                [self reloadThisView];
            }
        });
    });
}
- (void) collect:(UIButton*) but{
    if (but.selected == YES){
        return;
    }
    
    if ([InitData getUser] == nil){
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setSign:1];
        [self.myNavigationController pushAndDisplayViewController:login];
        return;
    }
    if (((T_User*)[InitData getUser]).utype == 2){
        [InitData netAlert:MYLocalizedString(@"该种用户不能下载简历", @"This kind of user can not download resume")];
        return;
    }
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        int t = [[[ITF_Apply alloc] init] collectResumeByUser:[InitData getUser] andRid:resume.resumeInfo.ID];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (t > 0){
                but.selected = YES;
            }
        });
    });
}
- (void) remarkClicked{
    remark.userInteractionEnabled = NO;
    
    if ([InitData getUser] == nil){
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setSign:1];
        [self.myNavigationController pushAndDisplayViewController:login];
        return;
    }
    if (((T_User*)[InitData getUser]).utype == 2){
        [InitData netAlert:MYLocalizedString(@"该种用户不能添加备注", @"This kind of user can not add remarks")];
        return;
    }
    
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    NSArray * arr = [NSArray arrayWithObjects:MYLocalizedString(@"符合要求", @"Meet the requirements"), MYLocalizedString(@"不符合要求", @"Does not meet the requirements"), MYLocalizedString(@"需要会和您联系", @"Need to be in contact with you"),MYLocalizedString(@"未接通电话", @"Missed call"), nil];
    [alertView setDirection:Y andTitle:MYLocalizedString(@"备注简历", @"Memo resume") andMessage:nil andArray:arr];
    alertView.delegate = self;
    [self.view addSubview:alertView];
}
- (void) customAlertViewbuttonClicked:(int)index{
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSArray * arr = [NSArray arrayWithObjects:MYLocalizedString(@"合适", @"Appropriate"), MYLocalizedString(@"不合适", @"Inappropriate"), MYLocalizedString(@"待定", @"Undetermined"),MYLocalizedString(@"未接通", @"Not connected"), nil];
        int t = [[[ITF_Apply alloc] init] companyReplyByUser:[InitData getUser] andPid:resume.resumeInfo.ID andJid:Jid andReplyId:index + 1 andReplyIdCn:[arr objectAtIndex:index]];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (t > 0){
                [InitData netAlert:MYLocalizedString(@"添加备注成功", @"Add notes to success")];
                remark.userInteractionEnabled =YES;
            }
        });
    });
}
@end
