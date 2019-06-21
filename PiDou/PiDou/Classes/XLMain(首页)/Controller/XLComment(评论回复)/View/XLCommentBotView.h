//
//  XLCommentBotView.h
//  PiDou
//
//  Created by ice on 2019/4/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, XLCommentBotViewType) {
    XLCommentBotViewType_white = 0,
    XLCommentBotViewType_black
};


@class XLCommentBotView;
@class XLTieziModel;
@protocol XLCommentBotViewDelegate <NSObject>

- (void)commentBotView:(XLCommentBotView *)commentBotView didSelectedWithIndex:(NSInteger)index;

@end


@interface XLCommentBotView : UIView

@property (nonatomic, weak) id <XLCommentBotViewDelegate> delegate;

@property (nonatomic, assign) XLCommentBotViewType commentBotViewType;

@property (nonatomic, strong) XLTieziModel *tieziModel;

@property (nonatomic, assign) BOOL isCommentDetail;

@end

NS_ASSUME_NONNULL_END
