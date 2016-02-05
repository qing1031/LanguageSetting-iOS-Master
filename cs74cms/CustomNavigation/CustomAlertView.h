//
//  CustomAlertView.h
//  74cms
//
//  Created by lyp on 15/4/23.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitData.h"

@protocol CustomAlertViewDelegate <NSObject>

- (void) customAlertViewbuttonClicked:(int) index;

@end

@interface CustomAlertView : UIView{
    float th;//标题高度
    float mh;//消息高度
    float bh;//按钮高度
    float height;//总高度
    float width;//总宽度
}

@property(nonatomic, retain) id<CustomAlertViewDelegate> delegate;

- (void) setDirection:(Direction) t andTitle:(NSString*) stitle andMessage:(NSString*) mes andArray:(NSArray*) arr;


@end
