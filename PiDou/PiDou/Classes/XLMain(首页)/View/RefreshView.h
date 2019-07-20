//
//  RefreshView.h
//  PiDou
//
//  Created by 邓康大 on 2019/7/20.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshView : UIView

+ (instancetype)refreshView;

- (void)showView;
- (void)removeView;

@end

NS_ASSUME_NONNULL_END
