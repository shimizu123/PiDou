//
//  XLPhotoNaviBar.h
//  PiDou
//
//  Created by ice on 2019/4/21.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLPhotoNaviBar;
@protocol XLPhotoNaviBarDelegate <NSObject>

- (void)didCloseWithPhotoNaviBar:(XLPhotoNaviBar *)photoNaviBar;
- (void)didNextWithPhotoNaviBar:(XLPhotoNaviBar *)photoNaviBar;

@end

@interface XLPhotoNaviBar : UIView

@property (nonatomic, weak) id <XLPhotoNaviBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
