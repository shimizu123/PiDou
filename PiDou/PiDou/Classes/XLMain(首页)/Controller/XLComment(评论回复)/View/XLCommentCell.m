//
//  XLCommentCell.m
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentCell.h"
#import "XLMainUserInfoView.h"
#import "XLCommentVideoView.h"
#import "XLCommentPicturesView.h"
#import "XLCommentModel.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "XLUserDetailController.h"

@interface XLCommentCell () <XLMainUserInfoViewDelegate>

@property (nonatomic, strong) XLMainUserInfoView *userInfoView;

@property (nonatomic, strong) UILabel *commentL;

@property (nonatomic, strong) UIView *replyCommentBgView;
@property (nonatomic, strong) UILabel *replyCommentContentL;
@property (nonatomic, strong) UIButton *replyCommentContentButton;
@property (nonatomic, strong) XLCommentVideoView *videoReplyView;
@property (nonatomic, strong) XLCommentPicturesView *picturesReplyView;


@property (nonatomic, strong) UIButton *replyNumButton;

@property (nonatomic, strong) UIImageView *shenImgV;

@property (nonatomic, strong) XLCommentVideoView *videoView;
@property (nonatomic, strong) XLCommentPicturesView *picturesView;

@property (nonatomic, strong) NSMutableArray *pictureUrlArr;

@end

@implementation XLCommentCell

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
    self.userInfoView = [[XLMainUserInfoView alloc] init];
    [self.contentView addSubview:self.userInfoView];
    self.userInfoView.userInfoViewType = XLMainUserInfoViewType_comment;
    self.userInfoView.delegate = self;
    
    self.commentL = [[UILabel alloc] init];
    [self.contentView addSubview:self.commentL];
    [self.commentL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.commentL.numberOfLines = 0;
    
    self.replyNumButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.replyNumButton];
    [self.replyNumButton xl_setTitle:[NSString stringWithFormat:@"共%d条回复 >",17] color:XL_COLOR_BLACK size:12.f];
    self.replyNumButton.backgroundColor = XL_COLOR_LINE;
    XLViewRadius(self.replyNumButton,12 * kWidthRatio6s);
    [self.replyNumButton sizeToFit];
    self.replyNumButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8 * kWidthRatio6s, 0, 8 * kWidthRatio6s);
    [self.replyNumButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [self.replyNumButton addTarget:self action:@selector(replyNumAction:) forControlEvents:(UIControlEventTouchUpInside)];
    //self.replyNumButton.enabled = NO;
    
    self.replyCommentBgView = [[UIView alloc] init];
    [self.contentView addSubview:self.replyCommentBgView];
    self.replyCommentBgView.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.replyCommentBgView, 4 * kWidthRatio6s);
    
    self.replyCommentContentL = [[UILabel alloc] init];
    [self.replyCommentBgView addSubview:self.replyCommentContentL];
    self.replyCommentContentL.numberOfLines = 0;
    [self.replyCommentContentL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    
    self.replyCommentContentButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.replyCommentBgView addSubview:self.replyCommentContentButton];
    [self.replyCommentContentButton addTarget:self action:@selector(replyCommentAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.shenImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.shenImgV];
    self.shenImgV.image = [UIImage imageNamed:@"main_shen_Big"];
    
    self.videoView = [[XLCommentVideoView alloc] init];
    [self.contentView addSubview:self.videoView];
    
    self.picturesView = [[XLCommentPicturesView alloc] init];
    [self.contentView addSubview:self.picturesView];
    
    self.videoReplyView = [[XLCommentVideoView alloc] init];
    [self.replyCommentBgView addSubview:self.videoReplyView];
    
    self.picturesReplyView = [[XLCommentPicturesView alloc] init];
    [self.replyCommentBgView addSubview:self.picturesReplyView];
    
    self.videoView.hidden = YES;
    self.picturesView.hidden = YES;
    self.videoReplyView.hidden = YES;
    self.picturesReplyView.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [self.commentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(56 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.userInfoView.mas_bottom).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.replyCommentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentL);
        make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.replyCommentContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyCommentBgView).mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.replyCommentBgView.mas_top).mas_offset(8 * kWidthRatio6s);
        make.right.equalTo(self.replyCommentBgView.mas_right).mas_offset(-8 * kWidthRatio6s);
        make.bottom.equalTo(self.replyCommentBgView.mas_bottom).mas_offset(-8 * kWidthRatio6s);
    }];
    
    [self.replyCommentContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.replyCommentBgView);
        make.bottom.equalTo(self.replyCommentContentL.mas_bottom);
    }];
    
    [self.replyNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyCommentBgView);
        make.top.equalTo(self.replyCommentBgView.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.shenImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-48 * kWidthRatio6s);
        make.width.height.mas_offset(64 * kWidthRatio6s);
    }];
}


