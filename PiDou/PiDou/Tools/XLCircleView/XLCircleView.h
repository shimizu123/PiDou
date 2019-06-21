//
//  XLCircleView.h
//  PiDou
//
//  Created by kevin on 14/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MovementDirectionType) {
    MovementDirectionForHorizontally = 0,
    MovementDirectionVertically,
};

@protocol XLCircleViewDelegate <NSObject>

@optional
- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface XLCircleView : UIView

@property (nonatomic, weak) id <XLCircleViewDelegate> delegate;

@property (nonatomic, assign) MovementDirectionType movementDirection;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic,assign) NSTimeInterval timeInterval;

@property (nonatomic, assign) BOOL hidePageControl;

@property (nonatomic, assign) BOOL canFingersSliding;

@end

NS_ASSUME_NONNULL_END
