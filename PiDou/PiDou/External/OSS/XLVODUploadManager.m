//
//  XLVODUploadManager.m
//  PiDou
//
//  Created by ice on 2019/4/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLVODUploadManager.h"
#import <VODUpload/VODUploadClient.h>
#import "XLPublishHandle.h"
#import "XLAliOSSModel.h"
#import <OSSLog.h>
#import <Photos/Photos.h>
#import "HXPhotoModel.h"

@interface XLVODUploadManager () <NSCopying>



@property (nonatomic, strong) VODUploadClient *uploader;
@property (nonatomic, strong) XLAliOSSModel *ossModel;
@property (nonatomic, copy) NSString *lastName;

@property (nonatomic, strong) NSMutableArray <UploadFileInfo *> *listFiles;

@end

@implementation XLVODUploadManager
singleton_m(XLVODUploadManager)


+ (void)vodVideoWithFilePath:(NSString *)fileName lastName:(NSString *)lastName success:(XLSuccess)success failure:(XLFailure)failure {
    [[self sharedXLVODUploadManager] vodVideoWithFilePath:fileName lastName:lastName success:success failure:failure    ];
}

+ (void)vodImageFilePath:(NSString *)filePath success:(XLSuccess)success failure:(XLFailure)failure {
    [[self sharedXLVODUploadManager] vodImageFilePath:filePath success:success failure:failure];
}


- (void)vodVideoWithFilePath:(NSString *)fileName lastName:(NSString *)lastName success:(XLSuccess)success failure:(XLFailure)failure {
    [OSSLog enableLog];
    self.lastName = lastName;
    kDefineWeakSelf;
    [XLPublishHandle getAliyunVideoOSSWithFileName:lastName coverUrl:@"" success:^(id  _Nonnull responseObject) {
        //[WeakSelf creatUploadClient:responseObject];
        [WeakSelf creatAuthUploadClient:responseObject success:success failure:failure];
        [WeakSelf uploadVideoWithFileName:fileName];
    } failure:^(id  _Nonnull result) {
        if (failure) {
            failure(result);
        }
    }];
}

- (void)vodImageFilePath:(NSString *)fileName success:(XLSuccess)success failure:(XLFailure)failure {
    //[OSSLog enableLog];
    kDefineWeakSelf;
    [XLPublishHandle getAliyunPhotoOSSWithType:@"" ext:@"" count:0 success:^(NSMutableArray *responseObject) {
        if (!XLArrayIsEmpty(responseObject)) {
            //[WeakSelf creatUploadClient:responseObject[0]];
            [WeakSelf creatAuthUploadClient:responseObject[0] success:success failure:failure];
            [WeakSelf uploadImageWithFileName:fileName];
        } else {
            if (failure) {
                failure(responseObject);
            }
        }
    } failure:^(id  _Nonnull result) {
        if (failure) {
            failure(result);
        }
    }];
}


#pragma mark - 添加视频
- (void)uploadVideoWithFileName:(NSString *)filePath {
    VodInfo *vodInfo = [[VodInfo alloc] init];
    vodInfo.title = @"title";
    vodInfo.desc =@"desc";
    vodInfo.cateId = @(19);
    vodInfo.tags = @"sports";
    [self.uploader addFile:filePath vodInfo:vodInfo];
    
//    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
//    VodInfo *vodInfo = [[VodInfo alloc] init];
//    vodInfo.title = @"hello test video";
//    [self.uploader addFile:videoPath vodInfo:vodInfo];
    
    [self startUpload];
}

#pragma mark - 添加图片
- (void)uploadImageWithFileName:(NSString *)filePath {
    VodInfo *imageInfo = [[VodInfo alloc] init];
    imageInfo.title = @"title";
    imageInfo.desc =@"desc";
    imageInfo.cateId = @(19);
    imageInfo.tags = @"sports";
    [self.uploader addFile:filePath vodInfo:imageInfo];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
//    VodInfo *vodInfo = [[VodInfo alloc] init];
//    vodInfo.title = @"hello test image";
//    [self.uploader addFile:imagePath vodInfo:vodInfo];
    
    [self startUpload];
}


