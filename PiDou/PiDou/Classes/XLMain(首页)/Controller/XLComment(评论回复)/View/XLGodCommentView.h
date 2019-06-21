//
//  XLGodCommentView.h
//  PiDou
//
//  Created by kevin on 8/5/2019.
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


@interface XLGodCommentView : UIView

@property (nonatomic, assign) XLCommentCellType commentType;

@property (nonatomic, strong) XLCommentModel *commentModel;

@property (nonatomic, copy) NSString *entity_id;

@end

NS_ASSUME_NONNULL_END
