//
//  XLTopicModel.h
//  PiDou
//
//  Created by ice on 2019/5/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTieziModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTopicModel : NSObject

/**话题id*/
@property (nonatomic, copy) NSString *topic_id;
/**话题封面*/
@property (nonatomic, copy) NSString *topic_cover;
/**话题内容数*/
@property (nonatomic, strong) NSNumber *topic_entity_count;
/**话题标题*/
@property (nonatomic, copy) NSString *topic_name;
/**0未关注  1已关注*/
@property (nonatomic, strong) NSNumber *followed;

/**多少人看过*/
@property (nonatomic, strong) NSNumber *view_count;
/**描述*/
@property (nonatomic, copy) NSString *topic_description;
/**内容列表  同首页内容列表结构*/
@property (nonatomic, strong) NSArray *entities;

@end

NS_ASSUME_NONNULL_END
