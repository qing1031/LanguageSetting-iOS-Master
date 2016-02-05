//
//  JobDetailViewController.m
//  74cms
//
//  Created by lyp on 15/5/7.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "JobDetailViewController.h"
#import "InitData.h"
#import "OtherJobViewController.h"
#import "LoginViewController.h"
#import "ITF_Company.h"
#import "T_AddJob.h"
#import "T_Company.h"
#import "ITF_Apply.h"
#import "CustomAlertView.h"
#import "T_ApplyJob.h"
#import "MapBigViewController.h"

@interface JobDetailViewController ()<CustomAlertViewDelegate>{
    UIButton *butSelected;
    
    UIButton *applyBut;
    
    UIScrollView *content;
    
    float height;
    int Jid ;
    
    T_AddJob *job;
    T_Company *company;
    
    int companyId;
    
    NSMutableArray *subMenuArray;
}

@end

@implementation JobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (Jid == 0)
        Jid = [InitData getPid];
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"详情", @"Detail")];
}
- (void) setJid:(int) tjid{
    Jid = tjid;
}
- (void) setCompanyId:(int) tcompanyId{
    companyId = tcompanyId;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (companyId > 0){//只看公司信息
        [self topView];
        return;
    }
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        job = [[[ITF_Company alloc] init] jobsShowByID:Jid];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (job != nil){
                [self topView];

                [self content1];
                [self bottom];
            }

        });
    });
}

