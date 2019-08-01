//
//  PublishLinkHandler.h
//  PiDou
//
//  Created by 邓康大 on 2019/7/31.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishLinkHandler : NSObject

+ (void)parsePPXLink:(NSString *)itemId success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