- (void)setCommentModel:(XLCommentModel *)commentModel {
    _commentModel = commentModel;
    if (!XLStringIsEmpty(_commentModel.parent.cid)) {
        //self.replyCommentContentL.text = [NSString stringWithFormat:@"%@：%@",_commentModel.parent.nickname,_commentModel.parent.content];
        self.replyCommentContentL.attributedText = [NSMutableAttributedString attributedStringReplyColorWithName:_commentModel.parent.nickname text:_commentModel.parent.content];
        NSString *replyType = _commentModel.parent.type;
        if (XLTypeVideo(replyType)) {
            self.videoReplyView.hidden = NO;
            self.picturesReplyView.hidden = YES;
            self.videoReplyView.videoURL = [NSURL URLWithString:_commentModel.parent.video_url];
            self.videoReplyView.video_image = self.commentModel.parent.video_image;

            CGFloat imageW = [self.commentModel.parent.video_image.width floatValue];
            CGFloat imageH = [self.commentModel.parent.video_image.height floatValue];
            CGFloat max = 210 * kWidthRatio6s;
            if (imageW > max) {
                imageH = max * imageH / imageW;
                imageW = max;
            }
            if (imageH > max) {
                imageW = max * imageW / imageH;
                imageH = max;
            }
            CGFloat currentH = self.videoReplyView.xl_h;
            if (currentH > 0 && currentH != imageH) {
                imageH = currentH;
                imageW = currentH * imageW / imageH;
            }
            
            [self.videoReplyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyCommentContentL);
                make.top.equalTo(self.replyCommentContentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
                make.bottom.equalTo(self.replyCommentBgView.mas_bottom).mas_offset(-8 * kWidthRatio6s);

            }];
            [self.replyCommentContentL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyCommentBgView).mas_offset(8 * kWidthRatio6s);
                make.top.equalTo(self.replyCommentBgView.mas_top).mas_offset(8 * kWidthRatio6s);
                make.right.equalTo(self.replyCommentBgView.mas_right).mas_offset(-8 * kWidthRatio6s);
            }];
            
            
        } else if (XLTypePicture(replyType)) {
            self.videoReplyView.hidden = YES;
            self.picturesReplyView.hidden = NO;
            
            CGFloat picturesViewW = (SCREEN_WIDTH - 56 * kWidthRatio6s - 16 * kWidthRatio6s - 16 * kWidthRatio6s);
            self.picturesReplyView.bgWidth = picturesViewW;
            self.picturesReplyView.pictures = _commentModel.parent.pic_images.mutableCopy;
            NSInteger count = self.picturesReplyView.pictures.count;
            
            CGFloat interSpacing = 4 * kWidthRatio6s;
            CGFloat width = (picturesViewW - 2 * interSpacing) / 3.0;
            CGFloat height = width;
            CGFloat picturesViewHeight = ((count - 1) / 3 + 1) * (height + interSpacing) - interSpacing;
            [self.picturesReplyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyCommentContentL);
                make.top.equalTo(self.replyCommentContentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
                make.bottom.equalTo(self.replyCommentBgView.mas_bottom).mas_offset(-8 * kWidthRatio6s);
                make.right.equalTo(self.replyCommentContentL);
                make.height.mas_offset(picturesViewHeight);
            }];

            [self.replyCommentContentL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyCommentBgView).mas_offset(8 * kWidthRatio6s);
                make.top.equalTo(self.replyCommentBgView.mas_top).mas_offset(8 * kWidthRatio6s);
                make.right.equalTo(self.replyCommentBgView.mas_right).mas_offset(-8 * kWidthRatio6s);
            }];
        } else {
            self.videoReplyView.hidden = YES;
            self.picturesReplyView.hidden = YES;
            [self.replyCommentContentL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyCommentBgView).mas_offset(8 * kWidthRatio6s);
                make.top.equalTo(self.replyCommentBgView.mas_top).mas_offset(8 * kWidthRatio6s);
                make.right.equalTo(self.replyCommentBgView.mas_right).mas_offset(-8 * kWidthRatio6s);
                make.bottom.equalTo(self.replyCommentBgView.mas_bottom).mas_offset(-8 * kWidthRatio6s);
            }];
        }
    }
    if (XLTypeVideo(_commentModel.type)) {
        self.commentType = XLCommentCellType_video;
        self.videoView.videoURL = [NSURL URLWithString:_commentModel.video_url];
    } else if (XLTypePicture(_commentModel.type)) {
        self.commentType = XLCommentCellType_picture;
        self.picturesView.pictures = _commentModel.pic_images;
    } else {
        self.commentType = XLCommentCellType_text;
    }
    _commentModel.user_info.cid = _commentModel.cid;
    _commentModel.user_info.do_liked = _commentModel.do_liked;
    _commentModel.user_info.do_like_count = _commentModel.do_like_count;
    
    self.userInfoView.userInfo = _commentModel.user_info;
    self.userInfoView.creatTime = _commentModel.created;
    self.commentL.text = _commentModel.content;
    [self.replyNumButton setTitle:[_commentModel.reply_count integerValue] ? [NSString stringWithFormat:@"共%@条回复 >",_commentModel.reply_count] : @"回复" forState:(UIControlStateNormal)];
    self.shenImgV.hidden = ![_commentModel.god boolValue];
    
}

