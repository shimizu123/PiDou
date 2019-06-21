//
//  XLUtilsMacros.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#ifndef XLUtilsMacros_h
#define XLUtilsMacros_h


#define WS(WeakSelf)            __weak __typeof(self)WeakSelf = self
#define kDefineWeakSelf         __weak typeof(self) WeakSelf = self

#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_MIN_LENGTH       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define iphone5s_ScreenWidth    320.0
#define iphone5s_ScreenHeight   568.0
#define iphone6s_ScreenWidth    375.0
#define iphone6s_ScreenHeight   667.0
#define iphone6sp_ScreenWidth   414.0
#define iphoneX_ScreenHeight    812.0

#define kWidthRatio             SCREEN_WIDTH/iphone5s_ScreenWidth
#define kHeightRatio            SCREEN_HEIGHT/iphone5s_ScreenHeight
#define kWidthRatio6s           SCREEN_MIN_LENGTH/iphone6s_ScreenWidth
#define kHeightRatio6s          SCREEN_HEIGHT/iphone6s_ScreenHeight
#define kWidthRatio6sp          SCREEN_WIDTH/iphone6sp_ScreenWidth

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iphoneX,iPhoneXs
#define iPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define iPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define iPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// 判断是否是iPhone X
#define iPHONE_LIUHAI_XL ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
// 状态栏高度
#define XL_STATUS_H             (iPHONE_LIUHAI_XL ? 44.f : 20.f)
// 适配X的刘海
#define XL_LIUHAI_H             (iPHONE_LIUHAI_XL ? 44.f : 0.f)
// 导航栏高度
#define XL_NAVIBAR_H            (iPHONE_LIUHAI_XL ? 88.f : 64.f)
// home indicator
#define XL_HOME_INDICATOR_H     (iPHONE_LIUHAI_XL ? 34.f : 0.f)
// tabBar高度
#define XL_TABBAR_H             (iPHONE_LIUHAI_XL ? 83.f : 49.f)

#define XL_SCREEN_RADIO         (SCREEN_WIDTH / 375.0)



#define XL_LEFT_DISTANCE        (16 * kWidthRatio6s)
#define XL_iPhoneX_DISTANCE     (iPhoneX ? 10.f : 0)
#define XL_ORI_DISTANCE         16

/// 视频宽高比
#define XL_VIDEO_SCALE          (9 / 16.0f)    // 9 : 16
#define XL_PLAYER_HEIGHT        (SCREEN_WIDTH * XL_VIDEO_SCALE)

#pragma mark - ---------判断系统版本-------------
#define iOS7   [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define iOS8   [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define iOS9   [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define iOS10  [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0
#define iOS11  [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0


// 沙盒路径
#define XLDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]
#define XLLibraryPath  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0]
#define XLCachesPath   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0]


// 字符串是否为空
#define XLStringIsEmpty(str) \
([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

// 字符串不为NULL
#define XLNotNullString(str) \
(XLStringIsEmpty(str) ? @"" : str)

// 数组是否为空
#define XLArrayIsEmpty(array) \
(array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

// 字典是否为空
#define XLDictIsEmpty(dic) \
(dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

// View 圆角和加边框
#define XLViewBorderRadius(View, Radius, Width, CGColor)\
[View.layer setCornerRadius:Radius];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:CGColor]

// View 圆角
#define XLViewRadius(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define XLTypeVideo(type) \
[type isEqualToString:@"video"]

#define XLTypePicture(type) \
[type isEqualToString:@"pic"]

#define XLTypeText(type) \
[type isEqualToString:@"text"]

#define XLTypeComment(type) \
[type isEqualToString:@"comment"]

#ifndef XL_CLAMP
#define XL_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define XLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define XLLog(...)
#endif



#endif /* XLUtilsMacros_h */
