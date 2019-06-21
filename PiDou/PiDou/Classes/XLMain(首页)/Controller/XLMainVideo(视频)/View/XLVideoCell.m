//
//  XLVideoCell.m
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLVideoCell.h"
#import "XLMainUserInfoView.h"
#import "XLMainUserActionView.h"
#import "XLTagRewardView.h"
#import "XLTieziModel.h"
#import "XLCommentModel.h"
#import "XLGodCommentView.h"
#import "UIImage+XLBlurGlass.h"
//#import "XLPlayerManager.h"
#import "UIImage+HXExtension.h"

@interface XLVideoCell () <XLMainUserActionViewDelegate>

@property (nonatomic, strong) XLMainUserInfoView *infoView;
@property (nonatomic, strong) XLMainUserActionView *actionView;
@property (nonatomic, strong) XLTagRewardView *tagRewardView;
@property (nonatomic, strong) XLGodCommentView *godCommentView;

@property (nonatomic, strong) UILabel *duanziLabel;

@property (nonatomic, strong) UIImageView *playerBgView;
@property (nonatomic, strong) UIImageView *playerView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIView *botKongView;

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation XLVideoCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.infoView = [[XLMainUserInfoView alloc] init];
    [self.contentView addSubview:self.infoView];
    self.infoView.userInfoViewType = XLMainUserInfoViewType_main;
    
    self.actionView = [[XLMainUserActionView alloc] init];
    [self.contentView addSubview:self.actionView];
    self.actionView.delegate = self;
    
    self.duanziLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.duanziLabel];
    self.duanziLabel.numberOfLines = 0;
    [self.duanziLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    
    self.playerBgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.playerBgView];
    self.playerBgView.userInteractionEnabled = YES;
   
    self.playerView = [[UIImageView alloc] init];
    [self.playerBgView addSubview:self.playerView];
    self.playerView.userInteractionEnabled = YES;
    self.playerView.backgroundColor = XL_COLOR_BG;
    self.playerView.tag = 1314;
    
    self.playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.playButton];
    [self.playButton xl_setImageName:@"video_play_2" selectImage:@"video_pause" target:self action:@selector(didPlayAction:)];
    self.playButton.selected = NO;
    
    self.godCommentView = [[XLGodCommentView alloc] init];
    [self.contentView addSubview:self.godCommentView];
    
    self.tagRewardView = [[XLTagRewardView alloc] init];
    [self.contentView addSubview:self.tagRewardView];
    
    self.botKongView = [[UIView alloc] init];
    self.botKongView.backgroundColor = XL_COLOR_BG;
    [self.contentView addSubview:self.botKongView];
    
    [self initLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initLayout {
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    
    
    [self.duanziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.infoView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.playerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(SCREEN_WIDTH * 9 / 16.0);
    }];
    

    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playerBgView);
        make.top.bottom.equalTo(self.playerBgView);
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    
    [self.godCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.playerView.mas_bottom).mas_offset(12 * kWidthRatio6s);
    }];
    
    [self.tagRewardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.godCommentView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(48 * kWidthRatio6s);
        make.top.equalTo(self.tagRewardView.mas_bottom);
    }];
    
    [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.actionView.mas_bottom);
    }];
}


- (void)didPlayAction:(UIButton *)button {
    button.hidden = NO;
    if (!self.isDetailVC) {
        button.selected = !button.selected;
    }
    if (button.selected && !self.isDetailVC) {
        button.hidden = YES;
    }
//    if (_delegate && [_delegate respondsToSelector:@selector(videoCell:didVideoPlay:)]) {
//        [_delegate videoCell:self didVideoPlay:button.selected];
//    }
    if (self.complete) {
        self.complete(self.tieziModel.video_url);
    }
   //[XLPlayerManager playVideoWithIndexPath:self.indexPath tag:1314 + self.indexPath.row scrollView:self.tableView videoUrl:self.tieziModel.video_url entity_id:self.tieziModel.entity_id];
    
}

//- (void)setIndexPath:(NSIndexPath *)indexPath {
//    _indexPath = indexPath;
//    self.playerView.tag = 1314 + _indexPath.row;
//}

- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
    
    self.playButton.hidden = NO;
    self.playButton.selected = NO;
    self.duanziLabel.text = _tieziModel.content;
    
    _tieziModel.user_info.pdcoin_count = _tieziModel.pdcoin_count;
    _tieziModel.user_info.do_like_count = _tieziModel.do_like_count;
    _tieziModel.user_info.do_liked = _tieziModel.do_liked;
    _tieziModel.user_info.pdcoin_count = _tieziModel.pdcoin_count;
    _tieziModel.user_info.entity_id = _tieziModel.entity_id;
    self.infoView.userInfo = _tieziModel.user_info;
    
    
    
    self.actionView.tieziModel = _tieziModel;
    self.tagRewardView.topics = _tieziModel.topics;
    self.tagRewardView.entity_id = _tieziModel.entity_id;
    
    if (_tieziModel.video_image) {
        
        
        CGFloat videoW = [_tieziModel.video_image.width floatValue];
        CGFloat videoH = [_tieziModel.video_image.height floatValue];
        if (videoW > (SCREEN_WIDTH)) {
            videoH = videoH * (SCREEN_WIDTH) / videoW;
            videoW = SCREEN_WIDTH;
        }
        
        if (videoH > SCREEN_WIDTH) {
            videoW = videoW * SCREEN_WIDTH / videoH;
            videoH = SCREEN_WIDTH;
        }
        [self.playerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
            make.width.mas_offset(SCREEN_WIDTH);
            make.height.mas_offset(videoH);
        }];
    
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.playerBgView);
            make.top.bottom.equalTo(self.playerBgView);
            make.width.mas_offset(videoW);
        }];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.playerView sd_setImageWithURL:[NSURL URLWithString:self.tieziModel.video_image.url] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    UIImage *blurImage = [image blur];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.playerBgView.image = blurImage;
                    });
                });
            }];
        });
    }
    
    if (XLArrayIsEmpty(_tieziModel.topics) && !self.isDetailVC) {
        [self.tagRewardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.godCommentView.mas_bottom).mas_offset(1 * kWidthRatio6s);
            make.height.mas_offset(CGFLOAT_MIN);
        }];
    } else {
        [self.tagRewardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.godCommentView.mas_bottom).mas_offset(12 * kWidthRatio6s);
            make.height.mas_offset(28 * kWidthRatio6s);
        }];
    }
    
    if (_tieziModel.isComment) {
        self.actionView.hidden = YES;
        self.tagRewardView.hidden = YES;
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.playerView.mas_bottom).mas_offset(8 * kWidthRatio6s);
        }];
        self.infoView.creatTime = _tieziModel.created;
    } else {
        self.actionView.hidden = NO;
        self.tagRewardView.hidden = NO;
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.actionView.mas_bottom);
        }];
    }
    
    if (!XLStringIsEmpty(_tieziModel.god_comment.cid)) {
        self.godCommentView.hidden = NO;
        self.godCommentView.entity_id = _tieziModel.entity_id;
        self.godCommentView.commentType = XLCommentCellType_video;
        self.godCommentView.commentModel = _tieziModel.god_comment;
        [self.godCommentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.playerView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        }];
    } else {
        self.godCommentView.hidden = YES;
        [self.godCommentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.playerView.mas_bottom).mas_offset(0);
            make.height.mas_offset(CGFLOAT_MIN);
        }];
    }
    
}

- (void)setIsDetailVC:(BOOL)isDetailVC {
    _isDetailVC = isDetailVC;
    if (_isDetailVC) {
        self.infoView.userInfoViewType = XLMainUserInfoViewType_focus;
        self.actionView.hidden = YES;
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.tagRewardView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        }];
        self.tagRewardView.isDetail = YES;
        self.infoView.creatTime = _tieziModel.created;
        self.playButton.hidden = NO;
    } else {
        self.actionView.hidden = NO;
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.actionView.mas_bottom);
        }];
        self.tagRewardView.isDetail = NO;
    }
}

- (void)setIsMyPublish:(BOOL)isMyPublish {
    _isMyPublish = isMyPublish;
    if (_isMyPublish) {
        self.infoView.userInfoViewType = XLMainUserInfoViewType_delete;
    }
}

#pragma mark - XLMainUserActionViewDelegate
/**
 @param index 0:点赞 1:评论 2：收藏 3:打赏 4:转发
 */
- (void)actonView:(XLMainUserActionView *)actionView didSelectedWithIndex:(NSInteger)index select:(BOOL)select count:(NSString *)count {
    if (self.didSelectedAction) {
        self.didSelectedAction(@{@"index":@(index),@"select":@(select),@"count":count});
    }
}

@end
