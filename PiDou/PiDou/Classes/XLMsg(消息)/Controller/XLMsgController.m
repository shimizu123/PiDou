//
//  XLMsgController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMsgController.h"
#import "XLMsgTable.h"
#import "XLNaviArrowView.h"
#import "XLMsgListView.h"
#import "XLMgsHandle.h"
#import "XLLaunchManager.h"

@interface XLMsgController ()

@property (nonatomic, strong) XLMsgTable *table;
@property (nonatomic, strong) XLNaviArrowView *arrowView;
@property (nonatomic, strong) XLMsgListView *listView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) int page;

@end

@implementation XLMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = 0;
    [self initNaviItem];
    [self initUI];
    
    [self didLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    kDefineWeakSelf;
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self finish:^{
            [WeakSelf goTabBarItem];
        }];
        return;
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

- (void)goTabBarItem {
    [self.tabBarController setSelectedIndex:0];
}

- (void)initData {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        return;
    }
    NSString *category = @"";
    
    switch (self.type) {
        case 0:
        {
            // 为空或不传时为全部
            [self.arrowView setTitle:@"全部消息" forState:(UIControlStateNormal)];
        }
            break;
        case 1:
        {
            // 评论和回复
            category = @"comment";
            [self.arrowView setTitle:@"评论与回复" forState:(UIControlStateNormal)];
        }
            break;
        case 2:
        {
            // 点赞
            category = @"do_like";
            [self.arrowView setTitle:@"赞" forState:(UIControlStateNormal)];
        }
            break;
        case 3:
        {
            // 关注
            category = @"follow";
            [self.arrowView setTitle:@"关注" forState:(UIControlStateNormal)];
        }
            break;
        case 4:
        {
            // 通知
            category = @"system";
            [self.arrowView setTitle:@"通知" forState:(UIControlStateNormal)];
        }
            break;
            
            
        default:
            break;
    }
    
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMgsHandle messageWithPage:self.page category:category success:^(NSMutableArray *data) {
       // [HUDController hideHUD];
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            [WeakSelf.data addObjectsFromArray:data];
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
            WeakSelf.data = data;
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
}

- (void)initNaviItem {
    
    self.navigationItem.titleView = self.arrowView;
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
    
    [self.listView dismiss];
}

- (void)didClickArrowView:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.listView show];
    } else {
        [self.listView dismiss];
    }
}

#pragma mark - lazy load
- (XLMsgTable *)table {
    if (!_table) {
        _table = [[XLMsgTable alloc] init];
    }
    return _table;
}

- (XLNaviArrowView *)arrowView {
    if (!_arrowView) {
        _arrowView = [XLNaviArrowView naviArrowView];
        [_arrowView setTitle:@"全部消息" forState:(UIControlStateNormal)];
        [_arrowView setTitleColor:XL_COLOR_DARKBLACK forState:(UIControlStateNormal)];
        [_arrowView setImage:[UIImage imageNamed:@"msg_arrowdown"] forState:(UIControlStateNormal)];
        [_arrowView setImage:[UIImage imageNamed:@"msg_arrowup"] forState:(UIControlStateSelected)];
        _arrowView.frame = CGRectMake(0, 0, 200, 44);
        [_arrowView addTarget:self action:@selector(didClickArrowView:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _arrowView;
}

- (XLMsgListView *)listView {
    if (!_listView) {
        kDefineWeakSelf;
        _listView = [[XLMsgListView alloc] initMsgListViewWithComplete:^(id  _Nonnull result) {
            XLLog(@"点击了:%ld",[result integerValue]);
            if ([result integerValue] != -1) {
                WeakSelf.type = [result integerValue];
                [WeakSelf.data removeAllObjects];
                [WeakSelf didLoadData];
            }
            [WeakSelf didClickArrowView:WeakSelf.arrowView];
        }];
    }
    return _listView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}


@end
