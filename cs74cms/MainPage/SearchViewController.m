//
//  SearchViewController.m
//  74cms
//
//  Created by lyp on 15/4/30.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SearchViewController.h"
#import "InitData.h"
#import "FindResumeViewController.h"
#import "ITF_Other.h"

@interface SearchViewController ()<UITextFieldDelegate>{
    UILabel *leibie;
    
    UITextField *textField;
    UIButton *selected;
    
    UIView *dropDownView;
    UIButton *dropDown;
}

@end

@implementation SearchViewController

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
    
    [self.myNavigationController setTitle:MYLocalizedString(@"搜索", @"Search")];
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, [InitData Width] - 70, 25)];
    [searchView setBackgroundColor:[UIColor colorWithRed:230./255 green:230./255 blue:230./255 alpha:1]];
    searchView.layer.cornerRadius = 5;
    [self.view addSubview:searchView];
    
    
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setFrame:CGRectMake([InitData Width] - 55, 10, 55, 25)];
    [searchBut setTitleColor:[UIColor colorWithRed:55./255 green:117./255 blue:172./255 alpha:1] forState:UIControlStateNormal];
    [searchBut setTitle:MYLocalizedString(@"搜索", @"Search") forState:UIControlStateNormal];
    searchBut.titleLabel.adjustsFontSizeToFitWidth = YES;
    [searchBut addTarget:self action:@selector(searchButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBut];

    
    leibie = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 40, 25)];
    leibie.text = MYLocalizedString(@"搜职位", @"Search for jobs") ;
    leibie.font = [UIFont systemFontOfSize:13];
    leibie.textColor = [UIColor colorWithRed:130./255 green:130./255 blue:130./255 alpha:1];
    [searchView addSubview:leibie];
    
    dropDown = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropDown setImage:[UIImage imageNamed:@"drop_down.png"] forState:UIControlStateNormal];
    [dropDown addTarget:self action:@selector(dropDownClick) forControlEvents:UIControlEventTouchUpInside];
    [dropDown setFrame:CGRectMake(8, 2, 60, 20)];
    [dropDown setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    dropDown.selected = NO;
    [searchView addSubview:dropDown];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, searchView.frame.size.width - 70, 25)];
    textField.placeholder = MYLocalizedString(@"请输入关键字...", @"please type in key words");
    textField.delegate = self;
    textField.textColor = [UIColor colorWithRed:143./255 green:143./255 blue:143./255 alpha:1];
    textField.font = [UIFont systemFontOfSize:13];
    [searchView addSubview:textField];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 45, [InitData Width], 1)];
    [view setBackgroundColor:[UIColor colorWithRed:237./255 green:237./255 blue:237./255 alpha:1]];
    [self.view addSubview:view];
    
    [self hotSearch];
}

- (void) hotSearch{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 62, 15, 15)];
    [imgView setImage:[UIImage imageNamed:@"img_flag.png"]];
    [self.view addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 120, 20)];
    label.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    label.text = MYLocalizedString(@"热门搜索:", @"Hot search");
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    

    //获取热门搜索词
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSMutableArray * tarray = [[[ITF_Other alloc] init] getHotWord];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addHotWord:tarray];

        });
    });
}
- (void) addHotWord:(NSArray*) arr{
    float height = 90;
    float width = 15;
    for (int i=0; i<[arr count]; i++){
        CGSize size = [[arr objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:13]];
      //  NSLog(@"%f %f", size.width + width + 20, size.height);
        if (width + size.width + 20 > [InitData Width]- 6){
            width = 15;
            height += 30;
        }

        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = i + 1;
        [but setFrame:CGRectMake(width, height, size.width + 20, 20)];
        [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
      
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        but.layer.borderColor = [UIColor colorWithRed:205./255 green:205./255 blue:205./255 alpha:1].CGColor;
        but.layer.borderWidth = 1;
        but.layer.cornerRadius = 8;
        
        [but setTitleColor:[UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor colorWithRed:102./255 green:128./255 blue:171./255 alpha:1] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(hotSearchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        width += size.width + 20 + 8;
    }
}
- (void) changeSubView{
    dropDownView = [[UIView alloc] initWithFrame:CGRectMake(15, 30, 65, 65)];
    [dropDownView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:dropDownView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    [imgView setImage:[UIImage imageNamed:@"popwindow.png"]];
    [dropDownView addSubview:imgView];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setBackgroundColor:[UIColor clearColor]];
    [but1 setFrame:CGRectMake(12, 12, 50, 25)];
    but1.tag = 1;
    [but1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but1.titleLabel.font = [UIFont systemFontOfSize:12];
    [but1 setTitle:MYLocalizedString(@"搜职位", @"Search for jobs") forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(dropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
    [dropDownView addSubview:but1];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 37, 65, 1)];
    [sep setBackgroundColor:[UIColor whiteColor]];
    [dropDownView addSubview:sep];
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but2 setFrame:CGRectMake(12, 38, 50, 25)];
    [but2 setBackgroundColor:[UIColor clearColor]];
    but2.tag = 2;
    [but2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but2.titleLabel.font = [UIFont systemFontOfSize:12];
    [but2 setTitle:MYLocalizedString(@"搜简历", @"Search resume") forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(dropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
    [dropDownView addSubview:but2];
    
}
- (void) hotSearchClick:(UIButton*) but{

    if (selected != nil && selected.tag != but.tag){
        selected.selected = NO;
        selected.layer.borderColor = [UIColor colorWithRed:205./255 green:205./255 blue:205./255 alpha:1].CGColor;
    }
    
    textField.text = but.titleLabel.text;
    
    but.selected = !but.selected;
    if (but.selected){
        selected = but;
        but.layer.borderColor = [UIColor colorWithRed:102./255 green:128./255 blue:171./255 alpha:1].CGColor;
    }
    else{
        but.layer.borderColor = [UIColor colorWithRed:205./255 green:205./255 blue:205./255 alpha:1].CGColor;
        selected = nil;
    }
}

- (void) dropDownClick{
    if (!dropDown.selected){
        dropDown.selected = YES;
        [self changeSubView];
    }
}

- (void) dropDownSelected:(UIButton*) but{
//    leibie.text = but.tag == 1?@"搜职位":@"搜简历";
    leibie.text = but.tag == 1?MYLocalizedString(@"搜职位", @"Search for jobs"):MYLocalizedString(@"搜简历", @"Search resume");

    [InitData distory:dropDownView];
    dropDown.selected = NO;
}

- (void) searchButClick{
    FindResumeViewController *find = [[FindResumeViewController alloc] init];
    int type = [leibie.text isEqualToString:MYLocalizedString(@"搜简历", @"Search resume")]?0:2 ;
    [find setType:type];
    if (type == 0)
        [find setDistrict:@"" andJobs:@"" andExperience:0 andEducation:0 andKey:textField.text];
    else
        [find setDistrict:@"" andTrade:@"" andJobs:@"" andPublishTime:@"" andKey:textField.text];
    [self.myNavigationController pushAndDisplayViewController:find];
}

#pragma mark delegate
- (BOOL) textFieldShouldReturn:(UITextField *)ttextField{
    [ttextField resignFirstResponder];
    return YES;
}
@end
