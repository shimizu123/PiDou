//
//  XLUserDatabase.m
//  CBNReporterVideo
//
//  Created by kevin on 16/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLUserDatabase.h"

#define XLUserSqliteName @"KCBNUserSqlite"

@implementation XLUserDatabase
singleton_m(XLUserDatabase)
+ (void)addUser:(XLAppUserModel *)user {
    [[self sharedXLUserDatabase] addUser:user];
}

+ (void)deleteUser {
    [[self sharedXLUserDatabase] deleteUser];
}

+ (void)updateUser:(XLAppUserModel *)user {
    [[self sharedXLUserDatabase] updateUser:user];
}

/**刷新本地token*/
+ (void)updateToken:(XLAppUserModel *)user {
    [[self sharedXLUserDatabase] updateToken:user];
}

+ (XLAppUserModel *)searchUser {
    return [[self sharedXLUserDatabase] searchUser];
}

/**-----------------------------------------------------*/

- (void)addUser:(XLAppUserModel *)user {
    [self deleteUser];
    user.bg_tableName = XLUserSqliteName;
    BOOL isSave = [user bg_saveOrUpdate];
    if (!isSave) {
        XLLog(@"用户存储失败");
    }
}

- (XLAppUserModel *)searchUser {
    /**
     同步查询所有People的数据.
     */
    NSArray* finfAlls = [XLAppUserModel bg_findAll:XLUserSqliteName];
    if (XLArrayIsEmpty(finfAlls)) {
        return nil;
    }
    return finfAlls[0];
}

- (void)deleteUser {
    /**
     清除People的数据库表.
     */
    [XLAppUserModel bg_clear:XLUserSqliteName];
}

- (void)updateUser:(XLAppUserModel *)user {
    /**
     将CBNUserAccount类数据中uid=@""的数据更新为当前对象的数据.
     */
    user.bg_tableName = XLUserSqliteName;
    NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"user_id"),bg_sqlValue(self.searchUser.user_id)];
    [user bg_updateWhere:where];
    
}

/**刷新本地token*/
- (void)updateToken:(XLAppUserModel *)user {
//    NSString *updateTokenDate = user.updateTokenDate;
//    if (updateTokenDate == nil) {
//        // 肯定不会存在updateTokenDate为空的情况,这里只是做个保护而已
//        updateTokenDate = @"";
//
//    }
    NSString *where = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"token"),bg_sqlValue(user.token),bg_sqlKey(@"user_id"),bg_sqlValue(self.searchUser.user_id)];
    [XLAppUserModel bg_update:XLUserSqliteName where:where];
}
@end
