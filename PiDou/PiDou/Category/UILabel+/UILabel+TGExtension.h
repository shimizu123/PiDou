//
//  UILabel+TGExtension.h
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TGExtension)

- (void)setGapWithFloat:(CGFloat)gap;

- (void)setGapWithFloat:(CGFloat)gap labelWidth:(CGFloat)labelWidth;

- (void)xl_setTextColor:(UIColor *)textColor fontSize:(CGFloat)size;

- (void)addImageInLeftWithNames:(NSArray *)names gap:(CGFloat)gap;

@end
