//
//  XLPublishView.h
//  TG
//
//  Created by kevin on 7/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPublishView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images complete:(XLCompletedBlock)complete;
- (void)show;
- (void)dismiss;

@property (nonatomic, strong) UIImage *bgImage;

@end
