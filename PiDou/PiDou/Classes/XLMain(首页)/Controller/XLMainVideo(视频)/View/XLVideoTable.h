//
//  XLVideoTable.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLVideoTable : NSObject


@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, copy) XLFinishBlock reloadDataBlock;

@end

NS_ASSUME_NONNULL_END
