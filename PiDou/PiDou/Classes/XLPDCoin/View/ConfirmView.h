//
//  ConfirmView.h
//  PiDou
//
//  Created by 邓康大 on 2019/8/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmView : UIView
singleton_h(ConfirmView)

@property (nonatomic, copy) NSArray *typeArray;

+ (instancetype)confirmView;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
