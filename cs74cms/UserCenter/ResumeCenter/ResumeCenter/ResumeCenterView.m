//
//  ResumeCenterView.m
//  74cms
//
//  Created by lyp on 15/4/22.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "ResumeCenterView.h"
#import "InitData.h"
#import "DealCacheController.h"
#define But_TAGBEGIN 255

@interface ResumeCenterView(){
    UILabel *titleLabel;
    UILabel *creatLabel;
    UILabel *updateLabel;
    
    UILabel *haveApplyLa;
    UILabel *careMeLa;
    UILabel *inviteLa;
    
    UIButton *picture;
    UIButton *privacySet;
}

@end

@implementation ResumeCenterView

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1]];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], [InitData Height] * 0.4)];
        [topView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:topView];
        
        float width = 70, height = 85;
        picture = [UIButton buttonWithType:UIButtonTypeCustom];
        [picture setImage:[UIImage imageNamed:@"picture.jpg"] forState:UIControlStateNormal];//@"http://may.74cms.com/data/photo/thumb/2015/05/27/20150527152804.png"
        [picture setFrame:CGRectMake(20, 25, width, height)];
        [picture addTarget:self action:@selector(getPicture:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:picture];
        
        privacySet = [UIButton buttonWithType:UIButtonTypeCustom];
        [privacySet setFrame:CGRectMake(20, 25 + height + 10, width, 20)];
        [privacySet addTarget:self action:@selector(privacySet:) forControlEvents:UIControlEventTouchUpInside];
        [privacySet setTitle:MYLocalizedString(@"公开", @"Public") forState:UIControlStateNormal];
        [privacySet setBackgroundColor:[UIColor colorWithRed:96./255 green:118./255 blue:155./255 alpha:1]];
        privacySet.titleLabel.textColor = [UIColor whiteColor];
        privacySet.titleLabel.font = [UIFont systemFontOfSize:14];
        privacySet.layer.cornerRadius = 1;
        [topView addSubview:privacySet];
     
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] * 0.35, 25, [InitData Width] * 0.6, 20)];
        titleLabel.text = MYLocalizedString(@"我的简历", @"My resume");
        titleLabel.font = [UIFont systemFontOfSize:15];
        [topView addSubview:titleLabel];
        
        updateLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] * 0.35, 60, 200, 20)];
        updateLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        updateLabel.font = [UIFont systemFontOfSize:13];
        updateLabel.text = MYLocalizedString(@"刷新时间   ", @"Refresh time");
        [topView addSubview:updateLabel];
        
        creatLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] * 0.35, updateLabel.frame.size.height + updateLabel.frame.origin.y + 5, 200, 20)];
        creatLabel.textColor = updateLabel.textColor;
        creatLabel.font = updateLabel.font;
        creatLabel.text = MYLocalizedString(@"创建时间   ", @"Create time");
        [topView addSubview:creatLabel];
        
        
        
        UIButton *haveApply = [UIButton buttonWithType:UIButtonTypeCustom];
        [haveApply setFrame:CGRectMake([InitData Width] * 0.35, topView.frame.size.height * 0.6, 40, 40)];
        [haveApply setImage:[UIImage imageNamed:@"apply_resume_img.png"] forState:UIControlStateNormal];
        [haveApply setImage:[UIImage imageNamed:@"apply_resume_img2.png"] forState:UIControlStateHighlighted];
        haveApply.adjustsImageWhenHighlighted = NO;
        [haveApply addTarget:self action:@selector(haveApplyClicked) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:haveApply];
        
        UIFont *font = [UIFont systemFontOfSize:14];
        
        haveApplyLa = [[UILabel alloc] initWithFrame:CGRectMake(haveApply.frame.origin.x, topView.frame.size.height * 0.6 + 40, 40, 20)];
        haveApplyLa.textColor = [UIColor colorWithRed:53.0 / 255 green:53.0 /255 blue:53.0/255 alpha:1];
        haveApplyLa.textAlignment = NSTextAlignmentCenter;
        haveApplyLa.font = font;
        haveApplyLa.text = @"15";
        [topView addSubview:haveApplyLa];
        
        UIButton *careMe = [UIButton buttonWithType:UIButtonTypeCustom];
        [careMe setFrame:CGRectMake([InitData Width] * 0.55, topView.frame.size.height * 0.6, 40, 40)];
        [careMe setImage:[UIImage imageNamed:@"who_attent_my.png"] forState:UIControlStateNormal];
        [careMe setImage:[UIImage imageNamed:@"who_attent_my2.png"] forState:UIControlStateHighlighted];
        careMe.adjustsImageWhenHighlighted = NO;
        [careMe addTarget:self action:@selector(careMeClicked) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:careMe];
        
        careMeLa = [[UILabel alloc] initWithFrame:CGRectMake(careMe.frame.origin.x, topView.frame.size.height * 0.6 + 40, 40, 20)];
        careMeLa.textColor = [UIColor colorWithRed:53.0 / 255 green:53.0 /255 blue:53.0/255 alpha:1];
        careMeLa.textAlignment = NSTextAlignmentCenter;
        careMeLa.font = font;
        careMeLa.text = @"13";
        [topView addSubview:careMeLa];
        
        
        UIButton *invite = [UIButton buttonWithType:UIButtonTypeCustom];
        [invite setFrame:CGRectMake([InitData Width] * 0.75, topView.frame.size.height * 0.6, 40, 40)];
        [invite setImage:[UIImage imageNamed:@"interview.png"] forState:UIControlStateNormal];
        [invite setImage:[UIImage imageNamed:@"interview2.png"] forState:UIControlStateHighlighted];
        invite.adjustsImageWhenHighlighted = NO;
        [invite addTarget:self action:@selector(inviteClicked) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:invite];
        
        inviteLa = [[UILabel alloc] initWithFrame:CGRectMake(invite.frame.origin.x, topView.frame.size.height * 0.6 + 40, 40, 20)];
        inviteLa.textColor = [UIColor colorWithRed:53.0 / 255 green:53.0 /255 blue:53.0/255 alpha:1];
        inviteLa.textAlignment = NSTextAlignmentCenter;
        inviteLa.font = font;
        inviteLa.text = @"2";
        [topView addSubview:inviteLa];
        
        
        
        float ewidth = [InitData Width] / (3 + 0.6 * 2 + 0.5 * 2);
        float etop = ([InitData Height] - topView.frame.size.height - 70 - ewidth * 2 - 20 * 2) / 2;
        
        NSArray *titleArr = [NSArray arrayWithObjects:MYLocalizedString(@"编辑简历", @"Edit resume"), MYLocalizedString(@"预览简历", @"Preview resume"), MYLocalizedString(@"刷新简历", @"Refresh resume"),   MYLocalizedString(@"隐私设置", @"Privacy settings"), MYLocalizedString(@"屏蔽企业", @"Shielding enterprise"), MYLocalizedString(@"删除简历", @"Delete resume"), nil];
        NSArray *imgArr = [NSArray arrayWithObjects:@"edit_resume.png", @"preview_resume.png", @"refresh_resume.png",  @"set_privacy.png", @"shield_firm.png", @"delete_resume2.png", nil];
        NSArray *imgArr2 = [NSArray arrayWithObjects:@"edit_resume2.png", @"preview_resume.png", @"refresh_resume2.png",  @"set_privacy2.png", @"shield_firm2.png", @"delete_resume2.png", nil];
        
        for (int i=0; i<[titleArr count]; i++){
            float x = i % 3 * ewidth * 1.6 + ewidth * 0.5;
            float y = i / 3 * (ewidth + 20 + etop) + etop + topView.frame.size.height;
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:[imgArr2 objectAtIndex:i]] forState:UIControlStateHighlighted];
            [but setFrame:CGRectMake(x, y, ewidth, ewidth)];
            but.tag = But_TAGBEGIN + i;
            [but addTarget:self action:@selector(butClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:but];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y + ewidth + 5, ewidth, 20)];
            label.font = font;
            label.textColor = haveApplyLa.textColor;
            label.text = [titleArr objectAtIndex:i];
            [self addSubview:label];
        }
        
        
    }
    return self;
}

