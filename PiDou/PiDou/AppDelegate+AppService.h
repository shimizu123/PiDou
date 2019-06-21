//
//  AppDelegate+AppService.h
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)

/**初始化window*/
- (void)initWindow;

/**微信*/ 
- (void)initWechat;

/**QQ*/
- (void)initQQ;

@end
