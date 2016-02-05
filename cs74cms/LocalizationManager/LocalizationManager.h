//
//  LocalizationManager.h
//  Recipe
//
//  Created by Yingcheng Li on 1/27/15.
//  Copyright (c) 2015 ss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationManager : NSObject

+ (void) initLocalizationBundle;
+ (NSString*) getLocalizedString:(NSString*) key andComment:(NSString*) comment;

@end