- (void) setHaveApply:(NSString*) str{
    haveApplyLa.text = str;
}
- (void) setCareMe:(NSString*) str{
    careMeLa.text = str;
}
- (void) setInvite:(NSString*) str{
    inviteLa.text = str;
}

- (void) setTitle:(NSString*) str
{
    titleLabel.text = str;
}
- (void) setUpdateTime:(NSString*) str
{
    updateLabel.text = [NSString stringWithFormat:MYLocalizedString(@"刷新时间   %@", @"Update time   %@"), str];
}
- (void) setCreatTime:(NSString*) str
{
    creatLabel.text = [NSString stringWithFormat:@"%@%@", creatLabel.text, str];
}
- (void) setPicture:(NSString*) str{
    NSData *data = [[[DealCacheController alloc] init] getImageData:str];
    UIImage*img = [UIImage imageWithData:data];
    [picture setImage:img forState:UIControlStateNormal];
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
   // });
}

- (void) setPrivacySetTitle:(NSString*) str{
    [privacySet setTitle:str forState:UIControlStateNormal];
}
- (void) privacySet:(UIButton*) but{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(butClicked:)]){
        [self.delegate privacySet];
    }
}

- (void) butClicked:(UIButton*) but{
    int tag = (int)but.tag - But_TAGBEGIN;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(butClicked:)]){
        [self.delegate butClicked:tag];
    }
    
}

- (void) haveApplyClicked{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(haveApplyClicked)]){
        [self.delegate haveApplyClicked];
    }
}

- (void) careMeClicked{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(careMeClicked)]){
        [self.delegate careMeClicked];
    }
}
- (void) inviteClicked{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(inviteClicked)]){
        [self.delegate inviteClicked];
    }
}

- (void) getPicture:(UIButton*) but{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getPicture:)]){
        [self.delegate getPicture:but];
    }
}

@end
