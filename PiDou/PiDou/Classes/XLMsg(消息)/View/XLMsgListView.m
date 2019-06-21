//
//  XLMsgListView.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMsgListView.h"
#import "XLMsgListCell.h"

#define CELL_H 48 * kWidthRatio6s

@interface XLMsgListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XLBaseTableView *tableView;
@property (nonatomic, copy) NSArray *lists;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) XLCompletedBlock complete;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation XLMsgListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    
    
    self.tableView.frame = self.bounds;
    [self addSubview:self.tableView];
    
    self.closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(tap) forControlEvents:(UIControlEventTouchUpInside)];
    CGFloat y = CELL_H * self.lists.count;
    self.closeButton.frame = CGRectMake(0, y, self.xl_w, SCREEN_HEIGHT - y);
    
    self.selectIndex = 0;
}

- (void)tap {
    if (self.complete) {
        self.complete(@(-1));
    }
}

- (instancetype)initMsgListViewWithComplete:(XLCompletedBlock)complete {
    self.complete = complete;
    return [self initWithFrame:(CGRectMake(0, XL_NAVIBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H))];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSInteger row = indexPath.row;
    static NSString *ID = @"kcell";
    XLMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XLMsgListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    cell.listName = self.lists[indexPath.row];
    cell.select = self.selectArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_H;
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
    [self.selectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.row == idx) {
            self.selectArr[idx] = @"1";
            self.selectIndex = indexPath.row;
        } else {
            self.selectArr[idx] = @"0";
        }
    }];
    [self.tableView reloadData];
    if (self.complete) {
        self.complete(@(indexPath.row));
    }
}

#pragma mark - lazy load
- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self setup];
    }
    return _tableView;
}

- (NSArray *)lists {
    if (!_lists) {
        _lists = @[@"全部消息",@"评论与回复",@"赞",@"关注",@"通知"];
    }
    return _lists;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray arrayWithObjects:@"1",@"0",@"0",@"0",@"0", nil];
    }
    return _selectArr;
}


- (void)setViewAnimaWithHeight:(CGFloat)height {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = height;
        self.tableView.frame = rect;

    } completion:nil];
}

- (void)show {
    self.hidden = NO;
     [self setViewAnimaWithHeight:SCREEN_HEIGHT - XL_NAVIBAR_H];
    
}
- (void)dismiss {
    self.hidden = YES;
    [self setViewAnimaWithHeight:0];
}

@end
