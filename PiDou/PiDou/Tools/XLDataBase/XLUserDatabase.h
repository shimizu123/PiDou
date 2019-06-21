//
//  XLUserDatabase.h
//  CBNReporterVideo
//
//  Created by kevin on 16/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XLAppUserModel.h"

@class XLAppUserModel;
@interface XLUserDatabase : NSObject
singleton_h(XLUserDatabase)

+ (void)addUser:(XLAppUserModel *)user;

+ (void)deleteUser;

+ (void)updateUser:(XLAppUserModel *)user;

/**刷新本地token*/
+ (void)updateToken:(XLAppUserModel *)user;

+ (XLAppUserModel *)searchUser;

@end
