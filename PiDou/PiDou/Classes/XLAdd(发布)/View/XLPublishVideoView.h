//
//  XLPublishVideoView.h
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLPublishVideoView;
@class HXPhotoModel;
@protocol XLPublishVideoViewDelegate <NSObject>

- (void)publishVideoView:(XLPublishVideoView *)publishVideoView videos:(NSArray<HXPhotoModel *> *)videos;

@end

@interface XLPublishVideoView : UIView

@property (nonatomic, weak) id <XLPublishVideoViewDelegate> delegate;
- (void)goPhotoViewController;

@end

NS_ASSUME_NONNULL_END
