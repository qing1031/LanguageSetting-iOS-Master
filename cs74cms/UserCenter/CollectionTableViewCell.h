//
//  CollectionTableViewCell.h
//  74cms
//
//  Created by LPY on 15-4-14.
//  Copyright (c) 2015年 lyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell
- (void) setTitle:(NSString*) str;

- (void) setMessage:(NSString*) str;

- (void) setTime:(NSString*) str;


//type0 灰色  1胡萝卜黄  2艳红
- (void) setValueColorType:(int) type;
- (void) setValue:(NSString*) str;

- (void) setTimeColorType:(int) type;

- (void) setStyle:(int) sign;//sign ＝ 1 表示橙色的在上面，默认橙色在下面
@end
