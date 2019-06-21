//
//  XLPlayerManager.h
//  TG
//
//  Created by kevin on 28/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFPlayer.h"

@interface XLPlayerManager : NSObject
singleton_h(XLPlayerManager)


/**
 播放器放在fatherView上

 @param fatherView 添加播放器
 @param url 视频url
 */
+ (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url isVoice:(BOOL)isVoice;
+ (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url;

/**
 播放器放在fatherView上
 
 @param fatherView 添加播放器
 @param path 本地视频路径
 */
+ (void)playVideoWithFatherView:(UIView *)fatherView videoPath:(NSString *)path isVoice:(BOOL)isVoice;
+ (void)playVideoWithFatherView:(UIView *)fatherView videoPath:(NSString *)path;

/**
 播放器放在Cell上

 @param indexPath cell的indexPath
 @param tag cell上的存放播放器的view的tag,一般用self.contentView.tag
 @param scrollView cell所在的tableview或collectionview
 @param url 视频url
 */
+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url isVoice:(BOOL)isVoice;
+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url;
+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url entity_id:(NSString *)entity_id;

/**一般在页面已经出现的时候调用*/
+ (void)appear;
/**一般在页面已经消失的时候调用*/
+ (void)disappear;

@end
