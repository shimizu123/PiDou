//
//  XLBaseTableView.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLBaseTableView : UITableView

- (void)showNullViewWithText:(NSString *)text;
- (void)dismissNullView;

@end

NS_ASSUME_NONNULL_END
