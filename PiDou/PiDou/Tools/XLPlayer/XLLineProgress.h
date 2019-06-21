//
//  XLLineProgress.h
//  TG
//
//  Created by kevin on 14/12/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLLineProgress : NSObject
singleton_h(XLLineProgress)

/**初始化*/
+ (void)initLineProgressView:(UIView *)supView;

/**重置*/
+ (void)resetProgress;

/**进度*/
+ (void)setLineProgress:(CGFloat)progress;

@end
