//
//  XLAudioManager.m
//  TG
//
//  Created by kevin on 30/5/18.
//  Copyright © 2018年 YIcai. All rights reserved.
//

#import "XLAudioManager.h"
#import "ZFPlayer.h"
#import "XLAudioContentView.h"

@interface XLAudioManager () <ZFPlayerDelegate, XLAudioContentViewDelegate>

@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) XLAudioContentView *controlView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;


@end


@implementation XLAudioManager
singleton_m(XLAudioManager)

+ (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url duration:(NSInteger)duration {
    [[self sharedXLAudioManager] playVideoWithFatherView:fatherView videoUrl:url duration:duration];
}

+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url duration:(NSInteger)duration {
    [[self sharedXLAudioManager] playVideoWithIndexPath:indexPath tag:tag scrollView:scrollView videoUrl:url duration:duration];
}

+ (void)appear {
    [[self sharedXLAudioManager] appear];
}
+ (void)disappear {
    [[self sharedXLAudioManager] disappear];
}

- (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url duration:(NSInteger)duration {
    self.playerModel.fatherView = fatherView;
    self.playerModel.videoURL = [NSURL URLWithString:url];
    
    [self playVideo];
    
    self.controlView.videolen = duration;
}

- (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url duration:(NSInteger)duration {
    self.playerModel.indexPath = indexPath;
    self.playerModel.fatherViewTag = tag;
    self.playerModel.scrollView = scrollView;
    self.playerModel.videoURL = [NSURL URLWithString:url];
    
    [self playVideo];
    self.controlView.videolen = duration;
}

- (void)playVideo {
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

- (void)appear {
    if (_playerView) {
        self.playerView.playerPushedOrPresented = NO;
    }
    ZFPlayerShared.isLockScreen = YES;
}
- (void)disappear {
    if (_playerView) {
        self.playerView.playerPushedOrPresented = YES;
        [self removePlayer];
    }
    ZFPlayerShared.isLockScreen = NO;
}

- (void)removePlayer {
    [self.playerView resetPlayer];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
    self.playerModel = nil;
    [self.controlView removeFromSuperview];
    self.controlView = nil;
}

#pragma mark - XLAudioContentViewDelegate
- (void)audioContentViewRepeatPlay {
    [self.playerView resetPlayer];
    [self playVideo];
}

#pragma mark - lazy load
- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        //_playerModel.title            = @"这里设置视频标题";
        _playerModel.placeholderImage = [UIImage imageNamed:@"video_pl"];
        _playerModel.seekTime = 0;
        //_playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        //_playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        self.controlView = [[XLAudioContentView alloc] init];
        [_playerView playerControlView:self.controlView playerModel:self.playerModel];
        self.controlView.assistant = self;
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload = NO;
        
//        _playerView.stopPlayWhileCellNotVisable = YES;
        // 预览图设置
        _playerView.hasPreviewView = NO;
    }
    return _playerView;
}


@end
