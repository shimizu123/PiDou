//
//  XLDuanziCell.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLDuanziCell.h"
#import "XLMainUserInfoView.h"
#import "XLMainUserActionView.h"
#import "XLTagRewardView.h"
#import "XLGodCommentView.h"

@interface XLDuanziCell () <XLMainUserActionViewDelegate>

@property (nonatomic, strong) XLMainUserInfoView *infoView;
@property (nonatomic, strong) XLMainUserActionView *actionView;
@property (nonatomic, strong) XLTagRewardView *tagRewardView;

@property (nonatomic, strong) XLGodCommentView *godCommentView;

@property (nonatomic, strong) UILabel *duanziLabel;
@property (nonatomic, strong) UIView *botKongView;

@end

@implementation XLDuanziCell

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
   // self.duanziLabel.numberOfLines = 0;
    self.duanziLabel.numberOfLines = 7;
    [self.duanziLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    self.godCommentView = [[XLGodCommentView alloc] init];
    [self.contentView addSubview:self.godCommentView];

    self.tagRewardView = [[XLTagRewardView alloc] init];
    [self.contentView addSubview:self.tagRewardView];
    
    self.botKongView = [[UIView alloc] init];
    self.botKongView.backgroundColor = XL_COLOR_BG;
    [self.contentView addSubview:self.botKongView];
    
    [self initLayout];
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
    
    [self.godCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
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

- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
    self.duanziLabel.text = _tieziModel.content;
    self.actionView.tieziModel = _tieziModel;
    self.tagRewardView.topics = _tieziModel.topics;
    self.tagRewardView.entity_id = _tieziModel.entity_id;
    
    _tieziModel.user_info.do_like_count = _tieziModel.do_like_count;
    _tieziModel.user_info.do_liked = _tieziModel.do_liked;
    _tieziModel.user_info.pdcoin_count = _tieziModel.pdcoin_count;
    _tieziModel.user_info.entity_id = _tieziModel.entity_id;
    self.infoView.userInfo = _tieziModel.user_info;
    
    if (XLArrayIsEmpty(_tieziModel.topics) && !self.isDetailVC) {
        [self.tagRewardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.godCommentView.mas_bottom).mas_offset(1 * kWidthRatio6s);
            make.height.mas_offset(0);
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
            make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(8 * kWidthRatio6s);
        }];
        self.infoView.creatTime = _tieziModel.created;
    } else {
        self.actionView.hidden = NO;
        self.tagRewardView.hidden = NO;
        [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.actionView.mas_bottom);
        }];
    }
    
    
    if (!XLStringIsEmpty(_tieziModel.god_comment.cid)) {
        self.godCommentView.entity_id = _tieziModel.entity_id;
        self.godCommentView.hidden = NO;
        self.godCommentView.commentType = XLCommentCellType_text;
        self.godCommentView.commentModel = _tieziModel.god_comment;
        [self.godCommentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
        }];
    } else {
        self.godCommentView.hidden = YES;
        [self.godCommentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(0);
            make.height.mas_offset(0);
        }];
    }
    
    
}
- (void)setIsMyPublish:(BOOL)isMyPublish {
    _isMyPublish = isMyPublish;
    if (_isMyPublish) {
        self.infoView.userInfoViewType = XLMainUserInfoViewType_delete;
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

- (void)setIsDetail:(BOOL)isDetail {
    _isDetail = isDetail;
    if (_isDetail) {
        self.duanziLabel.numberOfLines = 0;
    } else {
        self.duanziLabel.numberOfLines = 7;
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
