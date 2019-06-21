//
//  XLWalletBillModel.h
//  PiDou
//
//  Created by kevin on 7/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWalletBillModel : NSObject

/**交易类型  详细的类型请参照下方详细*/
@property (nonatomic, strong) NSNumber *type;

/**交易金额 为带有符号的字符串*/
@property (nonatomic, copy) NSString *amount;

/**交易日期*/
@property (nonatomic, copy) NSString *date;

/**参与日期*/
@property (nonatomic, copy) NSString *join_date;
/**是否已分红  0否 1是*/
@property (nonatomic, strong) NSNumber *status;

@end

NS_ASSUME_NONNULL_END
