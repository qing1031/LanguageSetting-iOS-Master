//
//  MicroResumeViewController.m
//  74cms
//
//  Created by lyp on 15/5/1.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MicroResumeViewController.h"
#import "InitData.h"
#import "EditResumeViewController.h"
#import "ITF_Other.h"
#import "T_Resume.h"

@interface MicroResumeViewController (){
    float height;
    int Mid;
    
    T_Resume *resume;
}

@end

@implementation MicroResumeViewController

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
            resume = [[[ITF_Other alloc] init] simpleResumeShowByID:Mid];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                [self topView];
                [self selfValue];
                [self contact];
            });
        });
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"微简历", @"Micro resume")];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
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
- (void) topView{
    UIFont *font = [UIFont systemFontOfSize:13];
    UIColor *textcolor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
    name.text = resume.fullname;
    name.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:name];
    
    UILabel *updateTime = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, 160, 30)];
    updateTime.text = [NSString stringWithFormat:MYLocalizedString(@"更新于%@", @"Update in%@"), resume.refreshtime];
    updateTime.textColor = [UIColor colorWithRed:102.0/255 green:102./255 blue:102./255 alpha:1];
    updateTime.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:updateTime];
    
    UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 250, 15)];
    sex.text = [NSString stringWithFormat:MYLocalizedString(@"%@|%@岁|%@", @"%@|%@age|%@"),resume.sex_cn, resume.birthdate, resume.experience_cn];
    sex.font = font;
    sex.textColor = textcolor;
    [self.view addSubview:sex];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 68, 70, 15)];
    label1.font = font;
    label1.textColor = textcolor;
    label1.text = MYLocalizedString(@"意向职位：", @"Intentional position:");
    [self.view addSubview:label1];
    
    UILabel *residence = [[UILabel alloc] initWithFrame:CGRectMake(80, 68, 150, 15)];
    residence.textColor = textcolor;
    residence.font =font;
    residence.text = resume.intention_jobs;
    [self.view addSubview:residence];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 70, 15)];
    label2.font = font;
    label2.textColor = textcolor;
    label2.text = MYLocalizedString(@"意向地区：", @"Intentional district:");
    [self.view addSubview:label2];
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(80, 85, 150, 15)];
    state.textColor = textcolor;
    state.font =font;
    state.text = resume.district_cn;
    [self.view addSubview:state];
    
    height = 100;
}

- (void) selfValue{
    UIColor *textcolor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    UIView *seperate = [[UIView alloc]initWithFrame:CGRectMake(0, 108, [InitData Width], 1)];
    seperate.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [self.view addSubview:seperate];
    height += 20;
    
    UIView *sign= [[UIView alloc] initWithFrame:CGRectMake(20, 120, 3, 14)];
    [sign setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [self.view addSubview:sign];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 120, 100, 14)];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = textcolor;
    title.text = MYLocalizedString(@"自我描述", @"Self description");
    [self.view addSubview:title];
    height += 20;
    
    NSString *str = resume.specialty;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake([InitData Width] - 40, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
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
    people.text =MYLocalizedString(@"联系人:", @"Contacts:");
    people.textColor = textcolor;
    people.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:people];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(73, height, 100, 14)];
    name.text = resume.fullname;
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
    telephone.text = resume.telephone;
    telephone.tag = 1800;
    telephone.textColor = textcolor;
    telephone.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:telephone];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(175, height - 3, 15, 18)];
    [but addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"man_phone.png"] forState:UIControlStateNormal];
    [self.view addSubview:but];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) save{
    EditResumeViewController *edit = [[EditResumeViewController alloc] init];
    [edit setMid:Mid];
    [self.myNavigationController pushAndDisplayViewController:edit];
}

@end
