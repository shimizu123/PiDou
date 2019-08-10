//
//  AdNoticeView.h
//  PiDou
//
//  Created by 邓康大 on 2019/7/15.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdNoticeView : UIView
singleton_h(AdNoticeView)

+ (instancetype)adNoticeView;
//参与社区回馈
@property (nonatomic, assign) BOOL isCommunity;
//提现
@property (nonatomic, assign) BOOL isWithdraw;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
