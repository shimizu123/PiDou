//
//  XLMineInviteController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineInviteController.h"
#import "XLSegment.h"
#import "XLSearchUserCell.h"
#import "XLMineHandle.h"

static NSString * XLSearchUserCellID = @"kXLSearchUserCell";
@interface XLMineInviteController () <XLSegmentDelegate, UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) XLSegment *segment;
@property (nonatomic, strong) UIView *hLine;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@end

@implementation XLMineInviteController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的邀请";
    
    [self initUI];
    
    [self didLoadData];
}


- (void)initUI {
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"直接邀请",@"间接邀请"] frame:(CGRectMake(60 * kWidthRatio6s, 0, SCREEN_WIDTH - 120 * kWidthRatio6s, 44 * kWidthRatio6s)) font:[UIFont xl_fontOfSize:14.f] botH:0 autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    self.segment.delegate = self;
    
    self.hLine = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.segment.frame), SCREEN_WIDTH, 1))];
    [self.view addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.hLine.frame), SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    [HUDController xl_showHUD];
    [XLMineHandle myInviteWithDirect:self.index+1 page:self.page success:^(id  _Nonnull responseObject) {
        [HUDController hideHUD];
        if (WeakSelf.page > 1) {
            [WeakSelf.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.tableView.mj_header endRefreshing];
            WeakSelf.data = responseObject;
        }
        [WeakSelf.tableView reloadData];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        if (WeakSelf.page > 1) {
            [WeakSelf.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [WeakSelf.tableView.mj_header endRefreshing];
        }
        [WeakSelf.tableView reloadData];
    }];
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    self.index = index;
    [self.data removeAllObjects];
    [self didLoadData];
}



- (void)registerCell {
    [_tableView registerClass:[XLSearchUserCell class] forCellReuseIdentifier:XLSearchUserCellID];
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
    XLSearchUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:XLSearchUserCellID forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.data)) {
        userCell.fansModel = self.data[row];
    }
    
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return userCell;
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
    
}

#pragma mark - lazy load
- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, XL_HOME_INDICATOR_H, 0);
        //        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self registerCell];
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
