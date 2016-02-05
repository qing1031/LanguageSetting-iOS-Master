//
//  Preview1ViewController.m
//  74cms
//
//  Created by lyp on 15/4/27.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "Preview1ViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "DealCacheController.h"
#import "T_ApplyJob.h"

#define default MYLocalizedString(@"这个人很懒， 什么也没有留下！", @"The man is lazy, nothing left!");
/*
@implementation UIView

- (void) drawRect:(CGRect) rect{
    [self drawLine];
}


- (void) drawLine{
    CGContextRef line = UIGraphicsGetCurrentContext();//获取上下文

    CGMutablePathRef path = CGPathCreateMutable();
    //
    CGPathMoveToPoint(path, NULL, 65, 215);
    //
    CGPathAddLineToPoint(path, NULL, 115, 220);
    //
    CGContextAddPath(line, path);
    //
    CGContextDrawPath(line, kCGPathFillStroke);
    //
    CGContextDrawPath(line, kCGPathFillStroke);
    //
    CGPathRelease(path);
    
    
}

@end
*/
@interface Preview1ViewController (){
    float height;
    
    UIScrollView *mainScrollView;
    UIColor *textcolor;
    UIFont *font;
    
    UIFont *titleFont;
    
    T_ResumeTotal *resume;
}

@end

@implementation Preview1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (void) setTitle:(NSString *)title{
    [self.myNavigationController setTitle:title];
}

- (void) viewCanBeSee{
    /*if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setPid:(int) pid{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_Interface *interface = [[T_Interface alloc] init];
        resume = [interface resumeShowByPid:pid];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self drawView];
            
        });
    });
}
- (void) drawView{
    textcolor = [UIColor colorWithRed:53.0/255 green:53./255 blue:53./255 alpha:1];
    font = [UIFont systemFontOfSize:12];
    titleFont = [UIFont systemFontOfSize:13];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -13, [InitData Width], [InitData Height] + 13)];
    [mainScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mainScrollView];
    
    
    [self topview];
    [self contact];
    [self intention];
    [self evaluation];
    [self education];
    [self work];
    [self train];
    
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

    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 75, 30, 50, 58)];
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
    if (resume.contact == nil || resume.contact.telephone == nil)
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
    if (resume.resumeInfo.specialty != nil)
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

@end
