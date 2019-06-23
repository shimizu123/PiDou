//
//  XLMainDetailTable.m
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMainDetailTable.h"
#import "XLVideoCell.h"
#import "XLPictureCell.h"
#import "XLDuanziCell.h"
#import "XLCommentCell.h"
#import "XLPlayerManager.h"
#import "XLTieziModel.h"
#import "XLCommentDetailController.h"
#import "XLCommentModel.h"
#import "XLVideoPlayerController.h"

static NSString * XLVideoCellID    = @"kXLVideoCell";
static NSString * XLPictureCellID  = @"kXLPictureCell";
static NSString * XLDuanziCellID   = @"kXLDuanziCell";
static NSString * XLCommentCellID  = @"kXLCommentCell";

@interface XLMainDetailTable () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation XLMainDetailTable


- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
    
    if (XLTypeVideo(_tieziModel.category)) {
        self.mainType = XLMainType_video;
    } else if (XLTypePicture(_tieziModel.category)) {
        self.mainType = XLMainType_picture;
    } else {
        self.mainType = XLMainType_duanz;
    }
    _tableView.hidden = NO;
    [self.tableView reloadData];
}


- (void)setCommentsData:(NSMutableArray *)commentsData {
    _commentsData = commentsData;
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

- (void)registerCell {
    [_tableView registerClass:[XLVideoCell class] forCellReuseIdentifier:XLVideoCellID];
    [_tableView registerClass:[XLPictureCell class] forCellReuseIdentifier:XLPictureCellID];
    [_tableView registerClass:[XLDuanziCell class] forCellReuseIdentifier:XLDuanziCellID];
    [_tableView registerClass:[XLCommentCell class] forCellReuseIdentifier:XLCommentCellID];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(mainDetailTable:didScroll:)]) {
        [_delegate mainDetailTable:self didScroll:scrollView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return self.commentsData.count;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (self.mainType == XLMainType_video) {
            XLVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:XLVideoCellID forIndexPath:indexPath];
            kDefineWeakSelf;
            if (self.tieziModel) {
                videoCell.isDetail = true;
                videoCell.tieziModel = self.tieziModel;
                videoCell.complete = ^(id  _Nonnull result) {
                    //[XLPlayerManager playVideoWithIndexPath:indexPath tag:1314 scrollView:WeakSelf.tableView videoUrl:result];
                    XLVideoPlayerController *videoDetailVC = [[XLVideoPlayerController alloc] init];
                    videoDetailVC.entity_id = WeakSelf.tieziModel.entity_id;
                    [WeakSelf.tableView.navigationController pushViewController:videoDetailVC animated:YES];
                };
            }
            videoCell.isDetailVC = YES;
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return videoCell;
        } else if (self.mainType == XLMainType_picture) {
            XLPictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:XLPictureCellID forIndexPath:indexPath];
            if (self.tieziModel) {
                pictureCell.isDetail = true;
                pictureCell.tieziModel = self.tieziModel;
            }
            pictureCell.isDetailVC = YES;
//            NSMutableArray *mArr = [NSMutableArray array];
//            for (int i = 0; i < indexPath.section + 1; i++) {
//                [mArr addObject:[NSString stringWithFormat:@"%d",i]];
//            }
//            pictureCell.pictures = mArr;
            pictureCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return pictureCell;
        } else {
            XLDuanziCell *duanziCell = [tableView dequeueReusableCellWithIdentifier:XLDuanziCellID forIndexPath:indexPath];
            if (self.tieziModel) {
                duanziCell.isDetail = true;
                duanziCell.tieziModel = self.tieziModel;
            }
            duanziCell.isDetailVC = YES;
            duanziCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return duanziCell;
        }
    } else {
        XLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XLCommentCellID forIndexPath:indexPath];
        if (!XLArrayIsEmpty(self.commentsData)) {
            XLCommentModel *comment = self.commentsData[row];
            cell.commentModel = comment;
            kDefineWeakSelf;
            cell.didSelectRepllyBlock = ^(id  _Nonnull result) {
//                if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(mainDetailTable:didReplyWithComment:)]) {
//                    [WeakSelf.delegate mainDetailTable:WeakSelf didReplyWithComment:result];
//                }
                XLCommentDetailController *commentDetailVC = [[XLCommentDetailController alloc] init];
                commentDetailVC.cid = comment.cid;
                commentDetailVC.entity_id = self.tieziModel.entity_id;
                [self.tableView.navigationController pushViewController:commentDetailVC animated:YES];
            };
            cell.didSelectedAction = ^(id  _Nonnull result) {
                [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
            };
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
    return 12 * kWidthRatio6s;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        XLCommentModel *comment = self.commentsData[row];
        XLCommentDetailController *commentDetailVC = [[XLCommentDetailController alloc] init];
        commentDetailVC.cid = comment.cid;
        commentDetailVC.entity_id = self.tieziModel.entity_id;
        [self.tableView.navigationController pushViewController:commentDetailVC animated:YES];
    }
}

- (void)reloadUserActionWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [dic[@"index"] integerValue];
    BOOL select = [dic[@"select"] boolValue];
    NSString *count = dic[@"count"];
    XLCommentModel *comment = self.commentsData[indexPath.row];
    if (index == 0) {
        comment.do_liked = @(select);
        comment.do_like_count = count;
    }
}

@end
