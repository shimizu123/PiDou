//
//  XLMineTopicController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineTopicController.h"
#import "XLFindTable.h"
#import "XLFansFocusHandle.h"
#import "XLTopicModel.h"
#import "XLPlayerManager.h"

@interface XLMineTopicController ()

@property (nonatomic, strong) XLFindTable *table;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@end

@implementation XLMineTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self didLoadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [XLPlayerManager appear];
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.xl_h);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XLPlayerManager disappear];
}

- (void)initUI {
    
    [self.view addSubview:self.table.tableView];
    self.table.tableView.contentInset = UIEdgeInsetsMake(0, 0, XL_HOME_INDICATOR_H, 0);
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

- (void)initData {
    kDefineWeakSelf;
    [XLFansFocusHandle myFollowTopicsWithPage:self.page success:^(id  _Nonnull responseObject) {
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
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        WeakSelf.table.data = WeakSelf.data;
    }];
}



#pragma mark - lazy load
-(XLFindTable *)table {
    if (!_table) {
        _table = [[XLFindTable alloc] init];
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
