//
//  OutflowDetailController.m
//  PiDou
//
//  Created by 邓康大 on 2019/9/1.
//  Copyright © 2019 ice. All rights reserved.
//

#import "OutflowDetailController.h"
#import "XLPDCoinHandle.h"
#import "PdcOutflowRecordCell.h"

@interface OutflowDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@end

@implementation OutflowDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"PDCoin流转明细";
    
    [self initUI];
    [self registerCell];
    
    [self didLoadData];
}

- (void)initUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
   // self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    [XLPDCoinHandle outflowDetail:self.page success:^(id  _Nonnull responseObject) {
        if (WeakSelf.page > 1) {
            [WeakSelf.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.tableView.mj_header endRefreshing];
            WeakSelf.data = responseObject;
        }
        [WeakSelf.tableView reloadData];
    } failure:^(id  _Nonnull result) {
        if (WeakSelf.page > 1) {
            [WeakSelf.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [WeakSelf.tableView.mj_header endRefreshing];
        }
    }];
}

- (void)registerCell {
    [self.tableView registerClass:[PdcOutflowRecordCell class] forCellReuseIdentifier:@"PdcOutflowRecordCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PdcOutflowRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PdcOutflowRecordCell" forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.data)) {
        cell.recordModel = self.data[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

@end
