//
//  XLXingRewardView.m
//  PiDou
//
//  Created by ice on 2019/5/12.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLXingRewardView.h"
#import "UIButton+XLAdd.h"
#import "XLXingRewardCell.h"
#import "XLMineHandle.h"
#import "XLWalletInfoModel.h"
#import "XLRechargeController.h"

#define MinSpacing 16 * kWidthRatio6s

static NSString *XLXingRewardCellID = @"kXLXingRewardCell";


@interface XLXingRewardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *remindButton;

@property (nonatomic, strong) XLBaseCollectionView *collectionView;

@property (nonatomic, strong) UILabel *xingNumL;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *rewardButton;

@property (nonatomic, assign) NSInteger item;

@property (nonatomic, copy) NSArray *data;

@property (nonatomic, strong) NSNumber *coin;
@property (nonatomic, strong) NSNumber *rmb2coin;

@end

@implementation XLXingRewardView

+ (instancetype)xingRewardView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.item = 0;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    
    
    self.topButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.topButton];
    [self.topButton addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.botView = [[UIView alloc] init];
    [self addSubview:self.botView];
    self.botView.backgroundColor = [UIColor whiteColor];
    XLViewRadius(self.botView, 8 * kWidthRatio6s);
    
    self.titleL = [[UILabel alloc] init];
    [self.botView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.titleL.text = @"星票打赏";
    self.titleL.textAlignment = NSTextAlignmentCenter;
    
    self.remindButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.botView addSubview:self.remindButton];
    [self.remindButton xl_setTitle:@"打赏10星票礼物返还0PDCoin" color:XL_COLOR_DARKGRAY size:11.f];
    [self.remindButton setImage:[UIImage imageNamed:@"mine_remind"] forState:(UIControlStateNormal)];
    [self.remindButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.remindButton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleLeft) imageTitleSpace:2 * kWidthRatio6s];
    self.remindButton.hidden = YES;
    
    [self.botView addSubview:self.collectionView];
    
    
    self.xingNumL = [[UILabel alloc] init];
    [self.botView addSubview:self.xingNumL];
    [self.xingNumL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    self.xingNumL.text = @"我的星票：0";
    self.xingNumL.textAlignment = NSTextAlignmentCenter;
    
    self.addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.botView addSubview:self.addButton];
    [self.addButton xl_setTitle:@"充值>>" color:XL_COLOR_RED size:14.f target:self action:@selector(addXingAction:)];
    [self.addButton setContentEdgeInsets:(UIEdgeInsetsMake(0, XL_LEFT_DISTANCE, 0, 0))];
    
    self.rewardButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.botView addSubview:self.rewardButton];
    [self.rewardButton xl_setTitle:@"确认打赏" color:[UIColor whiteColor] size:16.f target:self action:@selector(rewardAction:)];
    self.rewardButton.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.rewardButton, 16 * kWidthRatio6s);
    
    [self initLayout];
    
    [self initData];
}

- (void)initData {
    self.rewardButton.enabled = NO;
    self.addButton.enabled = NO;
    self.hidden = YES;
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMineHandle walletInfoWithSuccess:^(XLWalletInfoModel *responseObject) {
        [HUDController hideHUD];
        self.rewardButton.enabled = YES;
        self.addButton.enabled = YES;
        WeakSelf.hidden = NO;
        WeakSelf.coin = responseObject.coin;
        WeakSelf.rmb2coin = responseObject.rmb2coin;
        if ([responseObject.generate_pdcoin boolValue]) {
            self.remindButton.hidden = NO;
            [self.remindButton setTitle:[NSString stringWithFormat:@"打赏10星票礼物返还%.0fPDCoin",responseObject.coin2pdcoin.floatValue * 10] forState:(UIControlStateNormal)];
            [self.remindButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.titleL);
                make.top.equalTo(self.titleL.mas_bottom).mas_offset(23 * kWidthRatio6s);
                make.height.mas_offset(16 * kWidthRatio6s);
            }];
        } else {
            self.remindButton.hidden = YES;
            [self.remindButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.titleL);
                make.top.equalTo(self.titleL.mas_bottom).mas_offset(2 * kWidthRatio6s);
                make.height.mas_offset(0.1);
            }];
        }
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        WeakSelf.rewardButton.enabled = YES;
        WeakSelf.addButton.enabled = YES;
        WeakSelf.hidden = NO;
    }];
}

