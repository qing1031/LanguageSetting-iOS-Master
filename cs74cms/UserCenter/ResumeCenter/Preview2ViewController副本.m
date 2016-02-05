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

@interface Preview2ViewController ()<CustomAlertViewDelegate>{
    float height;
    
    UIScrollView *mainScrollView;
    UIColor *textcolor;
    UIFont *font;
    
    UIFont *titleFont;
}

@end

@implementation Preview2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    
    UIButton *remark = [UIButton buttonWithType:UIButtonTypeCustom];
    [remark setTitle:@"备注" forState:UIControlStateNormal];
    [remark addTarget:self action:@selector(remarkClicked) forControlEvents:UIControlEventTouchUpInside];
    [remark setFrame:CGRectMake(0, 0, 80, 40)];
    NSArray *arr = [NSArray arrayWithObjects:remark, nil];
    [self.myNavigationController setRightBtn:arr];
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    
    [self.myNavigationController setTitle:@"jianli1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) drawView{
    textcolor = [UIColor colorWithRed:53.0/255 green:53./255 blue:53./255 alpha:1];
    font = [UIFont systemFontOfSize:12];
    titleFont = [UIFont systemFontOfSize:13];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height] - 50)];
    [mainScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mainScrollView];
    
    
    [self topview];
    //[self contact];
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
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
    name.text = @"王群";
    name.font = [UIFont systemFontOfSize:15];
    [mainScrollView addSubview:name];
    
    UILabel *updateTime = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 100, 30)];
    updateTime.text = @"更新于2015-4-9";
    updateTime.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    updateTime.font = [UIFont systemFontOfSize:13];
    [mainScrollView addSubview:updateTime];
    
    UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 15, 15)];
    sex.text = @"男";
    sex.font = font;
    sex.textColor = textcolor;
    [mainScrollView addSubview:sex];
    
   
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(35, 51, 1, 13)];
    sep1.backgroundColor = textcolor;
    [mainScrollView addSubview:sep1];
   
    UILabel *age = [[UILabel alloc] initWithFrame:CGRectMake(38, 50, 30, 15)];
    age.textColor = textcolor;
    age.font = font;
    age.text = @"25岁";
    [mainScrollView addSubview:age];

    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(68, 50, 1, 15)];
    sep2.backgroundColor = textcolor;
    [mainScrollView addSubview:sep2];
   
    UILabel *edu = [[UILabel alloc] initWithFrame:CGRectMake(70, 51, 26, 13)];
    edu.text = @"本科";
    edu.textColor = textcolor;
    edu.font = font;
    [mainScrollView addSubview:edu];
    

    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(97, 51, 1, 13)];
    sep3.backgroundColor = textcolor;
    [mainScrollView addSubview:sep3];

    UILabel *exp = [[UILabel alloc] initWithFrame:CGRectMake(99, 50, 60, 15)];
    exp.textColor = textcolor;
    exp.font = font;
    exp.text = @"3-4年";
    [mainScrollView addSubview:exp];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 68, 70, 15)];
    label1.font = font;
    label1.textColor = textcolor;
    label1.text = @"现居住地：";
    // [label1 setBackgroundColor:[UIColor redColor]];
    [mainScrollView addSubview:label1];
    
    UILabel *residence = [[UILabel alloc] initWithFrame:CGRectMake(80, 68, 150, 15)];
    residence.textColor = textcolor;
    residence.font =font;
    residence.text = @"太原";
    [mainScrollView addSubview:residence];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 70, 15)];
    label2.font = font;
    label2.textColor = textcolor;
    label2.text = @"求职状态：";
    [mainScrollView addSubview:label2];
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(80, 85, 150, 15)];
    state.textColor = textcolor;
    state.font =font;
    state.text = @"目前正在找工作";
    [mainScrollView addSubview:state];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 100, 20, 46, 58)];
    [imgView setImage:[UIImage imageNamed:@""]];
    [mainScrollView addSubview:imgView];
    
    height += 110;
}

