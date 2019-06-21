//
//  XLUserCommentCell.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserCommentCell.h"
#import "XLMainUserInfoView.h"
#import "XLMainUserActionView.h"
#import "XLTieziModel.h"
#import "XLMainDetailController.h"
#import "XLCommentPicturesView.h"
#import "XLCommentVideoView.h"


@interface XLUserCommentCell () <XLMainUserActionViewDelegate>

@property (nonatomic, strong) XLMainUserInfoView *infoView;
@property (nonatomic, strong) UILabel *commentL;

@property (nonatomic, strong) XLCommentVideoView *videoView;
@property (nonatomic, strong) XLCommentPicturesView *picturesView;

@property (nonatomic, strong) UIView *oriView;
@property (nonatomic, strong) UILabel *oriDescL;
@property (nonatomic, strong) UIImageView *oriImgV;
@property (nonatomic, strong) UIImageView *playImgV;

@property (nonatomic, strong) UILabel *oriTitleL;

@property (nonatomic, strong) XLMainUserActionView *actionView;
@property (nonatomic, strong) UIView *botKongView;



@end

@implementation XLUserCommentCell

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
    self.infoView.userInfoViewType = XLMainUserInfoViewType_none;
    
    
    self.commentL = [[UILabel alloc] init];
    [self.contentView addSubview:self.commentL];
    self.commentL.numberOfLines = 0;
    [self.commentL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    
    self.oriView = [[UIView alloc] init];
    [self.contentView addSubview:self.oriView];
    self.oriView.backgroundColor = COLOR(0xf8f8fa);
    XLViewRadius(self.oriView, 4 * kWidthRatio6s);
    self.oriView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTieziDetailTap:)];
    [self.oriView addGestureRecognizer:tap];
    
    self.oriDescL = [[UILabel alloc] init];
    [self.oriView addSubview:self.oriDescL];
    [self.oriDescL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.oriDescL.numberOfLines = 0;
    
    self.oriImgV = [[UIImageView alloc] init];
    [self.oriView addSubview:self.oriImgV];
    self.oriImgV.clipsToBounds = YES;
    [self.oriImgV setContentMode:UIViewContentModeScaleAspectFill];
//    self.oriImgV.backgroundColor = XLRandomColor;
    
    self.playImgV = [[UIImageView alloc] init];
    [self.oriImgV addSubview:self.playImgV];
    self.playImgV.image = [UIImage imageNamed:@"video_play_2"];
    
    self.oriTitleL = [[UILabel alloc] init];
    [self.oriView addSubview:self.oriTitleL];
    [self.oriTitleL xl_setTextColor:[UIColor whiteColor] fontSize:10.f];
    self.oriTitleL.backgroundColor = COLOR_A(0x000000, 0.4);
    self.oriTitleL.textAlignment = NSTextAlignmentCenter;
    XLViewRadius(self.oriTitleL, 4 * kWidthRatio6s);
    self.oriTitleL.text = @"原贴";
    
    self.actionView = [[XLMainUserActionView alloc] init];
    [self.contentView addSubview:self.actionView];
    self.actionView.userActionType = XLMainUserActionType_comment;
    self.actionView.delegate = self;
    
    self.botKongView = [[UIView alloc] init];
    self.botKongView.backgroundColor = XL_COLOR_BG;
    [self.contentView addSubview:self.botKongView];
    
    self.videoView = [[XLCommentVideoView alloc] init];
    [self.contentView addSubview:self.videoView];
    
    self.picturesView = [[XLCommentPicturesView alloc] init];
    [self.contentView addSubview:self.picturesView];
    
    self.videoView.hidden = YES;
    self.picturesView.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [self.commentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.infoView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.oriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentL);
        make.top.equalTo(self.commentL.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.height.mas_equalTo(64 * kWidthRatio6s);
    }];
    
    [self.oriDescL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.oriView);
        make.left.equalTo(self.oriView).mas_equalTo(12 * kWidthRatio6s);
    }];
    
    [self.oriImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.oriView);
        make.left.equalTo(self.oriDescL.mas_right);
        make.width.equalTo(self.oriImgV.mas_height);
    }];
    
    [self.playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.oriImgV);
        make.width.height.mas_equalTo(24 * kWidthRatio6s);
    }];
    
    [self.oriTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.oriView);
        make.height.mas_equalTo(16 * kWidthRatio6s);
        make.width.mas_equalTo(28 * kWidthRatio6s);
    }];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(48 * kWidthRatio6s);
        make.top.equalTo(self.oriView.mas_bottom);
    }];
    
    [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(12 * kWidthRatio6s);
        make.top.equalTo(self.actionView.mas_bottom);
    }];
}



