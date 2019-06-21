//
//  XLSearchTopicController.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchTopicController.h"
#import "XLSearchNaviBar.h"
#import "XLFansFocusHandle.h"
#import "XLTopicModel.h"
#import "XLSearchHandle.h"

@interface XLSearchTopicController () <XLSearchNaviBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) XLSearchNaviBar *searchBar;
@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listsArr;
@property (nonatomic, assign) int page;

@end

@implementation XLSearchTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationItem.title = @"搜索话题";
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
    
    [self didLoadData];
}

- (void)initUI {
    self.searchBar = [[XLSearchNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索或新增话题";
    
    self.tableView.frame = CGRectMake(0, XL_NAVIBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - XL_TABBAR_H);
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
    [XLFansFocusHandle hotTopicsWithPage:self.page success:^(id  _Nonnull responseObject) {
        if (WeakSelf.page > 1) {
            [WeakSelf.tableView.mj_footer endRefreshing];
            [WeakSelf.listsArr addObjectsFromArray:responseObject];
        } else {
            [WeakSelf.tableView.mj_header endRefreshing];
            WeakSelf.listsArr = responseObject;
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

- (void)setSelectedTopic:(NSString *)selectedTopic {
    _selectedTopic = selectedTopic;
    if (!XLStringIsEmpty(_selectedTopic)) {
        self.topicVCType = XLSearchTopicVCType_selected;
    } else {
        self.topicVCType = XLSearchTopicVCType_unselected;
    }
}


- (void)initSearchData {
    if (XLStringIsEmpty(self.searchBar.text)) {
        return;
    }
    [self.listsArr removeAllObjects];
    NSString *category = @"topic";
    
    kDefineWeakSelf;
    [XLSearchHandle searchResultWithKeyword:self.searchBar.text page:1 category:category success:^(id result) {
        NSMutableArray *topicData = [XLTopicModel mj_objectArrayWithKeyValuesArray:result];
        WeakSelf.listsArr = topicData;
        [WeakSelf.tableView reloadData];
    } failure:^(id  _Nonnull result) {
        [WeakSelf.tableView reloadData];
        WeakSelf.selectedTopic = WeakSelf.searchBar.text;
    }];
}

- (void)initDataWithSearchText:(NSString *)searchText {
    XLLog(@"searchText:%@",searchText);
    if (!XLStringIsEmpty(self.searchBar.text)) {
        
        [self initSearchData];
    } else {
    }
}


#pragma mark - XLSearchNaviBarDelegate
- (void)searchBar:(XLSearchNaviBar *)searchBar textDidChange:(NSString *)searchText {
    [self initDataWithSearchText:searchText];
}
- (void)searchBarDidBeginEditing:(XLSearchNaviBar *)searchBar {
    
}
- (void)searchBarDidEndEditing:(XLSearchNaviBar *)searchBar {
    
}
- (void)searchBarDidBack {
//    if (!XLStringIsEmpty(self.selectedTopic)) {
//        if (self.didSelectedComplete) {
//            self.didSelectedComplete(self.selectedTopic);
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarDidSearch {
    [self initDataWithSearchText:self.searchBar.text];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.topicVCType == XLSearchTopicVCType_selected ? 1 : 0;
    }
    return self.listsArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        static NSString *cellID = @"kCellTop";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"不发布到任何话题";
        cell.imageView.image = [UIImage imageNamed:@"publish_photo"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellID = @"kCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    if (!XLArrayIsEmpty(self.listsArr)) {
        XLTopicModel *topic = self.listsArr[row];
        cell.textLabel.text = topic.topic_name;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48 * kWidthRatio6s;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 34 * kWidthRatio6s;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 34 * kWidthRatio6s))];
        UILabel *titleL = [[UILabel alloc] initWithFrame:(CGRectMake(16 * kWidthRatio6s, 0, header.xl_w, header.xl_h))];
        [titleL xl_setTextColor:XL_COLOR_BLACK fontSize:12.f];
        [header addSubview:titleL];
        titleL.text = @"热门话题";
        header.backgroundColor = XL_COLOR_BG;
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        self.selectedTopic = @"";
        if (self.didSelectedComplete) {
            self.didSelectedComplete(self.selectedTopic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        XLLog(@"%ld",row);
        XLTopicModel *topic = self.listsArr[row];
        self.selectedTopic = topic.topic_name;
        if (self.didSelectedComplete) {
            self.didSelectedComplete(self.selectedTopic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - lazy load
- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (NSMutableArray *)listsArr {
    if (!_listsArr) {
        _listsArr = [NSMutableArray array];
    }
    return _listsArr;
}

@end
