//
//  XLMainUserActionView.h
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTieziModel;
@class XLMainUserActionView;
@class XLCommentModel;
typedef NS_ENUM(NSUInteger, XLMainUserActionType) {
    XLMainUserActionType_tiezi = 0,
    XLMainUserActionType_comment,
};


@protocol XLMainUserActionViewDelegate <NSObject>


/**
 @param index 0:点赞 1:评论 2：收藏 3:打赏 4:转发
 */
- (void)actonView:(XLMainUserActionView *)actionView didSelectedWithIndex:(NSInteger)index select:(BOOL)select count:(NSString *)count;

@end

@interface XLMainUserActionView : UIView

@property (nonatomic, assign) XLMainUserActionType userActionType;

@property (nonatomic, strong) XLTieziModel *tieziModel;
@property (nonatomic, strong) XLCommentModel *commentModel;

@property (nonatomic, weak) id <XLMainUserActionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
