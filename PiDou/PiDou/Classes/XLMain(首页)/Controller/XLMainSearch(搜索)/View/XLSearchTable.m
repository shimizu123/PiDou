//
//  XLSearchTable.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchTable.h"
#import "XLVideoCell.h"
#import "XLPictureCell.h"
#import "XLDuanziCell.h"
#import "XLPlayerManager.h"
#import "XLSearchResultTopCell.h"
#import "XLSearchUserCell.h"
#import "XLTopicCell.h"

#import "XLMainDetailController.h"
#import "XLTopicDetailTopCell.h"
#import "XLUserDetailController.h"
#import "XLTopicDetailController.h"
#import "XLTopicModel.h"
#import "XLSearchModel.h"
#import "XLFansModel.h"


static NSString * XLVideoCellID           = @"kXLVideoCell";
static NSString * XLPictureCellID         = @"kXLPictureCell";
static NSString * XLDuanziCellID          = @"kXLDuanziCell";
static NSString * XLSearchResultTopCellID = @"kXLSearchResultTopCell";
static NSString * XLSearchUserCellID      = @"kXLSearchUserCell";
static NSString * XLTopicCellID           = @"kXLTopicCell";
static NSString * XLTopicDetailTopCellID  = @"kXLTopicDetailTopCell";

@interface XLSearchTable () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) XLVideoCell *playingCell;
@property (nonatomic, copy) NSString *currentVideoPath;

@end

@implementation XLSearchTable


- (void)setSearchModel:(XLSearchModel *)searchModel {
    _searchModel = searchModel;
    _tableView.hidden = NO;
    self.data = _searchModel.entities;
}

- (void)setData:(NSMutableArray *)data {
    _data = data;
    _tableView.hidden = NO;
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.tableView.contentOffset.y < 0) {
            [self.tableView setContentOffset:(CGPointZero) animated:YES];
        }
    });
}

- (void)setTopicModel:(XLTopicModel *)topicModel {
    _topicModel = topicModel;
    _tableView.hidden = NO;
    self.data = _topicModel.entities.mutableCopy;
}

- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, XL_HOME_INDICATOR_H, 0);
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

- (void)setSearchType:(XLSearchType)searchType {
    _searchType = searchType;
    [self.tableView reloadData];
}

- (void)registerCell {
    [_tableView registerClass:[XLVideoCell class] forCellReuseIdentifier:XLVideoCellID];
    [_tableView registerClass:[XLPictureCell class] forCellReuseIdentifier:XLPictureCellID];
    [_tableView registerClass:[XLDuanziCell class] forCellReuseIdentifier:XLDuanziCellID];
    [_tableView registerClass:[XLSearchResultTopCell class] forCellReuseIdentifier:XLSearchResultTopCellID];
    [_tableView registerClass:[XLSearchUserCell class] forCellReuseIdentifier:XLSearchUserCellID];
    [_tableView registerClass:[XLTopicCell class] forCellReuseIdentifier:XLTopicCellID];
    [_tableView registerClass:[XLTopicDetailTopCell class] forCellReuseIdentifier:XLTopicDetailTopCellID];
}

- (void)handleScroll{
    // 找到下一个要播放的cell(最在屏幕中心的)
    XLVideoCell *finnalCell = nil;
    NSArray *visiableCells = [self.tableView visibleCells];
    NSMutableArray *indexPaths = [NSMutableArray array];
    CGFloat gap = MAXFLOAT;
    for (id visibleCell in visiableCells) {
        if ([visibleCell isKindOfClass:[XLVideoCell class]]) {
            XLVideoCell *cell = (XLVideoCell *)visibleCell;
            [indexPaths addObject:cell.indexPath];
            if (cell.videoPath.length > 0) {
                // 如果这个cell有视频
                CGPoint coorCenter = [self.tableView convertPoint:cell.center toView:self.tableView.superview];
                CGFloat delta = fabs(coorCenter.y - self.tableView.superview.xl_h / 2);
                if (delta < gap) {
                    gap = delta;
                    finnalCell = cell;
                }
            }
        }
    }
    if (finnalCell != nil && self.playingCell != finnalCell)  {
        UIButton *button = finnalCell.playButton;
        button.selected = !button.selected;
        if (button.selected && !finnalCell.isDetailVC) {
            button.hidden = YES;
        }
        [XLPlayerManager playVideoWithIndexPath:finnalCell.indexPath tag:1314 scrollView:self.tableView videoUrl:finnalCell.videoPath entity_id:finnalCell.entityId];
        self.playingCell = finnalCell;
        self.currentVideoPath = finnalCell.videoPath;
    }
    // 注意, 如果正在播放的cell和finnalCell是同一个cell, 不应该在播放
    BOOL isPlayingCellVisiable = YES;
    if (![indexPaths containsObject:self.playingCell.indexPath]) {
        isPlayingCellVisiable = NO;
    }
    // 当前播放视频的cell移出视线， 或者cell被快速的循环利用了， 都要移除播放器
    if (!isPlayingCellVisiable || ![self.playingCell.videoPath isEqualToString:self.currentVideoPath]) {
        [[XLPlayerManager sharedXLPlayerManager] removePlayer];
    }
}

