//
//  XLMulTableView.m
//  TG
//
//  Created by kevin on 6/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLMulTableView.h"

@interface XLMulTableView () <UIScrollViewDelegate>

@end

@implementation XLMulTableView


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        [self setContentOffset:(CGPointZero) animated:NO];
        // 告知副视图已经滑倒顶部，切换到主视图
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kcellScrollToTop" object:self userInfo:nil];
    } else {
    }
    if (!self.canScroll) {
        [scrollView setContentOffset:(CGPointZero)];
    }
}


/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



@end
