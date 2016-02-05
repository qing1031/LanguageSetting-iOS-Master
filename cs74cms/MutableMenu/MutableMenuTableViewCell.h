//
//  MutableMenuTableViewCell.h
//  cs74cms
//
//  Created by lyp on 15/5/15.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MutableMenuCellDelegate <NSObject>

- (void) getSelectedCell:(int) index andSelected:(BOOL) select;


@end


@interface MutableMenuTableViewCell : UITableViewCell{
    UIImageView *imgView;
    
    UIButton *label;
   // UIButton *select;
    
    int index;
    int level;
}
@property (nonatomic, strong) id<MutableMenuCellDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *ChildArray;//存放子菜单
@property (nonatomic,assign) BOOL  Open;//表示子菜单是否打开

@property (nonatomic, assign) int level;

- (void) setTitle:(NSString*) str;

- (NSString*) getTitle;

- (void) setTitleX:(CGFloat) x;

- (void) setChance:(BOOL) selected;//选中

- (void) setCanSelectedByIndex:(int) tindex;//点击

@end
