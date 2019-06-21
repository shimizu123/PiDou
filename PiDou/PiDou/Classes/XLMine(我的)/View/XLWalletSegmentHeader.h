//
//  XLWalletSegmentHeader.h
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWalletSegmentHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) XLCompletedBlock didSelected;

@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
