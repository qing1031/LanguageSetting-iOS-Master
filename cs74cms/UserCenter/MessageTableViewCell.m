//
//  MessageTableViewCell.m
//  74cms
//
//  Created by LPY on 15-4-13.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "InitData.h"
@interface MessageTableViewCell(){
    UILabel *title;
    UILabel *message;
    UILabel *time;
    UILabel *state;
    UIButton *delet;
}

@end

@implementation MessageTableViewCell

@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTitle:(NSString*) str
{
    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
    [self addSubview:title];
    title.text = str;
    
    /*不要删除
    delet = [UIButton buttonWithType:UIButtonTypeCustom];
    [delet setFrame:CGRectMake([InitData Width] - 60, 32, 40, 40)];
    [delet setImage:[UIImage imageNamed:@"delet.png"] forState:UIControlStateNormal];
    [delet addTarget:self action:@selector(deletClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delet];
    */
    
    UIView *separe = [[UIView alloc] initWithFrame:CGRectMake(0, 80, [InitData Width], 5)];
    [separe setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
    [self addSubview:separe];
}
- (void) setMessage:(NSString*) str{
    message = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, self.frame.size.width  - 80, 15)];
    message.font = [UIFont systemFontOfSize:14];
    message.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    message.text = str;
    [self addSubview:message];

}
- (void) setTime:(NSString*) str{
    time = [[ UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 100, 15, 80, 20)];
    time.font = [UIFont systemFontOfSize:12];
    time.textAlignment = NSTextAlignmentRight;
    time.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    [self addSubview:time];
    time.text = str;
}
- (void) setState:(NSString*) str{
    state = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 80, 15, 50, 25)];
    state.font = [UIFont systemFontOfSize:12];
    state.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    [self addSubview:state];
    state.text = str;
}



#pragma mark - event
/*
-(void) deletClicked:(UIButton*) but{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deletClicked:)]){
        [self.delegate deletClicked:self.tag];
    }
}*/

@end
