//
//  XLUserDetailTable.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserDetailTable.h"
#import "XLUserDetailTopCell.h"
#import "XLUserDetailHeader.h"
#import "XLUserCommentCell.h"
#import "XLVideoCell.h"
#import "XLPictureCell.h"
#import "XLDuanziCell.h"
#import "XLPlayerManager.h"
#import "XLCommentDetailController.h"
#import "XLMainDetailController.h"

static NSString * XLUserDetailTopCellID = @"kXLUserDetailTopCell";
static NSString * XLUserDetailHeaderID  = @"kXLUserDetailHeader";
static NSString * XLUserCommentCellID   = @"kXLUserCommentCell";

static NSString * XLVideoCellID         = @"kXLVideoCell";
static NSString * XLPictureCellID       = @"kXLPictureCell";
static NSString * XLDuanziCellID        = @"kXLDuanziCell";

@interface XLUserDetailTable () <UITableViewDelegate, UITableViewDataSource, XLUserDetailHeaderDelegate, UIScrollViewDelegate>

@end

@implementation XLUserDetailTable

- (void)setData:(NSMutableArray *)data {
    _data = data;
    _tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)setUser:(XLAppUserModel *)user {
    _user = user;
    _tableView.hidden = NO;
    [self.tableView reloadData];
}

- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.hidden = YES;
        [self setup];
    }
    return _tableView;
}

- (void)setup {
    [self registerCell];
}


- (void)setUserDetailType:(XLUserDetailType)userDetailType {
    _userDetailType = userDetailType;
    [self.tableView reloadData];
}

- (void)registerCell {
    [_tableView registerClass:[XLUserDetailTopCell class] forCellReuseIdentifier:XLUserDetailTopCellID];
    [_tableView registerClass:[XLUserDetailHeader class] forHeaderFooterViewReuseIdentifier:XLUserDetailHeaderID];
    [_tableView registerClass:[XLUserCommentCell class] forCellReuseIdentifier:XLUserCommentCellID];
    
    [_tableView registerClass:[XLVideoCell class] forCellReuseIdentifier:XLVideoCellID];
    [_tableView registerClass:[XLPictureCell class] forCellReuseIdentifier:XLPictureCellID];
    [_tableView registerClass:[XLDuanziCell class] forCellReuseIdentifier:XLDuanziCellID];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidTable:contentOffsetY:)]) {
        [_delegate scrollViewDidTable:self contentOffsetY:offY];
    }
}

