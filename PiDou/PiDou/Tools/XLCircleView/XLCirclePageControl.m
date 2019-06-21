//
//  XLCirclePageControl.m
//  PiDou
//
//  Created by kevin on 14/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCirclePageControl.h"

#define dotW     6
#define dotH     3
#define magrin   5


@implementation XLCirclePageControl

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginX = dotW + magrin;
    CGFloat newW = (self.subviews.count - 1) * magrin + self.subviews.count * dotW;
    self.frame = CGRectMake((self.superview.xl_w - newW) * 0.5, self.frame.origin.y, newW, self.frame.size.height);
    //self.frame = CGRectMake(50, self.frame.origin.y, newW, self.frame.size.height);
    
//    CGPoint center = self.center;
//    center.x = self.superview.superview.center.x;
//    self.center = center;
    
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotH)];
        
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = dotH/2;
    }
}

@end