// 松手时已经静止,只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) { // scrollView已经完全静止
        [self handleScroll];
    }
}

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleScroll];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (_delegate && [_delegate respondsToSelector:@selector(searchTable:contentOffsetY:)]) {
        [_delegate searchTable:self contentOffsetY:offY];
    }
    [self.tableView.parentController.view endEditing:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return self.data.count;
    }
    return self.searchType == XLSearchType_all || self.searchType == XLSearchType_topicDetail ? 1 : 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (self.searchType == XLSearchType_topicDetail) {
            XLTopicDetailTopCell *topicDetailCell = [tableView dequeueReusableCellWithIdentifier:XLTopicDetailTopCellID forIndexPath:indexPath];
            if (self.topicModel) {
                topicDetailCell.topicModel = self.topicModel;
            }
            topicDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return topicDetailCell;
        }
        XLSearchResultTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:XLSearchResultTopCellID forIndexPath:indexPath];
        if (self.searchModel) {
            topCell.searchModel = self.searchModel;
        }
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return topCell;
    } else {

        if (self.searchType == XLSearchType_user) {
            XLSearchUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:XLSearchUserCellID forIndexPath:indexPath];
            if (!XLArrayIsEmpty(self.data)) {
                userCell.fansModel = self.data[row];
            }
            userCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return userCell;
        } else if (self.searchType == XLSearchType_topic){
            XLTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:XLTopicCellID forIndexPath:indexPath];
            if (!XLArrayIsEmpty(self.data)) {
                topicCell.topicModel = self.data[row];
            }
            topicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return topicCell;
        } else {
            if (self.searchType == XLSearchType_all || self.searchType == XLSearchType_allNotTopic) {
                if (!XLArrayIsEmpty(self.data)) {
                    XLTieziModel *tieziModel = self.data[row];
                    if (XLTypeVideo(tieziModel.category)) {
                        self.allType = XLSearchType_video;
                    } else if (XLTypePicture(tieziModel.category)) {
                        self.allType = XLSearchType_picture;
                    } else {
                        self.allType = XLSearchType_duanzi;
                    }
                }
            }
            if (self.searchType == XLSearchType_video || ((self.searchType == XLSearchType_all || self.searchType == XLSearchType_allNotTopic) && self.allType == XLSearchType_video)) {
                XLVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:XLVideoCellID forIndexPath:indexPath];
                if (!XLArrayIsEmpty(self.data)) {
                    XLTieziModel *tieziModel = self.data[row];
                    videoCell.tieziModel = tieziModel;
                    videoCell.indexPath = indexPath;
                    kDefineWeakSelf;
                    videoCell.didSelectedAction = ^(id  _Nonnull result) {
//                        if (WeakSelf.reloadDataBlock) {
//                            WeakSelf.reloadDataBlock();
//                        }
                        [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
                    };
                    videoCell.complete = ^(id  _Nonnull result) {
                        [XLPlayerManager playVideoWithIndexPath:indexPath tag:1314 scrollView:WeakSelf.tableView videoUrl:tieziModel.video_url entity_id:tieziModel.entity_id];
                    };
                }
                videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return videoCell;
            } else if (self.searchType == XLSearchType_picture || ((self.searchType == XLSearchType_all || self.searchType == XLSearchType_allNotTopic) && self.allType == XLSearchType_picture)) {
                XLPictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:XLPictureCellID forIndexPath:indexPath];
                kDefineWeakSelf;
                pictureCell.didSelectedAction = ^(id  _Nonnull result) {
//                    if (WeakSelf.reloadDataBlock) {
//                        WeakSelf.reloadDataBlock();
//                    }
                    [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
                };
                if (!XLArrayIsEmpty(self.data)) {
                    XLTieziModel *tieziModel = self.data[row];
                    pictureCell.tieziModel = tieziModel;
                }
                pictureCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return pictureCell;
            } else {
                // else if (self.searchType == XLSearchType_duanzi)
                XLDuanziCell *duanziCell = [tableView dequeueReusableCellWithIdentifier:XLDuanziCellID forIndexPath:indexPath];
                kDefineWeakSelf;
                duanziCell.didSelectedAction = ^(id  _Nonnull result) {
//                    if (WeakSelf.reloadDataBlock) {
//                        WeakSelf.reloadDataBlock();
//                    }
                    [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
                };
                if (!XLArrayIsEmpty(self.data)) {
                    XLTieziModel *tieziModel = self.data[row];
                    duanziCell.tieziModel = tieziModel;
                }
                duanziCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return duanziCell;
            }
        }
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 246 * kWidthRatio6s;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.searchType == XLSearchType_topicDetail) {
            XLTopicDetailController *topicDetailVC = [[XLTopicDetailController alloc] init];
            topicDetailVC.topic_id = self.searchModel.topic.topic_id;
            [self.tableView.navigationController pushViewController:topicDetailVC animated:YES];
        }
    } else {
        
        if (self.searchType == XLSearchType_user) {
            XLUserDetailController *userDetailVC = [[XLUserDetailController alloc] init];
            XLFansModel *fans = self.data[indexPath.row];
            userDetailVC.user_id = fans.user_id;
            [self.tableView.navigationController pushViewController:userDetailVC animated:YES];
        } else if (self.searchType == XLSearchType_topic) {
            XLTopicDetailController *topicDetailVC = [[XLTopicDetailController alloc] init];
            XLTopicModel *topic = self.data[indexPath.row];
            topicDetailVC.topic_id = topic.topic_id;
            [self.tableView.navigationController pushViewController:topicDetailVC animated:YES];
        } else {
            
            XLMainDetailController *mainDetailVC = [[XLMainDetailController alloc] init];
            XLTieziModel *tieziModel = self.data[indexPath.row];
            mainDetailVC.entity_id = tieziModel.entity_id;
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
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

@end
