//
//  CustomAlertView.m
//  74cms
//
//  Created by lyp on 15/4/23.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "CustomAlertView.h"
#import "InitData.h"

@implementation CustomAlertView

@synthesize delegate;

- (void) drawXButton:(NSArray*) arr{
    float cwidth = width / [arr count];
    
    float widthAll = 0;
    
    UIView *view = [[self subviews] objectAtIndex:0];
    view.userInteractionEnabled = YES;
    
    for (int i=0; i<[arr count]; i++){
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(widthAll, th + mh, cwidth, bh)];
        [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [but setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        but.tag = 100 + i;
        [but addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        if (i > 0){
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(widthAll, th + mh, 1, bh) ];
            [sep setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235. /255  alpha:1]];
            [view addSubview:sep];
        }
        
        widthAll += cwidth;
        
    }
    
}

- (void) drawYButton:(NSArray*) arr{
    float heightAll = 0;
    
    UIView *view = [[self subviews] objectAtIndex:0];
    
    for (int i=0; i<[arr count]; i++){
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(8, th + mh + heightAll, width - 16, bh)];
        [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        //[but setBackgroundColor:[UIColor redColor]];
        
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.tag = 100 + i;
        [but addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        if (i > 0){
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(8, th + mh + heightAll, width - 16, 1) ];
            [sep setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235. /255  alpha:1]];
            [view addSubview:sep];
        }
        
        heightAll += bh;
    }
}


- (void) setDirection:(Direction) t andTitle:(NSString*) stitle andMessage:(NSString*) mes andArray:(NSArray*) arr{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self setFrame:CGRectMake(0, 0, [InitData Width], [InitData Height])];
    
    th = 40;
    mh = 60;
    bh = 40;
    
    float bhAll = bh;
    if (t == Y){
        bhAll = bh * [arr count];
        mh = 0;
        if (mes != nil && ![mes isEqualToString:@""])
            mh = 40;
    }
    
    height = th + mh + bhAll;
    width = [InitData Width] - 40;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, ([InitData Height] - height) / 2, [InitData Width] - 40, height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.cornerRadius = 3;
    [self addSubview:view];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, width - 16, th)];
    titleLabel.textColor = [UIColor colorWithRed:243.0 / 255 green:134.0 / 255 blue:58.0 / 255 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = stitle;
    [view addSubview:titleLabel];
    
    UIView *seperateView1 = [[UIView alloc] initWithFrame:CGRectMake(8, th, width - 16, 1)];
    [seperateView1 setBackgroundColor:titleLabel.textColor];
    [view addSubview:seperateView1];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, th, width - 16, 40)];
    messageLabel.text = mes;
    messageLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:messageLabel];
    
    if (t == X  || mh > 0){
        UIView *seperateView2 = [[UIView alloc] initWithFrame:CGRectMake(8, th + mh, width - 16, 1)];
        [seperateView2 setBackgroundColor:[UIColor colorWithRed:235. / 255 green:235. / 255 blue:235. / 255 alpha:1]];
        [view addSubview:seperateView2];
    }
    
    if (t == X) {
        [self drawXButton:arr];
    }
    else{
        [self drawYButton:arr];
    }
    
}


- (void) buttonClicked:(UIButton*) but{
    long index = but.tag - 100;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customAlertViewbuttonClicked:)])
        [self.delegate customAlertViewbuttonClicked:(int)index];
    
    [InitData distory:self];
}
@end
