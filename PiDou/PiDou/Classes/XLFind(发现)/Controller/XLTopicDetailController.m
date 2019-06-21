//
//  XLTopicDetailController.m
//  PiDou
//
//  Created by kevin on 7/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTopicDetailController.h"
#import "XLUserNaviBar.h"
#import "XLSearchTable.h"
#import "XLFansFocusHandle.h"
#import "XLTopicModel.h"
#import "XLPlayerManager.h"

@interface XLTopicDetailController () <XLSearchTableDelegate>

@property (nonatomic, strong) XLUserNaviBar *naviBar;
@property (nonatomic, strong) XLSearchTable *table;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) XLTopicModel *topicModel;
@property (nonatomic, assign) int page;

@end

@implementation XLTopicDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
    
    [self didLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData) name:XLTopicFocusNotification object:nil];
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
    
    
    
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.table.tableView];
    self.table.searchType = XLSearchType_topicDetail;
    
    self.table.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.table.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    if (@available(iOS 11.0, *)) {
        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.naviBar];
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
    [XLFansFocusHandle topicDetailWithTopic_id:self.topic_id page:self.page success:^(XLTopicModel *topicModel) {
        [HUDController hideHUD];
        WeakSelf.topicModel = topicModel;
        
    
        XLAppUserModel *user = [[XLAppUserModel alloc] init];
        user.nickname = topicModel.topic_name;
        user.followed = topicModel.followed;
        user.avatar = topicModel.topic_cover;
        user.isTopic = YES;
        user.user_id = topicModel.topic_id;
        WeakSelf.naviBar.user = user;
        
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:topicModel.entities];
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
            WeakSelf.data = topicModel.entities.mutableCopy;
        }
        WeakSelf.topicModel.entities = WeakSelf.data;
        WeakSelf.table.topicModel = WeakSelf.topicModel;
        
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        WeakSelf.topicModel.entities = WeakSelf.data;
        WeakSelf.table.data = WeakSelf.data;
        
    }];
}

#pragma mark - XLSearchTableDelegate
- (void)searchTable:(XLSearchTable *)searchTable contentOffsetY:(CGFloat)contentOffsetY {
    if (contentOffsetY > 90 * kWidthRatio6s) {
        self.naviBar.isUser = YES;
    } else {
        self.naviBar.isUser = NO;
    }
}

#pragma mark - lazy load
- (XLSearchTable *)table {
    if (!_table) {
        _table = [[XLSearchTable alloc] init];
        _table.delegate = self;
//        kDefineWeakSelf;
//        _table.reloadDataBlock = ^{
//            [WeakSelf didLoadData];
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

- (XLUserNaviBar *)naviBar {
    if (!_naviBar) {
        _naviBar = [[XLUserNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
        kDefineWeakSelf;
        _naviBar.updateFinish = ^{
            [WeakSelf initData];
        };
    }
    return _naviBar;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
