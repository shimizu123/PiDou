//
//  NSString+XLUrl.m
//  TG
//
//  Created by kevin on 18/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "NSString+XLUrl.h"

@implementation NSString (XLUrl)

- (NSString *)urlEncodeing {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
