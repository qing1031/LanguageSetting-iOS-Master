//
//  IntruduceViewController.m
//  74cms
//
//  Created by lyp on 15/5/5.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "IntruduceViewController.h"
#import "InitData.h"

@interface IntruduceViewController ()<UITextViewDelegate>{
    UITextView *mainText;
    UILabel *label;
    UILabel *num;
    
    NSString *content;
}

@end

@implementation IntruduceViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setTitle:(NSString *)title{
    [self.myNavigationController setTitle:title];
    label.text = MYLocalizedString(@"请简要叙述职位的功能及要求！", @"Please briefly describe the functions and requirements of the position!");
    
    if ([title isEqualToString:MYLocalizedString(@"自我描述", @"Self description")]){
        label.text = MYLocalizedString(@"请简要叙述对自己的评价。避免使用一些空洞老套的话。", @"Please briefly describe your own evaluation. Avoid the use of some empty old words.");
    }
}
- (void) setContent:(NSString*) str{
    content = str;
    if (mainText != nil)
        mainText.text = str;
    if (label != nil){
        [label removeFromSuperview];
        label = nil;
    }
}
- (void) drawView{
    
    mainText = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, [InitData Width] - 20, [InitData Height] - 40)];
    mainText.delegate = self;
    mainText.font = [UIFont systemFontOfSize:14];
    //mainText.returnKeyType = UIReturnKeyDone;
    if (content != nil)
        mainText.text = content;
    [self.view addSubview:mainText];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, [InitData Width] - 24, 30)];
    label.text = MYLocalizedString(@"输入对公司的简要介绍。", @"Enter a brief introduction of the company.");
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.enabled = NO;
    [self.view addSubview:label];
    
    num = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 60, mainText.frame.origin.y + mainText.frame.size.height - 40, 60, 30)];
    num.textColor = [UIColor colorWithRed:205./255 green:205./255 blue:205./255 alpha:1];
    num.font = [UIFont systemFontOfSize:13];
    num.text = [NSString stringWithFormat:@"%d/200",0];
    [self.view addSubview:num];
}

- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    
    [self.myNavigationController setTitle:MYLocalizedString(@"公司简介", @"Company profile")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"保存", @"Save") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 50, 50)];
    but.titleLabel.font = [UIFont systemFontOfSize:13];
    NSArray *arr = [NSArray arrayWithObject:but];
    
    [self.myNavigationController setRightBtn:arr];
}

- (void) saveInfo{
    [mainText resignFirstResponder];
  //  NSLog(@"%s, %@", __func__, mainText.text);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(IntruduceGetContent:andGetNum:)]){
        [self.delegate IntruduceGetContent:mainText.text andGetNum:mainText.text.length];
        [self.myNavigationController dismissViewController];
    }
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
    num.text = [NSString stringWithFormat:@"%u/200", str.length];
}

@end
