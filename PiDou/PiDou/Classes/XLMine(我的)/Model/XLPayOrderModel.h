//
//  XLPayOrderModel.h
//  PiDou
//
//  Created by kevin on 13/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPayOrderModel : NSObject

/**appid*/
@property (nonatomic, copy) NSString *appid;
/**商户id*/
@property (nonatomic, copy) NSString *mch_id;
/**nonce_str*/
@property (nonatomic, copy) NSString *nonce_str;
/**prepay_id*/
@property (nonatomic, copy) NSString *prepay_id;
/**result_code*/
@property (nonatomic, copy) NSString *result_code;
/**return_code*/
@property (nonatomic, copy) NSString *return_code;
/**return_msg*/
@property (nonatomic, copy) NSString *return_msg;
/**sign*/
@property (nonatomic, copy) NSString *sign;
/**trade_type*/
@property (nonatomic, copy) NSString *trade_type;
/**time*/
@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
