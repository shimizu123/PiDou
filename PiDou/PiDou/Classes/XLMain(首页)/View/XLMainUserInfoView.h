//
//  XLMainUserInfoView.h
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLMainUserInfoViewType) {
    XLMainUserInfoViewType_main = 0,
    XLMainUserInfoViewType_comment,
    XLMainUserInfoViewType_focus,
    XLMainUserInfoViewType_delete,
    XLMainUserInfoViewType_none,
};

@class XLMainUserInfoView;
@protocol XLMainUserInfoViewDelegate <NSObject>

/**
 @param index 0:点赞 1:评论 2：收藏 3:打赏 4:转发
 */
- (void)userInfoView:(XLMainUserInfoView *)userInfoView didSelectedWithIndex:(NSInteger)index select:(BOOL)select count:(NSString *)count;

@end

@interface XLMainUserInfoView : UIView

@property (nonatomic, assign) XLMainUserInfoViewType userInfoViewType;

- (void)reloadInfo;

@property (nonatomic, strong) XLAppUserModel *userInfo;

@property (nonatomic, assign) BOOL tieziGodComment;

@property (nonatomic, copy) NSString *creatTime;

@property (nonatomic, weak) id <XLMainUserInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
