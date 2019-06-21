//
//  XLUserNaviBar.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLUserNaviBarSkin) {
    XLUserNaviBarSkin_white = 0,
    XLUserNaviBarSkin_black
};


@interface XLUserNaviBar : UIView

@property (nonatomic, assign) BOOL isUser;
@property (nonatomic, strong) XLAppUserModel *user;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL backBlack;

@property (nonatomic, copy) XLFinishBlock updateFinish;

@property (nonatomic, assign) XLUserNaviBarSkin naviSkin;

@end

NS_ASSUME_NONNULL_END
