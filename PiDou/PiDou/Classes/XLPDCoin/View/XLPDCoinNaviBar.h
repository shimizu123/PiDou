//
//  XLPDCoinNaviBar.h
//  PiDou
//
//  Created by ice on 2019/4/22.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLPDCoinNaviBar;
@protocol XLPDCoinNaviBarDelegate <NSObject>

- (void)onClose:(XLPDCoinNaviBar *)naviBar;
- (void)onDetail:(XLPDCoinNaviBar *)naviBar;

@end

@interface XLPDCoinNaviBar : UIView

@property (nonatomic, weak) id <XLPDCoinNaviBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
