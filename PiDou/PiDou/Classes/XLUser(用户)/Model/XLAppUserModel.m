//
//  XLAppUserModel.m
//  TG
//
//  Created by kevin on 8/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLAppUserModel.h"

@implementation XLAppUserModel

/**
 想要定义'唯一约束',实现该函数返回相应的key即可.
 */
+ (NSString *)bg_uniqueKey {
    return @"user_id";
}

@end
