//
//  XLShareManager.h
//  PiDou
//
//  Created by kevin on 8/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLShareManager : NSObject
singleton_h(XLShareManager)

@property (nonatomic, strong) XLShareModel *message;

/**分享网页*/
+ (void)shareWebPageToPlatformType:(XLSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController;

/**分享图文（新浪支持，微信/QQ仅支持图或文本分享）*/
+ (void)shareImageAndTextToPlatformType:(XLSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
