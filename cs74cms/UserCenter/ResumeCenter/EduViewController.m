//
//  EduViewController.m
//  74cms
//
//  Created by lyp on 15/4/21.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EduViewController.h"
#import "InitData.h"
#define EDU_TAGBEGIN 350

@interface EduViewController (){
    NSArray *arr;
    
    UIImageView *selected;
    
    int selectedIndex;
}

@end

@implementation EduViewController

@synthesize delegate;


- (void) setViewWithNSArray:(NSArray *) array{

    arr = array;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1]];
    
    UIScrollView *bgView = [[UIScrollView alloc] init];
    [bgView setBackgroundColor:self.view.backgroundColor];
    bgView.showsHorizontalScrollIndicator = NO;
    bgView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgView];
    
    float cellHeight = 40;
    float height = [array count] * cellHeight;

    if (height > [InitData Height])
        height = [InitData Height];
    
    [bgView setFrame:CGRectMake(0, 0, [InitData Width], height)];
    [bgView setContentSize:CGSizeMake([InitData Width], cellHeight * [array count])];
    height = 0;
    UIFont *font1 = [UIFont systemFontOfSize:14];
    UIColor *color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    for (int i=0; i<[arr count]; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight - 1)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = EDU_TAGBEGIN + i;
        [bgView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, cellHeight)];
        label.text = [arr objectAtIndex:i];
        label.textColor = color1;
        label.font = font1;
        [view addSubview:label];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        height += cellHeight;
    }
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, cellHeight * [arr count])];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake([InitData Width] - 15, 0, 15, cellHeight * [arr count])];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view2];
}

- (void) setTitle:(NSString *)title{
    [self.myNavigationController setTitle:title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.edgesForExtendedLayout = UIRectEdgeNone;//这句话很关键，不加出线空白
}

- (void) viewCanBeSee{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:MYLocalizedString(@"确定", @"Done") forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, 40, 40)];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    NSArray *butArr = [NSArray arrayWithObject:but];
    [self.myNavigationController setRightBtn:butArr];
}
- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark event
- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
    selectedIndex = (int)recognizer.view.tag - EDU_TAGBEGIN;
    
    [selected removeFromSuperview];
    if (selected == nil){
        float height = recognizer.view.frame.size.height;
        selected = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 20 - 30, (height - 30) / 2, 30, 30)];
        [selected setImage:[UIImage imageNamed:@"check.png"]];
    }
    [recognizer.view addSubview:selected];
    
}
- (void) save{
    [self.myNavigationController dismissViewController];
    if (arr != nil && [arr count] > selectedIndex){
        NSString *str = [arr objectAtIndex:selectedIndex];
        if (delegate!= nil && [delegate respondsToSelector:@selector(selectString:)]){
            [self.delegate selectString:str];
        }
        if (delegate!= nil && [delegate respondsToSelector:@selector(selectIndex:)]){
            [self.delegate selectIndex:selectedIndex];
        }
    }
}
@end
