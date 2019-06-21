//
//  XLMineController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineController.h"
#import "XLMineTable.h"
#import "XLUserLoginHandle.h"
#import "XLMineHandle.h"

@interface XLMineController ()

@property (nonatomic, strong) XLMineTable *table;

@end

@implementation XLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initUI {
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_TABBAR_H);
    [self.view addSubview:self.table.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initData {
    [self initUserInfoData];
    [self initAdvsData];
}

- (void)initUserInfoData {
    kDefineWeakSelf;
    if (!XLStringIsEmpty([XLUserHandle userid])) {
        [XLUserLoginHandle userInfoWithSuccess:^(XLAppUserModel *userInfo) {
            WeakSelf.table.userInfo = userInfo;
        } failure:^(id  _Nonnull result) {
            
        }];
    } else {
        self.table.userInfo = nil;
    }
}

- (void)initAdvsData {
    kDefineWeakSelf;
    [XLMineHandle announcementWithSuccess:^(id  _Nonnull responseObject) {
        WeakSelf.table.advsData = responseObject;
    } failure:^(id  _Nonnull result) {
        WeakSelf.table.advsData = [NSMutableArray array];
    }];
}

#pragma mark - lazy load
- (XLMineTable *)table {
    if (!_table) {
        _table = [[XLMineTable alloc] init];
        _table.titles = @[@"神评鉴定",@"皮逗商城",@"小游戏",@"我的收藏",@"我的作品",@"我的钱包",@"我的邀请",@"设置",@"意见反馈"];
    }
    return _table;
}

@end
