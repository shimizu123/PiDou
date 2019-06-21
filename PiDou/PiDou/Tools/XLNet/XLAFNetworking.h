//
//  XLAFNetworking.h
//  TG
//
//  Created by kevin on 31/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLAFNetworking : NSObject
singleton_h(XLAFNetworking)


/**通用POST*/
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure;

/**通用GET*/
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure;


///**通用POST*/
//+ (void)authorizationPost:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure;
//
///**通用GET*/
//+ (void)authorizationGet:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure;

@end
