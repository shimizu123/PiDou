//
//  XLUserDetailController.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserDetailController.h"
#import "XLUserNaviBar.h"
#import "XLUserDetailTable.h"
#import "XLMineHandle.h"
#import "XLMineHandle.h"

@interface XLUserDetailController () <XLUserDetailTableDelegate>

@property (nonatomic, strong) XLUserNaviBar *naviBar;

@property (nonatomic, strong) XLUserDetailTable *table;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) int page;

@end

@implementation XLUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    // self.navigationItem.title = @"个人名片";
    [self initUI];
    
    [self didLoadData];
    
    [self initUserInfoData];
}



- (void)initUI {
    [self.view addSubview:self.naviBar];
    
    self.table.tableView.frame = CGRectMake(0, XL_NAVIBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.table.tableView];
    self.table.delegate = self;
    self.table.tableType = XLUserDetailTableType_mineDetail;

    
    if (@available(iOS 11.0, *)) {
        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.table.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.table.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)didLoadData {
    _page = 1;
    [self initData];
}

- (void)loadMoreData {
    _page++;
    [self initData];
}

- (void)initUserInfoData {
    kDefineWeakSelf;
    [XLMineHandle userInfoWithUser_id:self.user_id success:^(XLAppUserModel *user) {
        WeakSelf.naviBar.user = user;
        WeakSelf.table.user = user;
    } failure:^(id  _Nonnull result) {
        
    }];
}

- (void)initData {
    switch (self.index) {
        case 0:
        {
            [self initDynamicData];
        }
            break;
        case 1:
        {
            [self initTieziData];
        }
            break;
        case 2:
        {
            [self initCommentData];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)initDynamicData {
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMineHandle userDynamicWithUser_id:self.user_id page:self.page success:^(NSMutableArray *responseObject) {
        [HUDController hideHUD];
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
            WeakSelf.data = responseObject;
        }
        WeakSelf.table.data = WeakSelf.data;
    } failure:^(id  _Nonnull result) {
        if (WeakSelf.page > 1) {
            [HUDController hideHUDWithText:@"没有更多数据"];
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [HUDController xl_hideHUDWithResult:result];
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        if (XLArrayIsEmpty(WeakSelf.data)) {
            WeakSelf.table.data = WeakSelf.data;
        }
    }];
}

- (void)initTieziData {
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMineHandle userEntityWithUser_id:self.user_id page:self.page success:^(NSMutableArray *responseObject) {
        [HUDController hideHUD];
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
            WeakSelf.data = responseObject;
        }
        WeakSelf.table.data = WeakSelf.data;
    } failure:^(id  _Nonnull result) {
        if (WeakSelf.page > 1) {
            [HUDController hideHUDWithText:@"没有更多数据"];
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [HUDController xl_hideHUDWithResult:result];
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        if (XLArrayIsEmpty(WeakSelf.data)) {
            WeakSelf.table.data = WeakSelf.data;
        }
    }];
}

- (void)initCommentData {
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMineHandle userCommentsWithUser_id:self.user_id page:self.page success:^(NSMutableArray *responseObject) {
        [HUDController hideHUD];
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
            WeakSelf.data = responseObject;
        }
        WeakSelf.table.data = WeakSelf.data;
    } failure:^(id  _Nonnull result) {
        
        if (WeakSelf.page > 1) {
            [HUDController hideHUDWithText:@"没有更多数据"];
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [HUDController xl_hideHUDWithResult:result];
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        if (XLArrayIsEmpty(WeakSelf.data)) {
            WeakSelf.table.data = WeakSelf.data;
        }
    }];
}

#pragma mark - XLUserDetailTableDelegate
- (void)userDetailTable:(XLUserDetailTable *)userDetailTable didSegmentWithIndex:(NSInteger)index {
    self.index = index;
    [self didLoadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidTable:(XLUserDetailTable *)table contentOffsetY:(CGFloat)contentOffsetY {
    if (contentOffsetY > 170 * kWidthRatio6s) {
        self.naviBar.isUser = YES;
    } else {
        self.naviBar.isUser = NO;
    }
}


#pragma mark - lazy load
- (XLUserNaviBar *)naviBar {
    if (!_naviBar) {
        _naviBar = [[XLUserNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
        _naviBar.backBlack = YES;
        kDefineWeakSelf;
        _naviBar.updateFinish = ^{
            [WeakSelf initData];
        };
    }
    return _naviBar;
}

- (XLUserDetailTable *)table {
    if (!_table) {
        _table = [[XLUserDetailTable alloc] init];
    }
    return _table;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}


@end
