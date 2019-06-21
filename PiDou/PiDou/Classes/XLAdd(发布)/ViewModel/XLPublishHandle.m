//
//  XLPublishHandle.m
//  PiDou
//
//  Created by kevin on 29/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishHandle.h"
#import "XLAliOSSModel.h"

@implementation XLPublishHandle

#pragma mark - 发布视频、图片、文字和链接
+ (void)publishWithCategory:(NSString *)category topics:(NSArray *)topics content:(NSString *)content urls:(NSArray *)urls success:(XLSuccess)success failure:(XLFailure)failure {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    dataDic[@"category"] = category;
    if (!XLArrayIsEmpty(topics)) {
        dataDic[@"topic"] = topics;
    }
    dataDic[@"content"] = content;
    if (!XLArrayIsEmpty(urls)) {
        dataDic[@"urls"] = urls;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"data"] = dataDic.mj_JSONString;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Publish];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSDictionary *dic = [responseObject valueForKey:@"data"];
            NSLog(@"entity_id:%@",[dic valueForKey:@"entity_id"]); 
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**获取阿里云视频上传信息*/
+ (void)getAliyunVideoOSSWithFileName:(NSString *)fileName coverUrl:(NSString *)coverUrl success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"video_file_name"] = fileName;
    if (!XLStringIsEmpty(coverUrl)) {
        params[@"video_cover_url"] = coverUrl;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UploadVideo];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAliOSSModel *ossModel = [XLAliOSSModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(ossModel);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**获取阿里云图片上传信息*/
+ (void)getAliyunPhotoOSSWithType:(NSString *)type ext:(NSString *)ext count:(int)count success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!XLStringIsEmpty(type)) {
        params[@"image_type"] = type;
    }
    if (!XLStringIsEmpty(ext)) {
        params[@"image_ext"] = ext;
    }
    if (count > 0) {
        params[@"image_count"] = @(MAX(count, 1));
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UploadImage];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *ossModels = [XLAliOSSModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            if (success) {
                success(ossModels);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
