//
//  XLUserDetailTable.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLUserDetailType) {
    XLUserDetailType_dongtai = 0,
    XLUserDetailType_tiezi,
    XLUserDetailType_comment,
};

typedef NS_ENUM(NSUInteger, XLUserDetailTableType) {
    XLUserDetailTableType_mineDetail = 0, // 个人名片
    XLUserDetailTableType_minePublish,    // 我的作品
};

@class XLUserDetailTable;
@protocol XLUserDetailTableDelegate <NSObject>

@optional;
- (void)scrollViewDidTable:(XLUserDetailTable *)table contentOffsetY:(CGFloat)contentOffsetY;
- (void)userDetailTable:(XLUserDetailTable *)userDetailTable didSegmentWithIndex:(NSInteger)index;

@end

@interface XLUserDetailTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, assign) XLUserDetailType userDetailType;

@property (nonatomic, assign) XLUserDetailTableType tableType;

@property (nonatomic, weak) id <XLUserDetailTableDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, copy) XLFinishBlock reloadDataBlock;

@property (nonatomic, strong) XLAppUserModel *user;

/**我的作品，有删除按钮*/
@property (nonatomic, assign) BOOL isMyPublish;

@end

NS_ASSUME_NONNULL_END
