//
//  SearchResumeViewController.m
//  74cms
//
//  Created by lyp on 15/4/29.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SearchResumeViewController.h"
#import "InitData.h"
#import "FindResumeViewController.h"
#import "EduViewController.h"
#import "ChoiceIndustryViewController.h"
#import "ITF_Company.h"
#import "T_category.h"
#import "MapSearchViewController.h"

@interface SearchResumeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EduDelegate,  MutableChoiceDelegate>{
    UITextField *searchTextField;
    
    float height;
    
    int type;//0搜索简历  1搜索职位
    
    NSMutableArray *array;
    
    NSMutableArray *subMenuArray;
    
    UIView *seletedView;
    
    NSString *jobs;
    NSString *district;
    int experience;
    int education;
    
    NSString *trade;
    NSString *publishTime;
    
    UIView *backgroundView;
}

@end

@implementation SearchResumeViewController

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
    }else{
        height = 256;
        [self searchHistory];
    }
    [self.myNavigationController setTitle:MYLocalizedString(@"搜索简历", @"Search resume")];
    [self.myNavigationController setRightBtn:nil];
    
    if (type == 1){
        [self.myNavigationController setTitle:MYLocalizedString(@"搜索职位", @"Search for jobs")];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:MYLocalizedString(@"地图搜索", @"Search by map") forState:UIControlStateNormal];
        [but setFrame:CGRectMake(0, 0, 80, 40)];
        but.titleLabel.font = [UIFont systemFontOfSize:10];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(mapSearch) forControlEvents:UIControlEventTouchUpInside];
        NSArray *butArr = [NSArray arrayWithObject:but];
        [self.myNavigationController setRightBtn:butArr];
    }
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setType:(int) ttype{
    type = ttype;
}

- (void) drawView{
    [self.view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    
    [self topView];
    [self requirement];
    [self searchHistory];

}

- (void) topView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [self.view addSubview:topView];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(15, 7, [InitData Width] - 30, 26)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    searchView.layer.cornerRadius = 5;
    [topView addSubview:searchView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(3, 1, 25, 25)];
    [but setImage:[UIImage imageNamed:@"searchBut.jpg"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(searchButClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:but];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 2, 1, 22)];
    [view setBackgroundColor:topView.backgroundColor];
    [searchView addSubview:view];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 3, [InitData Width] - 80, 20)];
    searchTextField.placeholder = MYLocalizedString(@"请输入关键字...", @"please type in key words");
    searchTextField.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    searchTextField.font = [UIFont systemFontOfSize:13];
    searchTextField.delegate = self;
    [searchView addSubview:searchTextField];
}
- (void) requirement{
    float cellHeight = 40;
    height = 40;
    NSArray *arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"意向地区", @"Intentional area"), MYLocalizedString(@"意向职位", @"Intentional position"), MYLocalizedString(@"工作经验", @"Work experience"), MYLocalizedString(@"学历", @"Education"), nil];
    if (type == 1){
        arr = [[NSArray alloc] initWithObjects:MYLocalizedString(@"地区", @"Area"), MYLocalizedString(@"行业", @"Position"), MYLocalizedString(@"职能", @"Function"), MYLocalizedString(@"更新日期", @"Update date"), nil];
    }
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
    for (int i=0; i<[arr count]; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, cellHeight)];
        label1.text = [arr objectAtIndex:i];
        label1.textColor = color1;
        label1.font = font1;
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 0, 130, cellHeight)];
        label2.text = @"";
        label2.textColor = color2;
        label2.font = font2;
        label2.textAlignment = NSTextAlignmentRight;
        [view addSubview:label2];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go.png"]];
        [img setFrame:CGRectMake([InitData Width] - 40, (cellHeight - 20) / 2, 20, 20)];
        [view addSubview:img];

        height += cellHeight + 1;
    }
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 15, (cellHeight + 1) * 3)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, 45, 15, (cellHeight + 1) * 3)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(15, height + 8, [InitData Width] - 30, 35)];
    [but addTarget:self action:@selector(searchButClicked) forControlEvents:UIControlEventTouchUpInside];
    [but setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"butColor.png"]]];
    [but setTitle:MYLocalizedString(@"搜索", @"Search") forState:UIControlStateNormal];
    but.layer.cornerRadius = 5;
    [self.view addSubview:but];
    height += 52;
}
- (void) searchHistory{
    
    if (backgroundView != nil)
        [backgroundView removeFromSuperview];
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], [InitData Height] - height)];
    backgroundView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:backgroundView];
    height = 0;
    
    UIView *view1= [[UIView alloc] initWithFrame:CGRectMake(20, height, [InitData Width] - 40, 20)];
    [backgroundView addSubview:view1];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 16, 16)];
    [imgView1 setImage:[UIImage imageNamed:@"watch.png"]];
    [view1 addSubview:imgView1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 20)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    label1.text = MYLocalizedString(@"近期搜索记录", @"Recent search records");
    [view1 addSubview:label1];
    
    UIView *view2= [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 115, height, 82, 20)];
    view2.tag = 1001;
    [backgroundView addSubview:view2];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanHistory)];
    recognizer.numberOfTapsRequired = 1;
    [view2 addGestureRecognizer:recognizer];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -3, 30, 30)];
    [imgView2 setImage:[UIImage imageNamed:@"delet.png"]];
    [view2 addSubview:imgView2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 20)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    label2.text = MYLocalizedString(@"清空搜索记录", @"Empty search records");
    [view2 addSubview:label2];
    
    height += 28;
    
    UIView *viewt = [[UIView alloc] initWithFrame:CGRectMake(15, height, [InitData Width] - 30, 1)];
    [viewt setBackgroundColor:[UIColor colorWithRed:221./255 green:221./255 blue:221./255 alpha:1]];
    [backgroundView addSubview:viewt];
    height ++;
    
    switch (type) {
        case 0:{
            NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchResume"];
            if (str != nil && ![str isEqualToString:@""])
                array = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"&&"]];
        }
            break;
        case 1:{
            NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchJob"];
            if (str != nil && ![str isEqualToString:@""])
                array = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"&&"]];
        }
            break;
        default:
            break;
    }
    
    
    
    if (array == nil || [array count] == 0){
        [self noSearchHistory];
        return;
    }
    
    float tableviewHeight = [array count] * 40;
    
    tableviewHeight  = tableviewHeight >([InitData Height] - height)?([InitData Height] - height):tableviewHeight;
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], tableviewHeight)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tag = 988;
    [mainTableView setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:mainTableView];
  
    UIView *viewleft = [[UIView alloc] initWithFrame:CGRectMake(0, height, 15, tableviewHeight)];
    [viewleft setBackgroundColor:self.view.backgroundColor];
    [backgroundView addSubview:viewleft];
    
    UIView *viewright = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, height, 15, tableviewHeight)];
    [viewright setBackgroundColor:self.view.backgroundColor];
    [backgroundView addSubview:viewright];
}

