//
//  XLMineCollectionController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineCollectionController.h"
#import "XLSearchTable.h"
#import "XLFansFocusHandle.h"
#import "XLPlayerManager.h"

@interface XLMineCollectionController ()

@property (nonatomic, strong) XLSearchTable *table;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@end

@implementation XLMineCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    
    [self initUI];
    
    [self didLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [XLPlayerManager appear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XLPlayerManager disappear];
}


- (void)initUI {
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.table.tableView];
    self.table.searchType = XLSearchType_allNotTopic;
    
    self.table.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.table.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    if (@available(iOS 11.0, *)) {
        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLFansFocusHandle myCollectedWithPage:self.page success:^(id  _Nonnull responseObject) {
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
        [HUDController hideHUD];
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshingWithNoMoreData];
            WeakSelf.page--;
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        WeakSelf.table.data = WeakSelf.data;
    }];
}


#pragma mark - lazy load
- (XLSearchTable *)table {
    if (!_table) {
        _table = [[XLSearchTable alloc] init];
        _table.searchType = XLSearchType_allNotTopic;
        kDefineWeakSelf;
        _table.reloadDataBlock = ^{
            [WeakSelf didLoadData];
        };
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
