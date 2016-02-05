//
//  MicroZhaoPinViewController.m
//  74cms
//
//  Created by lyp on 15/5/1.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MicroZhaoPinViewController.h"
#import "InitData.h"
#import "PublicJobViewController.h"

#import "ITF_Other.h"

@interface MicroZhaoPinViewController (){
    float height;
    int Mid;
    
    T_AddJob *job;
    
}

@end

@implementation MicroZhaoPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            job = [[[ITF_Other alloc] init] simpleZhaopinShowByID:Mid];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{

                [InitData haveLoaded:self.view];
                [self topView];
                [self selfValue];
                [self contact];
            });
        });
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"微招聘", @"Micro recruitment")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(editZhaopin) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"编辑", @"Edit") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
}

- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void) setMID:(int) tMid{
    Mid = tMid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) topView{
    UIFont *font = [UIFont systemFontOfSize:13];
    UIColor *textcolor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    name.text = job.jobs_name;
    name.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:name];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 51, 18, 18)];
    [imgView setImage:[UIImage imageNamed:@"watch.png"]];
    [self.view addSubview:imgView];
    
    UILabel *updateTime = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, 100, 30)];
    updateTime.text = job.olddeadline;
    updateTime.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    updateTime.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:updateTime];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(130, 55, 25, 12)];
    [imgView2 setImage:[UIImage imageNamed:@"eye.png"]];
    [self.view addSubview:imgView2];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(155, 45, 100, 30)];
    time.text = [NSString stringWithFormat:MYLocalizedString(@"浏览%d次", @"Browse%d times"),job.click];
    time.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    time.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:time];
    height = 75;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 1)];
    [view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [self.view addSubview:view];
    height += 10;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 70, 15)];
    label1.font = font;
    label1.textColor = textcolor;
    label1.text = MYLocalizedString(@"公司名称：", @"Company name:");
    [self.view addSubview:label1];
    
    UILabel *ans1 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 150, 15)];
    ans1.textColor = textcolor;
    ans1.font =font;
    ans1.text = job.companyname;
    [self.view addSubview:ans1];
    height += 20;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 70, 15)];
    label2.font = font;
    label2.textColor = textcolor;
    label2.text = MYLocalizedString(@"工作地点：", @"Working area:");
    [self.view addSubview:label2];
    
    UILabel *ans2 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 150, 15)];
    ans2.textColor = textcolor;
    ans2.font =font;
    ans2.text = job.district_cn;
    [self.view addSubview:ans2];
    height += 20;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 70, 15)];
    label3.font = font;
    label3.textColor = textcolor;
    label3.text = MYLocalizedString(@"招聘人数:", @"Recruitment number:");
    [self.view addSubview:label3];
    
    UILabel *ans3 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 150, 15)];
    ans3.textColor = textcolor;
    ans3.font =font;
    ans3.text = [NSString stringWithFormat:MYLocalizedString(@"%d人", @"%d person"), job.amount];
    [self.view addSubview:ans3];
    height += 20;
}

- (void) selfValue{
    UIColor *textcolor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    UIView *seperate = [[UIView alloc]initWithFrame:CGRectMake(0, height + 8, [InitData Width], 1)];
    seperate.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [self.view addSubview:seperate];
    height += 20;
    
    UIView *sign= [[UIView alloc] initWithFrame:CGRectMake(20, height, 3, 14)];
    [sign setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [self.view addSubview:sign];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, height, 100, 14)];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = textcolor;
    title.text = MYLocalizedString(@"职位要求", @"Job requirements");
    [self.view addSubview:title];
    height += 20;
    
    NSString *str = job.contents;
    CGSize size =
    [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake([InitData Width] - 40, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, size.width, size.height)];
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:13];
    if (str != nil)
        label.attributedText = [InitData getMutableAttributedStringWithString:str];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    height += size.height + 10;
}
- (void) contact{
    UIColor *textcolor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    
    UIView *sign= [[UIView alloc] initWithFrame:CGRectMake(20, height, 3, 14)];
    [sign setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [self.view addSubview:sign];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, height, 100, 14)];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = textcolor;
    title.text = MYLocalizedString(@"联系方式", @"Contact information");
    [self.view addSubview:title];
    height += 20;
    
    UILabel *people = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 53, 14)];
    people.text = MYLocalizedString(@"联系人:", @"Contacts:");
    people.textColor = textcolor;
    people.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:people];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(73, height, 100, 14)];
    name.text = job.contact;
    name.textColor = textcolor;
    name.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:name];
    
    height += 20;
    
    
    UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 67, 14)];
    tel.text = MYLocalizedString(@"联系电话:", @"Contact phone:");
    tel.textColor = textcolor;
    tel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tel];
    
    UILabel *telephone = [[UILabel alloc] initWithFrame:CGRectMake(87, height, 100, 14)];
    telephone.text = job.telephone;
    telephone.textColor = textcolor;
    telephone.tag = 1800;
    telephone.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:telephone];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(175, height - 3, 15, 18)];
    [but addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"man_phone.png"] forState:UIControlStateNormal];
    [self.view addSubview:but];
}

#pragma mark event
- (void) editZhaopin{
    PublicJobViewController *zhao = [[PublicJobViewController alloc] init];
    [zhao setMid:Mid];
    [self.myNavigationController pushAndDisplayViewController:zhao];
}

- (void) call:(UIButton*) but{
    UIView *sup = [but superview];
    NSArray *arr = [sup subviews];
    NSMutableString *phone = [NSMutableString stringWithString:@"tel://"];
    for (int i=0; i<[arr count]; i++){
        UIView *view = [arr objectAtIndex:i];
        if (view.tag == 1800){
            [phone appendString:((UILabel*)view).text];
            break;
        }
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}
@end
