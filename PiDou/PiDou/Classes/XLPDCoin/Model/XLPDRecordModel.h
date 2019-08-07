//
//  XLPDRecordModel.h
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface XLPDRecordModel : NSObject

/**记录id 领取时需传入此id*/
@property (nonatomic, copy) NSString *pid;
/**数量*/
@property (nonatomic, copy) NSString *amount;
/**类型*/
@property (nonatomic, strong) NSNumber *type;
/**时间yyyy-mm-dd*/
@property (nonatomic, copy) NSString *created;

@property (nonatomic, copy) NSString *typeStr;

/**参与日期*/
@property (nonatomic, copy) NSString *join_date;
/**提现状态 -1 全部/ 0 待处理 / 1 提现成功 / 2 驳回 / 3 提现失败*/
@property (nonatomic, copy) NSString *status;
/**交易日期*/
@property (nonatomic, copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
