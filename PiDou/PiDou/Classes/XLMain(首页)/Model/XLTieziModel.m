//
//  XLTieziModel.m
//  PiDou
//
//  Created by kevin on 29/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTieziModel.h"

@implementation XLTieziModel


//把数组变量名（左）映射到类名（右）
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"pic_images" : @"XLSizeModel",
             @"topics"     : @"XLTopicModel"
             };
}


@end
