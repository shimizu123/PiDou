//
//  XLPublishPhotoView.h
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLPublishPhotoView;
@class HXPhotoModel;
@protocol XLPublishPhotoViewDelegate <NSObject>

- (void)publishPhotoView:(XLPublishPhotoView *)publishPhotoView  photos:(NSArray<HXPhotoModel *> *)photos original:(BOOL)isOriginal;

@end

@interface XLPublishPhotoView : UIView

@property (nonatomic, weak) id <XLPublishPhotoViewDelegate> delegate;

- (void)goPhotoViewController;
@end

NS_ASSUME_NONNULL_END
