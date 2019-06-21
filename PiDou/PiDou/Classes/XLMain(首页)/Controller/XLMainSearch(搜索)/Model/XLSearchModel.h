//
//  XLSearchModel.h
//  PiDou
//
//  Created by ice on 2019/5/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTopicModel.h"
#import "XLTieziModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLSearchModel : NSObject

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) XLTopicModel *topic;
@property (nonatomic, strong) NSMutableArray *entities;

@end

NS_ASSUME_NONNULL_END
