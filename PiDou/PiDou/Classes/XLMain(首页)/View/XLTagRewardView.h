//
//  XLTagRewardView.h
//  PiDou
//
//  Created by ice on 2019/4/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTagRewardView : UIView

@property (nonatomic, strong) NSArray *topics;
/**是否是帖子详情，帖子详情要展示打赏按钮*/
@property (nonatomic, assign) BOOL isDetail;

@property (nonatomic, copy) NSString *entity_id;

@end

NS_ASSUME_NONNULL_END
