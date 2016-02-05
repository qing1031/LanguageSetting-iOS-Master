//
//  FeekbackViewController.m
//  74cms
//
//  Created by lyp on 15/4/29.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "FeekbackViewController.h"
#import "InitData.h"
#import "ITF_Other.h"

@interface FeekbackViewController ()<UITextViewDelegate, UITextFieldDelegate>{
    UITextView *mainText;
    UITextField *telText;
    UILabel *label;
    UILabel *num;
    
    UIButton * selected;
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
}

@end

@implementation FeekbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    if ([[self.view subviews] count] <= 0){
        [self drawView];
        [self registerKeyBoardNotification];
    }
}
- (void) viewCanBeSee{
    if ([[self.view subviews] count] <= 0){
        [self drawView];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"用户反馈", @"User feedback") ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    UILabel *leixin = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 30)];
    leixin.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    leixin.font = [UIFont systemFontOfSize:15];
    leixin.text = MYLocalizedString(@"反馈类型:", @"Feedback type：");
    [self.view addSubview:leixin];
    
    selected = nil;
    
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"意见", @"Opinion"), MYLocalizedString(@"建议", @"Suggest"),MYLocalizedString(@"求助", @"Help"), MYLocalizedString(@"投诉", @"Complaint"), nil];
    
    float width = 15 + 70;
    for (int i=0; i<4; i++){
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(width, 27, 15, 15)];
        [but setImage:[UIImage imageNamed:@"white_dui1.png"] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"white_dui.png"] forState:UIControlStateSelected];
        but.tag = i + 1;
        [but addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        UILabel *labelt = [[UILabel alloc] initWithFrame:CGRectMake(width + 17, 20, 30, 30)];
        labelt.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
        labelt.font = [UIFont systemFontOfSize:15];
        labelt.text = [arr objectAtIndex:i];
        labelt.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:labelt];
        
        width += 55;
    }
    
    mainText = [[UITextView alloc] initWithFrame:CGRectMake(15, 60, [InitData Width] - 30, 180)];
    mainText.delegate = self;
    [mainText setBackgroundColor:[UIColor whiteColor]];
    mainText.layer.cornerRadius = 5;
    mainText.layer.borderColor = [UIColor colorWithRed:202./255 green:202./255 blue:202./255 alpha:1].CGColor;
    mainText.layer.borderWidth = 1;
    mainText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:mainText];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 67, [InitData Width] - 40, 15)];
    label.text = MYLocalizedString(@"请输入您的反馈意见(200字以内)", @"Please enter your feedback (200 words or less)");
    label.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    label.enabled = NO;
    [self.view addSubview:label];
    
    num = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 60, mainText.frame.origin.y + mainText.frame.size.height - 40, 60, 30)];
    num.textColor = [UIColor colorWithRed:205./255 green:205./255 blue:205./255 alpha:1];
    num.font = [UIFont systemFontOfSize:13];
    num.text = [NSString stringWithFormat:@"%d/200",0];
    [self.view addSubview:num];
    
    
    UILabel *llabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 255, 80, 20)];
    llabel.text = MYLocalizedString(@"联系方式:",@"Contact");
    llabel.font = [UIFont systemFontOfSize:15];
    llabel.textColor = leixin.textColor;
    [self.view addSubview:llabel];
    
    telText = [[UITextField alloc] initWithFrame:CGRectMake(90, 250, [InitData Width] - 90 - 15, 30)];
    telText.textColor = mainText.textColor;
    telText.backgroundColor = [UIColor whiteColor];
    telText.layer.borderColor = mainText.layer.borderColor;
    telText.layer.borderWidth = 1;
    telText.layer.cornerRadius = 5;
    telText.font = [UIFont systemFontOfSize:13];
    telText.delegate = self;
    telText.placeholder = MYLocalizedString(@"请输入您的联系方式",@"Please enter your contact information");
    [self.view addSubview:telText];
    
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(15, 295, [InitData Width] - 30, 35)];
    [but setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"butColor.png"]]];
    [but setTitle:MYLocalizedString(@"提交", @"Submit") forState:UIControlStateNormal];
    but.layer.cornerRadius = 5;
    [but addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
}

- (void) selected:(UIButton*) but{
    if (selected == but)
        return;
    if (selected != nil){
        selected.selected = NO;
    }
    
    but.selected = YES;
    selected = but;
}
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return  NO;
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
    num.text = [NSString stringWithFormat:@"%ld/200", (unsigned long)str.length];
}
- (void) submitClicked:(UIButton*) but{
    if(selected == nil){
        [InitData netAlert:MYLocalizedString(@"请选择反馈类型", @"Please select the type of feedback")];
        return;
    }
    if ([mainText.text isEqualToString:@""]){
        [InitData netAlert:MYLocalizedString(@"反馈内容不能为空", @"Feedback content can not be empty")];
        return;
    }
    if ([telText.text isEqualToString:@""]){
        [InitData netAlert:MYLocalizedString(@"联系方式不能为空", @"Contact can not be empty")];
        return;
    }
    [telText resignFirstResponder];
    [mainText resignFirstResponder];
    
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        int t = [[[ITF_Other alloc] init] suggestByInfotype:selected.tag andFeedback:mainText.text andTel:telText.text];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (t > 0){
                [InitData netAlert:MYLocalizedString(@"反馈成功！", @"Feedback success!")];
                [self.myNavigationController dismissViewController];
                return ;
            }
            else{
                [InitData netAlert:MYLocalizedString(@"反馈失败", @"Feedback failure")];
            }
            
        });
    });
}


#pragma mark- 键盘通知事件 ［核心代码］
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    i_textFieldY = [self getAllY:textField];
    i_textFieldHeight = textField.frame.size.height;
    
    // float bottom = [InitData Height] - allY - textField.frame.size.height;
}

//注册键盘监听消息
-(void)registerKeyBoardNotification
{
    //增加监听，当键盘出现或改变时收出消息    ［核心代码］
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    //计算偏移量
    i_offset = keyboardHeight - ([InitData Height]-(i_textFieldY+i_textFieldHeight));
    
    //进行偏移
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    UIView *view = self.view;
    
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    if(i_offset > 0)
    {
        CGRect rect = CGRectMake(0.0f,-i_offset,width,height); //把整个view 往上提，肯定要用负数 y
        view.frame = rect;
    }
    
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(i_offset > 0)
    {
        //恢复到偏移前的正常量
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        UIView *view = self.view;
        float width = view.frame.size.width;
        float height = view.frame.size.height;
        CGRect rect = CGRectMake(0.0f,0,width,height); //把整个view 往上提，肯定要用负数 y   注意self.view 的y 是从20开始的，即StautsBarHeight
        
        view.frame = rect;
        
        [UIView commitAnimations];
    }
    
    i_offset = 0;
}

- (float) getAllY:(UIView*) view{
    if (view == self.view){
        return 0;
    }
    float all = view.frame.origin.y;
    if ([view superview] != nil){
        all += [self getAllY:[view superview]];
    }
    return all;
}
@end
