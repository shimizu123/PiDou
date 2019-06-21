//
//  XLGroupBar.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGroupBar.h"
#import "XLSegment.h"

#define SearchButtonWidth 55 * kWidthRatio6s
@interface XLGroupBar () <XLSegmentDelegate>

@property (nonatomic, strong) XLSegment *segment;
//搜索按钮
@property (nonatomic,strong) UIButton *searchBtn;

@end

@implementation XLGroupBar

+ (instancetype)groupBar {
    return [[self alloc] initWithFrame:(CGRectMake(0, XL_STATUS_H, SCREEN_WIDTH, XL_NAVIBAR_H - XL_STATUS_H))];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)setup {
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"推荐",@"视频",@"图片",@"段子"] frame:(CGRectMake(0, 0, self.xl_w - SearchButtonWidth, self.xl_h)) font:[UIFont xl_fontOfSize:16.f] botH:0 autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.segment];
    self.segment.delegate = self;
    
    self.searchBtn.frame = CGRectMake(CGRectGetMaxX(self.segment.frame), 0, SearchButtonWidth, self.xl_h);
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(groupBar:didSelectIndex:)]) {
        [_delegate groupBar:self didSelectIndex:index];
    }
}

#pragma mark - 点击搜索
- (void)searchAction {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSearchWithGroupBar:)]) {
        [_delegate didSelectSearchWithGroupBar:self];
    }
}

#pragma mark - public method
- (void)didClickWithIndex:(NSInteger)index {
    [self.segment didClickWithIndex:index];
}

- (NSInteger)selectIndex {
    return self.segment.selectIndex;
}


- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.segment.progress = progress;
}

#pragma mark - lazy load
- (UIButton *)searchBtn {
    if (_searchBtn == nil) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_searchBtn];
        [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setImage:[UIImage imageNamed:@"main_search_Black"] forState:UIControlStateNormal];
        [_searchBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _searchBtn;
}


@end
