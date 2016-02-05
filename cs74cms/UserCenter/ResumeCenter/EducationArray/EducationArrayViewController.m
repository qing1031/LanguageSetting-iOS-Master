//
//  EducationArrayViewController.m
//  74cms
//
//  Created by lyp on 15/4/23.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EducationArrayViewController.h"
#import "InitData.h"
#import "EducationTableViewCell.h"
#import "EducationViewController.h"
#import "WordViewController.h"
#import "TrainViewController.h"
#import "CustomAlertView.h"
#import "T_Interface.h"

#define EDUARRTAG 2100

@interface EducationArrayViewController ()<UITableViewDelegate, UITableViewDataSource, EducationTableViewCellDelegate, CustomAlertViewDelegate>{
    NSMutableArray *array;//
    
    UITableView *tableView;
    
    UIView *tixinView;
    
    long currentIndex;//要删除的项目
    int Pid;//当前的简历
    int type;//3教育 4工作 5培训
    
    UIView *selectBack;
}

@end

@implementation EducationArrayViewController

- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0/255 blue:235.0/255 alpha:1]];
    
    if (tableView == nil){
        tableView = [[UITableView alloc] init];
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = NO;
    }
    else{
        [tableView reloadData];
    }
    
    float height = 55 * [array count] > ([InitData Height] - 30)?([InitData Height] - 30):55 * [array count];
    [tableView setFrame:CGRectMake(0, 0, [InitData Width], height)];
    
    
    if (tixinView == nil){
        tixinView = [[UIView alloc] init];
        [self.view addSubview:tixinView];
        
        UIImageView *tixin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        tixin.image = [UIImage imageNamed:@"tixin.png"];
        [tixinView addSubview:tixin];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 15)];
        label.text = MYLocalizedString(@"长按可删除教育经历", @"Long press to delete education experience");
        label.textColor = [UIColor colorWithRed:102.0 / 255 green:102. / 255 blue:102. / 255 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        [tixinView addSubview:label];
    }
    
    [tixinView setFrame:CGRectMake(20, height + 10, 250, 15)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setPid:(int) tpid andType:(int) ttype{
    type = ttype;
    Pid = tpid;
}

- (void) getArray{
           T_User *user = [InitData getUser];
        switch (type) {
            case 3:
            array = [[[T_Interface alloc] init] resumeEducationByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andEductaion:nil];
            break;
        case 4:
            array = [[[T_Interface alloc] init] resumeWorkByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andWork:nil];
            break;
        default:
            array = [[[T_Interface alloc] init] resumeTrainByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andTraining:nil];
            break;
    }
}
- (void) nextPage{
    if (array == nil || [array count] == 0){
        switch (type) {
            case 3:
                [self.myNavigationController pushAndDisplayViewController:[[EducationViewController alloc] init]];
                break;
            case 4:
                [self.myNavigationController pushAndDisplayViewController:[[WordViewController alloc] init]];
                break;
            default:
                [self.myNavigationController pushAndDisplayViewController:[[TrainViewController alloc] init]];
                break;
        }
        
        return;
    }
  //  if ([[self.view subviews] count] <= 0){
    [self drawView];
   // }
}

- (void) viewCanBeSee{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        [self getArray];

        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [self nextPage];

        });
    });    
        
    
    NSString *title;
    switch (type) {
        case 3:
            title = MYLocalizedString(@"添加教育经历", @"Add education experience");
            break;
        case 4:
            title = MYLocalizedString(@"工作经历", @"Work experience");
            break;
        default:
            title = MYLocalizedString(@"培训经历", @"Training experience");
            break;
    }
    
    [self.myNavigationController setTitle:title];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"添加", @"Add") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *arr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:arr];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event
