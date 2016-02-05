//
//  CollectionTableViewCell.m
//  74cms
//
//  Created by LPY on 15-4-14.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "InitData.h"
@interface CollectionTableViewCell(){
    UILabel *title;
    UILabel *message;
    UILabel *time;
    UILabel *value;
}

@end

@implementation CollectionTableViewCell

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
    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, self.frame.size.width  - 100, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
    [self addSubview:title];
    title.text = str;
    
    UIView *separe = [[UIView alloc] initWithFrame:CGRectMake(15, 80, [InitData Width] - 30, 1)];
    [separe setBackgroundColor:[UIColor colorWithRed:201.0 / 255 green:201.0 / 255 blue:201.0 / 255 alpha:1]];
    [self addSubview:separe];

}
- (void) setMessage:(NSString*) str{
    message = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, self.frame.size.width  - 135, 15)];
    message.font = [UIFont systemFontOfSize:14];
    message.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    [self addSubview:message];
    message.text = str;
}
- (void) setTime:(NSString*) str{
    time = [[ UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 140, 18, 120, 20)];
    time.font = [UIFont systemFontOfSize:12];
    time.textAlignment = NSTextAlignmentRight;
    time.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    [self addSubview:time];
    time.text = str;
}
//type0 灰色  1胡萝卜黄  2艳红
- (void) setValueColorType:(int) type{
    switch (type) {
        case 0:
            value.textColor = [UIColor colorWithRed:135./255 green:135./255 blue:135./255 alpha:1];
            break;
        case 1:
            value.textColor = [UIColor colorWithRed:237./255 green:113./255 blue:45./255 alpha:1];
            break;
        case 2:
            value.textColor = [UIColor colorWithRed:252./255 green:84./255 blue:89./255 alpha:1];
            break;
            
        default:
            break;
    }
}
- (void) setTimeColorType:(int) type{
    switch (type) {
        case 0:
            time.textColor = [UIColor colorWithRed:135./255 green:135./255 blue:135./255 alpha:1];
            break;
        case 1:
            time.textColor = [UIColor colorWithRed:237./255 green:113./255 blue:45./255 alpha:1];
            break;
        case 2:
            time.textColor = [UIColor colorWithRed:252./255 green:84./255 blue:89./255 alpha:1];
            break;
            
        default:
            break;
    }
}
- (void) setValue:(NSString*) str{
    value = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 170, 45, 150, 15)];
    value.font = [UIFont systemFontOfSize:12];
    value.textColor = [UIColor colorWithRed:243.0 / 255 green:134.0 / 255 blue:58.0 / 255 alpha:1];
    value.textAlignment = NSTextAlignmentRight;
    [self addSubview:value];
    value.text = str;
}

- (void) setStyle:(int) sign{
    if (sign == 1)
    {
        CGRect frame = time.frame;
        time.frame = value.frame;
        value.frame = frame;
    }
}



@end
