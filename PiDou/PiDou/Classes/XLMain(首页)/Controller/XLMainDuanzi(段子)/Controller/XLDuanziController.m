//
//  XLDuanziController.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLDuanziController.h"
#import "XLDuanziTable.h"
#import "XLTieziHandle.h"

@interface XLDuanziController ()

@property (nonatomic, strong) XLDuanziTable *table;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@property (nonatomic, assign) BOOL onceDidload;

@property(nonatomic, assign) BOOL isLoadMore;

@end

@implementation XLDuanziController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"段子";
    
    [self initUI];
    [self didLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"doubleClickHomeTabBarItem" object:nil];
    
}

- (void)refreshUI {
    if ([self isShowingOnKeyWindow:self]) {
        NSLog(@"刷新段子页面");
        [self.table.tableView.mj_header beginRefreshing];
        [self.table.tableView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
}

- (void)initUI {
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H - XL_TABBAR_H);
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
    _isLoadMore = NO;
    _page = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"page"];
    if (!_page) {
        _page = 1;
    } else {
        _page++;
    }
    
    [self initData];
}

- (void)loadMoreData {
    _isLoadMore = YES;
    _page++;
    [self initData];
}

- (void)initData {
    kDefineWeakSelf;
    if (!self.onceDidload) {
        [HUDController xl_showHUD];
        self.onceDidload = YES;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:_page forKey:@"page"];
    [XLTieziHandle tieziListWithPage:self.page category:@"text" success:^(id  _Nonnull responseObject) {
       // [HUDController hideHUD];
//        if (WeakSelf.page > 1) {
//            [WeakSelf.table.tableView.mj_footer endRefreshing];
//            [WeakSelf.data addObjectsFromArray:responseObject];
//        } else {
//            [WeakSelf.table.tableView.mj_header endRefreshing];
//            WeakSelf.data = responseObject;
//        }
        if (WeakSelf.isLoadMore) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
            WeakSelf.data = responseObject;
        }
        
        WeakSelf.table.data = WeakSelf.data;
    } failure:^(id  _Nonnull result) {
       // [HUDController xl_hideHUDWithResult:result];
//        if (WeakSelf.page > 1) {
//            [WeakSelf.table.tableView.mj_footer endRefreshing];
//            WeakSelf.page--;
//        } else {
//            [WeakSelf.table.tableView.mj_header endRefreshing];
//        }
        if (WeakSelf.isLoadMore) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        
        WeakSelf.table.data = WeakSelf.data;
    }];
    [HUDController hideHUD];
}

#pragma mark - mark
- (XLDuanziTable *)table {
    if (!_table) {
        _table = [[XLDuanziTable alloc] init];
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

@end
