//
//  XLRecommendController.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLRecommendController.h"
#import "XLSearchTable.h"
#import "XLTieziHandle.h"
#import "XLPlayerManager.h"
#import "XLVideoCell.h"

@interface XLRecommendController ()

@property (nonatomic, strong) XLSearchTable *table;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@property (nonatomic, assign) BOOL onceDidload;

@property (nonatomic, strong) XLVideoCell *playingCell;
@property (nonatomic, copy) NSString *currentVideoPath;

@end

@implementation XLRecommendController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐";
    
    [self initUI];
    [self didLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"doubleClickHomeTabBarItem" object:nil];
}

- (void)refreshUI {
    if ([self isShowingOnKeyWindow:self]) {
        NSLog(@"刷新推荐页面");
        [self.table.tableView.mj_header beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [XLPlayerManager appear];
    [self handleScroll];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XLPlayerManager disappear];
}

- (void)handleScroll{
    // 找到下一个要播放的cell(最在屏幕中心的)
    XLVideoCell *finnalCell = nil;
    NSArray *visiableCells = [self.table.tableView visibleCells];
    NSMutableArray *indexPaths = [NSMutableArray array];
    CGFloat gap = MAXFLOAT;
    for (XLVideoCell *cell in visiableCells) {
        [indexPaths addObject:cell.indexPath];
        if (cell.videoPath.length > 0) {
            // 如果这个cell有视频
            CGPoint coorCenter = [self.table.tableView convertPoint:cell.center toView:self.table.tableView.superview];
            CGFloat delta = fabs(coorCenter.y - SCREEN_HEIGHT / 2);
            if (delta < gap) {
                gap = delta;
                finnalCell = cell;
            }
        }
    }
    if (finnalCell != nil && self.playingCell != finnalCell)  {
        UIButton *button = finnalCell.playButton;
        button.selected = !button.selected;
        if (button.selected && !finnalCell.isDetailVC) {
            button.hidden = YES;
        }
        [XLPlayerManager playVideoWithIndexPath:finnalCell.indexPath tag:1314 scrollView:self.table.tableView videoUrl:finnalCell.videoPath entity_id:finnalCell.entityId];
        self.playingCell = finnalCell;
        self.currentVideoPath = finnalCell.videoPath;
    }
    // 注意, 如果正在播放的cell和finnalCell是同一个cell, 不应该在播放
    BOOL isPlayingCellVisiable = YES;
        if (![indexPaths containsObject:self.playingCell.indexPath]) {
            isPlayingCellVisiable = NO;
        }
    // 当前播放视频的cell移出视线， 或者cell被快速的循环利用了， 都要移除播放器
    if (!isPlayingCellVisiable || ![self.playingCell.videoPath isEqualToString:self.currentVideoPath]) {
        [[XLPlayerManager sharedXLPlayerManager] removePlayer];
    }
    
}


- (void)initUI {
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H - XL_TABBAR_H);
    [self.view addSubview:self.table.tableView];
    self.table.searchType = XLSearchType_allNotTopic;
    
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
    if (!self.onceDidload) {
        [HUDController xl_showHUD];
        self.onceDidload = YES;
    }
    [XLTieziHandle tieziListWithPage:self.page category:@"" success:^(id  _Nonnull responseObject) {
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
}

#pragma mark - lazy load
- (XLSearchTable *)table {
    if (!_table) {
        _table = [[XLSearchTable alloc] init];
        _table.searchType = XLSearchType_allNotTopic;
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

@end
