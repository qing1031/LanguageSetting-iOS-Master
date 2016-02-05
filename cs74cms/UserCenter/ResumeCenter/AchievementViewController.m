//
//  AchievementViewController.m
//  cs74cms
//
//  Created by lyp on 15/5/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "AchievementViewController.h"
#import "InitData.h"

@interface AchievementViewController ()<UITextViewDelegate>{
    UITextView *mainText;
    UILabel *label;
    
    int pid;//简历的id
    NSString *content;
}
@end

@implementation AchievementViewController

@synthesize delegate;

- (void) drawView{
    
    mainText = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, [InitData Width] - 20, [InitData Height] - 40)];
    mainText.delegate = self;
    mainText.font = [UIFont systemFontOfSize:14];
    //mainText.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:mainText];
    if (content != nil)
        mainText.text = content;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, [InitData Width] - 24, 45)];
    label.text = MYLocalizedString(@"输入你对自己工作职责的简短描述", @"Enter a short description of your job responsibilities.");
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.enabled = NO;
    [self.view addSubview:label];
}

- (void) setTitle:(NSString *)title andTishi:(NSString*) tishi{
    [self.myNavigationController setTitle:title];
    label.text = tishi;
}

- (void) setContent:(NSString*) str{
    content = str;
    if (mainText != nil){
        mainText.text = str;
    }
    if (label != nil){
        [label removeFromSuperview];
        label = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"职责介绍", @"Responsibility introduction")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"保存", @"Save") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 50, 50)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObject:but];
    
    [self.myNavigationController setRightBtn:arr];
    
}

- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -event

- (void) saveInfo:(UIButton*) but{
    [mainText resignFirstResponder];
    but.userInteractionEnabled = NO;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(achievementScanf:)]){
        [self.delegate achievementScanf:mainText.text];
    }
    [self.myNavigationController dismissViewController];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return  NO;
    }
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView{
    NSString *str = textView.text;
    
    if (str.length == 0){
        label.hidden = NO;
    }
    else{
        label.hidden = YES;
    }
}



@end