- (void)setCommentType:(XLCommentCellType)commentType {
    _commentType = commentType;
    switch (_commentType) {
        case XLCommentCellType_video:
        {
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
//            [self.replyNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.commentL);
//                make.top.equalTo(self.videoView.mas_bottom).mas_offset(8 * kWidthRatio6s);
//                make.height.mas_offset(24 * kWidthRatio6s);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//            }];
            if (XLStringIsEmpty(self.commentModel.parent.cid)) {
                [self.replyCommentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.commentL);
                    make.top.equalTo(self.videoView.mas_bottom).mas_offset(0);
                    make.height.mas_offset(CGFLOAT_MIN);
                }];
                self.replyCommentBgView.hidden = YES;
                
            } else {
                self.replyCommentBgView.hidden = NO;
                [self.replyCommentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.commentL);
                    make.top.equalTo(self.videoView.mas_bottom).mas_offset(8 * kWidthRatio6s);
                }];
            }
            
        }
            break;
        case XLCommentCellType_picture:
        {
            self.videoView.hidden = YES;
            self.picturesView.hidden = NO;
            self.pictureUrlArr = _commentModel.pic_images.mutableCopy;
            CGFloat picturesViewW = (SCREEN_WIDTH - 56 * kWidthRatio6s - 16 * kWidthRatio6s);
            self.picturesView.bgWidth = picturesViewW;
            self.picturesView.pictures = self.pictureUrlArr;
            NSInteger count = self.pictureUrlArr.count;
            
            CGFloat interSpacing = 4 * kWidthRatio6s;
            CGFloat width = (picturesViewW - 2 * interSpacing) / 3.0;
            CGFloat height = width;
            CGFloat picturesViewHeight = ((count - 1) / 3 + 1) * (height + interSpacing) - interSpacing;
            [self.picturesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.commentL);
                make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
                make.right.equalTo(self.commentL);
                make.height.mas_offset(picturesViewHeight);
            }];
//            [self.replyNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.commentL);
//                make.top.equalTo(self.picturesView.mas_bottom).mas_offset(8 * kWidthRatio6s);
//                make.height.mas_offset(24 * kWidthRatio6s);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//            }];
            if (XLStringIsEmpty(self.commentModel.parent.cid)) {
                [self.replyCommentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.commentL);
                    make.top.equalTo(self.picturesView.mas_bottom).mas_offset(0);
                    make.height.mas_offset(CGFLOAT_MIN);
                }];
                self.replyCommentBgView.hidden = YES;
            } else {
                self.replyCommentBgView.hidden = NO;
                [self.replyCommentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.commentL);
                    make.top.equalTo(self.picturesView.mas_bottom).mas_offset(8 * kWidthRatio6s);
                }];
            }
        }
            break;
        case XLCommentCellType_text:
        {
            self.videoView.hidden = YES;
            self.picturesView.hidden = YES;
//            [self.replyNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.commentL);
//                make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
//                make.height.mas_offset(24 * kWidthRatio6s);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//            }];
            if (XLStringIsEmpty(self.commentModel.parent.cid)) {
                [self.replyCommentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.commentL);
                    make.top.equalTo(self.commentL.mas_bottom).mas_offset(0);
                    make.height.mas_offset(CGFLOAT_MIN);
                }];
                self.replyCommentBgView.hidden = YES;
            } else {
                self.replyCommentBgView.hidden = NO;
                [self.replyCommentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.commentL);
                    make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
                }];
            }
        }
            break;
            
            
        default:
            break;
    }
}

- (void)replyNumAction:(UIButton *)button {
    if (self.didSelectRepllyBlock) {
        self.didSelectRepllyBlock(self.commentModel);
    }
}

- (void)replyCommentAction:(UIButton *)button {
    if (!XLStringIsEmpty(self.commentModel.parent.user_id)) {
        XLUserDetailController *userDetailVC = [[XLUserDetailController alloc] init];
        userDetailVC.user_id = self.commentModel.parent.user_id;
        [self.navigationController pushViewController:userDetailVC animated:YES];
    }
}

#pragma mark - XLMainUserInfoViewDelegate
/**
 @param index 0:点赞 1:评论 2：收藏 3:打赏 4:转发
 */
- (void)userInfoView:(XLMainUserInfoView *)userInfoView didSelectedWithIndex:(NSInteger)index select:(BOOL)select count:(NSString *)count {
    if (self.didSelectedAction) {
        self.didSelectedAction(@{@"index":@(index),@"select":@(select),@"count":count});
    }
}

#pragma mark - lazy load
- (NSMutableArray *)pictureUrlArr {
    if (!_pictureUrlArr) {
        _pictureUrlArr = [NSMutableArray array];
    }
    return _pictureUrlArr;
}

@end
