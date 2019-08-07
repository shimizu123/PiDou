//
//  GeneralHandle.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "GeneralHandle.h"

@implementation GeneralHandle

+ (void)systemTitle:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseUrl, Url_SystemTitle];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        NSDictionary *data = [responseObject valueForKey:@"data"];
        
        if (code == 200) {
            if (success) {
                success([data valueForKey:@"content"]);
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
