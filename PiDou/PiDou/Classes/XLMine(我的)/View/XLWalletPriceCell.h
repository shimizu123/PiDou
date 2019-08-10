//
//  XLWalletPriceCell.h
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLWalletInfoModel;
@interface XLWalletPriceCell : UITableViewCell
singleton_h(XLWalletPriceCell)

@property (nonatomic, strong) XLWalletInfoModel *walletInfo;

@property (nonatomic, copy) XLCompletedBlock communityActionBlock;

@property (nonatomic, assign) NSInteger index;

// 参与社区活动
- (void)communityAction;
// 提现
- (void)withdrawAction;

@end

NS_ASSUME_NONNULL_END
