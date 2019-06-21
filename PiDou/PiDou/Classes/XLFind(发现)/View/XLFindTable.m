//
//  XLFindTable.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLFindTable.h"
#import "XLTopicCell.h"
#import "XLTopicDetailController.h"
#import "XLTopicModel.h"

static NSString * XLTopicCellID = @"kXLTopicCell";

@interface XLFindTable () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XLFindTable

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
    [_tableView registerClass:[XLTopicCell class] forCellReuseIdentifier:XLTopicCellID];
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
    XLTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:XLTopicCellID forIndexPath:indexPath];
    
    if (!XLArrayIsEmpty(self.data)) {
        topicCell.topicModel = self.data[row];
    }
    topicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return topicCell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64 * kWidthRatio6s;
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
    XLTopicDetailController *topicDetailVC = [[XLTopicDetailController alloc] init];
    XLTopicModel *topic = self.data[indexPath.row];
    topicDetailVC.topic_id = topic.topic_id;
    [self.tableView.navigationController pushViewController:topicDetailVC animated:YES];
}

@end
