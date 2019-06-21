//
//  XLLaunchManager.h
//  TG
//
//  Created by kevin on 22/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLLaunchManager : NSObject
singleton_h(XLLaunchManager)

/**判断是否登录*/
+ (void)isLogin;


+ (void)goLogin;

+ (void)goLoginWithTarget:(id)target;

+ (void)goLoginWithTarget:(id)target finish:(XLFinishBlock)finish;

@end
