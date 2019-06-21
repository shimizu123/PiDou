//
//  SendMessageToWXReq+requestWithTextOrMediaMessage.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"

@implementation SendMessageToWXReq (requestWithTextOrMediaMessage)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (req.scene == WXSceneSpecifiedSession) {
        req.toUserOpenId = @"oyAaTjoAesTaqxEm8pm2FQ4UZMkM";
    }
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end
