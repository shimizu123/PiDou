//
//  RandomString.h
//  PiDou
//
//  Created by 邓康大 on 2019/7/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RandomString : NSObject

+ (NSString *)getPdversion;

+ (NSString *)getRandomString;

+ (NSString *)md5WithString:(NSString *)pdrandom;

+ (NSString *)getVersion;

@end

NS_ASSUME_NONNULL_END
