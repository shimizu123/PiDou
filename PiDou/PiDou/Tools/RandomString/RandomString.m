//
//  RandomString.m
//  PiDou
//
//  Created by 邓康大 on 2019/7/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "RandomString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RandomString
singleton_m(RandomString)

+ (NSString *)getPdversion {
    NSString *version = [RandomString getVersion];
    NSString *pdversion = [NSString stringWithFormat:@"appv%@", version];
    
    return pdversion;
}

+ (NSString *)getRandomString {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:6];
    for (int i = 0; i < 6; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % strAll.length;
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

+ (NSString *)md5WithString:(NSString *)pdrandom {
    
    NSString *fixedStr = @"igxitxurigxurxigxutxitxut";
    NSString *totalStr = [fixedStr stringByAppendingString:pdrandom];

    return [[self sharedRandomString] md5:totalStr];
}

+ (NSString *)getVersion {
    //编译版本号 CFBundleVersion
    //更新版本号 CFBundleShortVersionString
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *localAppVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return localAppVersion;
}

+ (NSString *)getPdsign:(NSDictionary *)dict {
    NSArray *sortArray = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *key in sortArray) {
        NSString *valueString = [dict objectForKey:key];
        [valueArray addObject:valueString];
    }
    NSString *Str = [valueArray componentsJoinedByString:@""];
    NSString *fixedStr = @"igxitxurigxurxigxutxitxut";
    NSString *totalStr = [fixedStr stringByAppendingString:Str];
    
    return [[self sharedRandomString] md5:totalStr];
}

- (NSString *)md5:(NSString *)str {
    // MD5加密都是通过C级别的函数来计算，所以需要将加密的字符串转换为C语言的字符串
    const char *cstring = str.UTF8String;
    // 创建一个C语言的字符数组，用来接收加密结束之后的字符
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //MD5计算（也就是加密）
    //第一个参数：需要加密的字符串
    //第二个参数：需要加密的字符串的长度
    //第三个参数：加密完成之后的字符串存储的地方
    CC_MD5(cstring, (CC_LONG)strlen(cstring), result);
    // 将加密完成的字符拼接起来使用（16进制的）。
    // 声明一个可变字符串类型，用来拼接转换好的字符
    NSMutableString *md5String = [NSMutableString string];
    // %02x：x 表示以十六进制形式输出，02 表示不足两位，前面补0输出；超出两位，不影响。当x小写的时候，返回的密文中的字母就是小写的，当X大写的时候返回的密文中的字母是大写的。
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", result[i]];
    }
    
    return md5String;
}


@end
