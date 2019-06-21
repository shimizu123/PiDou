//
//  XLGroupBarView.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLGroupBarView;
@protocol XLGroupBarViewDelegate <NSObject>

//选中某个模块
- (void)groupBarView:(XLGroupBarView *)groupBarView didSelectIndex:(NSInteger)index;
//选中搜索
- (void)didSelectSearchWithGroupBarView:(XLGroupBarView *)groupBarView;

@end

@interface XLGroupBarView : UIView

@property (nonatomic, weak) id <XLGroupBarViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *groups;
//选中的位置
@property (nonatomic, assign) NSInteger index;


#pragma mark - 初始化
+ (instancetype)groupBarView;
#pragma mark - 设置偏移
- (void)setUpContentOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
