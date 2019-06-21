//
//  XLSearchNaviBar.m
//  CBNReporterVideo
//
//  Created by kevin on 12/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLSearchNaviBar.h"
#import "UIImage+TGExtension.h"
#import "XLSearchBar.h"

@interface XLSearchNaviBar () <UISearchBarDelegate>

@property (nonatomic, strong) XLSearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIView *hLine;

@end

@implementation XLSearchNaviBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.cancleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.cancleBtn];
    [self.cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.cancleBtn setTitleColor:XL_COLOR_DARKBLACK forState:(UIControlStateNormal)];
    self.cancleBtn.titleLabel.font = [UIFont xl_fontOfSize:16.f];
    [self.cancleBtn addTarget:self action:@selector(goBack:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.searchBar = [[XLSearchBar alloc] init];
    [self addSubview:self.searchBar];
    self.searchBar.placeholder = @"请输入搜索关键词";
    XLViewRadius(self.searchBar, 15);
    NSDictionary *attributeDic = @{NSFontAttributeName : [UIFont xl_fontOfSize:14.f] , NSStrokeColorAttributeName :COLOR(0xb6b6b8)};
    [self.searchBar setScopeBarButtonTitleTextAttributes:attributeDic forState:UIControlStateNormal];
    
    [self.searchBar setImage:[UIImage imageNamed:@"search_jingzi"] forSearchBarIcon:(UISearchBarIconSearch) state:(UIControlStateNormal)];
    self.searchBar.delegate = self;
    UIImage *bgImage = [UIImage imageWithColor:COLOR(0xf8f8f8) size:(CGSizeMake(SCREEN_WIDTH, 30))];
    [self.searchBar setSearchFieldBackgroundImage:bgImage forState:(UIControlStateNormal)];
    [self.searchBar setBackgroundImage:bgImage forBarPosition:(UIBarPositionAny) barMetrics:(UIBarMetricsDefault)];
    //    self.searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 0);
    
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(5, 0);
    
    
    
    
    self.hLine = [[UIView alloc] init];
    [self addSubview:self.hLine];
    self.hLine.backgroundColor =XL_COLOR_LINE;
    self.hLine.hidden = YES;
    
    [self initLayout];
    
}

- (void)initLayout {
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(XL_LEFT_DISTANCE);
        make.bottom.equalTo(self).mas_offset(-5);
        make.height.mas_offset(30);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBar);
        make.left.equalTo(self.searchBar.mas_right);
        make.right.equalTo(self);
        make.width.mas_offset(62 * kWidthRatio6s);
    }];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(1);
    }];
}

- (void)goBack:(UIButton *)btn {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(searchBarDidBack)]) {
        [_delegate searchBarDidBack];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (_delegate && [_delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]) {
        [_delegate searchBarDidBeginEditing:self];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (_delegate && [_delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
        [_delegate searchBarDidEndEditing:self];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [_delegate searchBar:self textDidChange:searchText];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (_delegate && [_delegate respondsToSelector:@selector(searchBarDidSearch)]) {
        [_delegate searchBarDidSearch];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self goBack:nil];
}

- (NSString *)text {
    return self.searchBar.text;
}

- (void)setText:(NSString *)text {
    self.searchBar.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.searchBar.placeholder = _placeholder;
}

@end
