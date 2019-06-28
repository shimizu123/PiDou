//
//  XLMainUserActionView.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMainUserActionView.h"
#import "XLTieziModel.h"
#import "XLTieziHandle.h"
#import "XLCommentHandle.h"
#import "XLXingRewardView.h"
#import "XLLaunchManager.h"
#import "XLMainDetailController.h"
#import "XLShareView.h"

@interface XLMainUserActionView ()

@property (nonatomic, strong) UIButton *zanButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *rewardButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) XLXingRewardView *rewardView;

@end

@implementation XLMainUserActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.zanButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.zanButton];
    
    self.commentButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.commentButton];
    
    self.collectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.collectButton];
    
    self.rewardButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.rewardButton];
    
    self.shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.shareButton];
    
    [self button:self.zanButton title:@"赞" num:0 imageName:@"main_zan"];
    [self button:self.commentButton title:@"评论" num:1 imageName:@"main_comment"];
    [self button:self.collectButton title:@"收藏" num:2 imageName:@"main_collect"];
    [self button:self.rewardButton title:@"" num:3 imageName:@"main_reward"];
    [self button:self.shareButton title:@"分享" num:4 imageName:@"main_share"];
    
    [self initLayout];
}

- (void)initLayout {
    [self.zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zanButton.mas_right);
        make.top.bottom.width.equalTo(self.zanButton);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right);
        make.top.bottom.width.equalTo(self.zanButton);
    }];
    
    [self.rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectButton.mas_right);
        make.top.bottom.width.equalTo(self.zanButton);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rewardButton.mas_right);
        make.top.bottom.width.equalTo(self.zanButton);
        make.right.equalTo(self);
    }];
}

- (void)button:(UIButton *)button title:(NSString *)title num:(NSInteger)num imageName:(NSString *)imageName {
    [button xl_setTitle:title color:XL_COLOR_BLACK size:13.f];
    [button setTitleColor:XL_COLOR_RED forState:(UIControlStateSelected)];
    [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",imageName]] forState:(UIControlStateSelected)];
    CGSize imageSize = button.imageView.bounds.size;
    if (!XLStringIsEmpty(title)) {
        CGFloat interval = 4 * kWidthRatio6s;
        button.titleEdgeInsets = UIEdgeInsetsMake(0,imageSize.width + interval, 0, 0);
    }
    [button addTarget:self action:@selector(userAction:) forControlEvents:(UIControlEventTouchUpInside)];
    button.tag = 100 + num;
}

- (void)userAction:(UIButton *)button {
    NSInteger tag = button.tag - 100;
    
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    
    switch (tag) {
        case 0:
        {
            // 点赞
            XLLog(@"点赞");
            kDefineWeakSelf;
            
            [HUDController xl_showHUD];
            if (self.tieziModel) {
                
                [XLTieziHandle tieziDolikeWithEntityID:self.tieziModel.entity_id success:^(id  _Nonnull responseObject) {
                   // [HUDController hideHUDWithText:responseObject];
                    [HUDController hideHUD];
                    WeakSelf.zanButton.selected = YES;
                    NSString *do_like_count = [NSString stringWithFormat:@"%ld",[WeakSelf.tieziModel.do_like_count integerValue] + 1];
                    [WeakSelf.zanButton setTitle:do_like_count forState:(UIControlStateNormal)];
                    if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(actonView:didSelectedWithIndex:select:count:)]) {
                        [WeakSelf.delegate actonView:WeakSelf didSelectedWithIndex:tag select:YES count:do_like_count];
                    }
                } failure:^(id  _Nonnull result) {
                    [HUDController xl_hideHUDWithResult:result];
                }];
            } else if (self.commentModel) {
                [XLCommentHandle doLikeCommentWithCid:self.commentModel.cid success:^(id  _Nonnull responseObject) {
                    [HUDController hideHUDWithText:responseObject];
                    WeakSelf.zanButton.selected = YES;
                    NSString *do_like_count = [NSString stringWithFormat:@"%ld",[WeakSelf.commentModel.do_like_count integerValue] + 1];
                    [WeakSelf.zanButton setTitle:do_like_count forState:(UIControlStateNormal)];
                    if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(actonView:didSelectedWithIndex:select:count:)]) {
                        [WeakSelf.delegate actonView:WeakSelf didSelectedWithIndex:tag select:YES count:do_like_count];
                    }
                } failure:^(id  _Nonnull result) {
                    [HUDController xl_hideHUDWithResult:result];
                }];
            }
        }
            break;
        case 1:
        {
            // 评论
            XLLog(@"评论");
            if (!XLStringIsEmpty(self.tieziModel.entity_id)) {
                XLMainDetailController *mainDetailVC = [[XLMainDetailController alloc] init];
                mainDetailVC.entity_id = self.tieziModel.entity_id;
                [self.navigationController pushViewController:mainDetailVC animated:YES];
            }
        }
            break;
        case 2:
        {
            // 收藏
            XLLog(@"收藏");
            kDefineWeakSelf;
            [HUDController xl_showHUD];
            [XLTieziHandle tieziCollectWithEntityID:self.tieziModel.entity_id success:^(id  _Nonnull responseObject) {
                //[HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                NSInteger count = [WeakSelf.tieziModel.collect_count integerValue];
                if (!WeakSelf.collectButton.selected) {
                    count += 1;
                    [WeakSelf.collectButton setTitle:[NSString stringWithFormat:@"%ld",count] forState:(UIControlStateNormal)];
                } else {
                    count -= 1;
                    [WeakSelf.collectButton setTitle:[NSString stringWithFormat:@"%@",count <= 0 ? @"收藏" : @(count)] forState:(UIControlStateNormal)];
                }
                WeakSelf.collectButton.selected = !WeakSelf.collectButton.selected;
                if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(actonView:didSelectedWithIndex:select:count:)]) {
                    [WeakSelf.delegate actonView:WeakSelf didSelectedWithIndex:tag select:WeakSelf.collectButton.selected count:[NSString stringWithFormat:@"%ld",count]];
                }
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
            break;
        case 3:
        {
            // 大赏
            XLLog(@"大赏");
            if (_rewardView) {
                [self.rewardView dismiss];
                self.rewardView = nil;
            }
            [self.rewardView show];
        }
            break;
        case 4:
        {
            // 转发
            XLLog(@"转发");
            [self shareAction];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)shareAction {
    
    XLShareModel *message = [[XLShareModel alloc] init];
    if (self.tieziModel) {
        message.title = self.tieziModel.content;
        message.entity_id = self.tieziModel.entity_id;
    } else if (self.commentModel) {
        message.title = self.commentModel.content;
        message.cid = self.commentModel.cid;
    }
    
    XLShareView *shareView = [XLShareView shareView];
    shareView.showQRCode = false;
    shareView.message = message;
    shareView.noDeletebtn = YES;
    [shareView show];
}

- (void)setUserActionType:(XLMainUserActionType)userActionType {
    _userActionType = userActionType;
    if (_userActionType == XLMainUserActionType_comment) {
        [self.zanButton setTitle:@"赞" forState:(UIControlStateNormal)];
        [self.commentButton setTitle:@"评论" forState:(UIControlStateNormal)];
        [self.shareButton setTitle:@"分享" forState:(UIControlStateNormal)];
        // 3个
        [self.collectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentButton.mas_right);
            make.top.bottom.equalTo(self.zanButton);
            make.width.mas_equalTo(CGFLOAT_MIN);
        }];
        
        [self.rewardButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.collectButton.mas_right);
            make.top.bottom.equalTo(self.zanButton);
            make.width.mas_equalTo(CGFLOAT_MIN);
        }];
    } else {
        // 5个
        [self.collectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentButton.mas_right);
            make.top.bottom.width.equalTo(self.zanButton);
        }];
        
        [self.rewardButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.collectButton.mas_right);
            make.top.bottom.width.equalTo(self.zanButton);
        }];
    }
}

- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
    [self.zanButton setTitle:[_tieziModel.do_like_count integerValue] <= 0 ? @"赞" : _tieziModel.do_like_count forState:(UIControlStateNormal)];
    [self.commentButton setTitle:[_tieziModel.comment_count integerValue] <= 0 ? @"评论" : _tieziModel.comment_count forState:(UIControlStateNormal)];
    [self.collectButton setTitle:[_tieziModel.collect_count integerValue] <= 0 ? @"收藏" : _tieziModel.collect_count forState:(UIControlStateNormal)];
    [self.shareButton setTitle:[_tieziModel.share_count  integerValue] <= 0 ? @"分享" : _tieziModel.share_count forState:(UIControlStateNormal)];
    self.zanButton.selected = [_tieziModel.do_liked boolValue];
    self.collectButton.selected = [_tieziModel.collected boolValue];
}

- (void)setCommentModel:(XLCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.zanButton setTitle:[_commentModel.do_like_count integerValue] <= 0 ? @"赞" : _commentModel.do_like_count forState:(UIControlStateNormal)];
    [self.commentButton setTitle:[_commentModel.reply_count integerValue] <= 0 ? @"评论" : _commentModel.reply_count forState:(UIControlStateNormal)];
    [self.shareButton setTitle:[_commentModel.share_count integerValue] <= 0 ? @"分享" : _commentModel.share_count forState:(UIControlStateNormal)];
    self.zanButton.selected = [_commentModel.do_liked boolValue];
    
}


#pragma mark - lazy load
- (XLXingRewardView *)rewardView {
    if (!_rewardView) {
        _rewardView = [XLXingRewardView xingRewardView];
        _rewardView.entity_id = self.tieziModel.entity_id;
        _rewardView.targetVC = self.parentController;
    }
    return _rewardView;
}


@end
