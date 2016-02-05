//
//  ShieldingViewController.m
//  74cms
//
//  Created by lyp on 15/4/24.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ShieldingViewController.h"
#import "InitData.h"
#import "T_Interface.h"
#import "CustomAlertView.h"

@interface ShieldingViewController ()<UITableViewDataSource, UITableViewDelegate, CustomAlertViewDelegate>{
    NSMutableArray *array;
    
    UILabel *label;
    
    UIView *textFieldView;
    UITextField *textField;
    
    UIView *viewLeft;
    
    UIView *viewRight;
    
    UITableView *mainTableView;
    
    float cellHeight;
    
    int Pid;
    
    UIView * selected;
}

@end

@implementation ShieldingViewController

- (void) setPid:(int) pid{
    Pid = pid;
    if ([[self.view subviews] count] <= 0){
        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            T_User *user = [InitData getUser];
            
            array = [[[T_Interface alloc] init] resumeShieldCompanyByUsername:user.username andUserpwd:user.userpwd andPid:Pid andShieldCompany:nil];            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                [self drawView];
            });
        });
        
    }
}


- (void) drawView{
    if (textFieldView != nil){
        [InitData distory:textFieldView];
        textFieldView = nil;
    }
    
    if (label == nil){
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, [InitData Width] - 30, 40)];
        label.text = MYLocalizedString(@"如果不想让某家公司看到你的公开简历，可进行屏蔽设置，最多可以设置5个公司。", @"If you do not want to let a company see your open resume, can be shielded settings, can set up to 5 companies.");
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
        label.numberOfLines = 0;
    }
    if (label.superview == nil)
        [self.view addSubview:label];

    if ([array count] > 0){

        if (mainTableView == nil){
            mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [array count] * cellHeight - 1)];
            mainTableView.delegate = self;
            mainTableView.dataSource = self;
            mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            mainTableView.separatorInset = UIEdgeInsetsZero;
      //  mainTableView.separatorInset.left = 0.;
      //  mainTableView.separatorInset.right = 0;
            [self.view addSubview:mainTableView];
            
            viewLeft = [[UIView alloc] init];
            [viewLeft setBackgroundColor:[UIColor whiteColor]];
            
            viewRight = [[UIView alloc] init];
            [viewRight setBackgroundColor:[UIColor whiteColor]];
        }
        else{
            [mainTableView reloadData];
        }
        [mainTableView setFrame:CGRectMake(0, 0, [InitData Width], [array count] * cellHeight - 1)];
        
        [viewLeft setFrame:CGRectMake(0, 0, 15, [array count] * cellHeight)];
        [self.view addSubview:viewLeft];
        
        [viewRight setFrame:CGRectMake([InitData Width] - 15, 0, 15, [array count] * cellHeight)];
        [self.view addSubview:viewRight];
        
        [label setFrame:CGRectMake(15, mainTableView.frame.size.height + 10, [InitData Width] - 30, 40)];
    }
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(0, 0, 50, 40)];
        [but setTitle:MYLocalizedString(@"添加", @"Add") forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
        [but addTarget:self action:@selector(addShield) forControlEvents:UIControlEventTouchUpInside];
        NSArray *arr = [NSArray arrayWithObjects:but, nil];
        [self.myNavigationController setRightBtn:arr];
        return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellHeight = 40;

    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
}


