//
//  XLMsgTable.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMsgTable.h"
#import "XLMsgCell.h"
#import "XLMainDetailController.h"
#import "XLCommentDetailController.h"
#import "XLCommentModel.h"
#import "XLTieziModel.h"
#import "XLUserDetailController.h"

static NSString * XLMsgCellID = @"kXLMsgCellID";

@interface XLMsgTable () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation XLMsgTable

- (void)setData:(NSMutableArray *)data {
    _data = data;
    [self.tableView reloadData];
}

- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self setup];
    }
    return _tableView;
}

- (void)setup {
    [self registerCell];
}

- (void)registerCell {
    [_tableView registerClass:[XLMsgCell class] forCellReuseIdentifier:XLMsgCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    XLMsgCell *msgCell = [tableView dequeueReusableCellWithIdentifier:XLMsgCellID forIndexPath:indexPath];
//    NSInteger type = arc4random() % 3;
//    msgCell.actionType = type;

//    if (type == 2) {
//        msgCell.infoType = XLMsgInfoType_user;
//    } else {
//        msgCell.infoType = arc4random() % 4;
//    }
//
    if (!XLArrayIsEmpty(self.data)) {
        msgCell.msgModel = self.data[row];
    }
    msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return msgCell;
}
#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 94 * kWidthRatio6s;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!XLArrayIsEmpty(self.data)) {
        XLMsgModel *msgModel = self.data[indexPath.row];
        switch ([msgModel.type integerValue]) {
            case 1:
            case 2:
            case 5:
            case 6:
            {
                return 98 * kWidthRatio6s;
            }
                break;

            case 3:
            {
                return 94 * kWidthRatio6s;
            }
                break;
            case 4:
            {
                return 68 * kWidthRatio6s;
            }
                break;
            

                
                
            default:
                break;
        }
    }
    return 98 * kWidthRatio6s;
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
    XLMsgModel *message = self.data[indexPath.row];
    switch ([message.type integerValue]) {
        case 1:
        {
            // 评论内容
            XLMainDetailController *tieziDetailVC = [[XLMainDetailController alloc] init];
            tieziDetailVC.entity_id = message.entity.entity_id;
            [self.tableView.navigationController pushViewController:tieziDetailVC animated:YES];
        }
            break;
        case 2:
        {
            // 回复
            XLCommentDetailController *commentDetailVC = [[XLCommentDetailController alloc] init];
            commentDetailVC.cid = message.comment.cid;
            commentDetailVC.entity_id = message.entity.entity_id;
            [self.tableView.navigationController pushViewController:commentDetailVC animated:YES];
        }
            break;
        case 3:
        {
            // 赞
            XLMainDetailController *tieziDetailVC = [[XLMainDetailController alloc] init];
            tieziDetailVC.entity_id = message.entity.entity_id;
            [self.tableView.navigationController pushViewController:tieziDetailVC animated:YES];
        }
            break;
        case 4:
        {
            // 关注
            XLUserDetailController *userDetailVC = [[XLUserDetailController alloc] init];
            userDetailVC.user_id = message.user_info.user_id;
            [self.tableView.navigationController pushViewController:userDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // PDcoin被冻结
        }
            break;
        case 6:
        {
            // 打赏
        }
            break;
            
        default:
            break;
    }
    
}

@end
