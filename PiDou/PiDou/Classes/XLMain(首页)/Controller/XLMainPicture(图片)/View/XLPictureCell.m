//
//  XLPictureCell.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPictureCell.h"
#import "XLMainUserInfoView.h"
#import "XLMainUserActionView.h"
#import "XLPictureCollectView.h"
#import "XLTagRewardView.h"
#import "XLGodCommentView.h"

@interface XLPictureCell () <XLMainUserActionViewDelegate>


@property (nonatomic, strong) XLMainUserInfoView *infoView;
@property (nonatomic, strong) XLMainUserActionView *actionView;
@property (nonatomic, strong) XLTagRewardView *tagRewardView;
@property (nonatomic, strong) XLGodCommentView *godCommentView;

@property (nonatomic, strong) UILabel *duanziLabel;

@property (nonatomic, strong) XLPictureCollectView *pictureView;;

@property (nonatomic, strong) NSMutableArray *pictureItemInfos;

@property (nonatomic, strong) UIView *botKongView;

@end

@implementation XLPictureCell


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
    
    
    
    
    self.pictureView = [[XLPictureCollectView alloc] init];
    [self.contentView addSubview:self.pictureView];
    
    self.tagRewardView = [[XLTagRewardView alloc] init];
    [self.contentView addSubview:self.tagRewardView];
    
    self.godCommentView = [[XLGodCommentView alloc] init];
    [self.contentView addSubview:self.godCommentView];
    
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
    
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
    }];
    
    [self.godCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.pictureView.mas_bottom).mas_offset(12 * kWidthRatio6s);
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
    self.pictures = _tieziModel.pic_images;
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
            make.top.equalTo(self.pictureView.mas_bottom).mas_offset(12 * kWidthRatio6s);
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
        self.godCommentView.commentType = XLCommentCellType_picture;
        self.godCommentView.commentModel = _tieziModel.god_comment;
        [self.godCommentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.pictureView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        }];
    } else {
        self.godCommentView.hidden = YES;
        [self.godCommentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.pictureView.mas_bottom).mas_offset(0);
            make.height.mas_offset(CGFLOAT_MIN);
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

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;

    
    [self.pictureItemInfos removeAllObjects];
    CGFloat cellH = 0;
    
    
    NSInteger count = _pictures.count;
    
    
    for (int row = 0; row < count; row++) {
        // 行数
        NSInteger list = (count - 1) / 3 + 1;
        
        NSInteger firstNum = 0;
        NSInteger secondNum = 0;
        NSInteger thirdNum = 0;
        switch (list) {
            case 1:
            {
                firstNum = count;
                
            }
                break;
            case 2:
            {
                firstNum = count - 3;
                secondNum = 3;
                if (count == 4) {
                    firstNum = 2;
                    secondNum = 2;
                }
            }
                break;
            case 3:
            {
                firstNum = count - 6;
                secondNum = 3;
                thirdNum = 3;
            }
                break;
                
            default:
                break;
        }
        CGFloat itemW = SCREEN_WIDTH;
        CGFloat itemH = SCREEN_WIDTH;
        CGFloat MinSpacing = 6 * kWidthRatio6s;
        // 判断row 在哪个num
        if (row < firstNum) {
            itemW = itemH = (SCREEN_WIDTH - (firstNum - 1) * MinSpacing) / firstNum;
            
        } else if (row < firstNum + secondNum) {
            itemW = itemH = (SCREEN_WIDTH - (secondNum - 1) * MinSpacing) / secondNum;
        } else {
            itemW = itemH = (SCREEN_WIDTH - (thirdNum - 1) * MinSpacing) / thirdNum;
        }
        if (firstNum == 1 && row == 0) {
            itemH = 185 * kWidthRatio6s;
        }
        
        if (row == 0) {
            cellH = itemH;
        } else if (row == 3) {
            cellH += (itemH + MinSpacing);
        } else if (row == 6) {
            cellH += (itemH + MinSpacing);
        }
        
        if (count == 1) {
            XLSizeModel *size = _pictures[0];
            itemW = [size.width floatValue] > 0 ? [size.width floatValue] : 233 * kWidthRatio6s;
            itemH = [size.height floatValue] > 0 ? [size.height floatValue] : 343 * kWidthRatio6s;
            
            if (itemW > SCREEN_WIDTH) {
                itemH = itemH * SCREEN_WIDTH / itemW;
                itemW = SCREEN_WIDTH;
            }
            if (itemH > SCREEN_WIDTH) {
                itemW = itemW * SCREEN_WIDTH / itemH;
                itemH = SCREEN_WIDTH;
            }
            cellH = itemH;
            
            if (itemW < SCREEN_WIDTH - 2 * XL_LEFT_DISTANCE) {
                // 一张图片进行特殊处理
                [self.pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).mas_offset(XL_LEFT_DISTANCE);
                    make.right.equalTo(self.contentView).mas_offset(-XL_LEFT_DISTANCE);
                    make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
                }];
            } else {
                [self.pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.contentView);
                    make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
                }];
            }
        } else {
            [self.pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.duanziLabel.mas_bottom).mas_offset(12 * kWidthRatio6s);
            }];
        }
        [self.pictureItemInfos addObject:@{@"url":[_pictures[row] valueForKey:@"url"],@"width":@(itemW),@"height":@(itemH)}];
    }
    
    [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(cellH);
    }];
    self.pictureView.pictures = _pictureItemInfos;
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


#pragma mark - lazy load
- (NSMutableArray *)pictureItemInfos {
    if (!_pictureItemInfos) {
        _pictureItemInfos = [NSMutableArray array];
    }
    return _pictureItemInfos;
}

@end
