//
//  XLUserDetailHeader.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLUserDetailHeader;
@protocol XLUserDetailHeaderDelegate <NSObject>

- (void)userDetailHeader:(XLUserDetailHeader *)userDetailHeader didSegmentWithIndex:(NSInteger)index;

@end

@interface XLUserDetailHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id <XLUserDetailHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