- (void) topView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 37)];
    [topView setBackgroundColor:[UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1]];
    [self.view addSubview:topView];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 36, [InitData Width], 1)];
    bottom.backgroundColor = [UIColor colorWithRed:223./255 green:223./255 blue:223./255 alpha:1];
    [topView addSubview:bottom];
    
    if (companyId == 0){
        UIView *center = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] / 2, 0, 1, 37)];
        center.backgroundColor = bottom.backgroundColor;
        [topView addSubview:center];
    }
    
    float width = 0;
    if (companyId == 0){
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.tag = 1;
    [but setFrame:CGRectMake(width, 0, [InitData Width] / 2, 36)];
    [but setTitle:MYLocalizedString(@"职位详情", @"Position details") forState:UIControlStateNormal];
    [but setTitleColor:[UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1] forState:UIControlStateNormal];
    [but setTitleColor:[UIColor colorWithRed:237./255 green:96./255 blue:6./255 alpha:1] forState:UIControlStateSelected];
    [but addTarget:self action:@selector(butClicked:) forControlEvents:UIControlEventTouchUpInside];
    but.titleLabel.font = [UIFont systemFontOfSize:16];
    but.selected = YES;
    butSelected = but;
    [topView addSubview:but];
        width += [InitData Width] / 2;
    }
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.tag = 2;
    [but2 setFrame:CGRectMake(width, 0, [InitData Width] - width, 36)];
    [but2 setTitle:MYLocalizedString(@"公司简介", @"Company profile") forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1] forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor colorWithRed:237./255 green:96./255 blue:6./255 alpha:1] forState:UIControlStateSelected];
    [but2 addTarget:self action:@selector(butClicked:) forControlEvents:UIControlEventTouchUpInside];
    but2.titleLabel.font = [UIFont systemFontOfSize:16];
    but2.selected = NO;
    [topView addSubview:but2];
    
    if (companyId > 0)
        [self butClicked:but2];
}
- (void) content1{
    if (content == nil){
        
        float theight = [InitData Height] - 38;
        if([InitData getUser] == nil || ((T_User*)[InitData getUser]).utype == 2)
            theight -= 50;
        content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 38, [InitData Width], theight)];
        [content setBackgroundColor:[UIColor whiteColor]];
        content.showsHorizontalScrollIndicator = NO;
        content.showsVerticalScrollIndicator = NO;
        [self.view addSubview:content];


        height = 0;
    }
    
    UILabel *jobl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 15)];
    jobl.textColor = [UIColor colorWithRed:40./255 green:40./255 blue:40./255 alpha:1];
    jobl.font = [UIFont systemFontOfSize:16];
    jobl.text = MYLocalizedString(@"销售管理", @"Sales management");
    [content addSubview:jobl];
    if (job.jobs_name != nil)
        jobl.text = job.jobs_name;
    
    //如果职位认证过
    if (job.companyAudit > 0){
        CGSize size = [jobl.text sizeWithFont:jobl.font];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 5 + size.width, 20, 10, 10)];
        [imgView setImage:[UIImage imageNamed:@"attestation.png"]];
        [content addSubview:imgView];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 15, 15)];
    [imgView setImage:[UIImage imageNamed:@"watch.png"]];
    [content addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 40, 90, 15)];
    label.textColor = [UIColor colorWithRed:153./255 green:153./255 blue:153./255 alpha:1];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"2015-04-08";
    [content addSubview:label];
    if (job.addtime != nil)
        label.text = job.addtime;
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(121, 42, 19, 12)];
    [imgView2 setImage:[UIImage imageNamed:@"eye.png"]];
    [content addSubview:imgView2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, 100, 15)];
    label2.textColor = [UIColor colorWithRed:153./255 green:153./255 blue:153./255 alpha:1];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = [NSString stringWithFormat:MYLocalizedString(@"浏览%d次", @"Browse%d times"), job.click];
    [content addSubview:label2];

    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(220, 40, 15, 15)];
    [imgView3 setImage:[UIImage imageNamed:@"haveResume.png"]];
    [content addSubview:imgView3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(240, 40, 100, 15)];
    label3.textColor = [UIColor colorWithRed:153./255 green:153./255 blue:153./255 alpha:1];
    label3.font = [UIFont systemFontOfSize:13];
    label3.text = [NSString stringWithFormat:MYLocalizedString(@"%d人投简历", @"%d people vote resume"), job.countresume];
    [content addSubview:label3];
    height = 65;
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 1)];
    sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [content addSubview:sep];
    
    height += 10;
    /******************职位需求******************************/
    
    UIColor *color1 = [UIColor colorWithRed:117./255 green:117./255 blue:117./255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:70./255 green:70./255 blue:70./255 alpha:1];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    NSArray *arr1 = [NSArray arrayWithObjects:MYLocalizedString(@"公司名称：", @"Company name"), MYLocalizedString(@"工作地点：", @"Working area:"), MYLocalizedString(@"职位类别：", @"Job category:"), MYLocalizedString(@"招聘条件：", @"Recruitment conditions:"), nil];
    NSString * tstr = [NSString stringWithFormat:MYLocalizedString(@"%@|招%d人|%@|%@", @"%@| recruit %d people|%@|%@"), job.nature_cn, job.amount, job.education_cn, job.experience_cn];
    NSArray *arr2 = [NSArray arrayWithObjects:job.companyname, job.district_cn, job.category_cn, tstr, nil];
    
    UILabel *gongzi = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 200, 15)];
    gongzi.textColor = [UIColor colorWithRed:237./255 green:96./255 blue:6./255 alpha:1];
    gongzi.font = [UIFont systemFontOfSize:15];
    gongzi.text = MYLocalizedString(@"3000-5000元/月", @"3000-5000 RMB/month");
    [content addSubview:gongzi];
    height += 23;
    
    for (int i=0; i<4; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 70, 15)];
        label.textColor = color1;
        label.font = font;
        label.text = [arr1 objectAtIndex:i];
        [content addSubview:label];
        
        CGSize size = [[arr2 objectAtIndex:i] sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 85 - 15, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
         UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(85, height, size.width, size.height)];
        label2.textColor = color2;
        label2.font = font;
        label2.numberOfLines = 0;
        label2.text = [arr2 objectAtIndex:i];
        [content addSubview:label2];
        
        if (i==1){
            CGSize size = [label2.text sizeWithFont:label2.font];
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setImage:[UIImage imageNamed:@"ditu.png"] forState:UIControlStateNormal];
            but.tag = 1;
            [but addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
            [but setFrame:CGRectMake(85 + size.width + 5 - 14, height -14, 41, 41)];
            [but setImageEdgeInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
            [content addSubview:but];
        }
         
         height += size.height + 5;
    }
    
    height += 5;
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 1)];
    sep2.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [content addSubview:sep2];
    
    height += 13;
    
    /******************职位需求******************************/
    
    UIView *sign = [[UIView alloc] initWithFrame:CGRectMake(15, height, 3, 14)];
    sign.backgroundColor = [UIColor colorWithRed:51./255 green:112./255 blue:169./255 alpha:1];
    [content addSubview:sign];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, height, 100, 14)];
    title.textColor = color2;
    title.font = [UIFont systemFontOfSize:15];
    title.text = MYLocalizedString(@"职位描述", @"Job description");
    [content addSubview:title];
    height += 20;
    
    UILabel *contentLab = [[UILabel alloc] init];
    CGSize size = [job.contents sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 34, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    [contentLab setFrame:CGRectMake(17, height, [InitData Width] - 34, size.height)];
    contentLab.textColor = color2;
    contentLab.font = font;
    contentLab.numberOfLines = 0;
    contentLab.attributedText = [InitData getMutableAttributedStringWithString:job.contents];
    contentLab.lineBreakMode = NSLineBreakByCharWrapping;
    [content addSubview:contentLab];
    
    height += size.height + 10;
    
    UIView *sign2 = [[UIView alloc] initWithFrame:CGRectMake(15, height, 3, 14)];
    sign2.backgroundColor = [UIColor colorWithRed:51./255 green:112./255 blue:169./255 alpha:1];
    [content addSubview:sign2];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(25, height, 100, 14)];
    title2.textColor = color2;
    title2.font = title.font;
    title2.text = MYLocalizedString(@"联系方式", @"Contact information");
    [content addSubview:title2];
    height += 20;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 56, 15)];
    lab.textColor = color2;
    lab.font = font;
    lab.text = MYLocalizedString(@"联系人：", @"Contacts:");
    [content addSubview:lab];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(73, height, 200, 15)];
    info.textColor = color2;
    info.font = font;
    info.text = job.contact;
    [content addSubview:info];
    height += 20;
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 70, 15)];
    lab2.textColor = color2;
    lab2.font = font;
    lab2.text = MYLocalizedString(@"联系电话：", @"phone number:");
    [content addSubview:lab2];
    
    UILabel *info2 = [[UILabel alloc] initWithFrame:CGRectMake(87, height, 200, 15)];
    info2.textColor = color2;
    info2.font = font;
    info2.text = job.telephone;
    [content addSubview:info2];
    height += 20;
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 70, 15)];
    lab3.textColor = color2;
    lab3.font = font;
    lab3.text = MYLocalizedString(@"联系邮箱：", @"Email:");
    [content addSubview:lab3];
    
    UILabel *info3 = [[UILabel alloc] initWithFrame:CGRectMake(87, height, 200, 15)];
    info3.textColor = color2;
    info3.font = font;
    info3.text = job.email;
    [content addSubview:info3];
    height += 20;
    
    [content setContentSize:CGSizeMake([InitData Width], height)];
}
- (void) content2{
    if (content == nil){
        float theight = [InitData Height] - 38;
        if([InitData getUser] == nil || ((T_User*)[InitData getUser]).utype == 2)
            theight -= 50;
            content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 38, [InitData Width], theight)];
        [content setBackgroundColor:[UIColor whiteColor]];
        content.showsHorizontalScrollIndicator = NO;
        content.showsVerticalScrollIndicator = NO;
        [self.view addSubview:content];
        height = 0;
    }
    
    UILabel *jobl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, [InitData Width] - 30, 15)];
    jobl.textColor = [UIColor colorWithRed:40./255 green:40./255 blue:40./255 alpha:1];
    jobl.font = [UIFont systemFontOfSize:16];
    jobl.text = company.companyname;
    [content addSubview:jobl];
    
    height = 40;
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 1)];
    sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [content addSubview:sep];
    
    height += 13;
    /******************职位需求******************************/
    
    UIColor *color1 = [UIColor colorWithRed:117./255 green:117./255 blue:117./255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:70./255 green:70./255 blue:70./255 alpha:1];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    NSArray *arr1 = [NSArray arrayWithObjects:MYLocalizedString(@"规模：", @"Scale:"), MYLocalizedString(@"性质：", @"Nature:"), MYLocalizedString(@"行业：", @"Industry:"), MYLocalizedString(@"地址：", @"Adress:"), nil];
    NSArray *arr2 = [NSArray arrayWithObjects:company.scale_cn, company.nature_cn, company.trade_cn, company.district_cn, nil];
    
    
    for (int i=0; i<4; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 42, 15)];
        label.textColor = color1;
        label.font = font;
        label.text = [arr1 objectAtIndex:i];
        [content addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(56, height, 200, 15)];
        label2.textColor = color2;
        label2.font = font;
        label2.text = [arr2 objectAtIndex:i];
        [content addSubview:label2];
        
        if (i == 3){
            CGSize size = [label2.text sizeWithFont:label2.font];
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setImage:[UIImage imageNamed:@"ditu.png"] forState:UIControlStateNormal];
            but.tag = 1;
            [but addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
            [but setFrame:CGRectMake(56 + size.width + 5 - 14, height -14, 41, 41)];
            [but setImageEdgeInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
            [content addSubview:but];
        }
        
        height += 20;
    }
    
    height += 5;
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 1)];
    sep2.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [content addSubview:sep2];
    
    height += 13;
    /**********************其他职位**********************************/
    
    UIView *other = [[UIView alloc] initWithFrame:CGRectMake(17, height, [InitData Width] - 34, 20)];
    [other setBackgroundColor:[UIColor whiteColor]];
    [content addSubview:other];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherJob)];
    recognizer.numberOfTapsRequired = 1;
    [other addGestureRecognizer:recognizer];
    
    
    UILabel *otherLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    otherLab.textColor = color2;
    otherLab.font = [UIFont systemFontOfSize:14];
    otherLab.text = [NSString stringWithFormat:MYLocalizedString(@"该公司的其他职位（%d）", @"Other positions in the company（%d）"), company.countJobs];
    [other addSubview:otherLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(other.frame.size.width - 12, 2, 12, 18)];
    [imgView setImage:[UIImage imageNamed:@"go.png"]];
    [other addSubview:imgView];
    
    height += 30;
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 1)];
    sep3.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [content addSubview:sep3];
    
    height += 10;
    
    /******************职位需求******************************/
    
    UIView *sign = [[UIView alloc] initWithFrame:CGRectMake(15, height, 3, 14)];
    sign.backgroundColor = [UIColor colorWithRed:51./255 green:112./255 blue:169./255 alpha:1];
    [content addSubview:sign];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, height, 100, 14)];
    title.textColor = color2;
    title.font = [UIFont systemFontOfSize:15];
    title.text = MYLocalizedString(@"公司简介", @"Company profile");
    [content addSubview:title];
    height += 20;
    
    
    NSString *str = company.contents;
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 34, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(17, height, [InitData Width] - 34, size.height)];
    contentLab.textColor = color2;
    contentLab.numberOfLines = 0;
    contentLab.attributedText = [InitData getMutableAttributedStringWithString:str];
    contentLab.font = font;
    [content addSubview:contentLab];
    

    height += size.height + 10;
    
    UIView *sign2 = [[UIView alloc] initWithFrame:CGRectMake(15, height, 3, 14)];
    sign2.backgroundColor = [UIColor colorWithRed:51./255 green:112./255 blue:169./255 alpha:1];
    [content addSubview:sign2];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(25, height, 100, 14)];
    title2.textColor = color2;
    title2.font = title.font;
    title2.text = MYLocalizedString(@"联系方式", @"Contact");
    [content addSubview:title2];
    height += 20;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 56, 15)];
    lab.textColor = color2;
    lab.font = font;
    lab.text = MYLocalizedString(@"联系人：", @"Contacts:");
    [content addSubview:lab];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(73, height, 200, 15)];
    info.textColor = color2;
    info.font = font;
    info.text = company.contact;
    [content addSubview:info];
    height += 20;
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 70, 15)];
    lab2.textColor = color2;
    lab2.font = font;
    lab2.text = MYLocalizedString(@"联系电话：", @"phone number:");
    [content addSubview:lab2];
    
    UILabel *info2 = [[UILabel alloc] initWithFrame:CGRectMake(87, height, 200, 15)];
    info2.textColor = color2;
    info2.font = font;
    info2.text = company.telephone;
    [content addSubview:info2];
    height += 20;
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 70, 15)];
    lab3.textColor = color2;
    lab3.font = font;
    lab3.text = MYLocalizedString(@"联系邮箱：", @"Email");
    [content addSubview:lab3];
    
    UILabel *info3 = [[UILabel alloc] initWithFrame:CGRectMake(87, height, 200, 15)];
    info3.textColor = color2;
    info3.font = font;
    info3.text = company.email;
    [content addSubview:info3];
    height += 20;
    
    [content setContentSize:CGSizeMake([InitData Width], height)];
}
- (void) bottom{
    if (((T_User*)[InitData getUser]).utype == 1)
        return;
    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(0, [InitData Height] - 50, [InitData Width], 50)];
    [botView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:botView];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 1)];
    [top setBackgroundColor:[UIColor colorWithRed:223./255 green:223./255 blue:223./255 alpha:1]];
    [botView addSubview:top];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 120, 0, 1, 50)];
    sep1.backgroundColor = top.backgroundColor;
    [botView addSubview:sep1];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 60, 0, 1, 50)];
    sep2.backgroundColor = top.backgroundColor;
    [botView addSubview:sep2];
    
    applyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBut setFrame:CGRectMake(0, 0, [InitData Width] - 120, 50)];
    [applyBut setTitle:MYLocalizedString(@"申请职位", @"Apply for a position") forState:UIControlStateNormal];
    [applyBut setTitleColor:[UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1] forState:UIControlStateNormal];
    [applyBut setTitleColor:[UIColor colorWithRed:237./255 green:96./255 blue:6./255 alpha:1] forState:UIControlStateSelected];
    applyBut.titleLabel.font = [UIFont systemFontOfSize:16];
    [applyBut addTarget:self action:@selector(applyButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:applyBut];

    UIButton *call = [UIButton buttonWithType:UIButtonTypeCustom];
    [call setFrame:CGRectMake(applyBut.frame.size.width + 12, applyBut.frame.origin.y+10, 40, 40)];
    [call setImageEdgeInsets:UIEdgeInsetsMake(0, 11, 22, 11)];
    [call addTarget:self action:@selector(callButClicked) forControlEvents:UIControlEventTouchUpInside];
    [call setImage:[UIImage imageNamed:@"phoneUnselected.png"] forState:UIControlStateNormal];
    [botView addSubview:call];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(call.frame.origin.x + 2, call.frame.origin.y + 20, 18 + 20, 14)];
    label.textColor = [UIColor colorWithRed:140./255 green:140./255 blue:140./255 alpha:1];
    label.font = [UIFont systemFontOfSize:13];
    label.text = MYLocalizedString(@"电话", @"Mobile phone");
    label.textAlignment = NSTextAlignmentCenter;
    [botView addSubview:label];
    
    UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];
    [star setFrame:CGRectMake(applyBut.frame.size.width + 70, applyBut.frame.origin.y+10, 40, 40)];
    [star setImageEdgeInsets:UIEdgeInsetsMake(0, 11, 22, 11)];
    [star addTarget:self action:@selector(collectButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [star setImage:[UIImage imageNamed:@"collect_star.png"] forState:UIControlStateNormal];
    [star setImage:[UIImage imageNamed:@"clollect_stars.png"] forState:UIControlStateSelected];
    [botView addSubview:star];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(star.frame.origin.x, call.frame.origin.y + 20, 18 + 20, 14)];
    label2.textColor = [UIColor colorWithRed:140./255 green:140./255 blue:140./255 alpha:1];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = MYLocalizedString(@"收藏", @"Collect");
    label2.textAlignment = NSTextAlignmentCenter;
    [botView addSubview:label2];
}


