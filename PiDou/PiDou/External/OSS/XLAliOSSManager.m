//
//  XLAliOSSManager.m
//  TG
//
//  Created by kevin on 10/10/17.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import "XLAliOSSManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonHMAC.h>
#import "XLPublishHandle.h"
#import "UIWindow+TGExtension.h"
#import "XLAliOSSModel.h"

//NSString * const Endpoint                   = @"https://oss-cn-shanghai.aliyuncs.com";

@interface XLAliOSSManager () {
    OSSClient * client;
}

@property (nonatomic, strong) XLAliOSSModel *ossInfoModel;

@end

@implementation XLAliOSSManager
singleton_m(XLAliOSSManager)

#pragma mark - 图文
- (void)sts_uploadImageWithData:(NSData *)data success:(XLSuccess)success failure:(XLFailure)failure {
    
    if (![self sts_setupEnvironment:NO]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    if (data.length > 0) {
        NSString *objectKey = [NSString stringWithFormat:@"%@.jpg",[self getTimeNow]];
        NSString *objectKeys = [NSString stringWithFormat:@"IaApp/image/%@/%@",[XLUserHandle userid],objectKey];
        [self initOSSPutObjectWithBucket:self.ossInfoModel.Bucket objectKeys:objectKeys data:data success:success failure:failure];
    } else {
        // 没有图片
        if (success) {
            success(nil);
        }
    }
 
}

#pragma mark - 视频
- (void)sts_uploadVideoWithData:(NSData *)data progress:(OSSNetworkingUploadProgressBlock)progress success:(XLSuccess)success failure:(XLFailure)failure {
    if (![self sts_setupEnvironment:YES]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *objectKey = [NSString stringWithFormat:@"%@.mp4",[self getTimeNow]];
    NSString *objectKeys = [NSString stringWithFormat:@"IaApp/media/%@/%@",[XLUserHandle userid],objectKey];
    [self initOSSPutObjectWithBucket:self.ossInfoModel.Bucket objectKeys:objectKeys data:data progress:progress success:success failure:failure];
}



- (BOOL)sts_setupEnvironment:(BOOL)video {
    
    // 打开调试log
    [OSSLog enableLog];
    
    [self sts_initOSSClient:video];
    return YES;
}

- (void)sts_initOSSClient:(BOOL)video {
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        // 向服务器请求token
        if (video) {
            [XLPublishHandle getAliyunVideoOSSWithFileName:nil coverUrl:nil success:^(id  _Nonnull responseObject) {
                [tcs setResult:responseObject];
            } failure:^(id  _Nonnull result) {
                 [tcs setError:result];
            }];
        } else {
            [XLPublishHandle getAliyunPhotoOSSWithType:nil ext:nil count:nil success:^(id  _Nonnull responseObject) {
                [tcs setResult:responseObject];
            } failure:^(id  _Nonnull result) {
                 [tcs setError:result];
            }];
        }
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        
        if (tcs.task.error) {
            XLLog(@"get token error: %@", tcs.task.error);
            return nil;
        } else {
            XLAliOSSModel *ossModel = tcs.task.result;
            self.ossInfoModel = ossModel;
            OSSFederationToken *token = [OSSFederationToken new];
            token.tAccessKey = ossModel.AccessKeyId;
            token.tSecretKey = ossModel.AccessKeySecret;
            token.expirationTimeInGMTFormat = ossModel.Expiration;
            token.tToken = ossModel.SecurityToken;
            return token;
            // 返回数据是json格式，需要解析得到token的各个字段
//            NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:tcs.task.result options:kNilOptions error:nil];
//            NSInteger errNo = [[responseObject valueForKey:@"errNo"] integerValue];
//            NSString *msg = [responseObject valueForKey:@"errMsg"];
//            if (errNo == -1) {
//                id result = [responseObject valueForKey:@"result"];
//                OSSFederationToken * token = [OSSFederationToken new];
//                NSString *AccessKeyId = [result valueForKey:@"AccessKeyId"];
//                NSString *AccessKeySecret = [result valueForKey:@"AccessKeySecret"];
//                NSString *Expiration = [result valueForKey:@"Expiration"];
//                NSString *SecurityToken = [result valueForKey:@"SecurityToken"];
//
//                token.tAccessKey = AccessKeyId;
//                token.tSecretKey = AccessKeySecret;
//                token.expirationTimeInGMTFormat = Expiration;
//                token.tToken = SecurityToken;
//                return token;
//            } else {
//                [HUDController hideHUDWithText:msg];
//                return nil;
//            }
        }
        
    }];
    client = [[OSSClient alloc] initWithEndpoint:self.ossInfoModel.Endpoint credentialProvider:credential];
    //NSString *objectKeys = [NSString stringWithFormat:@"test/%@.jpg",[self getTimeNow]];
    
}


#pragma mark - 异步上传
- (void)initOSSPutObjectWithBucket:(NSString *)bucket objectKeys:(NSString *)objectKeys data:(NSData *)data success:(XLSuccess)success failure:(XLFailure)failure {
    [self initOSSPutObjectWithBucket:bucket objectKeys:objectKeys data:data progress:nil success:success failure:failure];
}

- (void)initOSSPutObjectWithBucket:(NSString *)bucket objectKeys:(NSString *)objectKeys data:(NSData *)data progress:(OSSNetworkingUploadProgressBlock)progress success:(XLSuccess)success failure:(XLFailure)failure {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = bucket;
    
    put.objectKey = objectKeys;
    //put.uploadingFileURL = [NSURL fileURLWithPath:fullPath];
    put.uploadingData = data;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            XLLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            if (progress) {
                progress(bytesSent,totalByteSent,totalBytesExpectedToSend);
            }
        });
    };
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        //task = [client presignPublicURLWithBucketName:bucket withObjectKey:objectKeys];
        if (!task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(put.objectKey);
                }
                
            });
            XLLog(@"upload object success!");
            
        } else {
            XLLog(@"upload object failed, error: %@" , task.error);
            
            if (failure) {
                failure(task.error);
            }
        }
        return nil;
    }];
}

#pragma mark - 返回当前时间
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"iOS/%@-%i", date,last];
    return timeNow;
}


@end
