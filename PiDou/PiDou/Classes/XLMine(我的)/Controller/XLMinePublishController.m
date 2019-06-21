//
//  XLMinePublishController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMinePublishController.h"
#import "XLUserDetailTable.h"
#import "XLMineHandle.h"

@interface XLMinePublishController () <XLUserDetailTableDelegate>

@property (nonatomic, strong) XLUserDetailTable *table;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) int page;

@end

@implementation XLMinePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的作品";
    
    [self initUI];
    
    self.index = 0;
    [self didLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:XLDelMyPublishNotification object:nil];
}


- (void)initUI {
    
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.table.tableView];
    
    
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
    [self.data removeAllObjects];
    [self initData];
}

- (void)loadMoreData {
    _page++;
    [self initData];
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

#pragma mark - lazy load
- (XLUserDetailTable *)table {
    if (!_table) {
        _table = [[XLUserDetailTable alloc] init];
        _table.tableType = XLUserDetailTableType_minePublish;
        _table.delegate = self;
        _table.isMyPublish = YES;
//        kDefineWeakSelf;
//        _table.reloadDataBlock = ^{
//            [WeakSelf initData];
//        };
    }
    return _table;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
