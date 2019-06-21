//
//  XLCommentVideoView.m
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentVideoView.h"
#import "XLPhotoBrowser.h"

@interface XLCommentVideoView ()

@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIButton *playbutton;

@end

@implementation XLCommentVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.bgImgV = [[UIImageView alloc] init];
    [self addSubview:self.bgImgV];
    self.bgImgV.backgroundColor = XL_COLOR_BG;
    
    self.playbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.playbutton];
    [self.playbutton xl_setImageName:@"video_play_2" target:self action:@selector(playAction:)];
    
    [self initLayout];
}

- (void)initLayout {
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.playbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)playAction:(UIButton *)button {
    XLLog(@"点击图片播放");
    if (self.videoURL) {
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.currentImageIndex = 0;
        browser.imageArray = @[self.videoURL];
        browser.sourceImagesContainerView = self;
        [browser show];
    }
}

- (void)setVideo_image:(XLSizeModel *)video_image {
    _video_image = video_image;
    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:_video_image.url] placeholderImage:nil];
    
    CGFloat imageW = [_video_image.width floatValue];
    CGFloat imageH = [_video_image.height floatValue];
    CGFloat max = 210 * kWidthRatio6s;
    if (imageW > max) {
        imageH = max * imageH / imageW;
        imageW = max;
    }
    if (imageH > max) {
        imageW = max * imageW / imageH;
        imageH = max;
    }
    
    [self.bgImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.mas_offset(imageW);
        make.height.mas_offset(imageH);
    }];
}



@end
