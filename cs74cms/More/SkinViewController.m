//
//  SkinViewController.m
//  74cms
//
//  Created by lyp on 15/4/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SkinViewController.h"
#import "InitData.h"

@interface SkinViewController ()

@end

@implementation SkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle: MYLocalizedString(@"更换皮肤", @"Change skin") ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    float cellHeight = 40;
    float height = 1;
    NSArray *arr = [[NSArray alloc] initWithObjects: MYLocalizedString(@"默认", @"default"),MYLocalizedString(@"蓝色", @"blue"), nil];
    NSArray *skin = [NSArray arrayWithObjects:@"black", @"blue", nil];//存储色值
    
    UIFont *font1 = [UIFont systemFontOfSize:14];

    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];

    for (int i=0; i<2; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        view.tag = i + 1;
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseSkin:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        [imgView setImage:[UIImage imageNamed:@"white_dui1.png"]];
        [view addSubview:imgView];
        NSString *str;
        if ((str = [[NSUserDefaults standardUserDefaults] valueForKey:@"skinColor"]) != nil){
            if ([str isEqualToString: [skin objectAtIndex:i]]){
                [imgView setImage:[UIImage imageNamed:@"white_dui.png"]];
            }
        }
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
        [view addSubview:img];
        
        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 12, (cellHeight + 1) * 1)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 12, 30, 12, (cellHeight + 1) * 1)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
}

- (void) choseSkin:(UITapGestureRecognizer*) recognizer{

    long t = recognizer.view.tag - 1;
    
    NSString *str= [NSString stringWithFormat:@"%s",t==0?"black":"blue"];
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"skinColor"];
    
    UIView *view = [[self.view subviews] objectAtIndex:t];
    UIImageView *imgView = [[view subviews] objectAtIndex:0];
    [imgView setImage:[UIImage imageNamed:@"white_dui.png"]];
    
    UIView *view2 = [[self.view subviews] objectAtIndex:t == 0?1:0];
    UIImageView *imgView2 = [[view2 subviews] objectAtIndex:0];
    [imgView2 setImage:[UIImage imageNamed:@"white_dui1.png"]];
    
    [self.myNavigationController setNavigationBarColor:[InitData getSkinColor]];
    
}

@end
