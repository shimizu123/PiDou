//
//  XLAliOSSModel.h
//  PiDou
//
//  Created by ice on 2019/4/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLAliOSSModel : NSObject

@property (nonatomic, copy) NSString *Endpoint;
@property (nonatomic, copy) NSString *Bucket;
@property (nonatomic, copy) NSString *FileName;
@property (nonatomic, copy) NSString *SecurityToken;
@property (nonatomic, copy) NSString *AccessKeyId;
@property (nonatomic, copy) NSString *ExpireUTCTime;
@property (nonatomic, copy) NSString *AccessKeySecret;
@property (nonatomic, copy) NSString *Expiration;
@property (nonatomic, copy) NSString *Region;
@property (nonatomic, copy) NSString *VideoId;
@property (nonatomic, copy) NSString *RequestId;
@property (nonatomic, copy) NSString *UploadAddress;
@property (nonatomic, copy) NSString *UploadAuth;
@property (nonatomic, copy) NSString *ImageId;
@property (nonatomic, copy) NSString *ImageURL;


@end

NS_ASSUME_NONNULL_END