- (void)creatAuthUploadClient:(XLAliOSSModel *)ossInfo success:(XLSuccess)success failure:(XLFailure)failure {
    
    NSLog(@"fileName:%@,ImageURL:%@",ossInfo.FileName,ossInfo.ImageURL);
    
    // create VODUploadClient object
    self.uploader = [VODUploadClient new];
    // weakself
    __weak typeof(self) weakSelf = self;
    // setup callback
    OnUploadFinishedListener FinishCallbackFunc = ^(UploadFileInfo* fileInfo, VodUploadResult* result){
        NSLog(@"upload finished callback videoid:%@, imageurl:%@", result.videoId, result.imageUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(XLStringIsEmpty(ossInfo.ImageURL) ? ossInfo.FileName : ossInfo.ImageURL);
            }
        });
    };
    OnUploadFailedListener FailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        NSLog(@"upload failed callback code = %@, error message = %@", code, message);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) {
                failure(message);
            }
        });
    };
    OnUploadProgressListener ProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        NSLog(@"upload progress callback uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
    };
    OnUploadTokenExpiredListener TokenExpiredCallbackFunc = ^{
        NSLog(@"upload token expired callback.");
        // token过期，设置新的上传凭证，继续上传
        [XLPublishHandle getAliyunVideoOSSWithFileName:weakSelf.lastName coverUrl:@"" success:^(XLAliOSSModel *ossInfo) {
            [weakSelf.uploader resumeWithToken:ossInfo.AccessKeyId accessKeySecret:ossInfo.AccessKeySecret secretToken:ossInfo.SecurityToken expireTime:ossInfo.Expiration];
        } failure:^(id  _Nonnull result) {
            
        }];
    };
    OnUploadRertyListener RetryCallbackFunc = ^{
        NSLog(@"upload retry begin callback.");
    };
    OnUploadRertyResumeListener RetryResumeCallbackFunc = ^{
        NSLog(@"upload retry end callback.");
    };
    OnUploadStartedListener UploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"upload upload started callback.");
        // 设置上传地址 和 上传凭证
        [weakSelf.uploader setUploadAuthAndAddress:fileInfo uploadAuth:ossInfo.UploadAuth uploadAddress:ossInfo.UploadAddress];
    };
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.finish = FinishCallbackFunc;
    listener.failure = FailedCallbackFunc;
    listener.progress = ProgressCallbackFunc;
    listener.expire = TokenExpiredCallbackFunc;
    listener.retry = RetryCallbackFunc;
    listener.retryResume = RetryResumeCallbackFunc;
    listener.started = UploadStartedCallbackFunc;
    // init with upload address and upload auth
    [self.uploader setListener:listener];
}


- (void)creatUploadClient:(XLAliOSSModel *)ossInfo {
    // create VODUploadClient object
    self.uploader = [VODUploadClient new];
    // weakself
    __weak typeof(self) weakSelf = self;
    // setup callback
    OnUploadFinishedListener FinishCallbackFunc = ^(UploadFileInfo* fileInfo, VodUploadResult* result){
        /**
         上传完成回调
         @param fileInfo 上传文件信息
         @param result 上传结果信息
         */
        NSLog(@"upload finished callback videoid:%@, imageurl:%@", result.videoId, result.imageUrl);
    };
    OnUploadFailedListener FailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        /**
         上传失败回调
         @param fileInfo 上传文件信息
         @param code 错误码
         @param message 错误描述
         */
        NSLog(@"upload failed callback code = %@, error message = %@", code, message);
    };
    OnUploadProgressListener ProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        /**
         上传进度回调
         @param fileInfo 上传文件信息
         @param uploadedSize 已上传大小
         @param totalSize 总大小
         */
        NSLog(@"upload progress callback uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
    };
    OnUploadTokenExpiredListener TokenExpiredCallbackFunc = ^{
        /**
         token过期回调
         上传地址和凭证方式上传需要调用resumeWithAuth:方法继续上传
         STS方式上传需要调用resumeWithToken:accessKeySecret:secretToken:expireTime:方法继续上传
         */
        NSLog(@"upload token expired callback.");
        // token过期，设置新的上传凭证，继续上传
        //[weakSelf.uploader resumeWithAuth:`new upload auth`];
        [XLPublishHandle getAliyunVideoOSSWithFileName:weakSelf.lastName coverUrl:@"" success:^(XLAliOSSModel *ossInfo) {
            [weakSelf.uploader resumeWithToken:ossInfo.AccessKeyId accessKeySecret:ossInfo.AccessKeySecret secretToken:ossInfo.SecurityToken expireTime:ossInfo.Expiration];
        } failure:^(id  _Nonnull result) {
            
        }];
    };
    OnUploadRertyListener RetryCallbackFunc = ^{
        /**
         上传开始重试回调
         */
        NSLog(@"upload retry begin callback.");
    };
    OnUploadRertyResumeListener RetryResumeCallbackFunc = ^{
        /**
         上传结束重试，继续上传回调
         */
        NSLog(@"upload retry end callback.");
    };
    OnUploadStartedListener UploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        /**
         开始上传回调
         上传地址和凭证方式上传需要调用setUploadAuthAndAddress:uploadAuth:uploadAddress:方法设置上传地址和凭证
         @param fileInfo 上传文件信息
         */
        NSLog(@"upload upload started callback.");
        // 设置上传地址 和 上传凭证
        //[weakSelf.uploader setUploadAuthAndAddress:fileInfo uploadAuth:`upload auth` uploadAddress:`upload address`];
    };
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.finish = FinishCallbackFunc;
    listener.failure = FailedCallbackFunc;
    listener.progress = ProgressCallbackFunc;
    listener.expire = TokenExpiredCallbackFunc;
    listener.retry = RetryCallbackFunc;
    listener.retryResume = RetryResumeCallbackFunc;
    listener.started = UploadStartedCallbackFunc;
    // init with upload address and upload auth
    //[self.uploader setListener:listener];
    [self.uploader setKeyId:ossInfo.AccessKeyId accessKeySecret:ossInfo.AccessKeySecret secretToken:ossInfo.SecurityToken expireTime:ossInfo.Expiration listener:listener];
    
    
    
}

