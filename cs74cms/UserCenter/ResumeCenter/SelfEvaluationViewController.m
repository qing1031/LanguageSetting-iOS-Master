//
//  SelfEvaluationViewController.m
//  74cms
//
//  Created by niko on 15/4/20.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SelfEvaluationViewController.h"
#import "InitData.h"
#import "T_Interface.h"

@interface SelfEvaluationViewController ()<UITextViewDelegate>{
    UITextView *mainText;
    UILabel *label;
    
    int pid;//简历的id
    NSString *content;
}

@end

@implementation SelfEvaluationViewController


- (void) drawView{
    
    mainText = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, [InitData Width] - 20, [InitData Height] - 40)];
    mainText.delegate = self;
    mainText.font = [UIFont systemFontOfSize:14];
    //mainText.returnKeyType = UIReturnKeyDone;

    [self.view addSubview:mainText];
    if (content != nil)
        mainText.text = content;
   
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, [InitData Width] - 24, 45)];
    label.text = MYLocalizedString(@"输入你对自己的简短评价。请简明扼要的说明你最大的优势是什么，避免使用一些空洞老套的话。", @"Enter your brief evaluation of yourself. Please explain the concise and to the point what is your biggest advantage, avoid the use of some empty old words.");
    label.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.enabled = NO;
    [self.view addSubview:label];
    
}

- (void) setPid:(int) tpid{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
    
    T_User * user = [InitData getUser];
    pid = tpid;
    T_Resume *resume = [[[T_Interface alloc] init] PersonalSpecialtyByUsername:user.username andUserpwd:user.userpwd andPid:pid andSpecialty:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (resume.specialty== nil || ![resume.specialty isEqualToString:@""]){
                mainText.text = resume.specialty;
                label.hidden = YES;
            }
        });
    });
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
    
    [self.myNavigationController setTitle:MYLocalizedString(@"自我评价", @"Self evaluation")];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"保存", @"Save")forState:UIControlStateNormal];
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
   // NSLog(@"%s, %@", __func__, mainText.text);
    [InitData isLoading:self.view];
    but.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User * user = [InitData getUser];
        T_Resume *resume = [[[T_Interface alloc] init] PersonalSpecialtyByUsername:user.username andUserpwd:user.userpwd andPid:pid andSpecialty:mainText.text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            but.userInteractionEnabled = YES;
            if ([InitData NetIsExit] && resume == nil){
                [InitData netAlert:MYLocalizedString(@"资料保存失败!", @"Data save failed!")];
                return;
            }
            [self.myNavigationController dismissViewController];
        });
    });
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
