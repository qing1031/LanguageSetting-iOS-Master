//
//  CutImageViewController.h
//  cs74cms
//
//  Created by lyp on 15/5/9.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "SuperViewController.h"
#import "BJImageCropper.h"

@protocol cutImageDelegate <NSObject>

- (void) getCutImage:(UIImage*) img;

@end

@interface CutImageViewController : SuperViewController

@property (nonatomic, retain) id<cutImageDelegate> delegate;

@property (nonatomic, strong) BJImageCropper *imageCropper;
@property (nonatomic, strong) UIImageView *preview;

//- (void) setCutImage:(UIImage*) img;
- (void) getPicture;

@end
