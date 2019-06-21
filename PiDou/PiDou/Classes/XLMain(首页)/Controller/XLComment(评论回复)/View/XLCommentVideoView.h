//
//  XLCommentVideoView.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLSizeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLCommentVideoView : UIView

/**视频地址*/
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) XLSizeModel *video_image;

@end

NS_ASSUME_NONNULL_END
