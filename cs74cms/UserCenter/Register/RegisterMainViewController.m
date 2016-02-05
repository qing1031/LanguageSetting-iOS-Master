//
//  RegisterMainViewController.m
//  74cms
//
//  Created by LPY on 15-4-13.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "RegisterMainViewController.h"
#import "InitData.h"
#import "RegisterViewController.h"
#import "EditCompanyViewController.h"

@interface RegisterMainViewController ()

@end

@implementation RegisterMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) drawView{
    float y = ([InitData Height] - 80 - [InitData Width]) / 2;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"color.jpg"]]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainImg.png"]];
    [imgView setFrame:CGRectMake(0, y, [InitData Width], [InitData Width])];
    [self.view addSubview:imgView];
    
    
    UIButton *gerenzhuce = [UIButton buttonWithType:UIButtonTypeCustom];
    [gerenzhuce setImage:[UIImage imageNamed:@"gerenzhuce.jpg"] forState:UIControlStateNormal];
    [gerenzhuce setImage:[UIImage imageNamed:@"gerenzhuceSelected.jpg"] forState:UIControlStateHighlighted];
    [gerenzhuce addTarget:self action:@selector(gerenzhuce) forControlEvents:UIControlEventTouchUpInside];
    [gerenzhuce setFrame:CGRectMake(20, [InitData Height] - 80, 130, 44)];
    [self.view addSubview:gerenzhuce];
    
    
    UIButton *qiyezhuce = [UIButton buttonWithType:UIButtonTypeCustom];
    [qiyezhuce setImage:[UIImage imageNamed:@"qiyezhuce.jpg"] forState:UIControlStateNormal];
    [qiyezhuce setImage:[UIImage imageNamed:@"qiyezhuceSelected.jpg"] forState:UIControlStateHighlighted];
    [qiyezhuce addTarget:self action:@selector(qiyezhuce) forControlEvents:UIControlEventTouchUpInside];
    [qiyezhuce setFrame:CGRectMake([InitData Width] - 20 - 130, gerenzhuce.frame.origin.y, 130, 44)];
    [self.view addSubview:qiyezhuce];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.view subviews] count] <= 0)
       [ self drawView];
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0)
        [ self drawView];
    [self.myNavigationController setTitle:MYLocalizedString(@"注册", @"Register")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gerenzhuce{
    if (self.myNavigationController != nil){
        RegisterViewController *reg = [[RegisterViewController alloc] init];
        [reg setType:2];
        [self.myNavigationController pushAndDisplayViewController:reg];
    }
}
- (void) qiyezhuce{
    if (self.myNavigationController != nil){
        RegisterViewController *reg = [[RegisterViewController alloc] init];
        [reg setType:1];
        [self.myNavigationController pushAndDisplayViewController:reg];
    }
}
@end
