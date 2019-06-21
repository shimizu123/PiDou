//
//  XLPublishAddLinkView.h
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPublishAddLinkView : UIView

- (instancetype)initPublishAddLinkViewWithComplete:(XLCompletedBlock)complete;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