#pragma mark - XLUserDetailHeaderDelegate
- (void)userDetailHeader:(XLUserDetailHeader *)userDetailHeader didSegmentWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            self.userDetailType = XLUserDetailType_dongtai;
        }
            break;
        case 1:
        {
            self.userDetailType = XLUserDetailType_tiezi;
        }
            break;

        case 2:
        {
            self.userDetailType = XLUserDetailType_comment;
        }
            break;

            
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(userDetailTable:didSegmentWithIndex:)]) {
        [_delegate userDetailTable:self didSegmentWithIndex:index];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.tableType == XLUserDetailTableType_mineDetail ? 1 : 0;
    }
    return self.data.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 1) {
        NSString *category = @"text";
        if (!XLArrayIsEmpty(self.data)) {
            id model = self.data[row];
            category = [model valueForKey:@"category"];
            
        }
//        NSString *category = @"comment";
//        if (self.userDetailType == XLUserDetailType_dongtai) {
//            // 动态,要去区分帖子还是评论
//        }
//        if (self.userDetailType == XLUserDetailType_tiezi) {
//        }
        if (XLTypeVideo(category)) {
            XLVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:XLVideoCellID forIndexPath:indexPath];
            kDefineWeakSelf;
            if (!XLArrayIsEmpty(self.data)) {
                XLTieziModel *tieziModel = self.data[row];
                videoCell.tieziModel = tieziModel;
                videoCell.complete = ^(id  _Nonnull result) {
                    [XLPlayerManager playVideoWithIndexPath:indexPath tag:1314 scrollView:WeakSelf.tableView videoUrl:tieziModel.video_url entity_id:tieziModel.entity_id];
                };
                videoCell.didSelectedAction = ^(id  _Nonnull result) {
//                    if (WeakSelf.reloadDataBlock) {
//                        WeakSelf.reloadDataBlock();
//                    }
                    [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
                };
            }
            videoCell.isMyPublish = self.isMyPublish;
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return videoCell;
        } else if (XLTypePicture(category)) {
            XLPictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:XLPictureCellID forIndexPath:indexPath];
            if (!XLArrayIsEmpty(self.data)) {
                XLTieziModel *tieziModel = self.data[row];
                pictureCell.tieziModel = tieziModel;
            }
            kDefineWeakSelf;
            pictureCell.didSelectedAction = ^(id  _Nonnull result) {
//                if (WeakSelf.reloadDataBlock) {
//                    WeakSelf.reloadDataBlock();
//                }
                [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
            };
            pictureCell.isMyPublish = self.isMyPublish;
            pictureCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return pictureCell;
        } else if (XLTypeText(category)) {
            // else if (self.searchType == XLSearchType_duanzi)
            XLDuanziCell *duanziCell = [tableView dequeueReusableCellWithIdentifier:XLDuanziCellID forIndexPath:indexPath];
            if (!XLArrayIsEmpty(self.data)) {
                XLTieziModel *tieziModel = self.data[row];
                duanziCell.tieziModel = tieziModel;
            }
            kDefineWeakSelf;
            duanziCell.didSelectedAction = ^(id  _Nonnull result) {
//                if (WeakSelf.reloadDataBlock) {
//                    WeakSelf.reloadDataBlock();
//                }
                [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
            };
            duanziCell.isMyPublish = self.isMyPublish;
            duanziCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return duanziCell;
        } else {
            XLUserCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:XLUserCommentCellID forIndexPath:indexPath];
            if (!XLArrayIsEmpty(self.data)) {
                commentCell.commentModel = self.data[row];
            }
            kDefineWeakSelf;
            commentCell.didSelectedAction = ^(id  _Nonnull result) {
//                if (WeakSelf.reloadDataBlock) {
//                    WeakSelf.reloadDataBlock();
//                }
                [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
            };
            commentCell.isMyPublish = self.isMyPublish;
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return commentCell;
        }
    } else {
        XLUserDetailTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:XLUserDetailTopCellID forIndexPath:indexPath];
        if (self.user) {
            topCell.user = self.user;
        }
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return topCell;
        
    }
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64 * kWidthRatio6s;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44 * kWidthRatio6s;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        XLUserDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XLUserDetailHeaderID];
        header.delegate = self;
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        id model = self.data[indexPath.row];
        NSString *category = [model valueForKey:@"category"];
        if (XLTypeComment(category)) {
            XLCommentModel *commentModel = model;
            XLCommentDetailController *commentDetailVC = [[XLCommentDetailController alloc] init];
            commentDetailVC.cid = commentModel.cid;
            commentDetailVC.entity_id = commentModel.entity.entity_id;
            [self.tableView.navigationController pushViewController:commentDetailVC animated:YES];
        } else {
            // 帖子详情
            XLTieziModel *tieziModel = model;
            XLMainDetailController *mainDetailVC = [[XLMainDetailController alloc] init];
            mainDetailVC.entity_id = tieziModel.entity_id;
            if (XLTypeVideo(category)) {
                mainDetailVC.mainType = XLMainType_video;
            } else if (XLTypePicture(category)) {
                mainDetailVC.mainType = XLMainType_picture;
            } else {
                mainDetailVC.mainType = XLMainType_duanz;
            }
            [self.tableView.navigationController pushViewController:mainDetailVC animated:YES];
        }
    }
}

- (void)reloadUserActionWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [dic[@"index"] integerValue];
    BOOL select = [dic[@"select"] boolValue];
    NSString *count = dic[@"count"];
    id model = self.data[indexPath.row];
    if ([model isKindOfClass:[XLTieziModel class]]) {
        XLTieziModel *tiezi = model;
        // index 0:点赞 1:评论 2：收藏 3:打赏 4:转发
        switch (index) {
            case 0:
            {
                tiezi.do_liked = @(select);
                tiezi.do_like_count = count;
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                tiezi.collected = @(select);
                tiezi.collect_count = count;
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
            }
                break;
                
                
            default:
                break;
        }
    } else if ([model isKindOfClass:[XLCommentModel class]]) {
        XLCommentModel *comment = model;
        // index 0:点赞 1:评论 2：收藏 3:打赏 4:转发
        switch (index) {
            case 0:
            {
                comment.do_liked = @(select);
                comment.do_like_count = count;
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
            }
                break;
                
                
            default:
                break;
        }
    }
}

@end
