//
//  LocalizationManager.m
//  Recipe
//
//  Created by Yingcheng Li on 1/27/15.
//  Copyright (c) 2015 ss. All rights reserved.
//

#import "LocalizationManager.h"

@implementation LocalizationManager

static NSBundle *localizeBundle;

+ (void) initLocalizationBundle {
    NSString *lngBundlePath = [[NSBundle mainBundle] pathForResource:@"Lang" ofType:@"bundle"];
    NSBundle *lngBundle = [NSBundle bundleWithPath:lngBundlePath];
    
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSString *path = [lngBundle pathForResource:lng ofType:@"lproj"];
    
    if (path == nil) {
        lng = @"en";
        [[NSUserDefaults standardUserDefaults] setObject:lng forKey:@"language"];
        path = [lngBundle pathForResource:lng ofType:@"lproj"];
    }
    localizeBundle = [NSBundle bundleWithPath:path];
}

+ (NSString*) getLocalizedString:(NSString*) key andComment:(NSString*) comment {
    [self initLocalizationBundle];
    
    return NSLocalizedStringFromTableInBundle(key, @"Root", localizeBundle, nil);
}

@end
