//
//  XLSearchModel.m
//  PiDou
//
//  Created by ice on 2019/5/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchModel.h"

@implementation XLSearchModel

//把数组变量名（左）映射到类名（右）
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"entities" : @"XLTieziModel",
             @"users"    : @"XLAppUserModel"
             };
}


@end
