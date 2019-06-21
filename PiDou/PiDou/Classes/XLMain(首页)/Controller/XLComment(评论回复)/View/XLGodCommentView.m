//
//  XLGodCommentView.m
//  PiDou
//
//  Created by kevin on 8/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGodCommentView.h"
#import "XLMainUserInfoView.h"
#import "XLCommentVideoView.h"
#import "XLCommentPicturesView.h"
#import "XLCommentModel.h"
#import "XLCommentDetailController.h"

@interface XLGodCommentView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) XLMainUserInfoView *userInfoView;

@property (nonatomic, strong) UILabel *commentL;

//@property (nonatomic, strong) UIButton *replyNumButton;

@property (nonatomic, strong) UIImageView *shenImgV;

@property (nonatomic, strong) XLCommentVideoView *videoView;
@property (nonatomic, strong) XLCommentPicturesView *picturesView;

@property (nonatomic, strong) NSMutableArray *pictureUrlArr;

@end

@implementation XLGodCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
    self.bgView = [[UIView alloc] init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.bgView, 2 * kWidthRatio6s);
    self.bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGodCommentAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.userInfoView = [[XLMainUserInfoView alloc] init];
    [self.bgView addSubview:self.userInfoView];
    self.userInfoView.userInfoViewType = XLMainUserInfoViewType_comment;
    self.userInfoView.tieziGodComment = YES;
    
    self.commentL = [[UILabel alloc] init];
    [self.bgView addSubview:self.commentL];
    [self.commentL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:13.f];
    self.commentL.numberOfLines = 0;
    
//    self.replyNumButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [self.bgView addSubview:self.replyNumButton];
//    [self.replyNumButton xl_setTitle:[NSString stringWithFormat:@"共%d条回复 >",17] color:XL_COLOR_BLACK size:12.f];
//    self.replyNumButton.backgroundColor = XL_COLOR_LINE;
//    XLViewRadius(self.replyNumButton,12 * kWidthRatio6s);
//    [self.replyNumButton sizeToFit];
//    self.replyNumButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8 * kWidthRatio6s, 0, 8 * kWidthRatio6s);
//    [self.replyNumButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    
    self.shenImgV = [[UIImageView alloc] init];
    [self.bgView addSubview:self.shenImgV];
    self.shenImgV.image = [UIImage imageNamed:@"main_shen_Big"];
    
    self.videoView = [[XLCommentVideoView alloc] init];
    [self.bgView addSubview:self.videoView];
    
    self.picturesView = [[XLCommentPicturesView alloc] init];
    [self.bgView addSubview:self.picturesView];
    
    self.videoView.hidden = YES;
    self.picturesView.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(12 * kWidthRatio6s, XL_LEFT_DISTANCE, 12 * kWidthRatio6s, XL_LEFT_DISTANCE));
    }];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
    }];
    
    [self.commentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).mas_offset(12 * kWidthRatio6s);
        make.right.equalTo(self.bgView).mas_offset(-12 * kWidthRatio6s);
        make.top.equalTo(self.userInfoView.mas_bottom).mas_offset(13 * kWidthRatio6s);
        make.bottom.equalTo(self.bgView).mas_offset(-12 * kWidthRatio6s);
    }];
    
//    [self.replyNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commentL);
//        make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
//        make.height.mas_offset(24 * kWidthRatio6s);
//        make.bottom.equalTo(self.bgView.mas_bottom);
//    }];
    
    [self.shenImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).mas_offset(0);
        make.right.equalTo(self.bgView).mas_offset(-48 * kWidthRatio6s);
        make.width.height.mas_offset(64 * kWidthRatio6s);
    }];
}


- (void)tapGodCommentAction:(UITapGestureRecognizer *)tap {
    // 进入评论详情
    XLCommentDetailController *commentDetailVC = [[XLCommentDetailController alloc] init];
    commentDetailVC.cid = self.commentModel.cid;
    commentDetailVC.entity_id = self.entity_id;
    [self.navigationController pushViewController:commentDetailVC animated:YES];
}

- (void)setCommentModel:(XLCommentModel *)commentModel {
    _commentModel = commentModel;
    if (XLTypeVideo(_commentModel.type)) {
//        self.commentType = XLCommentCellType_video;
//        self.videoView.videoURL = [NSURL URLWithString:_commentModel.video_url];
        self.commentL.text = [NSString stringWithFormat:@"%@\n[视频]",_commentModel.content];
        self.commentType = XLCommentCellType_text;
    } else if (XLTypePicture(_commentModel.type)) {
//        self.commentType = XLCommentCellType_picture;
//        self.picturesView.pictures = _commentModel.pic_images;
        self.commentL.text = [NSString stringWithFormat:@"%@\n[图片]",_commentModel.content];
        self.commentType = XLCommentCellType_text;
    } else {
        self.commentType = XLCommentCellType_text;
        self.commentL.text = _commentModel.content;
    }
    
    _commentModel.user_info.cid = _commentModel.cid;
    _commentModel.user_info.do_like_count = _commentModel.do_like_count;
    _commentModel.user_info.do_liked = _commentModel.do_liked;
    self.userInfoView.userInfo = _commentModel.user_info;
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
            [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.commentL);
                make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
                make.width.mas_offset(196 * kWidthRatio6s);
                make.height.mas_offset(112 * kWidthRatio6s);
                make.bottom.equalTo(self.bgView.mas_bottom);
            }];
//            [self.replyNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.commentL);
//                make.top.equalTo(self.videoView.mas_bottom).mas_offset(8 * kWidthRatio6s);
//                make.height.mas_offset(24 * kWidthRatio6s);
//                make.bottom.equalTo(self.bgView.mas_bottom);
//            }];
        }
            break;
        case XLCommentCellType_picture:
        {
            self.videoView.hidden = YES;
            self.picturesView.hidden = NO;
            self.pictureUrlArr = _commentModel.pic_images.mutableCopy;
            CGFloat picturesViewW = (SCREEN_WIDTH - 56 * kWidthRatio6s - 23 * kWidthRatio6s);
            self.picturesView.bgWidth = picturesViewW;
            self.picturesView.pictures = self.pictureUrlArr;
            NSInteger count = self.pictureUrlArr.count;
            
            CGFloat interSpacing = 4 * kWidthRatio6s;
            CGFloat width = (SCREEN_WIDTH - 56 * kWidthRatio6s - 23 * kWidthRatio6s - 2 * interSpacing) / 3.0;
            CGFloat height = width;
            CGFloat picturesViewHeight = ((count - 1) / 3 + 1) * (height + interSpacing) - interSpacing;
            [self.picturesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.commentL);
                make.top.equalTo(self.commentL.mas_bottom).mas_offset(8 * kWidthRatio6s);
                make.right.equalTo(self.bgView);
                make.height.mas_offset(picturesViewHeight);
                make.bottom.equalTo(self.bgView.mas_bottom);
            }];
//            [self.replyNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.commentL);
//                make.top.equalTo(self.picturesView.mas_bottom).mas_offset(8 * kWidthRatio6s);
//                make.height.mas_offset(24 * kWidthRatio6s);
//                make.bottom.equalTo(self.bgView.mas_bottom);
//            }];
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
//                make.bottom.equalTo(self.bgView.mas_bottom);
//            }];
        }
            break;
            
            
        default:
            break;
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
