//
//  XLAliOSSManager.h
//  TG
//
//  Created by kevin on 10/10/17.
//  Copyright © 2017年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>


@interface XLAliOSSManager : NSObject
singleton_h(XLAliOSSManager)

- (void)sts_uploadImageWithData:(NSData *)data success:(XLSuccess)success failure:(XLFailure)failure;
//- (void)sts_uploadVoiceWithData:(NSData *)data success:(XLSuccess)success failure:(XLFailure)failure;
//- (void)sts_uploadVideoWithData:(NSData *)data success:(XLSuccess)success failure:(XLFailure)failure;
//- (void)sts_uploadImageWithData:(NSData *)data progress:(OSSNetworkingUploadProgressBlock)progress success:(XLSuccess)success failure:(XLFailure)failure;
- (void)sts_uploadVideoWithData:(NSData *)data progress:(OSSNetworkingUploadProgressBlock)progress success:(XLSuccess)success failure:(XLFailure)failure;

@end
