//
//  NewsTableViewCell.m
//  74cms
//
//  Created by lyp on 15/5/4.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "InitData.h"
#import "DealCacheController.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setType:(NSString*) type andTitle:(NSString*) title andMessage:(NSString*) mes andImg:(NSString*) img{
    UILabel *titleLab = [[UILabel alloc] init];
    [titleLab setFrame:CGRectMake(100, 20, [InitData Width] - 120, 15)];
    if (img == nil){
        [titleLab setFrame:CGRectMake(15, 20, [InitData Width] - 40, 15)];
    }
    
    titleLab.text = [NSString stringWithFormat:@"[%@]%@", type, title];
    titleLab.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLab];
    
    
    UILabel *mesLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x, 40, titleLab.frame.size.width, 33)];
    mesLab.numberOfLines =3;
    mesLab.text = mes;
    mesLab.font = [UIFont systemFontOfSize:12];
    mesLab.textColor = [UIColor colorWithRed:135./255 green:135./255 blue:135./255 alpha:1];
    [self addSubview:mesLab];
    
    if (img != nil){
        //不可从主线程取值

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            NSData *data = [[[DealCacheController alloc] init] getImageData:img];
            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 75, 50)];
                [imgView setImage:[UIImage imageWithData:data]];
                [self addSubview:imgView];
                
            });
        });
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 89, [InitData Width] - 30, 1)];
    [view setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
    [self addSubview:view];
}

@end
