//
//  XLFansModel.h
//  PiDou
//
//  Created by ice on 2019/4/28.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLFansModel : NSObject

/**Oauth统一认证用户ID*/
@property (nonatomic, copy) NSString *user_id;
/**昵称*/
@property (nonatomic, copy) NSString *nickname;
/**头像*/
@property (nonatomic, copy) NSString *avatar;
/**签名*/
@property (nonatomic, copy) NSString *sign;
/**是否关注 0否 1是 2相互关注*/
@property (nonatomic, copy) NSString *followed;

@end

NS_ASSUME_NONNULL_END