- (void) viewCanBeSee{
    [self.myNavigationController setTitle:MYLocalizedString(@"设置屏蔽企业", @"Set shield enterprise")];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event
- (void) addShield{
    
    //如果有提醒，添加提醒

    if (label != nil  && label.superview != nil){
        [label removeFromSuperview];
        label = nil;
    }
    if (array != nil && [array count] == 5){
        [InitData netAlert:MYLocalizedString(@"已经添加了5个屏蔽字段", @"Set the shield enterprise has added 5 shielding fields")];
        return;
    }
    
    
    textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 40)];
    [textFieldView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:textFieldView];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, [InitData Width] - 40, 40)];
    textField.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    textField.font = [UIFont systemFontOfSize:14];
    [textFieldView addSubview:textField];
    
    UIButton *cbut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbut setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cbut setFrame:CGRectMake([InitData Width] - 20 - 40, 0, 40, 40)];
    [cbut setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [cbut addTarget:self action:@selector(clearBut) forControlEvents:UIControlEventTouchUpInside];
    [textFieldView addSubview:cbut];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(0, 0, 50, 40)];
    [but setTitle:MYLocalizedString(@"确定", @"Done") forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *arr = [NSArray arrayWithObjects:but, nil];
    [self.myNavigationController setRightBtn:arr];
    
    //如果添加过uitableview， 重改uitableview的位置
    if (mainTableView != nil){
        [mainTableView setFrame:CGRectMake(0, 45, [InitData Width], cellHeight * [array count] - 1)];
        
        [viewLeft setFrame:CGRectMake(0, 45, 15, [array count] * cellHeight)];
        
        [viewRight setFrame:CGRectMake([InitData Width] - 15, 45, 15, [array count] * cellHeight-1)];
    }
}

- (void) sure:(UIButton*) but{
    
   /* if (array == nil){
        array = [[NSMutableArray alloc] init];
    }*/
    
    [InitData isLoading:self.view];
    but.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_ShieldCompany *com  = [[T_ShieldCompany alloc] init];
        com.comkeyword = textField.text;
        NSMutableArray *tarray = [[[T_Interface alloc] init] resumeShieldCompanyByUsername:user.username andUserpwd:user.userpwd andPid:Pid andShieldCompany:com];
        array = [[[T_Interface alloc] init] resumeShieldCompanyByUsername:user.username andUserpwd:user.userpwd andPid:Pid andShieldCompany:nil];
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            but.userInteractionEnabled = YES;
            if (tarray != nil){

                [textField resignFirstResponder];
                [textField removeFromSuperview];
                textField = nil;
                [self drawView];
            }
        });
    });

}

- (void) clearBut{
    textField.text = @"";
}



- (void) longPressToDo:(UILongPressGestureRecognizer*) longPress{
    if (selected != longPress.view){
        selected = longPress.view;
        CustomAlertView *alertView = [[CustomAlertView alloc] init];
        alertView.tag = 1001;
        alertView.delegate = self;
        NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"确认", @"Confirm"), MYLocalizedString(@"取消", @"Cancle"), nil];
        [alertView setDirection:X andTitle:MYLocalizedString(@"消息确认", @"Message acknowledgement") andMessage:MYLocalizedString(@"你确定要删除当前屏蔽企业吗？", @"Are you sure you want to delete the current shield?") andArray:arr];
        [self.view addSubview:alertView];
    }
}
#pragma mark delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * tableSampleIdentifier = @"tableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    T_ShieldCompany * shield =[array objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", @"    " , shield.comkeyword];
    cell.tag = indexPath.row + 1;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longPress];

    return cell;
}

- (void) deleteContent{
    int selet = (int)selected.tag - 1;
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        T_ShieldCompany *shield = [array objectAtIndex:selet];
        NSMutableArray *arr = [[[T_Interface alloc] init] resumeShieldCompanyByUsername:user.username andUserpwd:user.userpwd andPid:Pid andShieldCompany:shield];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [InitData haveLoaded:self.view];
            if (arr != nil){
                [array removeObject:shield];
                //[mainTableView reloadData];
                [self drawView];
            }
        });
    });
}

- (void) customAlertViewbuttonClicked:(int)index{
    long cnt = [[self.view subviews] count];
    UIView *view = (UIView*)[[self.view subviews] objectAtIndex:cnt - 1];
    if (view.tag == 1001){
        [view removeFromSuperview];
    }

    switch (index) {
        case 0:

            [self deleteContent];
            break;
            
        default:
            //((UIView*)[[mainTableView subviews] objectAtIndex:currentIndex]).tag = EDUARRTAG + currentIndex;

            break;
    }    selected = nil;
}

@end
