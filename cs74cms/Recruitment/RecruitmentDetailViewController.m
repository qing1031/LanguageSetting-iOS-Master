//
//  RecruitmentDetailViewController.m
//  74cms
//
//  Created by lyp on 15/5/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "RecruitmentDetailViewController.h"
#import "InitData.h"
#import "T_Jobfair.h"
#import "ITF_Other.h"
#import "MapBigViewController.h"

@interface RecruitmentDetailViewController (){
    UIScrollView *backView;
    
    float height;
    
    int RID;
    
    UIFont *font;
    UIFont *titlefont;
    UIColor *textcolor;
    
    T_Jobfair *jobfair;
}

@end

@implementation RecruitmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void) viewCanBeSee{

    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        jobfair = [[[ITF_Other alloc] init] jobfairShowByID:RID];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self drawView];
        });
    });
    
    
    [self.myNavigationController setTitle: MYLocalizedString(@"招聘会详情", @"Recruitment details") ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setRID:(int) tRid{
    RID = tRid;
}
- (void) drawView{
    backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width],[InitData Height])];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.showsHorizontalScrollIndicator = NO;
    backView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backView];
    
    
    [self topView];
    [self introduce];
    [self canhui];
    [self contact];
}

- (void) topView{
    height = 0;
    font = [UIFont systemFontOfSize:13];
    titlefont = [UIFont systemFontOfSize:14];
    textcolor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    
    CGSize size0 = [jobfair.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([InitData Width] - 30,200) lineBreakMode:NSLineBreakByCharWrapping];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, [InitData Width] - 30, size0.height)];
    title.textColor = textcolor;
    title.font = [UIFont systemFontOfSize:15];
    title.text = jobfair.title;
    title.numberOfLines = 0;
    [backView addSubview:title];
    height = size0.height + 15 + 5;
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 65, 15)];
    date.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    date.font = [UIFont systemFontOfSize:13];
    date.text = MYLocalizedString(@"举办范围：", @"Holding range:");
    [backView addSubview:date];
    
    UILabel *date1 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 250, 15)];
    date1.textColor = title.textColor;
    date1.font = date.font;
    date1.text = [NSString stringWithFormat:@"%@ - %@", jobfair.holddate_start, jobfair.holddate_end];
    [backView addSubview:date1];
    height += 20;
    
    UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 65, 15)];
    place.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    place.font = [UIFont systemFontOfSize:13];
    place.text = MYLocalizedString(@"举办地点：", @"Holding place:");
    [backView addSubview:place];
    
    CGSize size = [jobfair.address sizeWithFont:date.font constrainedToSize:CGSizeMake([InitData Width] - 100, 100)];
    UILabel *place1 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, size.width, size.height)];
    place1.textColor = title.textColor;
    place1.numberOfLines = 0;
    place1.font = date.font;
    place1.text = jobfair.address;
    [backView addSubview:place1];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(size.width + 80 - 15, height - 15, 45, 45)];
    [but setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [but setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:but];
    
    height += size.height + 10;
}
- (void) introduce{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [backView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  招聘会介绍", @"Recruitment meeting introduce") ;
    intent.textColor = textcolor;
    intent.font = titlefont;
    [backView addSubview:intent];
    height += 30;
    
    CGSize size = [jobfair.introduction sizeWithFont:font constrainedToSize:CGSizeMake([InitData Width] - 40,8000) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, size.height)];
    label.numberOfLines = 0;
    label.attributedText = [InitData getMutableAttributedStringWithString:jobfair.introduction];
    label.textColor =textcolor;
    label.font = font;
    [backView addSubview:label];
    height += size.height + 10;
}

- (void) canhui{
    
    if (jobfair.trade_cn == nil ||([jobfair.trade_cn count] == 1 && [[jobfair.trade_cn objectAtIndex:0] isEqualToString:@""]))
        return;
    
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [backView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  参会行业", @"Participating introduce");
    intent.textColor = textcolor;
    intent.font = titlefont;
    [backView addSubview:intent];
    height += 25;

    for (int i=0; i<[jobfair.trade_cn count]; i++){
        UIImageView *imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, height, 15, 15)];
        imgview1.image = [UIImage imageNamed:@"star.png"];
        [backView addSubview:imgview1];
    
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, height, 200, 15)];
        label1.textColor = textcolor;
        label1.font = font;
        label1.text = [jobfair.trade_cn objectAtIndex:i];
        [backView addSubview:label1];
        height += 20;
    }
    
    height += 10;
}
- (void) contact{
    UIView *sign1 = [[UIView alloc]initWithFrame:CGRectMake(0, height, 5, 20)];
    [sign1 setBackgroundColor:[UIColor colorWithRed:16./255 green:100./255 blue:163./255 alpha:1]];
    [backView addSubview:sign1];
    
    UILabel *intent = [[UILabel alloc] initWithFrame:CGRectMake(5, height, [InitData Width] - 5, 20)];
    [intent setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    intent.text = MYLocalizedString(@"  联系方式", @"Contact information") ;
    intent.textColor = textcolor;
    intent.font = titlefont;
    [backView addSubview:intent];
    height += 25;
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 52, 15)];
    date.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    date.font = [UIFont systemFontOfSize:13];
    date.text = MYLocalizedString(@"联系人：", @"Contacts:");
    [backView addSubview:date];
    
    UILabel *date1 = [[UILabel alloc] initWithFrame:CGRectMake(67, height, 200, 15)];
    date1.textColor =textcolor;
    date1.font = date.font;
    date1.text = MYLocalizedString(@"2015年4月1日", @"April 1, 2015");
    [backView addSubview:date1];
    height += 20;
    
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 65, 15)];
    time.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    time.font = [UIFont systemFontOfSize:13];
    time.text = MYLocalizedString(@"联系电话：", @"Contact:");
    [backView addSubview:time];
    
    UILabel *time1 = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 200, 15)];
    time1.textColor = textcolor;
    time1.font = date.font;
    time1.tag = 1800;
    time1.text = @"12345678901";
    [backView addSubview:time1];

    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(175, height - 3, 15, 18)];
    [but addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"man_phone.png"] forState:UIControlStateNormal];
    [backView addSubview:but];
    
    height += 25;
    
    [backView setContentSize:CGSizeMake([InitData Width], height)];
}
- (void) locationClick{
    MapBigViewController *map = [[MapBigViewController alloc] init];
    [map setLat:jobfair.lat andLon:jobfair.lon andIsJob:YES];
    [self.myNavigationController pushAndDisplayViewController:map];
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