#pragma mark event
- (void) otherJob{
    OtherJobViewController *other = [[OtherJobViewController alloc] init];
    if (job.company_id > 0)
        [other setCompanyID:job.company_id];
    else
        [other setCompanyID:companyId];
    [self.myNavigationController pushAndDisplayViewController:other];
    if (job.companyname != nil && ![job.companyname isEqualToString:@""])
        [other setTitle:job.companyname];
    else if (company.companyname != nil && ![company.companyname isEqualToString:@""])
        [other setTitle:company.companyname];
}
- (void) applyButClicked:(UIButton*) but{
    if (but.selected == YES)
        return;
    /*********************************************************/
    
    if ([InitData getUser] == nil){
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setSign:1];
        [self.myNavigationController pushAndDisplayViewController:login];
        return;
    }
    if (((T_User*)[InitData getUser]).utype == 1){
        [InitData netAlert:MYLocalizedString(@"该种用户不能申请职位", @"This kind of user can not apply for a job")];
        return;
    }
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        subMenuArray = [[[ITF_Apply alloc] init] applyJobByUser:[InitData getUser] andJid:0 andRid:0];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (subMenuArray != nil){
                NSMutableArray *tarray = [[NSMutableArray alloc] init];
                for (int i=0; i<[subMenuArray count]; i++) {
                    T_ApplyJob *tresume = [subMenuArray objectAtIndex:i];
                    [tarray addObject:tresume.fullname];
                }
                CustomAlertView *custom = [[CustomAlertView alloc] init];
                custom.delegate = self;
                [custom setDirection:Y andTitle:MYLocalizedString(@"选择简历", @"Select resume") andMessage:nil andArray:tarray];
                [self.view addSubview:custom];
                applyBut.selected = YES;
            }
        });
    });
    
}

