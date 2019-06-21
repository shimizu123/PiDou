//
//  NSString+Additions.h
//  TG
//
//  Created by kevin on 26/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/**email*/
- (BOOL)isValidEmail;
/**phoneNumber*/
- (BOOL)isVAlidPhoneNumber;
/**url*/
- (BOOL)isValidUrl;

- (NSString*)encodeString:(NSString*)unencodedString;
- (BOOL)isChinese;

- (NSString *)phoneNumberEncry;

@end
