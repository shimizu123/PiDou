//
//  XLPDCoinModel.m
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPDCoinModel.h"

@implementation XLPDCoinModel

//把数组变量名（左）映射到类名（右）
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"records" : @"XLPDRecordModel",
             };
}

@end
