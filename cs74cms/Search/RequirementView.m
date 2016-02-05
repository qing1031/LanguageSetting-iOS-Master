//
//  RequirementView.m
//  74cms
//
//  Created by lyp on 15/4/30.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "RequirementView.h"
#import "InitData.h"
#import "T_category.h"
@implementation RequirementView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    }
    return self;
}

- (void) setWithArray:(NSArray*) array{
    float cellHeight = 35;
    float height = cellHeight * [array count];
    if (height > 300)
        height = 300;
    UIScrollView *bgview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    [bgview setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [self addSubview:bgview];
    
    for (int i=0; i<[array count]; i++){
        T_category *cat = [array objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight * i, self.frame.size.width, cellHeight - 1)];
        view.tag =  i + 1;
        [view setBackgroundColor:[UIColor whiteColor]];
        [bgview addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 220, 15)];
        label.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        label.text = cat.c_name;
        [view addSubview:label];
        
    }
    
    [bgview setContentSize:CGSizeMake([InitData Width], cellHeight * [array count])];
    bgview.showsHorizontalScrollIndicator = NO;
    bgview.showsVerticalScrollIndicator = NO;
    bgview.directionalLockEnabled = YES;
}

- (void) selectThis:(UITapGestureRecognizer*) recognizer{
    int index = (int)recognizer.view.tag - 1;
    if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(requirementThis:)]){
        [self.delegate requirementThis:index];
    }
    //[self removeFromSuperview];
    [InitData distory:self];
}




@end
