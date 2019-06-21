//
//  XLMsgListView.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface XLMsgListView : UIView


- (instancetype)initMsgListViewWithComplete:(XLCompletedBlock)complete;
- (void)show;
- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
