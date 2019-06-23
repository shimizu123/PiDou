//
//  XLVideoCell.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTieziModel;
@class XLVideoCell;
@class XLCommentModel;
@protocol XLVideoCellDelegate <NSObject>

//- (void)videoCell:(XLVideoCell *)videoCell didVideoPlay:(BOOL)play;

@end

@interface XLVideoCell : UITableViewCell

//@property (nonatomic, weak) id <XLVideoCellDelegate> delegate;

@property (nonatomic, copy) XLCompletedBlock complete;
@property (nonatomic, strong) XLTieziModel *tieziModel;

@property (nonatomic, assign) BOOL isDetailVC;
/**我的作品，有删除按钮*/
@property (nonatomic, assign) BOOL isMyPublish;

@property (nonatomic, copy) XLCompletedBlock didSelectedAction;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isDetail;

@end

NS_ASSUME_NONNULL_END
