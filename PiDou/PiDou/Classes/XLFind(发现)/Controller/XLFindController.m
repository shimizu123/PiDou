//
//  XLFindController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLFindController.h"
#import "XLSearchNaviBar.h"
#import "XLSegment.h"
#import "XLFindTable.h"
#import "XLSearchResultView.h"
#import "XLFansFocusHandle.h"
#import "XLTopicModel.h"
#import "XLSearchHandle.h"
#import "XLFansModel.h"
#import "XLLaunchManager.h"
#import "XLPlayerManager.h"

@interface XLFindController () <XLSearchNaviBarDelegate, XLSegmentDelegate, XLSearchResultViewDelegate>

@property (nonatomic, strong) XLSearchNaviBar *searchBar;

@property (nonatomic, strong) XLSegment *segment;

@property (nonatomic, strong) XLFindTable *table;

@property (nonatomic, strong) XLSearchResultView *searchResultView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger searchIndex;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@end

@implementation XLFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
    
    [self didLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [XLPlayerManager appear];
    if (self.searchResultView.hidden == NO) {
        [self.searchResultView reloadData];
    }
    kDefineWeakSelf;
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self finish:^{
            [WeakSelf goTabBarItem];
        }];
        return;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XLPlayerManager disappear];
}

- (void)goTabBarItem {
    [self.tabBarController setSelectedIndex:0];
}


- (void)initUI {
    self.searchBar = [[XLSearchNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
    
    
    CGFloat segmentH = 44 * kWidthRatio6s;
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"我的关注",@"热门话题"] frame:(CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, segmentH)) font:[UIFont xl_fontOfSize:16.f] botH:0 autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    self.segment.delegate = self;
    
    self.table.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.segment.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.segment.frame) - XL_TABBAR_H);
    [self.view addSubview:self.table.tableView];
    self.table.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.table.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    if (@available(iOS 11.0, *)) {
        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.searchResultView = [[XLSearchResultView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame)))];
    [self.view addSubview:self.searchResultView];
    self.searchResultView.hidden = YES;
    self.searchResultView.delegate = self;
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
    if (self.index == 0) {
        if (XLStringIsEmpty([XLUserHandle userid])) {
            WeakSelf.table.data = WeakSelf.data;
            return;
        }
        [HUDController xl_showHUD];
        [XLFansFocusHandle myFollowTopicsWithPage:self.page success:^(id  _Nonnull responseObject) {
           // [HUDController hideHUD];
            if (WeakSelf.page > 1) {
                [WeakSelf.table.tableView.mj_footer endRefreshing];
                [WeakSelf.data addObjectsFromArray:responseObject];
            } else {
                [WeakSelf.table.tableView.mj_header endRefreshing];
                WeakSelf.data = responseObject;
            }
            WeakSelf.table.data = WeakSelf.data;
        } failure:^(id  _Nonnull result) {
          // [HUDController xl_hideHUDWithResult:result];
            if (WeakSelf.page > 1) {
                [WeakSelf.table.tableView.mj_footer endRefreshing];
                WeakSelf.page--;
            } else {
                [WeakSelf.table.tableView.mj_header endRefreshing];
            }
            WeakSelf.table.data = WeakSelf.data;
        }];
        [HUDController hideHUD];
    } else {
        [HUDController xl_showHUD];
        [XLFansFocusHandle hotTopicsWithPage:self.page success:^(id  _Nonnull responseObject) {
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
            [HUDController xl_hideHUDWithResult:result];
            if (WeakSelf.page > 1) {
                [WeakSelf.table.tableView.mj_footer endRefreshing];
                WeakSelf.page--;
            } else {
                [WeakSelf.table.tableView.mj_header endRefreshing];
            }
            WeakSelf.table.data = WeakSelf.data;
        }];
    }
}


- (void)initSearchData {
    if (XLStringIsEmpty(self.searchBar.text)) {
        return;
    }
    
    NSString *category = @"";
    switch (self.searchIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            category = @"video";
        }
            break;
        case 2:
        {
            category = @"pic";
        }
            break;
        case 3:
        {
            category = @"text";
        }
            break;
        case 4:
        {
            category = @"user";
        }
            break;
        case 5:
        {
            category = @"topic";
        }
            break;
            
        default:
            break;
    }
    self.searchResultView.data = nil;
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLSearchHandle searchResultWithKeyword:self.searchBar.text page:1 category:category success:^(id result) {
        [HUDController hideHUD];
        if (WeakSelf.searchIndex == 0) {
            XLSearchModel *searchModel = [XLSearchModel mj_objectWithKeyValues:result];
            WeakSelf.searchResultView.searchModel = searchModel;
        } else if (WeakSelf.searchIndex == 4) {
            NSMutableArray *userData = [XLFansModel mj_objectArrayWithKeyValuesArray:result];
            WeakSelf.searchResultView.data = userData;
        } else if (WeakSelf.searchIndex == 5) {
            NSMutableArray *topicData = [XLTopicModel mj_objectArrayWithKeyValuesArray:result];
            WeakSelf.searchResultView.data = topicData;
        } else {
            
            NSMutableArray *tieziData = [XLTieziModel mj_objectArrayWithKeyValuesArray:result];
            WeakSelf.searchResultView.data = tieziData;
        }
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)initDataWithSearchText:(NSString *)searchText {
    XLLog(@"searchText:%@",searchText);
    
    if (XLStringIsEmpty(searchText)) {
        
        self.searchResultView.hidden = YES;
    } else {
        self.searchResultView.hidden = NO;
        [self initSearchData];
    }
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    self.index = index;
    [self didLoadData];
}

#pragma mark - XLSearchResultViewDelegate
- (void)searchResultView:(XLSearchResultView *)searchResultView didSegmentWithIndex:(NSInteger)index {
    self.searchIndex = index;
    [self initSearchData];
}


#pragma mark - XLSearchNaviBarDelegate
- (void)searchBar:(XLSearchNaviBar *)searchBar textDidChange:(NSString *)searchText {
   // [self initDataWithSearchText:searchText];
}
- (void)searchBarDidBeginEditing:(XLSearchNaviBar *)searchBar {
    
}
- (void)searchBarDidEndEditing:(XLSearchNaviBar *)searchBar {
    
}
- (void)searchBarDidBack {
    [self.view endEditing:YES];
    [self initDataWithSearchText:self.searchBar.text];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarDidSearch {
    [self initDataWithSearchText:self.searchBar.text];
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
