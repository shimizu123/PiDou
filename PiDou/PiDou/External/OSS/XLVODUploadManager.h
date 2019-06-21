//
//  XLVODUploadManager.h
//  PiDou
//
//  Created by ice on 2019/4/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class HXPhotoModel;
@interface XLVODUploadManager : NSObject
singleton_h(XLVODUploadManager)

+ (void)vodVideoWithFilePath:(NSString *)fileName lastName:(NSString *)lastName success:(XLSuccess)success failure:(XLFailure)failure;

+ (void)vodImageFilePath:(NSString *)filePath success:(XLSuccess)success failure:(XLFailure)failure;

- (NSString *)getTimeNow;


- (void)getVideoPathFromPhotoModel:(HXPhotoModel *)photoModel complete:(void (^)(NSString *, NSString *))result failure:(void (^)(NSString *))failure cancell:(void (^)(void))cancell;

@end

NS_ASSUME_NONNULL_END
