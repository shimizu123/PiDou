//
//  XLSegment.h
//  TG
//
//  Created by kevin on 26/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLSegmentDelegate <NSObject>

- (void)didSegmentWithIndex:(NSInteger)index;

@end

@interface XLSegment : UIView

@property (nonatomic, weak) id <XLSegmentDelegate> delegate;

@property (nonatomic, assign) BOOL bottomVHidden;

- (instancetype)initSegmentWithTitles:(NSArray *)titles frame:(CGRect)frame;

- (instancetype)initSegmentWithTitles:(NSArray *)titles frame:(CGRect)frame font:(UIFont *)font botH:(CGFloat)botH;

- (instancetype)initSegmentWithTitles:(NSArray *)titles frame:(CGRect)frame font:(UIFont *)font botH:(CGFloat)botH autoWidth:(BOOL)autoWidth;

- (void)didClickWithIndex:(NSInteger)index;


@property (nonatomic, assign) NSInteger selectIndex;
/**标题*/
@property (nonatomic, strong) NSArray *titles;

//动画执行进度
@property (nonatomic, assign) CGFloat progress;
//忽略动画
@property (nonatomic, assign) BOOL ignoreAnimation;

@property (nonatomic, assign) BOOL scaleAnimation;

@end
