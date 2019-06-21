//
//  XLCacheManager.m
//  PiDou
//
//  Created by ice on 2019/5/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCacheManager.h"

@implementation XLCacheManager


#pragma mark - 获取缓存大小
+ (NSString *)getCacheSize {
    //sd缓存大小
    NSUInteger sdCacheSize = [[SDImageCache sharedImageCache] getSize];
   ;
    
    return [self cacheSizeWithInterge:sdCacheSize];
}

#pragma mark - 清除缓存
+ (void)clearCache{
    //清理SD缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
}

+ (NSString *)cacheSizeWithInterge:(NSInteger)size{
    // 1k = 1024b, 1m = 1024k
    
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024.0;
        return [NSString stringWithFormat:@"%.2fKB",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024.0 * 1024.0);
        return [NSString stringWithFormat:@"%.2fMB",aFloat];
    }else{
        CGFloat aFloat = size/(1024.0*1024.0*1024.0);
        return [NSString stringWithFormat:@"%.2fGB",aFloat];
    }
    
}

@end
