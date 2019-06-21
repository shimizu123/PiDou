//
//  XLUtil.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLUtil : NSObject


/**获得版本名*/
+ (NSString *)getAppVersion;
/**获得版本号*/
+ (NSString *)getAppBuild;
/**获得手机系统版本*/
+ (NSString *)getPhoneVersion;
/**获得手机型号*/
+ (NSString *)getPhoneModel;
/**BundleIdentifier*/
+ (NSString *)getBundleIdentifier;
/**itunes的appid*/
+ (NSString *)getAppId;
/**UUIDString*/
+ (NSString *)uuid;


@end

NS_ASSUME_NONNULL_END
