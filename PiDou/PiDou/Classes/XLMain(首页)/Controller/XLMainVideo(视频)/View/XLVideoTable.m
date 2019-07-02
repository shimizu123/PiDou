//
//  XLVideoTable.m
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLVideoTable.h"
#import "XLVideoCell.h"
#import "XLPlayerManager.h"
#import "XLMainDetailController.h"
#import "XLTieziModel.h"

static NSString * XLVideoCellID = @"kXLVideoCell";
@interface XLVideoTable () <UITableViewDelegate, UITableViewDataSource, ZFPlayerControlViewDelagate>

@property (nonatomic, strong) XLVideoCell *playingCell;
@property (nonatomic, copy) NSString *currentVideoPath;

@end

@implementation XLVideoTable

- (void)setData:(NSMutableArray *)data {
    _data = data;
    _tableView.hidden = NO;
    [self.tableView reloadData];
}

- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
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

- (void)registerCell {
    [_tableView registerClass:[XLVideoCell class] forCellReuseIdentifier:XLVideoCellID];
}

- (void)handleScroll{
    // 找到下一个要播放的cell(最在屏幕中心的)
    XLVideoCell *finnalCell = nil;
    NSArray *visiableCells = [self.tableView visibleCells];
    NSMutableArray *indexPaths = [NSMutableArray array];
    CGFloat gap = MAXFLOAT;
    for (XLVideoCell *cell in visiableCells) {
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


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    XLVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:XLVideoCellID forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.data)) {
        XLTieziModel *tieziModel = self.data[row];
        videoCell.tieziModel = tieziModel;
        videoCell.indexPath = indexPath;
//        videoCell.tableView = tableView;
        kDefineWeakSelf;
        videoCell.complete = ^(NSString *url) {
            [XLPlayerManager playVideoWithIndexPath:indexPath tag:1314 scrollView:WeakSelf.tableView videoUrl:url entity_id:tieziModel.entity_id];
        };
        
        videoCell.didSelectedAction = ^(id result) {
//            if (WeakSelf.reloadDataBlock) {
//                WeakSelf.reloadDataBlock();
//            }
            [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
        };
    }
    videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return videoCell;
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
    XLMainDetailController *detailVC = [[XLMainDetailController alloc] init];
    detailVC.mainType = XLMainType_video;
    if (!XLArrayIsEmpty(self.data)) {
        XLTieziModel *tiezi = self.data[indexPath.row];
        detailVC.entity_id = tiezi.entity_id;
    }
    [self.tableView.navigationController pushViewController:detailVC animated:YES];
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
