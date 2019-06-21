//
//  XLShareManager.m
//  PiDou
//
//  Created by kevin on 8/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLShareManager.h"
#import "WXApiRequestHandler.h"


@implementation XLShareManager
singleton_m(XLShareManager)

/**分享网页*/
+ (void)shareWebPageToPlatformType:(XLSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController {
    [[self sharedXLShareManager] shareWebPageToPlatformType:platformType currentViewController:currentViewController];
}

/**分享图文（新浪支持，微信/QQ仅支持图或文本分享）*/
+ (void)shareImageAndTextToPlatformType:(XLSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController {
    [[self sharedXLShareManager] shareImageAndTextToPlatformType:platformType currentViewController:currentViewController];
}


/**分享网页*/
- (void)shareWebPageToPlatformType:(XLSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController {
    switch (platformType) {
        case XLSocialPlatformType_WechatSession:
        {
            // 微信
        }
            break;
        case XLSocialPlatformType_WechatTimeLine:
        {
            // 朋友圈
        }
            break;
            
        case XLSocialPlatformType_QQ:
        {
            // QQ
        }
            break;
            
            
        default:
            break;
    }
}

/**分享图文（新浪支持，微信/QQ仅支持图或文本分享）*/
- (void)shareImageAndTextToPlatformType:(XLSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController {
    switch (platformType) {
        case XLSocialPlatformType_WechatSession:
        {
            // 微信
            switch (self.message.shareType) {
                case XLShareType_Text:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case XLSocialPlatformType_WechatTimeLine:
        {
            // 朋友圈
        }
            break;
            
        case XLSocialPlatformType_QQ:
        {
            // QQ
        }
            break;
            
            
        default:
            break;
    }
}

@end
