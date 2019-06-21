//
//  XLPDCoinDiamondView.m
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPDCoinDiamondView.h"
#import "XLBigDiamondView.h"
#import "XLSmallDiamondView.h"

@interface XLPDCoinDiamondView () <XLSmallDiamondViewDelegate>

@property (nonatomic, strong) XLSmallDiamondView *diamondView;
@property (nonatomic, strong) XLBigDiamondView *bigView;
@property (nonatomic, strong) UILabel *notdataL;

@end

@implementation XLPDCoinDiamondView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.diamondView = [[XLSmallDiamondView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XLSmallDiamondViewHeight))];
    [self addSubview:self.diamondView];
    self.diamondView.delegate = self;
    //self.diamondView.dataList = @[@"1", @"2", @"3", @"4", @"5"];
    
    self.notdataL = [[UILabel alloc] init];
    [self addSubview:self.notdataL];
    [self.notdataL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:16.f];
    self.notdataL.textAlignment = NSTextAlignmentCenter;
    self.notdataL.text = @"正在产星中...";
    self.notdataL.hidden = YES;
    
    self.bigView = [[XLBigDiamondView alloc] init];
    [self addSubview:self.bigView];
    kDefineWeakSelf;
    self.bigView.didSelect = ^{
        [WeakSelf onGetPDCoinAction];
    };
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.notdataL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.diamondView);
    }];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-81 * kWidthRatio6s);
        make.width.height.mas_offset(88 * kWidthRatio6s);
    }];
}

- (void)setData:(NSArray *)data {
    _data = data;
    self.diamondView.dataList = _data;

    self.notdataL.hidden = !XLArrayIsEmpty(_data);
}

- (void)onGetPDCoinAction {
    NSLog(@"点击领取");
    [self.diamondView allPaopaoClick];
}

#pragma mark - XLSmallDiamondViewDelegate
- (void)smallDiamondView:(XLSmallDiamondView *)smallDiamondView didPappaoAtIndex:(NSInteger)index isLastOne:(BOOL)isLastOne {
    NSLog(@"点了%zd", index);
    
    if (isLastOne) {
        // 点了最后一个，刷新
        //self.diamondView.dataList = @[@"10", @"5", @"2", @"2", @"1", @"3.33"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pdCoinDiamondView:didPappaoAtIndex:isLastOne:)]) {
        [_delegate pdCoinDiamondView:self didPappaoAtIndex:index isLastOne:isLastOne];
    }
}

@end
