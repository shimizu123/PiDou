//
//  XLCommentInputView.h
//  PiDou
//
//  Created by ice on 2019/5/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLCommentInputViewSkin) {
    XLCommentInputViewSkin_white = 0,
    XLCommentInputViewSkin_black,
};

@class XLCommentInputView;
@protocol XLCommentInputViewDelegate <NSObject>

- (void)commentInputView:(XLCommentInputView *)commentInputView didSelectedWithIndex:(NSInteger)index;

@end

@interface XLCommentInputView : UIView

@property (nonatomic, weak) id <XLCommentInputViewDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, assign) XLCommentInputViewSkin viewSkin;

- (void)becomeActive;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
