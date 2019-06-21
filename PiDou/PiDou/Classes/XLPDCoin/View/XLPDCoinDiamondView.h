//
//  XLPDCoinDiamondView.h
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLPDCoinDiamondView;
@protocol XLPDCoinDiamondViewDelegate <NSObject>

- (void)pdCoinDiamondView:(XLPDCoinDiamondView *)pdCoinDiamondView didPappaoAtIndex:(NSInteger)index isLastOne:(BOOL)isLastOne;

@end

@interface XLPDCoinDiamondView : UIView

@property (nonatomic, copy) NSArray *data;

@property (nonatomic, weak) id <XLPDCoinDiamondViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
