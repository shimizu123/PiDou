//
//  XLPictureTable.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPictureTable.h"
#import "XLPictureCell.h"
#import "XLMainDetailController.h"

static NSString * XLPictureCellID = @"kXLPictureCell";

@interface XLPictureTable () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XLPictureTable

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
    [_tableView registerClass:[XLPictureCell class] forCellReuseIdentifier:XLPictureCellID];
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
    XLPictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:XLPictureCellID forIndexPath:indexPath];
    
    if (!XLArrayIsEmpty(self.data)) {
        pictureCell.tieziModel = self.data[row];
    }
    kDefineWeakSelf;
    pictureCell.didSelectedAction = ^(id result) {
//        if (WeakSelf.reloadDataBlock) {
//            WeakSelf.reloadDataBlock();
//        }
        [WeakSelf reloadUserActionWithDic:result indexPath:indexPath];
    };
//    NSMutableArray *mArr = [NSMutableArray array];
//    for (int i = 0; i < indexPath.section + 1; i++) {
//        [mArr addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//    pictureCell.pictures = mArr;
    pictureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return pictureCell;
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
    detailVC.mainType = XLMainType_picture;
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
