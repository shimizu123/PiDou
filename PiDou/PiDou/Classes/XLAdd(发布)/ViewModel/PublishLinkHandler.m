//
//  PublishLinkHandler.m
//  PiDou
//
//  Created by 邓康大 on 2019/7/31.
//  Copyright © 2019 ice. All rights reserved.
//

#import "PublishLinkHandler.h"


@implementation PublishLinkHandler

+ (void)parsePPXLink:(NSString *)itemId success:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"https://h5.pipix.com/bds/webapi/item/detail/?item_id=%@&source=share", itemId];
    [XLAFNetworking get:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"status_code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"message"];
        NSString *downloadUrl = responseObject[@"data"][@"item"][@"origin_video_download"][@"url_list"][0][@"url"];
        

        if (code == 0) {
            if (success) {
                success(downloadUrl);
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
