//
//  XLGroupBar.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLGroupBar;
@protocol XLGroupBarDelegate <NSObject>

//选中某个模块
- (void)groupBar:(XLGroupBar *)groupBar didSelectIndex:(NSInteger)index;
//选中搜索
- (void)didSelectSearchWithGroupBar:(XLGroupBar *)groupBar;


@end

@interface XLGroupBar : UIView

@property (nonatomic, weak) id <XLGroupBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectIndex;
//动画执行进度
@property (nonatomic, assign) CGFloat progress;

+ (instancetype)groupBar;
- (void)didClickWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
