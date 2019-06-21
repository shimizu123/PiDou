//
//  XLCommentDetailTable.m
//  PiDou
//
//  Created by kevin on 5/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentDetailTable.h"
#import "XLVideoCell.h"
#import "XLPictureCell.h"
#import "XLDuanziCell.h"
#import "XLCommentCell.h"
#import "XLCommentModel.h"
#import "XLPlayerManager.h"

static NSString * XLVideoCellID    = @"kXLVideoCell";
static NSString * XLPictureCellID  = @"kXLPictureCell";
static NSString * XLDuanziCellID   = @"kXLDuanziCell";
static NSString * XLCommentCellID  = @"kXLCommentCell";

@interface XLCommentDetailTable () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>



@end

@implementation XLCommentDetailTable

- (void)setCommentModel:(XLCommentModel *)commentModel {
    _commentModel = commentModel;
    _tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
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
    if (_delegate && [_delegate respondsToSelector:@selector(commentDetailTable:didScroll:)]) {
        [_delegate commentDetailTable:self didScroll:scrollView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return self.commentModel.replies.count;
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
        if (XLTypeVideo(self.commentModel.type)) {
            XLVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:XLVideoCellID forIndexPath:indexPath];
            kDefineWeakSelf;
            videoCell.complete = ^(id  _Nonnull result) {
                [XLPlayerManager playVideoWithIndexPath:indexPath tag:1314 scrollView:WeakSelf.tableView videoUrl:result entity_id:self.tieziModel.entity_id];
            };
            if (self.tieziModel) {
                videoCell.tieziModel = self.tieziModel;
            }
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return videoCell;
        } else if (XLTypePicture(self.commentModel.type)) {
            XLPictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:XLPictureCellID forIndexPath:indexPath];
            
            if (self.tieziModel) {
                pictureCell.tieziModel = self.tieziModel;
            }
 
            pictureCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return pictureCell;
        } else {
            XLDuanziCell *duanziCell = [tableView dequeueReusableCellWithIdentifier:XLDuanziCellID forIndexPath:indexPath];
            if (self.tieziModel) {
                duanziCell.tieziModel = self.tieziModel;
            }
            duanziCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return duanziCell;
        }
    } else {
        XLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XLCommentCellID forIndexPath:indexPath];
        //cell.commentType = indexPath.row % 3;
        if (!XLArrayIsEmpty(self.commentModel.replies)) {
            cell.commentModel = self.commentModel.replies[row];
            kDefineWeakSelf;
            cell.didSelectRepllyBlock = ^(id  _Nonnull result) {
                if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(commentDetailTable:didReplyWithComment:)]) {
                    [WeakSelf.delegate commentDetailTable:self didReplyWithComment:result];
                }
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

- (void)reloadUserActionWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [dic[@"index"] integerValue];
    BOOL select = [dic[@"select"] boolValue];
    NSString *count = dic[@"count"];
    XLCommentModel *comment = self.commentModel.replies[indexPath.row];
    if (index == 0) {
        comment.do_liked = @(select);
        comment.do_like_count = count;
    }
}

@end