- (void) noSearchHistory{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 250, 30)];
    label.textColor = [UIColor colorWithRed:135./255 green:135./255 blue:125./255 alpha:1];
    label.font = [UIFont systemFontOfSize:13];
    label.text = MYLocalizedString(@"暂无历史搜索记录", @"No search history records");
    [backgroundView addSubview:label];
    NSArray *tarray = [backgroundView subviews];
    for (UIView *view in tarray){
        if (view.tag == 988){
            [((UITableView*)view) removeFromSuperview];
        }
        if (view.tag == 1001){//清空 隐藏
            [view removeFromSuperview];
        }
    }
}

#pragma mark tableview delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (array != nil && [array count] >= 1)
        return [array count];
    return 0;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableSampleIdentifier = @"tableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    cell.tag = 2000 + [indexPath row];
    //[cell :[array objectAtIndex:[indexPath row]]];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, -67, 0, 0)];
    cell.textLabel.text = [NSString stringWithFormat:@"   %@",[array objectAtIndex:[indexPath row]]];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithRed:135./255 green:135./255 blue:135./255 alpha:1];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str =  array[[indexPath row]];
    
    searchTextField.text = str;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -

- (void) searchJobReq:(int) idx{
    NSString *req;
    NSString *title;
    switch (idx) {
        case 0:
            req = @"district";
            title = MYLocalizedString(@"地区", @"Area"); 
            break;
        case 1:
            req = @"QS_trade";
            title = MYLocalizedString(@"行业", @"Position");
            break;
        case 2:
            req = @"jobs";
            title = MYLocalizedString(@"职能", @"Function");
            break;
        default:
            title = MYLocalizedString(@"更新日期", @"Update date");
            break;
    }
    if (idx <= 2){
        ChoiceIndustryViewController *mutable = [[ChoiceIndustryViewController alloc] init];
        mutable.delegate = self;
        [mutable setHanshuName:req];
        [mutable setSign:idx];
        [self.myNavigationController pushAndDisplayViewController:mutable];
       
    }
    else{
        subMenuArray = [NSMutableArray arrayWithObjects: MYLocalizedString(@"近三天", @"In 3 days"), MYLocalizedString(@"近一周", @"In one week"), MYLocalizedString(@"近半月", @"In half month"), MYLocalizedString(@"近一月", @"In one month"), nil];
        EduViewController *edu = [[EduViewController alloc] init];
        [edu setViewWithNSArray:subMenuArray];
        edu.delegate = self;
        
        [self.myNavigationController pushAndDisplayViewController:edu];
    }
}

- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    long idx = recognizer.view.tag - 1;
    seletedView = recognizer.view;
    if (type == 1){
        [self searchJobReq:idx];
        return;
    }
    
    NSString *req;
    NSString *title;
    switch (idx) {
        case 0:
            req = @"district";
            title = MYLocalizedString(@"意向地区", @"Intentional area");
            break;
        case 1:
            req = @"jobs";
            title = MYLocalizedString(@"意向职位", @"Intentional position");
            break;
        case 2:
            req = @"QS_experience";
            title = MYLocalizedString(@"工作经验", @"Work experience");
            break;
        default:
            req = @"QS_education";
            title = MYLocalizedString(@"学历", @"Education");
            break;
    }
    if (idx < 2){
        ChoiceIndustryViewController *mutable = [[ChoiceIndustryViewController alloc] init];
        mutable.delegate = self;
        [mutable setHanshuName:req];
        [self.myNavigationController pushAndDisplayViewController:mutable];
        [mutable setTitle:title];
    }
    else{

        [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            
            subMenuArray = [[[ITF_Company alloc] init] classify:req andParentid:0];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                NSMutableArray * arr = [[NSMutableArray alloc] init];
                for (int i=0; i<[subMenuArray count]; i++) {
                    T_category *cat = [subMenuArray objectAtIndex:i];
                    [arr addObject:cat.c_name];
                }
                
                EduViewController *edu = [[EduViewController alloc] init];
                [edu setViewWithNSArray:arr];
                edu.delegate = self;
                
                [self.myNavigationController pushAndDisplayViewController:edu];
            });
        });

    }
}

- (void) searchButClicked{
    /*****添加点击跳转页面***/
    FindResumeViewController *find = [[FindResumeViewController alloc]  initWithString:searchTextField.text];
    if (type == 0){
        [find setDistrict:district andJobs:jobs andExperience:experience andEducation:education andKey:searchTextField.text];
        [find setType:0];
    }
    else{
        [find setDistrict:district andTrade:trade andJobs:jobs andPublishTime:publishTime andKey:searchTextField.text];
        [find setType:2];
    }
    [self.myNavigationController pushAndDisplayViewController:find];
    
    if ((array != nil && [array indexOfObject:searchTextField.text] != NSNotFound) || [searchTextField.text isEqualToString:@""]){
        return;
    }
    NSString *keyname;
    switch (type) {
        case 0:
            keyname = @"SearchResume";
            break;
        case 1:
            keyname = @"SearchJob";
            break;
        default:
            break;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyname] != nil){
        [str appendString:[[NSUserDefaults standardUserDefaults] objectForKey:keyname]];
        NSArray *arr = [str componentsSeparatedByString:@"&&"];
        if ([arr count] > 2){
            int start = (int)[arr count] - 2;
            str = [[NSMutableString alloc] init];
            [str appendString:arr[start]];
            [str appendFormat:@"&&%@", [arr objectAtIndex:start + 1]];
        }
        [str appendString:@"&&"];
    }
    [str appendFormat:@"%@", searchTextField.text];
    
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:keyname];
}

- (void) cleanHistory{
    switch (type) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"SearchResume"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"SearchJob"];
            break;
        default:
            break;
    }/*
    NSArray *tarray = [self.view subviews];
    for (UIView *view in tarray){
        if (view.tag == 988){
            [((UITableView*)view) reloadData];
            break;
        }
    }*/
    array = nil;
    [self noSearchHistory];
    [InitData netAlert:MYLocalizedString(@"清空历史搜索记录成功！", @"Clear history search record success!")];
}

- (void) mapSearch{
    MapSearchViewController *map = [[MapSearchViewController alloc] init];
    [self.myNavigationController pushAndDisplayViewController:map];
}

#pragma mark delegate

- (void) selectIndex:(int)index{
    if (type == 0){
        UILabel *label = [[seletedView subviews] objectAtIndex:1];
        T_category *cat = [subMenuArray objectAtIndex:index];
        label.text = cat.c_name;
        label.tag = cat.c_id;
        if (seletedView.tag - 1 ==2){
            experience =cat.c_id;
        }else{
            education = cat.c_id;
        }
    }
    else{
        UILabel *label = [[seletedView subviews] objectAtIndex:1];

        NSArray *tarray = [NSArray arrayWithObjects:@"3", @"7", @"15", @"30", nil];
        label.text = [subMenuArray objectAtIndex:index];
        publishTime = [tarray objectAtIndex:index];
    }
}
- (void) mutableChoiceByContent:(NSString *)content andId:(NSString *)idStr{
    if (type == 0){
        UILabel *label = [[seletedView subviews] objectAtIndex:1];
        label.text = content;
        if (seletedView.tag - 1 == 0){
            district = idStr;
        }else{
            jobs = idStr;
        }
    }
    else{
        UILabel *label = [[seletedView subviews] objectAtIndex:1];
        label.text = content;
        if (seletedView.tag - 1 == 0){
            district = idStr;
        }else if (seletedView.tag - 1 == 2){
            jobs = idStr;
        }else{
            trade = idStr;
        }
    }
}


@end
