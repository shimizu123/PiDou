//
//  XLGainPDCoinModel.h
//  PiDou
//
//  Created by ice on 2019/5/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLQQModel.h"
#import "XLQRCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLGainPDCoinModel : NSObject

/**加QQ群获得的PDcoin数*/
@property (nonatomic, strong) NSNumber *join_qq_pdcoin_count;

/**加微信群获得的PDcoin数*/
@property (nonatomic, strong) NSNumber *join_wechat_pdcoin_count;

/**关注公众号获得的PDcoin数*/
@property (nonatomic, strong) NSNumber *follow_wechat_mp;

/**qq群*/
@property (nonatomic, strong) NSArray <XLQQModel *> *qq_group;

/**微信群*/
@property (nonatomic, strong) NSArray <XLQRCodeModel *> *wechat_group;

/**微信公众号*/
@property (nonatomic, strong) NSArray <XLQRCodeModel *> *mp;

@end

NS_ASSUME_NONNULL_END
