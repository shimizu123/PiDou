//
//  XLMainDetailTable.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTieziModel;
@class XLCommentModel;
typedef NS_ENUM(NSUInteger, XLMainType) {
    XLMainType_video = 0,
    XLMainType_picture,
    XLMainType_duanz,
};

@class XLMainDetailTable;
@protocol XLMainDetailTableDelegate <NSObject>

- (void)mainDetailTable:(XLMainDetailTable *)mainDetailTable didScroll:(UIScrollView *)scrollView;
- (void)mainDetailTable:(XLMainDetailTable *)mainDetailTable didReplyWithComment:(XLCommentModel *)comment;

@end

@interface XLMainDetailTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, assign) XLMainType mainType;

@property (nonatomic, strong) XLTieziModel *tieziModel;

@property (nonatomic, strong) NSMutableArray *commentsData;

@property (nonatomic, weak) id delegate;

@end

NS_ASSUME_NONNULL_END
