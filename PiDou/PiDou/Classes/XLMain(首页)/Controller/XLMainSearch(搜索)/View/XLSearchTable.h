//
//  XLSearchTable.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLSearchType) {
    XLSearchType_all = 0, // 综合
    XLSearchType_video, // 视频
    XLSearchType_picture, // 图片
    XLSearchType_duanzi, // 段子
    XLSearchType_user, // 用户
    XLSearchType_topic, // 话题
    XLSearchType_allNotTopic, // 话题
    XLSearchType_topicDetail // 话题详情
};

@class XLSearchTable;
@class XLTopicModel;
@class XLSearchModel;
@protocol XLSearchTableDelegate <NSObject>

- (void)searchTable:(XLSearchTable *)searchTable contentOffsetY:(CGFloat)contentOffsetY;

@end

@interface XLSearchTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, assign) XLSearchType searchType;

@property (nonatomic, assign) XLSearchType allType;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) XLTopicModel *topicModel;

@property (nonatomic, weak) id <XLSearchTableDelegate> delegate;

@property (nonatomic, strong) XLSearchModel *searchModel;

@property (nonatomic, copy) XLFinishBlock reloadDataBlock;

@property (nonatomic, strong) MTGNativeAdManager *nativeVideoAdManager;

@end

NS_ASSUME_NONNULL_END
