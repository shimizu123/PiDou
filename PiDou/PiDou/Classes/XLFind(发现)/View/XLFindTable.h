//
//  XLFindTable.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLFindTable : NSObject

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@end

NS_ASSUME_NONNULL_END
