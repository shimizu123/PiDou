//
//  NSMutableDictionary+NullSafe.m
//  TG
//
//  Created by kevin on 27/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//
// 使用以下方法，可以解决方法可以避免诸如数组取值越界、字典传空值、removeObjectAtIndex等错误

#import "NSMutableDictionary+NullSafe.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (NullSafe)

//- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector {
//    Class class = [self class];
//    Method originalMethod = class_getInstanceMethod(class, origSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
//    BOOL didAddMethod = class_addMethod(class,origSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class,newSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        id obj = [[self alloc] init];
//        [obj swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:)];
//    });
//}
//- (void)safe_setObject:(id)value forKey:(NSString *)key {
//    if (value) {
//        [self safe_setObject:value forKey:key];
//    } else {
//        TGLog(@"[NSMutableDictionary setObject: forKey:], Object cannot be nil");
//    }
//}

@end
