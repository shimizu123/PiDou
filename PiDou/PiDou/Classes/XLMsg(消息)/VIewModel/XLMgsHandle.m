//
//  XLMgsHandle.m
//  PiDou
//
//  Created by kevin on 10/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMgsHandle.h"

@implementation XLMgsHandle

/**消息*/
+ (void)messageWithPage:(int)page category:(NSString *)category success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    params[@"category"] = category;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Message];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLMsgModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
  
            if (success) {
                success(data);
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
