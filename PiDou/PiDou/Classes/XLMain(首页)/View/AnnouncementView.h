//
//  AnnouncementView.h
//  PiDou
//
//  Created by 邓康大 on 2019/8/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementView : UIView

@property (nonatomic, copy) NSString *content;

+ (instancetype)announcementView;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