- (void)setCoin:(NSNumber *)coin {
    _coin = coin;
    self.xingNumL.text = [NSString stringWithFormat:@"我的星票：%@",_coin];
}

- (void)setRmb2coin:(NSNumber *)rmb2coin {
    _rmb2coin = rmb2coin;
}

- (void)initLayout {
    
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.botView.mas_top);
    }];
    
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.botView).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.botView).mas_offset(12 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
    }];
    
    [self.remindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom).mas_offset(23 * kWidthRatio6s);
        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.botView);
        make.height.mas_offset(120 * kWidthRatio6s);
        make.top.equalTo(self.remindButton.mas_bottom).mas_offset(1 * kWidthRatio6s);
    }];
    
    [self.xingNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(1);
        make.bottom.equalTo(self.botView).mas_offset(-XL_HOME_INDICATOR_H - 8 * kWidthRatio6s);
        make.height.mas_offset(64 * kWidthRatio6s);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xingNumL.mas_right).mas_offset(1);
        make.top.bottom.equalTo(self.xingNumL);
        make.right.equalTo(self.rewardButton.mas_left).mas_offset(-XL_LEFT_DISTANCE).with.priorityLow();
    }];
    
    [self.rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.botView).mas_offset(-XL_LEFT_DISTANCE);
        make.height.mas_offset(32 * kWidthRatio6s);
        make.width.mas_offset(96 * kWidthRatio6s);
        make.centerY.equalTo(self.xingNumL);
    }];
}


#pragma mark - show
- (void)show {
    
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - dismiss
- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

#pragma mark - 充值
- (void)addXingAction:(UIButton *)button {
//    if (_delegate && [_delegate respondsToSelector:@selector(xingRewardView:didSelected:item:)]) {
//        [_delegate xingRewardView:self didSelected:0 item:self.item];
//    }
    if (self.rmb2coin) {
        XLRechargeController *vc = [[XLRechargeController alloc] init];
        [self.targetVC.navigationController pushViewController:vc animated:YES];
        [self dismiss];
    }
}

#pragma mark - 打赏
- (void)rewardAction:(UIButton *)button {
//    if (_delegate && [_delegate respondsToSelector:@selector(xingRewardView:didSelected:item:)]) {
//        [_delegate xingRewardView:self didSelected:0 item:self.item];
//    }
    NSString *amount = self.data[self.item];
    if ([self.coin floatValue] < [amount floatValue]) {
        [HUDController hideHUDWithText:@"余额不足，请去充值"];
        return;
    }
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMineHandle xingCoinRewardWithEntity_id:self.entity_id amount:amount success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:@"打赏成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [WeakSelf initData];
//
//        });
        [WeakSelf dismiss];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)registCell {
    [_collectionView registerClass:[XLXingRewardCell class] forCellWithReuseIdentifier:XLXingRewardCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLXingRewardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XLXingRewardCellID forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.data)) {
        cell.numStr = self.data[indexPath.item];
    }
    cell.hightlight = indexPath.item == self.item;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.item = indexPath.item;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(88 * kWidthRatio6s, 88 * kWidthRatio6s);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(XL_LEFT_DISTANCE, XL_LEFT_DISTANCE, XL_LEFT_DISTANCE, XL_LEFT_DISTANCE);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return MinSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return MinSpacing;
}


#pragma mark - lazy load
- (XLBaseCollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.minimumLineSpacing = MinSpacing;
//        flowLayout.minimumInteritemSpacing = MinSpacing;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[XLBaseCollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.bounces = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self registCell];
        
    }
    return _collectionView;
}

- (NSArray *)data {
    if (!_data) {
        _data = [NSArray arrayWithObjects:@"1",@"10",@"100",@"1000", nil].mutableCopy;
    }
    return _data;
}

@end
