//
//  XLSearchResultView.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchResultView.h"
#import "XLSegment.h"
#import "XLSearchTable.h"
#import "XLSearchModel.h"

@interface XLSearchResultView () <XLSegmentDelegate>

@property (nonatomic, strong) XLSegment *segment;

@property (nonatomic, strong) XLSearchTable *table;

@end

@implementation XLSearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat segmentH = 44 * kWidthRatio6s;
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"综合",@"视频",@"图片",@"段子",@"用户",@"主题"] frame:(CGRectMake(0, 0, self.xl_w, segmentH)) font:[UIFont xl_fontOfSize:16.f] botH:0 autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.segment];
    self.segment.delegate = self;
    
    self.table.tableView.frame = CGRectMake(0, segmentH, self.xl_w, self.xl_h - segmentH);
    [self addSubview:self.table.tableView];
    
    self.table.searchType = XLSearchType_all;
//    if (@available(iOS 11.0, *)) {
//        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.parentController.automaticallyAdjustsScrollViewInsets = NO;
//    }
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(searchResultView:didSegmentWithIndex:)]) {
        [_delegate searchResultView:self didSegmentWithIndex:index];
    }
    switch (index) {
        case 0:
        {
            self.table.searchType = XLSearchType_all;
        }
            break;
        case 1:
        {
            self.table.searchType = XLSearchType_video;
        }
            break;
        case 2:
        {
            self.table.searchType = XLSearchType_picture;
        }
            break;
        case 3:
        {
            self.table.searchType = XLSearchType_duanzi;
        }
            break;
        case 4:
        {
            self.table.searchType = XLSearchType_user;
        }
            break;
        case 5:
        {
            self.table.searchType = XLSearchType_topic;
        }
            break;

        default:
            break;
    }
}

- (void)setSearchModel:(XLSearchModel *)searchModel {
    _searchModel = searchModel;
    self.table.searchModel = _searchModel;
}

- (void)setData:(NSMutableArray *)data {
    _data = data;
    self.table.data = _data;
}
- (void)reloadData {
    [self.table.tableView reloadData];
}

#pragma mark - lazy load
- (XLSearchTable *)table {
    if (!_table) {
        _table = [[XLSearchTable alloc] init];
    }
    return _table;
}

@end
