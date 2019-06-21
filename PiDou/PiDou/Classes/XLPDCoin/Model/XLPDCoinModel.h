//
//  XLPDCoinModel.h
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLPDRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLPDCoinModel : NSObject

/**持有PDcoin数*/
@property (nonatomic, strong) NSNumber *pdcoin_count;
/**冻结PDcoin数*/
@property (nonatomic, strong) NSNumber *freeze_pdcoin_count;
/**记录*/
@property (nonatomic, copy) NSArray *records;

@end

NS_ASSUME_NONNULL_END
