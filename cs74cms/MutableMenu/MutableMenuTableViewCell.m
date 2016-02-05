//
//  MutableMenuTableViewCell.m
//  cs74cms
//
//  Created by lyp on 15/5/15.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "MutableMenuTableViewCell.h"
#import "InitData.h"

@implementation MutableMenuTableViewCell

@synthesize ChildArray;
@synthesize Open;
@synthesize level;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) selectClick:(UIButton*) but{
    but.selected = !but.selected;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getSelectedCell: andSelected:)]){
        [self.delegate getSelectedCell:index andSelected:but.selected];
    }
}
- (void) setCanSelectedByIndex:(int) tindex{
    index = tindex;
    label.userInteractionEnabled = YES;
    [label addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    /*  select = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];

    [select setImage:[UIImage imageNamed:@"Unselected.png"] forState:UIControlStateNormal];
    [select setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateSelected];
    [select addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    select.selected = NO;
    [select setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [self addSubview:select];
    
    if (label != nil && level == 0)
        [label setFrame:CGRectMake(20 + 20 + 5, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
  
    else if (level > 0){
        [label setFrame:CGRectMake(label.frame.origin.x + 25, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
        float x = label.frame.origin.x - 15 - 10;
        [select setFrame:CGRectMake(x,  5, 30, 30)];
        
    }    */
}
- (void) setTitle:(NSString*) str{
    
  /*  label = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 250, 20)];
    label.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    label.font = [UIFont systemFontOfSize:14];
    label.text = str;
    [self addSubview:label];
    */
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]];
    label = [UIButton buttonWithType:UIButtonTypeCustom];
    [label setFrame:CGRectMake(25, 10, size.width, 20)];
    label.titleLabel.text = str;
    [label setTitle:str forState:UIControlStateNormal];
    [label setTitleColor:[UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1] forState:UIControlStateNormal];
    label.titleLabel.font = [UIFont systemFontOfSize:14];
    label.userInteractionEnabled = NO;
    [self addSubview:label];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, 39, [InitData Width] - 30, 1)];
    sep.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    [self addSubview:sep];
}
- (NSString*) getTitle{
    return label.titleLabel.text;
}
- (void) setTitleX:(CGFloat) x{
    level = x  / 25;
    [label setFrame:CGRectMake(25 + x, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
    
   /* if (select != nil){
        [select setFrame:CGRectMake(x - 10,  5, 30, 30)];
    }*/
}

- (void) setChance:(BOOL) selected{

    if (selected){
        imgView  = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 20 - 30, (40 - 30) / 2, 30, 30)];
        [imgView setImage:[UIImage imageNamed:@"check.png"]];
        [self addSubview:imgView];
        return;
    }
    [imgView removeFromSuperview];
    imgView = nil;
}

- (void) setOpen:(BOOL)topen{
    if (topen){
        imgView  = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 20 - 25, (40 - 25) / 2, 25, 25)];
        [imgView setImage:[UIImage imageNamed:@"down.png"]];
        [imgView setAlpha:0.7];
        [self addSubview:imgView];
        return;
    }
    imgView  = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 20 - 25, (40 - 25) / 2, 25, 25)];
    [imgView setImage:[UIImage imageNamed:@"up.png"]];
    [imgView setAlpha:0.7];
    [self addSubview:imgView];
}

@end
