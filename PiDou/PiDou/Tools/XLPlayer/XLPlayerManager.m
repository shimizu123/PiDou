//
//  XLPlayerManager.m
//  TG
//
//  Created by kevin on 28/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLPlayerManager.h"
#import "XLPlayerControlView.h"
#import "UIImage+TGExtension.h"
#import "XLVideoPlayerController.h"
#import "XLPhotoBrowser.h"

@interface XLPlayerManager () <ZFPlayerDelegate>

@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) XLPlayerControlView *controlView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
/**是否是语音播放*/
@property (nonatomic, assign) BOOL isVoice;

@property (nonatomic, copy) NSString *entity_id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@end

@implementation XLPlayerManager
singleton_m(XLPlayerManager)

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        //_playerModel.title            = @"这里设置视频标题";
        //_playerModel.placeholderImage = [UIImage imageNamed:@"coin_bg"];
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
        self.controlView = [[XLPlayerControlView alloc] init];
        self.controlView.xl_showBackBtn = NO;
        self.controlView.xl_isVoice = self.isVoice;
        if (self.playerModel.scrollView) {
            [_playerView playerControlView:self.controlView playerModel:self.playerModel];
        }
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
         _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload = NO;
        
        _playerView.smallScreenPlay = YES;
        // 预览图设置
        _playerView.hasPreviewView = NO;
        _playerView.stopPlayWhileCellNotVisable = YES;
    }
    return _playerView;
}

#pragma mark - view上播放
+ (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url {
    [self playVideoWithFatherView:fatherView videoUrl:url isVoice:NO];
}

+ (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url isVoice:(BOOL)isVoice {
    [[self sharedXLPlayerManager] playVideoWithFatherView:fatherView videoUrl:url isVoice:isVoice];
}

+ (void)playVideoWithFatherView:(UIView *)fatherView videoPath:(NSString *)path  {
    [self playVideoWithFatherView:fatherView videoPath:path isVoice:NO];
}
+ (void)playVideoWithFatherView:(UIView *)fatherView videoPath:(NSString *)path  isVoice:(BOOL)isVoice {
    [[self sharedXLPlayerManager] playVideoWithFatherView:fatherView videoPath:path isVoice:isVoice];
}

+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url entity_id:(NSString *)entity_id {
    [[self sharedXLPlayerManager] playVideoWithIndexPath:indexPath tag:tag scrollView:scrollView videoUrl:url entity_id:entity_id];
}

#pragma mark - cell上播放
+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url {
    [self playVideoWithIndexPath:indexPath tag:tag scrollView:scrollView videoUrl:url isVoice:NO];
}
+ (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url isVoice:(BOOL)isVoice {
    [[self sharedXLPlayerManager] playVideoWithIndexPath:indexPath tag:tag scrollView:scrollView videoUrl:url isVoice:isVoice];
}

- (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url entity_id:(NSString *)entity_id {
    self.entity_id = entity_id;
    self.url = url;
    self.contentScrollView = scrollView;
    [self playVideoWithIndexPath:indexPath tag:tag scrollView:scrollView videoUrl:url isVoice:NO];
}

+ (void)appear {
    [[self sharedXLPlayerManager] appear];
}
+ (void)disappear {
    [[self sharedXLPlayerManager] disappear];
}

- (void)playVideoWithFatherView:(UIView *)fatherView videoUrl:(NSString *)url isVoice:(BOOL)isVoice {
    self.isVoice = isVoice;
    self.playerModel.fatherView = fatherView;
    self.playerModel.videoURL = [NSURL URLWithString:url];
    
    [self playVideo];
}

- (void)playVideoWithFatherView:(UIView *)fatherView videoPath:(NSString *)path isVoice:(BOOL)isVoice {
    self.isVoice = isVoice;
    self.playerModel.fatherView = fatherView;
    self.playerModel.videoURL = [NSURL fileURLWithPath:path];
    
    [self playVideo];
}

- (void)playVideoWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag scrollView:(UIScrollView *)scrollView videoUrl:(NSString *)url isVoice:(BOOL)isVoice {
    self.isVoice = isVoice;
    self.playerModel = [[ZFPlayerModel alloc] init];
    self.playerModel.indexPath = indexPath;
    self.playerModel.fatherViewTag = tag;
    self.playerModel.scrollView = scrollView;
    self.playerModel.videoURL = [NSURL URLWithString:url];
    
    self.playerModel.placeholderImage = [UIImage thumbnailImageForVideo:self.playerModel.videoURL atTime:0.1];

    [self playVideo];
}

- (void)playVideo {
    [self.playerView resetToPlayNewVideo:self.playerModel];
}


- (void)appear {
    if (_playerView) {
        self.playerView.playerPushedOrPresented = NO;
    }
}
- (void)disappear {
    if (_playerView) {
        self.playerView.playerPushedOrPresented = YES;
        [self removePlayer];
    }
}

- (void)removePlayer {
    [self.playerView resetPlayer];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
    self.playerModel = nil;
    [self.controlView removeFromSuperview];
    self.controlView = nil;
}

#pragma mark - ZFPlayerDelegate
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    WS(WeakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WeakSelf.controlView.xl_state = (NSInteger)self.playerView.state;
    });
}
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    WS(WeakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WeakSelf.controlView.xl_state = (NSInteger)self.playerView.state;
    });
}

/**点击全屏*/
- (void)xl_fullScreen {
    XLLog(@"点击全屏");
    if (XLStringIsEmpty(self.entity_id) && !XLStringIsEmpty(self.url)) {
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.currentImageIndex = 0;
        browser.imageArray = @[[NSURL URLWithString:self.url]];
        browser.sourceImagesContainerView = self.contentScrollView;
        [browser show];
    } else {
        XLVideoPlayerController *videoDetailVC = [[XLVideoPlayerController alloc] init];
        videoDetailVC.entity_id = self.entity_id;
        [self.playerView.navigationController pushViewController:videoDetailVC animated:YES];
    }
}

@end
