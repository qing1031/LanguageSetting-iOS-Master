//
//  LocalizedDefine.h
//  cs74cms
//
//  Created by Software Superstar on 1/19/16.
//  Copyright © 2016 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#ifndef LocalizedDefine_h
#define LocalizedDefine_h

#import "LocalizationManager.h"

#define MYLocalizedString(key, comment) [LocalizationManager getLocalizedString:key andComment:comment]

#endif /* LocalizedDefine_h */
