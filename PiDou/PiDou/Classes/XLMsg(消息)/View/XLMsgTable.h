//
//  XLMsgTable.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLMsgTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@end

NS_ASSUME_NONNULL_END
