//
//  XLCommentDetailTable.h
//  PiDou
//
//  Created by kevin on 5/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XLCommentModel;
@class XLCommentDetailTable;
@class XLTieziModel;
@protocol XLCommentDetailTableDelegate <NSObject>

- (void)commentDetailTable:(XLCommentDetailTable *)commentDetailTable didScroll:(UIScrollView *)scrollView;
- (void)commentDetailTable:(XLCommentDetailTable *)commentDetailTable didReplyWithComment:(XLCommentModel *)comment;

@end

@interface XLCommentDetailTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) XLCommentModel *commentModel;
@property (nonatomic, strong) XLTieziModel *tieziModel;

@property (nonatomic, weak) id <XLCommentDetailTableDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
