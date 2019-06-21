//
//  XLMineTable.h
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLMineTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, strong) XLAppUserModel *userInfo;

@property (nonatomic, strong) NSArray *advsData;

@end

NS_ASSUME_NONNULL_END
