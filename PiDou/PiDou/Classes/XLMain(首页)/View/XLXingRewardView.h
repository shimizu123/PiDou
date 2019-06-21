//
//  XLXingRewardView.h
//  PiDou
//
//  Created by ice on 2019/5/12.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XLXingRewardView;
@protocol XLXingRewardViewDelegate <NSObject>

- (void)xingRewardView:(XLXingRewardView *)xingRewardView didSelected:(NSInteger)index item:(NSInteger)item;

@end

@interface XLXingRewardView : UIView


@property (nonatomic, weak) id <XLXingRewardViewDelegate> delegate;


@property (nonatomic, copy) NSString *entity_id;
@property (nonatomic, weak) UIViewController *targetVC;

+ (instancetype)xingRewardView;


- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
