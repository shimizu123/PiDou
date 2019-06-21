//
//  NSString+Encrypt.h
//  okfoods
//
//  Created by China Click on 2017/6/15.
//  Copyright © 2017年 China Click. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/**MD5加密*/
+ (NSString *)MD5Encrypt:(NSString *)string;

+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key;

+ (NSString *)decryptUseDES:(NSString *)plainText key:(NSString *)key;

- (NSString *)md5;
- (NSString *)sha1;
+ (NSString *)base64WithData:(NSData *)data;

@end
