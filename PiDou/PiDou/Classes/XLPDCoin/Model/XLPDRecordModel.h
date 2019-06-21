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
/**是否已分红  0否 1是*/
@property (nonatomic, strong) NSNumber *status;
/**交易日期*/
@property (nonatomic, copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
