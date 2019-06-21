//
//  XLCommentPicturesView.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLSizeModel;
NS_ASSUME_NONNULL_BEGIN

@interface XLCommentPicturesView : UIView

@property (nonatomic, strong) NSArray <XLSizeModel *> *pictures;
@property (nonatomic, assign) CGFloat bgWidth;

@end

NS_ASSUME_NONNULL_END