- (NSString *)getTimeNow {
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"iOS/%@-%i", date,last];
    return timeNow;
}


#pragma mark - 上传控制
- (void)startUpload {
    [self.uploader start];
}

- (void)stopUpload {
    [self.uploader stop];
}

- (void)pauseUpload {
    [self.uploader pause];
}

- (void)resumeUpload {
    [self.uploader resume];
}

#pragma mark - 管理上传队列
- (BOOL)deleteFile:(int)index {
    return [self.uploader deleteFile:index];
}

- (BOOL)cancelFile:(int)index {
    return [self.uploader cancelFile:index];
}

- (BOOL)resumeFile:(int)index {
    return [self.uploader resumeFile:index];
}

- (BOOL)clearFiles {
    return [self.uploader clearFiles];
}
- (NSMutableArray<UploadFileInfo *> *)listFiles {
    if (!_listFiles) {
        _listFiles = [NSMutableArray arrayWithArray:[self.uploader listFiles]];
    }
    return _listFiles;
}


- (void)getVideoPathFromPhotoModel:(HXPhotoModel *)photoModel complete:(void (^)(NSString *, NSString *))result failure:(void (^)(NSString *))failure cancell:(void (^)(void))cancell {
    NSString *path = photoModel.videoURL.path;
    if (!XLStringIsEmpty(photoModel.videoURL.path)) {
        if (result) {
            result(path,[path lastPathComponent]);
        }
        return;
    }
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    options.version = PHImageRequestOptionsVersionCurrent;
    
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    NSString *fileName = [photoModel.asset valueForKey:@"filename"];
    [manager requestExportSessionForVideo:photoModel.asset options:options exportPreset:AVAssetExportPresetHighestQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        
        NSString *savePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
        exportSession.outputURL = [NSURL fileURLWithPath:savePath];
        
        exportSession.shouldOptimizeForNetworkUse = NO;
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    
                {
                    
                    if (failure) {
                        
                        NSError *e = [exportSession error];
                        
                        XLLog(@"%@",e);
                        
                        failure([[exportSession error] localizedDescription]);
                        
                    }
                    
                    break;
                    
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    
                {
                    
                    if (cancell) {
                        
                        cancell();
                        
                    }
                    
                    break;
                    
                }
                    
                case AVAssetExportSessionStatusCompleted:
                    
                {
                    
                    if (result) {
                        
                        result(savePath,[savePath lastPathComponent]);
                        
                    }
                    
                    break;
                    
                }
                    
                default:
                    
                    break;
                    
            }
            
        }];
        
    }];
    
}


@end
