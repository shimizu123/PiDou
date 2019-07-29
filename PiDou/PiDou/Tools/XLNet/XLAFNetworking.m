//
//  XLAFNetworking.m
//  TG
//
//  Created by kevin on 31/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLAFNetworking.h"
#import "XLUserManager.h"


@interface XLAFNetworking ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation XLAFNetworking
singleton_m(XLAFNetworking)

/// 使用lazy load的目的是为了防止内存泄露
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 10.0f;
        
    }
    return _manager;
}





+ (void)post:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    [[self sharedXLAFNetworking] post:url params:params success:success failure:failure];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    [[self sharedXLAFNetworking] get:url params:params success:success failure:failure];
}

/**通用POST*/
+ (void)authorizationPost:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    [[self sharedXLAFNetworking] authorizationPost:url params:params success:success failure:failure];
}

/**通用GET*/
+ (void)authorizationGet:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    [[self sharedXLAFNetworking] authorizationGet:url params:params success:success failure:failure];
}

#pragma mark - POST

- (void)post:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    AFHTTPSessionManager * mgr = self.manager;
    
    
    NSString *pdversion = [RandomString getPdversion];
   // NSString *pdrandom = [RandomString getRandomString];
    NSString *pdsign = [RandomString getPdsign:params];
   // NSString *pdsign = [RandomString md5WithString:pdrandom];
    
    [mgr.requestSerializer setValue:pdversion forHTTPHeaderField:@"pdversion"];
   // [mgr.requestSerializer setValue:pdrandom forHTTPHeaderField:@"pdrandom"];
    [mgr.requestSerializer setValue:pdsign forHTTPHeaderField:@"pdsign"];
    //从静态库获取协议进行请求接口拼接
    
    //设置网路请求的超时时间
//    AFHTTPRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
//    requestSerializer.timeoutInterval = 10.f;
//    // 设置超时时间
//    //设置接受的参数类型
//    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if (!XLStringIsEmpty([XLUserHandle token])) {
        [mgr.requestSerializer setValue:[XLUserHandle token] forHTTPHeaderField:@"Authorization"];
    }
    
    //mgr.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"application/x-gzip", nil];
    
    //添加SSL功能
    mgr.securityPolicy = [self securityPolicyForHttps];
    
    //发送post请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        if (code == 401) {
            [XLUserManager logout];
        }
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - GET
- (void)get:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    AFHTTPSessionManager *mgr = self.manager;
    
    NSString *pdversion = [RandomString getPdversion];
   // NSString *pdrandom = [RandomString getRandomString];
    NSString *pdsign = [RandomString getPdsign:params];
    
    [mgr.requestSerializer setValue:pdversion forHTTPHeaderField:@"pdversion"];
   // [mgr.requestSerializer setValue:pdrandom forHTTPHeaderField:@"pdrandom"];
    [mgr.requestSerializer setValue:pdsign forHTTPHeaderField:@"pdsign"];
    
    //设置网路请求的超时时间
//    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
//    requestSerializer.timeoutInterval = 10.f;
    if (!XLStringIsEmpty([XLUserHandle token])) {
        [mgr.requestSerializer setValue:[XLUserHandle token] forHTTPHeaderField:@"Authorization"];
    }
    //设置接受的参数类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"application/x-gzip", nil];
    
    //添加SSL功能
    mgr.securityPolicy = [self securityPolicyForHttps];
    
    //发送GET请求
    [mgr GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        if (code == 401) {
            [XLUserManager logout];
        }
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];

}

/**通用POST*/
- (void)authorizationPost:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    AFHTTPSessionManager * mgr = self.manager;
    
    //从静态库获取协议进行请求接口拼接
    
    //设置网路请求的超时时间
    //    AFHTTPRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
    //    requestSerializer.timeoutInterval = 10.f;
    //    // 设置超时时间
    //    //设置接受的参数类型
    //    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if (!XLStringIsEmpty([XLUserHandle token])) {
        [mgr.requestSerializer setValue:[XLUserHandle token] forHTTPHeaderField:@"Authorization"];
    }
    //mgr.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"application/x-gzip", nil];
    
    //添加SSL功能
    mgr.securityPolicy = [self securityPolicyForHttps];
    
    //发送post请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/**通用GET*/
- (void)authorizationGet:(NSString *)url params:(NSDictionary *)params success:(XLSuccess)success failure:(XLError)failure {
    AFHTTPSessionManager *mgr = self.manager;
    
    //设置网路请求的超时时间
    //    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    //    requestSerializer.timeoutInterval = 10.f;
    if (!XLStringIsEmpty([XLUserHandle token])) {
        [mgr.requestSerializer setValue:[XLUserHandle token] forHTTPHeaderField:@"Authorization"];
    }
    //设置接受的参数类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"application/x-gzip", nil];
    
    //添加SSL功能
    mgr.securityPolicy = [self securityPolicyForHttps];
    
    //发送GET请求
    [mgr GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

#pragma mark - AFSecurityPolicy设置
- (AFSecurityPolicy *)securityPolicyForHttps {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

#pragma mark - 机构版参数
- (NSDictionary *)parameters:(NSDictionary *)dic {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    return params;
}

@end
