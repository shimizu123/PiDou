//
//  XLPublishVideoPhotoController.h
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLPublishVideoPhotoType) {
    XLPublishVideoPhotoType_video = 0,
    XLPublishVideoPhotoType_photo,
    XLPublishVideoPhotoType_link,
    XLPublishVideoPhotoType_text,
};

@interface XLPublishVideoPhotoController : XLBaseViewController

@property (nonatomic, assign) XLPublishVideoPhotoType publishVCType;

@end

NS_ASSUME_NONNULL_END
