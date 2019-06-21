//
//  XLPhotoBrowser.h
//  CBNReporterVideo
//
//  Created by kevin on 9/1/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPhotoBrowser : UIView

/**图片传uiimage,视频传NSURL*/
@property (nonatomic, strong) NSArray *imageArray;
/**从第几张图片开始展示，默认 0*/
@property (nonatomic, assign) int currentImageIndex;
/**退出时能回到原来的位置，需要传下面两个参数*/ 
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, weak) UIView *sourceImagesContainerView;


- (void)show;

@end

NS_ASSUME_NONNULL_END
