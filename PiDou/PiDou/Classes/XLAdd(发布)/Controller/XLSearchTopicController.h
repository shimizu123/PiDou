//
//  XLSearchTopicController.h
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLSearchTopicVCType) {
    XLSearchTopicVCType_unselected = 0,
    XLSearchTopicVCType_selected,
};

@interface XLSearchTopicController : XLBaseViewController

@property (nonatomic, assign) XLSearchTopicVCType topicVCType;

@property (nonatomic, copy) NSString *selectedTopic;

@property (nonatomic, copy) XLCompletedBlock didSelectedComplete;

@end

NS_ASSUME_NONNULL_END
