//
//  XLAudioManager.h
//  TG
//
//  Created by kevin on 30/5/18.
//  Copyright © 2018年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLAudioManager : NSObject
singleton_h(XLAudioManager)

+ (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url duration:(NSInteger)duration;
+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url duration:(NSInteger)duration;
/**一般在页面已经出现的时候调用*/
+ (void)appear;
/**一般在页面已经消失的时候调用*/
+ (void)disappear;

@end
