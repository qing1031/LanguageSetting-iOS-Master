//
//  NavigationBarView.m
//  myFirstPro
//
//  Created by zwh on 14-3-24.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import "NavigationBarView.h"
#import <AVFoundation/AVFoundation.h>
#import "InitData.h"

@interface NavigationBarView (){
    
    UILabel *titleLabel;

    //按钮对象
    UIButton *returnButton;
    UIButton *subMenuViewButton;
    
    //右边的按钮数组
    NSMutableArray * btnArray;
    
}

@end

@implementation NavigationBarView


@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        self.userInteractionEnabled = YES;
        btnArray = [[NSMutableArray alloc] init];
   
        //初始化标题
        titleLabel = [[UILabel alloc] init];
        //titleLabel.adjustsLetterSpacingToFitWidth = YES;
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont boldSystemFontOfSize:self.frame.size.height / 2];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        //设置按钮
        returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"返回按钮" ];
        [returnButton setImage:image forState:UIControlStateNormal];
        CGSize size = [InitData calculateImageSize:frame.size imageSize:image.size priorDirection:Y];
        [returnButton setFrame:CGRectMake(0, 0, size.width, size.height)];
        [returnButton addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:returnButton];
        
    }
    return self;
}

- (void) setTitle:(NSString *)title{
    titleLabel.text = title;
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    [titleLabel setFrame:CGRectMake((self.frame.size.width-size.width) / 2 , (self.frame.size.height - size.height) / 2, size.width, size.height)];
}

- (void) setRightBtn:(NSArray*) array{
    [self removeRightButton];
    btnArray = [NSMutableArray arrayWithArray:array];
    UIButton * btn;
    double btnwidth = [array count] ? ((UIButton*)[btnArray objectAtIndex:0]).frame.size.width : 0;
    for (int i=0; i<[btnArray count]; i++){
        btn = [btnArray objectAtIndex:i];
        [btn setFrame:CGRectMake([InitData Width] - btnwidth - 15, (self.frame.size.height - btn.frame.size.height) / 2, btn.frame.size.width, btn.frame.size.height)];
        [self addSubview:btn];
        btnwidth += btn.frame.size.width;
    }
}

- (NSArray*) getRightBtn{
    return btnArray;
}

- (void) removeRightButton{
    NSArray *array = btnArray;
    for (int i=0; i<[array count]; i++){
        [[array objectAtIndex:i] removeFromSuperview];
    }
    btnArray = nil;
}


#pragma mark - delegate

- (void) returnButtonClicked:(id) sender{
    [delegate returnButtonClicked];
}
- (void) subMenuViewButtonClicked:(id) sender{
    [delegate subMenuViewButtonClicked];
}/*
- (void) btnClicked:(id)sender{
    [delegate rightBtnClicked:sender];
}*/
@end
