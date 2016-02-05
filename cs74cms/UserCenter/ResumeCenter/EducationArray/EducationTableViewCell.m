//
//  EducationTableViewCell.m
//  74cms
//
//  Created by lyp on 15/4/23.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "EducationTableViewCell.h"
#import "InitData.h"

@implementation EducationTableViewCell

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTitle:(NSString*) title andStartTime:(NSString*) start andEndTime:(NSString*) end{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    label.textColor = [UIColor colorWithRed:53.0 / 255 green:53.0 / 255 blue:53.0 / 255 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    [self addSubview:label];
    
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 270, 16)];
    time.textColor = [UIColor colorWithRed:102.0 / 255 green:102. / 255 blue:102./255 alpha:1];
    time.text = [NSString stringWithFormat:MYLocalizedString(@"%@到%@", @"%@to%@"), start, end];
    time.font = [UIFont systemFontOfSize:13];
    [self addSubview:time];
    
    
    UIImageView *goView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 20 - 20, 15, 20, 25)];
    [goView setImage:[UIImage imageNamed:@"go.png"]];
    [self addSubview:goView];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 54, [InitData Width] - 30, 1)];
    [view setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235. / 255 blue:235. / 255 alpha:1]];
    [self addSubview:view];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPress];
    
    sign = YES;//为了防止长按多次出发
    
}

- (void) longPressToDo:(UILongPressGestureRecognizer*) longPress{
    if (sign && self.delegate != nil && [self.delegate respondsToSelector:@selector(longPressToDo:)]){
        [self.delegate longPressToDo:longPress.view.tag];
        sign = NO;
    }
}


@end
