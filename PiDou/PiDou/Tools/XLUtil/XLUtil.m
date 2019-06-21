//
//  XLUtil.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUtil.h"

@implementation XLUtil



#pragma mark - 获得版本名
+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - 获得版本号
+ (NSString *)getAppBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];;
}

#pragma mark - 获得手机系统版本
+ (NSString *)getPhoneVersion {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - 获得手机型号
+ (NSString *)getPhoneModel {
    return [[UIDevice currentDevice] model];
}

#pragma mark - BundleIdentifier
+ (NSString *)getBundleIdentifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];;
}

#pragma mark - itunes的appid
+ (NSString *)getAppId {
    return @"";
}

+ (NSString *)uuid {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}


@end
