//
//  MainFunction.m
//  74cms
//
//  Created by LPY on 15-4-10.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import "MainFunctionDiv.h"

@interface MainFunctionDiv(){
    
    UIImageView *imgView;
//    UILabel *titleLabel;
}

@end

@implementation MainFunctionDiv

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = [[UIColor colorWithRed:226.0 / 255 green:226.0 / 255 blue:226.0 / 255 alpha:1] CGColor];
        self.layer.borderWidth = 1;
        
        
        imgView = [[UIImageView alloc] init];
        CGSize s = CGSizeMake(frame.size.height / 2 - 16, frame.size.height / 2 - 16);
        CGPoint p = CGPointMake(frame.size.width / 2, (frame.size.height / 2 - 16)/ 2 + frame.size.height / 5);
        [imgView setFrame:CGRectMake(p.x - s.width / 2, p.y - s.height / 2, s.width, s.height)];

        [self addSubview: imgView];
        
        _titleLabel = [[UILabel alloc] init];
        CGSize s2 = CGSizeMake(frame.size.width / 1.5, 16);
        CGPoint p2 = CGPointMake(frame.size.width / 2, frame.size.height * 3 / 4 - 8);
        [_titleLabel setFrame:CGRectMake(p2.x - s2.width / 2, p2.y - s2.height / 2, s2.width, s2.height)];
        _titleLabel.font = [UIFont systemFontOfSize: 14];
        _titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
        _titleLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        [self addSubview:_titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setImage:(NSString*) img andTitle:(NSString*) title{
    [imgView setImage:[UIImage imageNamed:img]];
    [_titleLabel setText:title];
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    
}


- (void) singleTap:(UITapGestureRecognizer*) recognizer
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectThis:)] == YES){
        [self.delegate selectThis:(int)self.tag];
    }
}

@end
