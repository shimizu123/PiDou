//
//  XLUserCommentCell.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class XLCommentModel;
@interface XLUserCommentCell : UITableViewCell

@property (nonatomic, strong) XLCommentModel *commentModel;
@property (nonatomic, copy) XLCompletedBlock didSelectedAction;
/**我的作品，有删除按钮*/
@property (nonatomic, assign) BOOL isMyPublish;

@end

NS_ASSUME_NONNULL_END
