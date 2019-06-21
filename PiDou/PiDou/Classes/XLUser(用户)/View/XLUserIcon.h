//
//  XLUserIcon.h
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLUserIcon : UIView

@property (nonatomic, assign) BOOL vip;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *user_id;

@end

NS_ASSUME_NONNULL_END
