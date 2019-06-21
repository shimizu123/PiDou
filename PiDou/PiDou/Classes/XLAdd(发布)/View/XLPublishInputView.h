//
//  XLPublishInputView.h
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLPublishInputView;
@protocol XLPublishInputViewDelegate <NSObject>

- (void)publishInputView:(XLPublishInputView *)publishInputView didSelectedWithIndex:(NSInteger)index;

@end

@interface XLPublishInputView : UIView

@property (nonatomic, weak) id <XLPublishInputViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
