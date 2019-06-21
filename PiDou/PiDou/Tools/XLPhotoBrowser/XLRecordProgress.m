//
//  XLRecordProgress.m
//  CBNReporterVideo
//
//  Created by kevin on 22/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLRecordProgress.h"

#define thumbBound_x 10
#define thumbBound_y 20

@interface XLRecordProgress () {
    CGRect _lastBounds;
}


@end

@implementation XLRecordProgress

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    self.minimumTrackTintColor = XL_COLOR_BLUE;
    self.maximumTrackTintColor = [UIColor whiteColor];
    [self setThumbImage:[UIImage imageNamed:@"publish_yuanquan"] forState:(UIControlStateNormal)];
    
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, bounds.size.width, 3);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    _lastBounds = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        
        return result;
        
    }
    
    if ((point.y >= -thumbBound_y) && (point.y < _lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value / self.bounds.size.width;
        
        value = value < 0 ? 0 : value;
        value = value > 1 ? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= _lastBounds.origin.x - thumbBound_x) && (point.x <= (_lastBounds.origin.x + _lastBounds.size.width + thumbBound_x)) && (point.y < (_lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
        
    }
    return result;
}

@end
