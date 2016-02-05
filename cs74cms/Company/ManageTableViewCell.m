//
//  ManageTableViewCell.m
//  74cms
//
//  Created by lyp on 15/5/6.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ManageTableViewCell.h"
#import "InitData.h"

@implementation ManageTableViewCell

@synthesize delegate;

@synthesize menu;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) subMenu{
    UIView *subMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 50)];
    [subMenu setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, subMenu.frame.size.width, subMenu.frame.size.height)];
    backView.image = [UIImage imageNamed:@"backgrounds.png"];
    [subMenu addSubview:backView];
    
    NSArray *arr = [NSArray arrayWithObjects:@"examine.png", @"refresh_ex.png", @"compile.png", @"company_resume.png", @"deletes_res", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:MYLocalizedString(@"查看", @"See"), MYLocalizedString(@"刷新", @"Refresh"), MYLocalizedString(@"编辑", @"Edit"), MYLocalizedString(@"应聘简历", @"Apply for resume"), MYLocalizedString(@"删除", @"Delete"), nil];
    
    float cellH = 18;
    float left = 30;
    float sep = (subMenu.frame.size.width - cellH * 5 - left * 2) / 4;
    for (int i=0; i<[arr count]; i++){
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(left, i == 0?13 : 10, cellH ,i==0?(cellH - 5):cellH)];
        [imgView setImage:[UIImage imageNamed:[arr objectAtIndex:i]]];
         [subMenu addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left - 20, 10 + cellH + 3, cellH + 40, 13)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = [ arr2 objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [subMenu addSubview:label];
        
        UIButton *but =[UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(left, i==0?13:10, cellH + 10, (i==0?(cellH - 5):cellH) + 16)];
        [but setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        but.tag = i + 1;
        [but addTarget:self action:@selector(subMenuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [subMenu addSubview:but];
        
        left += cellH + sep;
    }
    [self addSubview:subMenu];
}

- (void) subMenuButClicked:(UIButton*) but{
    long index = but.tag - 1;
    if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(managetableViewCellSelected:)]){
        [self.delegate managetableViewCellSelected:(int) index];
    }
}

- (void) setTitle:(NSString*) str
{
    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 180, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
    [self addSubview:title];
    title.text = str;
    
    separe = [[UIView alloc] initWithFrame:CGRectMake(15, 80, [InitData Width] - 30, 1)];
    [separe setBackgroundColor:[UIColor colorWithRed:213.0 / 255 green:213.0 / 255 blue:213.0 / 255 alpha:1]];
    [self addSubview:separe];

}
- (void) setMessage:(NSString*) str{
    message = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, self.frame.size.width  - 80, 15)];
    message.font = [UIFont systemFontOfSize:14];
    message.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    [self addSubview:message];
    message.text = str;
}
- (void) setTime:(NSString*) str{
    time = [[ UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 110, 15, 90, 20)];
    time.font = [UIFont systemFontOfSize:12];
    time.textAlignment = NSTextAlignmentRight;
    time.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    [self addSubview:time];
    time.text = [str substringToIndex:10];
}
- (void) setValue:(NSString*) str{
    value = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 190, 45, 170, 15)];
    value.font = [UIFont systemFontOfSize:12];
    value.textColor = [UIColor colorWithRed:243.0 / 255 green:134.0 / 255 blue:58.0 / 255 alpha:1];
    value.textAlignment =NSTextAlignmentRight;
    [self addSubview:value];
    value.text = str;
}
- (void) setNum:(int) t{
    num = [[UILabel alloc] init];
    
    CGSize size = [title.text sizeWithFont:title.font];
    
    NSString *str = [NSString stringWithFormat:@"%d", t];
    CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:13]];
    
    [num setFrame:CGRectMake(size.width + 20 + 10, title.frame.origin.y + 2, size1.width + 10, 15)];
    num.textColor = [UIColor whiteColor];
    num.backgroundColor =[UIColor colorWithRed:228./255 green:48./255 blue:56./255 alpha:1];
    num.layer.cornerRadius = 7;
    num.layer.masksToBounds = YES;

    num.font = [UIFont systemFontOfSize:13];
    num.textAlignment = NSTextAlignmentCenter;
    num.text = str;
    [self addSubview:num];
    
}

@end
