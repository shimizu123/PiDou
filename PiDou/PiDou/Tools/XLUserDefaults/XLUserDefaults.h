//
//  XLUserDefaults.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLUserDefaults : NSObject

+ (void)xl_setValue:(id)value forKey:(NSString *)key;

+ (id)xl_valueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
