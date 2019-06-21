//
//  XLSearchHandle.m
//  PiDou
//
//  Created by ice on 2019/5/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchHandle.h"

@implementation XLSearchHandle


#pragma mark - 搜索
+ (void)searchResultWithKeyword:(NSString *)keyword page:(int)page category:(NSString *)category success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    params[@"keyword"] = keyword;
    params[@"category"] = category;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Search];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            //XLSearchModel *searchModel= [XLSearchModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success([responseObject valueForKey:@"data"]);
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
