//
//  XLLabTagsView.h
//  CBNVideoApp
//
//  Created by kevin on 8/1/18.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLLabTagsViewDelegate <NSObject>

- (void)didSelectedTagsWithIndex:(NSInteger)index;

@end

@interface XLLabTagsView : UIView


@property (nonatomic, weak) id <XLLabTagsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *tagsArr;
@property (nonatomic, assign) NSInteger currentIndex;

+ (instancetype)labTagsViewWithTagsArr:(NSArray *)tagsArr;
+ (instancetype)labTagsViewWithTagsArr:(NSArray *)tagsArr disable:(BOOL)disable;
/**获得view高度*/
- (CGFloat)viewHeight;

@end