- (void) contact{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *contact = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [contact setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    contact.text = @"  联系方式";
    contact.textColor = textcolor;
    contact.font = titleFont;
    [mainScrollView addSubview:contact];
    height += 25;
    
    UILabel *contact_con = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 70, 20)];
    contact_con.textColor = textcolor;
    contact_con.text = @"联系电话:";
    contact_con.font = font;
    [mainScrollView addSubview:contact_con];
    
    UILabel *contact_con2 = [[UILabel alloc] initWithFrame:CGRectMake(75, height, 200, 20)];
    contact_con2.font = font;
    contact_con2.textColor = textcolor;
    contact_con2.text = @"12345678910";
    [mainScrollView addSubview:contact_con2];
    height += 20;
    
    UILabel *emailLa = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 60, 20)];
    emailLa.textColor = textcolor;
    emailLa.font = font;
    emailLa.text = @"Email:";
    [mainScrollView addSubview:emailLa];
    
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(65, height, 200, 20)];
    email.text = @"12344568799@383.vom";
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
    intent.text = @"  求职意向";
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    UILabel *xingzi = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    xingzi.text = @"工作性质：";
    xingzi.textColor = textcolor;
    xingzi.font = titleFont;
    [mainScrollView addSubview:xingzi];
    
    UILabel *xingzi2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, [InitData Width] - 10, 20)];
    xingzi2.text = @"全职";
    xingzi2.textColor = textcolor;
    xingzi2.font = titleFont;
    [mainScrollView addSubview:xingzi2];
    height += 20;
    
    
    UILabel *hangye = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    hangye.text = @"期望行业：";
    hangye.textColor = textcolor;
    hangye.font = titleFont;
    [mainScrollView addSubview:hangye];
    
    UILabel *hangye2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 70, 20)];
    hangye2.textColor = textcolor;
    hangye2.text = @"计算机软件";
    hangye2.font = font;
    [mainScrollView addSubview:hangye2];
    height += 20;
    
    UILabel *didian = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    didian.text = @"期望地点：";
    didian.textColor = textcolor;
    didian.font = titleFont;
    [mainScrollView addSubview:didian];
    
    UILabel *didian2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 70, 20)];
    didian2.textColor = textcolor;
    didian2.text = @"北京";
    didian2.font = font;
    [mainScrollView addSubview:didian2];
    height += 20;
    
    UILabel *xinzi = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    xinzi.text = @"期望薪资：";
    xinzi.textColor = textcolor;
    xinzi.font = titleFont;
    [mainScrollView addSubview:xinzi];
    
    UILabel *xinzi2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 170, 20)];
    xinzi2.textColor = textcolor;
    xinzi2.text = @"50000及以上/月";
    xinzi2.font = font;
    [mainScrollView addSubview:xinzi2];
    height += 20;
    
    UILabel *zhineng = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 65, 20)];
    zhineng.text = @"目标职能：";
    zhineng.textColor = textcolor;
    zhineng.font = titleFont;
    [mainScrollView addSubview:zhineng];
    
    UILabel *zhineng2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 170, 20)];
    zhineng2.textColor = textcolor;
    zhineng2.text = @"高级软件工程师";
    zhineng2.font = font;
    [mainScrollView addSubview:zhineng2];
    height += 25;
    
}

- (void) evaluation{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = @"  自我评价";
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 60)];
    label.numberOfLines = 0;
    label.text = @"asdfasdfasdfasdfasdfdsf";
    label.textColor =textcolor;
    label.font = font;
    [mainScrollView addSubview:label];
    height += 65;
}

