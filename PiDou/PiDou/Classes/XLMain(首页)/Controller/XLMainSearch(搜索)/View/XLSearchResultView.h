//
//  XLSearchResultView.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class XLSearchModel;
@class XLSearchResultView;
@protocol XLSearchResultViewDelegate <NSObject>

- (void)searchResultView:(XLSearchResultView *)searchResultView didSegmentWithIndex:(NSInteger)index;

@end

@interface XLSearchResultView : UIView

@property (nonatomic, strong) XLSearchModel *searchModel;

@property (nonatomic, weak) id <XLSearchResultViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *data;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