- (void) locationClick:(UIButton*) but{
    MapBigViewController *map = [[MapBigViewController alloc] init];
    
    if (but.tag == 1){
        [map setLat:job.lat andLon:job.lon andIsJob:YES];
    }
    else{
        [map setLat:company.lat andLon:company.lon andIsJob:YES];
    }
    [self.myNavigationController pushAndDisplayViewController:map];
}
- (void) callButClicked{
    if (company == nil){
        company = [[[ITF_Company alloc] init] companyShowByID:job.company_id andJid:Jid];
    }
    if (company.telephone != nil && [InitData stringIsPhoneNumber:company.telephone]){
        NSString *str = [NSString stringWithFormat:@"tel://%@", company.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        [InitData netAlert:MYLocalizedString(@"无法拨打联系电话！", @"Unable to dial the telephone number!")];
    }
}
- (void) collectButClicked:(UIButton*) but{
    
    if ([InitData getUser] == nil){
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setSign:1];
        [self.myNavigationController pushAndDisplayViewController:login];
        return;
    }
    if (((T_User*)[InitData getUser]).utype == 1){
        [InitData netAlert:MYLocalizedString(@"该种用户不能收藏职位", @"This kind of user can not collect jobs")];
        return;
    }
    
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        int t = [[[ITF_Apply alloc] init] collectJobByUser:[InitData getUser] andJid:Jid];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (t > 0){
                but.selected = YES;
            }
        });
    });
   // but.selected = YES;
}
- (void) butClicked:(UIButton*) but{
    if (butSelected == but){
        return;
    }
    
    butSelected.selected = NO;
    but.selected = YES;
    butSelected = but;
    
    [InitData distory:content];
    content = nil;
    if (but.tag == 1){
        if (job != nil)
            [self content1];
    }
    else{
        if (company != nil)
            [self content2];
        else{
            [InitData isLoading:self.view];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //后台代码
                int t = companyId == 0? job.company_id : companyId;
                company = [[[ITF_Company alloc] init] companyShowByID:t andJid:Jid];
                
                //后台完成后，到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [InitData haveLoaded:self.view];
                    if (company != nil)
                        [self content2];
                });
            });
        }
    }
}

#pragma mark delegate
- (void) customAlertViewbuttonClicked:(int)index{
    T_ApplyJob *resume = [subMenuArray objectAtIndex:index];
    
    NSMutableArray *tarray = [[[ITF_Apply alloc] init] applyJobByUser:[InitData getUser] andJid:Jid andRid:resume.resume_id];
    if (tarray != nil){
        [applyBut setTitle:MYLocalizedString(@"已申请该职位", @"Have applied for the position") forState:UIControlStateSelected];
        applyBut.selected = YES;
    }
}
@end
