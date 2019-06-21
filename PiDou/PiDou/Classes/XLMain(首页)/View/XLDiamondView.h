//
//  XLDiamondView.h
//  PiDou
//
//  Created by kevin on 7/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLDiamondView : UIView

+ (instancetype)diamondViewWithTarget:(id)target;

- (void)showView;
- (void)removeView;

@end

NS_ASSUME_NONNULL_END
