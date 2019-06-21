//
//  XLAddkeywordView.h
//  CBNReporterVideo
//
//  Created by kevin on 17/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLAddkeywordView;
@protocol XLAddkeywordViewDelegate <NSObject>

- (void)addkeywordView:(XLAddkeywordView *)addkeywordView didSelectedAtIndex:(NSInteger)index;

@end

@interface XLAddkeywordView : UIView

@property (nonatomic, weak) id <XLAddkeywordViewDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray *tagsArr;

- (void)addTags:(NSArray *)tags;
- (void)addLastTag:(NSString *)tag;

@end
