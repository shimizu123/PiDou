//
//  XLSmallDiamondView.h
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const XLSmallDiamondViewHeight = 220;

@class XLSmallDiamondView;
@protocol XLSmallDiamondViewDelegate <NSObject>

- (void)smallDiamondView:(XLSmallDiamondView *)smallDiamondView didPappaoAtIndex:(NSInteger)index isLastOne:(BOOL)isLastOne;

@end

@interface XLSmallDiamondView : UIView

@property (nonatomic, weak) id <XLSmallDiamondViewDelegate> delegate;

@property (nonatomic, strong) NSArray *dataList;

// 重置动画，因为页面disappear会将layer动画移除
- (void)resetAnimation;
// 移除所有泡泡
- (void)removeAllPaopao;
// 点击所有泡泡
- (void)allPaopaoClick;

@end

NS_ASSUME_NONNULL_END
