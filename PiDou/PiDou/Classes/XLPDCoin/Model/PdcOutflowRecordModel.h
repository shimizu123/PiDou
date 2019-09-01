//
//  PdcOutflowRecordModel.h
//  PiDou
//
//  Created by 邓康大 on 2019/9/1.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PdcOutflowRecordModel : NSObject

@property (nonatomic, copy) NSString *transfer_amount;
/**时间yyyy-mm-dd*/
@property (nonatomic, copy) NSString *created;
/**状态 -1 全部/ 0 待转出 / 1 转出成功 / 2 转出失败*/
@property (nonatomic, copy) NSString *status;
/**类型*/
@property (nonatomic, strong) NSString *transfer_type;
/**类型*/
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
