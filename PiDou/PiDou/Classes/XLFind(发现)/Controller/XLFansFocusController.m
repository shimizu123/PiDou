//
//  XLFansFocusController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLFansFocusController.h"
#import "XLSearchUserCell.h"
#import "XLFansFocusHandle.h"

static NSString * XLSearchUserCellID = @"kXLSearchUserCell";

@interface XLFansFocusController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@end

@implementation XLFansFocusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"粉丝";
    
    [self initUI];
    
    [self didLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.vcType == XLFansFocusVCType_myfocus) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H - 44 * kWidthRatio6s);
    } else {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    }
    
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    switch (_vcType) {
        case XLFansFocusVCType_fans:
        {
            [XLFansFocusHandle fansListWithPage:self.page user_id:self.user_id success:^(id  _Nonnull responseObject) {
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
            break;
            
        case XLFansFocusVCType_focus:
        case XLFansFocusVCType_myfocus:
        {
            [XLFansFocusHandle focusListWithUser_id:self.user_id success:^(id  _Nonnull responseObject) {
                if (WeakSelf.page > 1) {
                    [WeakSelf.tableView.mj_footer endRefreshing];
                    WeakSelf.page = 1;
                } else {
                    [WeakSelf.tableView.mj_header endRefreshing];
                }
                WeakSelf.data = responseObject;
                [WeakSelf.tableView reloadData];
            } failure:^(id  _Nonnull result) {
                if (WeakSelf.page > 1) {
                    [WeakSelf.tableView.mj_footer endRefreshing];
                    WeakSelf.page = 1;
                } else {
                    [WeakSelf.tableView.mj_header endRefreshing];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)setVcType:(XLFansFocusVCType)vcType {
    _vcType = vcType;
    switch (_vcType) {
        case XLFansFocusVCType_fans:
        {
            self.navigationItem.title = @"粉丝";
        }
            break;
        
        case XLFansFocusVCType_focus:
        {
            self.navigationItem.title = @"关注";
        }
            break;
        default:
            break;
    }
}





- (void)setup {
    [self registerCell];
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
    
    userCell.cellType = XLSearchUserCellType_noFansNum;
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
        
        [self setup];
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
