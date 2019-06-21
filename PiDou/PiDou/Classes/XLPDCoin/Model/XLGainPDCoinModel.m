//
//  XLGainPDCoinModel.m
//  PiDou
//
//  Created by ice on 2019/5/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGainPDCoinModel.h"

@implementation XLGainPDCoinModel

//把数组变量名（左）映射到类名（右）
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"qq_group" : @"XLQQModel",
             @"wechat_group" : @"XLQRCodeModel",
             @"mp" : @"XLQRCodeModel",
             };
}

@end