- (void)setCommentModel:(XLCommentModel *)commentModel {
    _commentModel = commentModel;
    self.commentL.text = _commentModel.content;
    NSString *entityType = _commentModel.entity.category;
    
    NSString *entityContent = _commentModel.entity.content;
    NSString *oriDescPre = @"";
//    if (!XLStringIsEmpty(entityContent)) {
//        oriDescPre = [NSString stringWithFormat:@"%@：%@ // ",_commentModel.entity.user_info.nickname,_commentModel.entity.content];
//    }
    
    if (XLStringIsEmpty(entityContent)) {
        if (XLTypeVideo(entityType)) {
            self.oriDescL.text = [NSString stringWithFormat:@"%@%@：发布了视频",oriDescPre,_commentModel.entity.nickname];
        } else if (XLTypePicture(entityContent)) {
            self.oriDescL.text = [NSString stringWithFormat:@"%@%@：发布了图片",oriDescPre,_commentModel.user_info.nickname];
        } else {
            self.oriDescL.text = @"";
        }
    } else {
        self.oriDescL.text = [NSString stringWithFormat:@"%@%@：%@",oriDescPre,_commentModel.entity.nickname,entityContent];
    }
    //self.oriDescL.text = _commentModel.entity.content;
    [self.oriImgV sd_setImageWithURL:[NSURL URLWithString:_commentModel.entity.video_image.url] placeholderImage:nil];
    self.playImgV.hidden = !XLTypeVideo(_commentModel.category);
    

    _commentModel.user_info.cid = _commentModel.cid;
    _commentModel.user_info.entity_id = _commentModel.entity.entity_id;
    self.infoView.userInfo = _commentModel.user_info;
    
   
    self.actionView.commentModel = _commentModel;
    
    NSString *commentType = _commentModel.type;
    if (XLTypeVideo(commentType)) {
        self.videoView.hidden = NO;
        self.picturesView.hidden = YES;
        
        self.videoView.videoURL = [NSURL URLWithString:_commentModel.video_url];
        self.videoView.video_image = self.commentModel.video_image;
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentL);
            make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
            //                make.width.mas_offset(196 * kWidthRatio6s);
            //                make.height.mas_offset(112 * kWidthRatio6s);
        }];
        
        [self.oriView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.commentL);
            make.top.equalTo(self.videoView.mas_bottom).mas_offset(12 * kWidthRatio6s);
            make.height.mas_equalTo(64 * kWidthRatio6s);
        }];
    } else if (XLTypePicture(commentType)) {
        self.videoView.hidden = YES;
        self.picturesView.hidden = NO;
        
        CGFloat picturesViewW = SCREEN_WIDTH - 56 * kWidthRatio6s - 23 * kWidthRatio6s;
        self.picturesView.bgWidth = picturesViewW;
        self.picturesView.pictures = _commentModel.pic_images;
        NSInteger count = _commentModel.pic_images.count;
        
        CGFloat interSpacing = 4 * kWidthRatio6s;
        CGFloat width = (picturesViewW - 2 * interSpacing) / 3.0;
        CGFloat height = width;
        CGFloat picturesViewHeight = ((count - 1) / 3 + 1) * (height + interSpacing) - interSpacing;
        [self.picturesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentL);
            make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
            make.right.equalTo(self.contentView);
            make.height.mas_offset(picturesViewHeight);
        }];
        [self.oriView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.commentL);
            make.top.equalTo(self.picturesView.mas_bottom).mas_offset(12 * kWidthRatio6s);
            make.height.mas_equalTo(64 * kWidthRatio6s);
        }];
    } else {
        self.videoView.hidden = YES;
        self.picturesView.hidden = YES;
        [self.oriView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.commentL);
            make.top.equalTo(self.commentL.mas_bottom).mas_offset(12 * kWidthRatio6s);
            make.height.mas_equalTo(64 * kWidthRatio6s);
        }];
    }
}

- (void)goTieziDetailTap:(UITapGestureRecognizer *)tap {
    XLMainDetailController *mainDetailVC = [[XLMainDetailController alloc] init];
    mainDetailVC.entity_id = self.commentModel.entity.entity_id;
    [self.navigationController pushViewController:mainDetailVC animated:YES];
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

- (void)setIsMyPublish:(BOOL)isMyPublish {
    _isMyPublish = isMyPublish;
    if (_isMyPublish) {
        self.infoView.userInfoViewType = XLMainUserInfoViewType_delete;
    }
}

@end
