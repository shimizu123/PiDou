//
//  XLRootManager.h
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLRootManager : NSObject

/**获得根控制器*/
+ (id)getRootController;

/**根视图 - 启动图*/
+ (void)rootToLaunchVC;

/**根视图 - 主控制器*/
+ (void)rootToMainTabBarVC;

/**根视图 - 登录*/
+ (void)rootToLoginVC;


@end
