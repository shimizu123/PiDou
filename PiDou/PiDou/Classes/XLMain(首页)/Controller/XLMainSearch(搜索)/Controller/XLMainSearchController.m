//
//  XLMainSearchController.m
//  PiDou
//
//  Created by ice on 2019/4/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMainSearchController.h"
#import "XLSearchNaviBar.h"
#import "XLAddkeywordView.h"
#import "XLSearchResultView.h"
#import "XLSearchHandle.h"
#import "XLFansModel.h"
#import "XLSearchRecordModel.h"
#import "XLPlayerManager.h"

@interface XLMainSearchController () <XLSearchNaviBarDelegate, XLSearchResultViewDelegate, XLAddkeywordViewDelegate>

@property (nonatomic, strong) XLSearchNaviBar *searchBar;
@property (nonatomic, strong) XLAddkeywordView *keywordView;

@property (nonatomic, strong) NSMutableArray *keywords;

@property (nonatomic, strong) UILabel *recordTitleL;
@property (nonatomic, strong) UIButton *clearRecordButton;

@property (nonatomic, strong) XLSearchResultView *searchResultView;
@property (nonatomic, assign) NSInteger searchIndex;

@end

@implementation XLMainSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [XLPlayerManager appear];
    if (self.searchResultView.hidden == NO) {
        [self.searchResultView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XLPlayerManager disappear];
}

- (void)initUI {
    self.searchBar = [[XLSearchNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
    self.recordTitleL = [[UILabel alloc] initWithFrame:(CGRectMake(16 * kWidthRatio6s, CGRectGetMaxY(self.searchBar.frame) + 16 * kWidthRatio6s, 100 * kWidthRatio6s, 20 * kWidthRatio6s))];
    [self.view addSubview:self.recordTitleL];
    [self.recordTitleL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.recordTitleL.text = @"搜索记录";
    
    self.clearRecordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:self.clearRecordButton];
    [self.clearRecordButton xl_setImageName:@"search_trash" target:self action:@selector(clearRecordAction)];
//    [self.clearRecordButton setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
//    [self.clearRecordButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    self.clearRecordButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16 * kWidthRatio6s);
    
    self.keywordView = [[XLAddkeywordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.recordTitleL.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.recordTitleL.frame))];
    [self.view addSubview:self.keywordView];
    self.keywordView.delegate = self;
    [self.keywordView addTags:self.keywords];
    
    self.searchResultView = [[XLSearchResultView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame)))];
    [self.view addSubview:self.searchResultView];
    self.searchResultView.hidden = YES;
    self.searchResultView.delegate = self;
    
    [self initLayout];
}

- (void)initLayout {

    
    [self.clearRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordTitleL);
        make.right.equalTo(self.view).mas_offset(0);
        make.width.mas_offset(48 * kWidthRatio6s);
//        make.height.mas_offset(32 * kWidthRatio6s);
    }];
    
}

- (void)initSearchDataWithText:(NSString *)text {
    if (XLStringIsEmpty(text)) {
        return;
    }
    
    [self.view endEditing:YES];
    
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
    [XLSearchHandle searchResultWithKeyword:text page:1 category:category success:^(id result) {
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
    self.searchBar.text = searchText;
    if (XLStringIsEmpty(searchText)) {
        
        self.searchResultView.hidden = YES;
    } else {
        self.searchResultView.hidden = NO;
        [self initSearchDataWithText:searchText];
    }
}



#pragma mark - 清空搜索记录
- (void)clearRecordAction {
    XLLog(@"清空搜索记录");
    [self.keywords removeAllObjects];
    [self clearRecord];
    [self.keywordView addTags:self.keywords];
}

#pragma mark - XLSearchResultViewDelegate
- (void)searchResultView:(XLSearchResultView *)searchResultView didSegmentWithIndex:(NSInteger)index {
    self.searchIndex = index;
    [self initSearchDataWithText:self.searchBar.text];
}


#pragma mark - XLSearchNaviBarDelegate
- (void)searchBar:(XLSearchNaviBar *)searchBar textDidChange:(NSString *)searchText {

  //  [self initDataWithSearchText:searchText];
}
- (void)searchBarDidBeginEditing:(XLSearchNaviBar *)searchBar {
    
}
- (void)searchBarDidEndEditing:(XLSearchNaviBar *)searchBar {
    [self searchBarDidSearch];
}
- (void)searchBarDidBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarDidSearch {

    NSString *keyword = self.searchBar.text;
    if (!XLStringIsEmpty(keyword)) {
        [self initDataWithSearchText:keyword];
        XLSearchRecordModel *record = [[XLSearchRecordModel alloc] init];
        record.keyword = keyword;
        if (![self.keywords containsObject:keyword]) {
            [self addRecord:record];
            [self.keywords addObject:keyword];
        }
    }
    [self.keywordView addLastTag:keyword];
}

#pragma mark - XLAddkeywordViewDelegate
- (void)addkeywordView:(XLAddkeywordView *)addkeywordView didSelectedAtIndex:(NSInteger)index {
    //XLLog(@"%@",self.keywords[index]);
    [self initDataWithSearchText:self.keywords[index]];
}

#pragma mark - lazy load
- (NSMutableArray *)keywords {
    if (!_keywords) {
        NSArray *data = [NSMutableArray arrayWithArray:[self findAll]];
        _keywords = [NSMutableArray array];
        for (XLSearchRecordModel *record in data) {
            [_keywords addObject:record.keyword];
        }
        
    }
    return _keywords;
}

- (BOOL)addRecord:(XLSearchRecordModel *)record {
    record.bg_tableName = @"kSearchRecordTable";
    BOOL isSave = [record bg_saveOrUpdate];
    if (!isSave) {
        XLLog(@"存储失败");
    }
    return isSave;
}

- (NSArray *)findAll {
   return [XLSearchRecordModel bg_findAll:@"kSearchRecordTable"];
}

- (BOOL)clearRecord {
    return [XLSearchRecordModel bg_clear:@"kSearchRecordTable"];
}

@end
