//
//  XLBaseBlockHandle.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLBaseBlockHandle : NSObject

typedef void(^XLCompletedBlock)(id result);
typedef void(^XLFinishBlock)(void);
typedef void(^XLSuccess)(id responseObject);
typedef void(^XLFailure)(id result);
typedef void(^XLError)(NSError *error);

typedef void(^XLSuccessCallBack)(NSMutableArray *data);

@end

NS_ASSUME_NONNULL_END
