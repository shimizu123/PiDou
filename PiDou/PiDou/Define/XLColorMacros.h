//
//  XLColorMacros.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#ifndef XLColorMacros_h
#define XLColorMacros_h


#define COLOR(n)        [UIColor colorWithRed:(n>>16)/255.0 green:((n>>8)&0xff)/255.0 blue:((n)&0xff)/255.0 alpha:1.0]
#define COLOR_A(n,a)    [UIColor colorWithRed:(n>>16)/255.0 green:((n>>8)&0xff)/255.0 blue:((n)&0xff)/255.0 alpha:a]

#define CGCOLOR(n)      [UIColor colorWithRed:(n>>16)/255.0 green:((n>>8)&0xff)/255.0 blue:((n)&0xff)/255.0 alpha:1.0].CGColor
#define CGCOLOR_A(n,a)  [UIColor colorWithRed:(n>>16)/255.0 green:((n>>8)&0xff)/255.0 blue:((n)&0xff)/255.0 alpha:a].CGColor

#define RGB_COLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGB_COLOR_A(r, g, b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define RGB_CGCOLOR(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0].CGColor
#define RGB_CGCOLOR_A(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a].CGColor

#define XLRandomColor RGB_COLOR(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))


#define XL_COLOR_BLACK           COLOR(0x666666)
#define XL_COLOR_DARKBLACK       COLOR(0x333333)
#define XL_COLOR_DARKGRAY        COLOR(0x999999)
#define XL_COLOR_GRAY            COLOR(0xCCCCCC)
#define XL_COLOR_LINE            COLOR(0xF2F2F5)
#define XL_COLOR_BG              COLOR(0xf8f8fa)
#define XL_COLOR_RED             COLOR(0xE86B6B)
#define XL_COLOR_BLUE            COLOR(0x0071D8)
#define XL_COLOR_SHADOW          COLOR(0xB3B3B3)
#define XL_COLOR_GREEN           COLOR(0x069352)


#endif /* XLColorMacros_h */
