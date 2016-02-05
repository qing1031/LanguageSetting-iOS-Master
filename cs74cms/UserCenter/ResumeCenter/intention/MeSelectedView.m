//
//  MeSelectedView.m
//  74cms
//
//  Created by lyp on 15/4/28.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MeSelectedView.h"
#import "InitData.h"

@implementation MeSelectedView

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor colorWithRed:230.0/255 green:230./255 blue:230./255 alpha:1]];
        
        
        self.layer.borderColor =[UIColor colorWithRed:208./255 green:208./255 blue:208./255 alpha:1].CGColor;
        self.layer.borderWidth =1;
        
    }
    return self;
}

- (void) addString:(NSString*) str{
    float seperate = 15;
    float cellHeight = 30;
    float height = self.frame.size.height;
    if (height < seperate)
        height = seperate;
    
    int t = height / (cellHeight + seperate);
    
    float stringWidth = [str sizeWithFont:[UIFont systemFontOfSize:13]].width;
    stringWidth = stringWidth > 280? 280: stringWidth;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, height, stringWidth + 30, cellHeight)];
    [view setBackgroundColor:[UIColor colorWithRed:254./255 green:232./255 blue:204./255 alpha:1]];
    view.layer.cornerRadius = 3;
    view.layer.borderColor = [UIColor colorWithRed:254./255 green:203./255 blue:140./255 alpha:1].CGColor;
    view.layer.borderWidth = 1;
    [self addSubview:view];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height + cellHeight + seperate)];
    
    
    //下面给view添加内容
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, stringWidth, cellHeight)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:83./255 green:83./255 blue:83./255 alpha:1];
    label.text = str;
    [view addSubview:label];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(stringWidth - 5, -5, 40, 40)];
    [but setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    but.tag = t + 1;
    [but setImage:[UIImage imageNamed:@"closes.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
}

- (void) deleteClicked:(UIButton*) but{
    float seperate = 15;
    float cellHeight = 30;
    
    int t = (int)[[self subviews] count];//共有多少个viewheight / (cellHeight + seperate)

    for (int i=t - 1; i > but.tag - 1; i--){
        UIView *view = [[self subviews] objectAtIndex:i];
        [view setFrame:CGRectMake(view.frame.origin.x, (cellHeight + seperate) * i - cellHeight , view.frame.size.width, view.frame.size.height)];
        ((UIButton*)[[view subviews]objectAtIndex:1 ]).tag = i;
        //NSLog(@"%@, %ld", ((UILabel*)[[view subviews] objectAtIndex:0]).text, ((UIButton*)[[view subviews]objectAtIndex:1 ]).tag);
    }
    
    [InitData distory: (UIView*)[[self subviews] objectAtIndex:but.tag - 1] ];
    
    
    float height = (cellHeight + seperate) * t - cellHeight;
    if (height == seperate)
        height = 1;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
    
    //调用代理
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteItem:)]){
        [self.delegate deleteItem:(int)but.tag - 1];
    }
}

- (int) selectedCount{
    return (int)[[self subviews] count];
}

- (NSMutableArray*) selectedItem{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSArray *arr = [self subviews];
    for (int i=0; i<[arr count]; i++){
        UIView *view = [arr objectAtIndex:i];
        UILabel *label =[[view subviews] objectAtIndex:0];
        [res addObject:label.text];
    }
    return res;
}

@end
