//
//  XLCommentCell.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLCommentModel;
typedef NS_ENUM(NSUInteger, XLCommentCellType) {
    XLCommentCellType_video = 0,
    XLCommentCellType_picture,
    XLCommentCellType_text,
};

@interface XLCommentCell : UITableViewCell

@property (nonatomic, assign) XLCommentCellType commentType;

@property (nonatomic, strong) XLCommentModel *commentModel;

@property (nonatomic, copy) XLCompletedBlock didSelectRepllyBlock;

@property (nonatomic, copy) XLCompletedBlock didSelectedAction;

@end

NS_ASSUME_NONNULL_END
