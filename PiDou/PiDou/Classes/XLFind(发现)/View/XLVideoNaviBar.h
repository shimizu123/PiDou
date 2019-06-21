//
//  XLVideoNaviBar.h
//  PiDou
//
//  Created by kevin on 14/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTieziModel;
@interface XLVideoNaviBar : UIView

@property (nonatomic, strong) XLAppUserModel *user;
@property (nonatomic, strong) XLTieziModel *tieziModel;

@end

NS_ASSUME_NONNULL_END
