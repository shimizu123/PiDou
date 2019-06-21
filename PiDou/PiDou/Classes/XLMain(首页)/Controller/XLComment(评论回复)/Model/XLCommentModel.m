//
//  XLCommentModel.m
//  PiDou
//
//  Created by ice on 2019/4/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentModel.h"

@implementation XLCommentModel

//把数组变量名（左）映射到类名（右）
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"pic_images" : @"XLSizeModel",
             @"replies"   : @"XLCommentModel"
             };
}


@end
