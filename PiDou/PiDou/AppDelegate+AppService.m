//
//  AppDelegate+AppService.m
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "XLRootManager.h"
#import "WXApiManager.h"


@interface AppDelegate () <UIApplicationDelegate, WXApiDelegate, QQApiInterfaceDelegate, TencentSessionDelegate>

@end

@implementation AppDelegate (AppService)

#pragma mark ————— 初始化window —————
- (void)initWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [XLRootManager getRootController];
    [self.window makeKeyAndVisible];
}


/**微信*/
- (void)initWechat {
    //向微信注册
    [WXApi registerApp:Wechat_APP_ID enableMTA:YES];
}


- (void)initQQ {
   TencentOAuth *tencent = [[TencentOAuth alloc] initWithAppId:QQ_APP_ID andDelegate:self];
    XLLog(@"%@",tencent.openId);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]] || [QQApiInterface handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


// qq分享结果的回调
//- (void)onResp:(QQBaseResp *)resp
//{
//    if ([resp isKindOfClass:[SendMessageToQQResp class]] && resp.type == ESENDMESSAGETOQQRESPTYPE)
//    {
//        SendMessageToQQResp* sendReq = (SendMessageToQQResp*)resp;
//        // sendReq.result->0分享成功 -4取消分享
//        if ([sendReq.result integerValue] == 0) {
//            NSLog(@"qq share success");
//        }else{
//            NSLog(@"qq share failed");
//        }
//    }
//}


@end
