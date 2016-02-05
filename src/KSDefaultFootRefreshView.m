//
//  KSDefaultFootRefreshView.m
//  KSRefresh
//
//  Created by bing.hao on 15/4/6.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "KSDefaultFootRefreshView.h"

#define KSFootRefreshView_T_1 MYLocalizedString(@"加载更多数据", @"Load more data")
#define KSFootRefreshView_T_2 MYLocalizedString(@"松开刷新", @"Undo refresh")
#define KSFootRefreshView_T_3 @""
#define KSFootRefreshView_T_4 MYLocalizedString(@"已无更新的数据", @"No updated data")

#define NavigationHeight 55

@interface KSDefaultFootRefreshView ()

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;
@property (nonatomic, strong) UILabel                 * titleLabel;

@end

@implementation KSDefaultFootRefreshView
@synthesize isLastPage = _isLastPage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.indicatorView        = [[UIActivityIndicatorView alloc] init];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.indicatorView.center = CGPointMake(KS_SCREEN_WIDTH / 2, KSRefreshView_Height / 2);
        self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KS_SCREEN_WIDTH, KSRefreshView_Height)];
        self.titleLabel.font            = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor       = [UIColor darkGrayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
        self.titleLabel.text            = KSFootRefreshView_T_1;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.indicatorView];
        
        self.hidden = YES;
    }
    return self;
}

- (void)setIsLastPage:(BOOL)isLastPage
{
    if (isLastPage) {
        
        [self setValue:@(RefreshViewStateDefault) forKeyPath:@"_state"];
        [self.titleLabel setText:KSFootRefreshView_T_4];
        [self.indicatorView stopAnimating];
        
        UIEdgeInsets ei = self.targetView.contentInset;
        
        ei.bottom = self.targetViewOriginalEdgeInsets.bottom + KSRefreshView_Height;
        
        self.targetView.contentInset = ei;
        
    } else {
        [self.titleLabel setText:KSFootRefreshView_T_1];
    }
    
    _isLastPage = isLastPage;
}

- (void)setState:(RefreshViewState)state
{
    if (_isLastPage) {
        return;
    }
    
    [super setState:state];
    
    switch (state) {
        case RefreshViewStateDefault:
        {
            [self.titleLabel setText:KSFootRefreshView_T_1];
            [self.indicatorView stopAnimating];
            UIEdgeInsets ei = self.targetViewOriginalEdgeInsets;
            ei.bottom += NavigationHeight;
            [self setScrollViewContentInset:ei];
            
            break;
        }
        case RefreshViewStateVisible:
        {
            [self.titleLabel setText:KSFootRefreshView_T_1];
            [self.indicatorView stopAnimating];
            UIEdgeInsets ei = self.targetViewOriginalEdgeInsets;
            ei.bottom += NavigationHeight;
            [self setScrollViewContentInset:ei];//self.targetViewOriginalEdgeInsets
            
            break;
        }
        case RefreshViewStateTriggered:
        {
            [self.titleLabel setText:KSFootRefreshView_T_2];
            break;
        }
        case  RefreshViewStateLoading:
        {
            [self.titleLabel setText:KSFootRefreshView_T_3];
            [self.indicatorView startAnimating];
            
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.bottom = self.targetViewOriginalEdgeInsets.bottom + KSRefreshView_Height + NavigationHeight;
            
            [self setScrollViewContentInset:ei];
            
            if ([self.delegate respondsToSelector:@selector(refreshViewDidLoading:)]) {
                [self.delegate refreshViewDidLoading:self];
            }
            
            break;
        }
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.targetView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        
    }];
}

@end