- (void) education{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = @"  教育经历";
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
    label1.textColor = textcolor;
    label1.font = font;
    label1.text = [NSString stringWithFormat:@"%@-%@  %@", @"2009/9", @"2012/6", @"北京邮电大学｜硕士"];
    [mainScrollView addSubview:label1];
    height += 25;
    
    /****************************************
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, height, [InitData Width] - 20, 1)];
     [view drawRect:CGRectMake(0, 0, 110, 1)];
     [mainScrollView addSubview:view];
     *****************************************************************/
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
    label2.textColor = textcolor;
    label2.font = font;
    label2.text = [NSString stringWithFormat:@"%@-%@  %@", @"2009/9", @"2012/6", @"北京邮电大学｜本科"];
    [mainScrollView addSubview:label2];
    height += 25;
}

- (void) work{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = @"  工作经验";
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 80, 20)];
    time.textColor = textcolor;
    time.font = font;
    time.text = @"2011/6-2014/3";
    [mainScrollView addSubview:time];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, height, 100, 20)];
    label.textColor = textcolor;
    label.font = font;
    label.text = [NSString stringWithFormat:@"%@|%@", @"泰联科技", @"硕士"];
    [mainScrollView addSubview:label];
    height += 20;
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 60)];
    content.textColor = textcolor;
    content.font = font;
    content.text = @"sdfsadf";
    content.numberOfLines = -1;
    [mainScrollView addSubview:content];
    height += 60;
}

- (void) train{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [mainScrollView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake( 5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = @"  培训经历";
    intent.textColor = textcolor;
    intent.font = titleFont;
    [mainScrollView addSubview:intent];
    height += 25;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 80, 20)];
    time.textColor = textcolor;
    time.font = font;
    time.text = @"2011/6-2014/3";
    [mainScrollView addSubview:time];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, height, 100, 20)];
    label.textColor = textcolor;
    label.font = font;
    label.text = [NSString stringWithFormat:@"%@|%@", @"泰联科技", @"硕士"];
    [mainScrollView addSubview:label];
    height += 20;
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 60)];
    content.textColor = textcolor;
    content.font = font;
    content.text = @"sdfsadf";
    content.numberOfLines = -1;
    [mainScrollView addSubview:content];
    height += 60;
}

- (void) base{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [InitData Height] - 50, [InitData Width], 1)];
    [view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [self.view addSubview:view];
    
    UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
    [download setFrame:CGRectMake(0, [InitData Height] - 50, [InitData Width] - 60, 50)];
    [download setTitle:@"下载简历" forState:UIControlStateNormal];
    //download.titleLabel.textColor = [UIColor orangeColor];
    [download setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:download];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 60, [InitData Height] - 50, 1, 40)];
    [view2 setBackgroundColor:view.backgroundColor];
    [self.view addSubview:view2];
    
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    [collect setImage:[UIImage imageNamed:@"smille_shop_no.png"] forState:UIControlStateNormal];
    [collect setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateSelected];
    [collect setFrame:CGRectMake([InitData Width] - (60 - 15) / 2 - 15, [InitData Height] - 40, 15, 15)];
    [collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    collect.selected = NO;
    [self.view addSubview:collect];
    
    UILabel *collectlab = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 10 - 30, [InitData Height] - 25, 20, 10)];
    collectlab.textColor = textcolor;
    collectlab.font = [UIFont systemFontOfSize:10];
    collectlab.text = @"收藏";
    [self.view addSubview:collectlab];
}

- (void) download:(UIButton*) but{

}
- (void) collect:(UIButton*) but{
    but.selected = !but.selected;
    if (but.selected){
        
        return;
    }
    
}
- (void) remarkClicked{
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    NSArray * arr = [NSArray arrayWithObjects:@"符合要求", @"不符合要求", @"需要会和您联系", nil];
    [alertView setDirection:Y andTitle:@"备注简历" andMessage:nil andArray:arr];
    alertView.delegate = self;
    [self.view addSubview:alertView];
}
- (void) customAlertViewbuttonClicked:(int)index{
    switch (index) {
        case 0:

            break;
        case 1:
            
            break;
        default:
            
            break;
    }
}
@end
