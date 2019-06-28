//
//  XLMineTable.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineTable.h"
#import "XLMineTopCell.h"
#import "XLMineAdCell.h"
#import "XLMineListCell.h"
#import "XLMineInfoController.h"
#import "XLMineSettingController.h"
#import "XLMineAdviceController.h"
#import "XLMineCollectionController.h"
#import "XLMinePublishController.h"
#import "XLMineWalletController.h"
#import "XLMineInviteController.h"
#import "XLMineShenController.h"
#import "XLPDCoinController.h"
#import "XLLoginController.h"
#import "XLBaseNavigationController.h"
#import "XLInviteFriendCell.h"
//#import "XLAnnoDetailController.h"
#import "XLAnnouncement.h"
#import "XLInviteDetailController.h"
#import "XLLaunchManager.h"
#import "XLShareView.h"

static NSString * XLMineTopCellID      = @"kXLMineTopCell";
static NSString * XLMineAdCellID       = @"kXLMineAdCell";
static NSString * XLMineListCellID     = @"kXLMineListCell";
static NSString * XLInviteFriendCellID = @"kXLInviteFriendCell";

@interface XLMineTable () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *icons;

@end

@implementation XLMineTable

- (void)setUserInfo:(XLAppUserModel *)userInfo {
    _userInfo = userInfo;
    [self.tableView reloadData];
}

- (void)setAdvsData:(NSArray *)advsData {
    _advsData = advsData;
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
        
        [self setup];
    }
    return _tableView;
}

- (void)setup {
    [self registerCell];
}

- (void)registerCell {
    [_tableView registerClass:[XLMineTopCell class] forCellReuseIdentifier:XLMineTopCellID];
    [_tableView registerClass:[XLMineAdCell class] forCellReuseIdentifier:XLMineAdCellID];
    [_tableView registerClass:[XLMineListCell class] forCellReuseIdentifier:XLMineListCellID];
    [_tableView registerClass:[XLInviteFriendCell class] forCellReuseIdentifier:XLInviteFriendCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.titles.count;
    }
    if (section == 2) {
        return XLStringIsEmpty(self.userInfo.user_id) ? 0 : 1;
    }
    if (section == 1) {
        return 1;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        XLMineTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:XLMineTopCellID forIndexPath:indexPath];
        topCell.userInfo = self.userInfo;
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return topCell;
    } else if (section == 1) {
        XLMineAdCell *adCell = [tableView dequeueReusableCellWithIdentifier:XLMineAdCellID forIndexPath:indexPath];
        if (!XLArrayIsEmpty(self.advsData)) {
            //adCell.advModel = self.advsData[row];
            adCell.advData = self.advsData;
        }
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adCell;
    } else if (section == 2) {
        XLInviteFriendCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:XLInviteFriendCellID forIndexPath:indexPath];
        if (!XLStringIsEmpty(self.userInfo.invitation_code)) {
            inviteCell.invCode = self.userInfo.invitation_code;
        }
        inviteCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return inviteCell;
    } else {
        XLMineListCell *listCell = [tableView dequeueReusableCellWithIdentifier:XLMineListCellID forIndexPath:indexPath];
        
        listCell.icon = self.icons[row];
        
        if (!XLArrayIsEmpty(self.titles)) {
            listCell.titleName = self.titles[row];
        }
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return listCell;
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
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (!XLStringIsEmpty([XLUserHandle userid])) {
            XLMineInfoController *infoVC = [[XLMineInfoController alloc] init];
//            if (self.userInfo) {
//                infoVC.userInfo = self.userInfo;                
//            }
            [self.tableView.navigationController pushViewController:infoVC animated:YES];
        } else {
            XLLoginController *loginVC = [[XLLoginController alloc] init];
            XLBaseNavigationController *naviC = [[XLBaseNavigationController alloc] initWithRootViewController:loginVC];
            [self.tableView.navigationController presentViewController:naviC animated:YES completion:^{
                
            }];
        }
    } else if (section == 1) {
//        XLAnnouncement *advModel = self.advsData[row];
//        XLAnnoDetailController *annoDetailVC = [[XLAnnoDetailController alloc] init];
//        annoDetailVC.htmlStr = advModel.content;
//        [self.tableView.navigationController pushViewController:annoDetailVC animated:YES];
    }  else if (section == 2) {
//        XLInviteDetailController *inviteDetailVC = [[XLInviteDetailController alloc] init];
//        inviteDetailVC.title = @"皮逗视频下载";
//        [self.tableView.navigationController pushViewController:inviteDetailVC animated:YES];
        [self shareAction];
    } else {
        if (XLStringIsEmpty([XLUserHandle userid])) {
            [XLLaunchManager goLoginWithTarget:self.tableView.parentController];
            return;
        }
        
        switch (row) {
            case 0:
            {
                // 神评鉴定
                XLMineShenController *shenVC = [[XLMineShenController alloc] init];
                shenVC.userInfo = self.userInfo;
                [self.tableView.navigationController pushViewController:shenVC animated:YES];
            }
                break;
            case 1:
            {
                // 皮逗商城
                [HUDController hideHUDWithText:@"敬请期待"];
            }
                break;
            case 2:
            {
                // 小游戏
                [HUDController hideHUDWithText:@"敬请期待"];
            }
                break;
            case 3:
            {
                // 我的收藏
                XLMineCollectionController *collectionVC = [[XLMineCollectionController alloc] init];
                [self.tableView.navigationController pushViewController:collectionVC animated:YES];
            }
                break;
            case 4:
            {
                // 我的作品
                XLMinePublishController *publishVC = [[XLMinePublishController alloc] init];
                publishVC.user_id = [XLUserHandle userid];
                [self.tableView.navigationController pushViewController:publishVC animated:YES];
            }
                break;
            case 5:
            {
                // 我的钱包
                XLMineWalletController *walletVC = [[XLMineWalletController alloc] init];
                [self.tableView.navigationController pushViewController:walletVC animated:YES];
            }
                break;
            case 6:
            {
                // 我的邀请
                XLMineInviteController *inviteVC = [[XLMineInviteController alloc] init];
                [self.tableView.navigationController pushViewController:inviteVC animated:YES];
                
            }
                break;
            case 7:
            {
                // 设置
                XLMineSettingController *settingVC = [[XLMineSettingController alloc] init];
                [self.tableView.navigationController pushViewController:settingVC animated:YES];
            }
                break;
            case 8:
            {
                // 意见反馈
                XLMineAdviceController *adviceVC = [[XLMineAdviceController alloc] init];
                [self.tableView.navigationController pushViewController:adviceVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)shareAction {
    
    XLShareModel *message = [[XLShareModel alloc] init];
    message.title = [NSString stringWithFormat:@"皮逗邀请码：%@",self.userInfo.invitation_code];
    message.text = self.userInfo.invitation_code;
    
    XLShareView *shareView = [XLShareView shareView];
    shareView.showQRCode = true;
    shareView.message = message;
    shareView.noDeletebtn = YES;
    [shareView show];
}

- (NSArray *)icons {
    if (!_icons) {
        _icons = [NSArray arrayWithObjects:@"666", @"juice", @"qianbao", @"huangguan", @"666", @"juice", @"qianbao", @"huangguan", @"666", nil];
    }
    return _icons;
}


@end