- (void) add{
    //int type;//3教育 4工作 5培训
    switch (type) {
        case 3:{
            EducationViewController * edu = [[EducationViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:edu];
        }
            break;
        case 4:{
            WordViewController * edu = [[WordViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:edu];
        }
            break;
        case 5:{
            TrainViewController * edu = [[TrainViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:edu];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark delegate

- (void) longPressToDo:(long) tag{
   // NSLog(@"%ld", tag);
    currentIndex = tag - EDUARRTAG;
    //给选中的行添加标记
    NSIndexPath *path = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    selectBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], cell.frame.size.height)];
    [selectBack setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [cell addSubview:selectBack];
    
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"确认", @"Done"), MYLocalizedString(@"取消", @"Cancle"), nil];
    
    CustomAlertView *alerView = [[CustomAlertView alloc] init];
    NSString *tishi;
    switch (type) {
        case 3:
            tishi = MYLocalizedString(@"确定要删除当前教育经验吗？", @"Are you sure you want to delete the current education experience?");
            break;
        case 4:
            tishi = MYLocalizedString(@"确定要删除当前工作经历吗？", @"Are you sure you want to delete the current work experience?");
            break;
        default:
            tishi = MYLocalizedString(@"确定要删除该条培训经历吗？", @"Are you sure you want to delete this training experience?");
            break;
    }
    [alerView setDirection:X andTitle:MYLocalizedString(@"消息确认", @"Message acknowledgement") andMessage:tishi andArray:arr];
    alerView.delegate = self;
    [self.view addSubview:alerView];
    [alerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];

}

- (void) deleteContent:(int) index{
    switch (type) {
        case 3:{
            T_User *user = [InitData getUser];
            T_Education *edu = [[T_Education alloc] init];
            edu.ID = ((T_Education*) [array objectAtIndex:index]).ID;
            [[[T_Interface alloc] init] resumeEducationByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andEductaion:edu];
            
        }
            break;
        case 4:{
            T_User *user = [InitData getUser];
            T_Work *edu = [[T_Work alloc] init];
            edu.ID = ((T_Work*) [array objectAtIndex:index]).ID;
            [[[T_Interface alloc] init] resumeWorkByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andWork:edu];

        }
            break;
            
        default:{
            T_User *user = [InitData getUser];
            T_Training *edu = [[T_Training alloc] init];
            edu.ID = ((T_Training*) [array objectAtIndex:index]).ID;
            [[[T_Interface alloc] init] resumeTrainByUsername:user.username andUserpwd:user.userpwd andPid:[InitData getPid] andTraining:edu];
            
        }
            break;
    }
    
    [array removeObjectAtIndex:index];
    float height = 55 * [array count] > ([InitData Height] - 30)?([InitData Height] - 30):55 * [array count];
    [tableView setFrame:CGRectMake(0, 0, [InitData Width], height - 1)];
    [tixinView setFrame:CGRectMake(20, tableView.frame.size.height + 10, 250, 20)];

}


- (void) customAlertViewbuttonClicked:(int)index{
    [selectBack removeFromSuperview];
    selectBack = nil;
    switch (index) {
        case 0:{
            [self deleteContent:index];
            
        }
            break;
            
        default:
            ((UIView*)[[tableView subviews] objectAtIndex:currentIndex]).tag = EDUARRTAG + currentIndex;
            break;
    }
    long cnt = [[self.view subviews] count];
    [InitData distory:((UIView*)[[self.view subviews] objectAtIndex:cnt - 1])];
    [tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (array != nil && [array count] >= 1)
        return [array count];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell*) tableView:(UITableView *)ttableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  static NSString * tableSampleIdentifier = @"tableSampleIdentifier";WithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier
    EducationTableViewCell *cell = (EducationTableViewCell*)[ttableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[EducationTableViewCell alloc] init];
    }
    
    cell.tag = EDUARRTAG + [indexPath row];
    cell.delegate = self;
   // NSString *str = [NSString stringWithFormat:@"北京邮电大学%ld", cell.tag];
  //  [cell setTitle:str andStartTime:@"2009年9月" andEndTime:@"2012年6月"];
    switch (type) {
        case 3:{
            T_Education *edu = [array objectAtIndex:indexPath.row];
            [cell setTitle:edu.school andStartTime:edu.starttime andEndTime:edu.endtime];
        }
            break;
        case 4:{
            T_Work *work = [array objectAtIndex:indexPath.row];
            [cell setTitle:work.companyName andStartTime:work.starttime andEndTime:work.endtime];
        }
            break;
            
        default:{
            T_Training *work = [array objectAtIndex:indexPath.row];
            [cell setTitle:work.agency andStartTime:work.starttime andEndTime:work.endtime];
        }
            break;
    }

    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (type) {
        case 3:{
                EducationViewController * edu = [[EducationViewController alloc] init];
            [edu setEducation:[array objectAtIndex:indexPath.row]];
            [self.myNavigationController pushAndDisplayViewController:edu];
        }
            
            break;
        case 4:
        {
            WordViewController *word = [[WordViewController alloc] init];
            [word setWork:[array objectAtIndex:indexPath.row]];
            [self.myNavigationController pushAndDisplayViewController:word];
        }
            break;
        default:{
            TrainViewController *train = [[TrainViewController alloc] init];
            [train setTrain:[array objectAtIndex:indexPath.row]];
            [self.myNavigationController pushAndDisplayViewController:train];
        }
            break;
    }

}


@end
