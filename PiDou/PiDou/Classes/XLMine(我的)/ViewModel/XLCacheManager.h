//
//  XLCacheManager.h
//  PiDou
//
//  Created by ice on 2019/5/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLCacheManager : NSObject

/**
 获取缓存大小
 */
+ (NSString *)getCacheSize;

/**
 清除缓存
 */
+ (void)clearCache;

@end

NS_ASSUME_NONNULL_END
