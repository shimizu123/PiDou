//
//  XLPDCoinController.m
//  PiDou
//
//  Created by ice on 2019/4/22.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPDCoinController.h"
#import "XLPDCoinNaviBar.h"
#import "XLTwoLabelView.h"
#import "XLPDCoinDetailController.h"
#import "XLGainPDCoinController.h"
#import "XLPDCoinDiamondView.h"
#import "XLPDCoinHandle.h"
#import "XLPDCoinModel.h"
#import "XLCircleView.h"
#import "XLAdvModel.h"
#import "XLInviteDetailController.h"
#import "PrivacyController.h"

@interface XLPDCoinController () <XLPDCoinNaviBarDelegate, XLPDCoinDiamondViewDelegate, XLCircleViewDelegate>

@property (nonatomic, strong) XLPDCoinNaviBar *naviBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) XLTwoLabelView *holdCoinView;
@property (nonatomic, strong) XLTwoLabelView *freezeCoinView;
@property (nonatomic, strong) UIButton *gainCoinButton;

@property (nonatomic, strong) UIButton *coinLookButton;

//@property (nonatomic, strong) UIImageView *advImgV;
@property (nonatomic, strong) XLCircleView *circleView;

@property (nonatomic, strong) XLPDCoinDiamondView *diamondView;

@property (nonatomic, strong) XLPDCoinModel *pdCoinModel;

@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSMutableArray *advs;

@end

@implementation XLPDCoinController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
    
    
    self.page = 1;
    [self initData];
}



- (void)initUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
    self.scrollView.bounces = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.bgImgV = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
    [self.scrollView addSubview:self.bgImgV];
    self.bgImgV.image = [UIImage imageNamed:@"coin_bg"];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.naviBar];
    
    self.holdCoinView = [[XLTwoLabelView alloc] init];
    [self.scrollView addSubview:self.holdCoinView];
    self.holdCoinView.topFont = [UIFont xl_fontOfSize:12.f];
    self.holdCoinView.botFont = [UIFont xl_fontOfSize:24.f];
    self.holdCoinView.topColor = COLOR_A(0xffffff, 0.6);
    self.holdCoinView.botColor = [UIColor whiteColor];
    self.holdCoinView.interitemSpacing = 22 * kWidthRatio6s;
    
    self.freezeCoinView = [[XLTwoLabelView alloc] init];
    [self.scrollView addSubview:self.freezeCoinView];
    self.freezeCoinView.topFont = [UIFont xl_fontOfSize:12.f];
    self.freezeCoinView.botFont = [UIFont xl_fontOfSize:24.f];
    self.freezeCoinView.topColor = COLOR_A(0xffffff, 0.6);
    self.freezeCoinView.botColor = [UIColor whiteColor];
    self.freezeCoinView.interitemSpacing = 22 * kWidthRatio6s;
    
    self.holdCoinView.titleTop = @"持有PDCoin";
    self.freezeCoinView.titleTop = @"冻结PDCoin";
    self.holdCoinView.titleBot = @"0";
    self.freezeCoinView.titleBot = @"0";
    
    self.gainCoinButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.gainCoinButton];
    [self.gainCoinButton xl_setTitle:@"获取更多PDCoin" color:[UIColor whiteColor] size:14.f target:self action:@selector(gainPDCoinAction)];
    XLViewBorderRadius(self.gainCoinButton, 16 * kWidthRatio6s, 1, [UIColor whiteColor].CGColor);
    
    self.diamondView = [[XLPDCoinDiamondView alloc] init];
    [self.scrollView addSubview:self.diamondView];
    self.diamondView.delegate = self;
    
    self.coinLookButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.coinLookButton];
    [self.coinLookButton xl_setImageName:@"coin_look" target:self action:@selector(coinLookAction)];
    
    
//    self.advImgV = [[UIImageView alloc] init];
//    [self.scrollView addSubview:self.advImgV];
//    self.advImgV.backgroundColor = XL_COLOR_BG;
    self.circleView = [[XLCircleView alloc] init];
    self.circleView.delegate = self;
    [self.scrollView addSubview:self.circleView];
    self.circleView.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.circleView, 6 * kWidthRatio6s);
    
    [self initLayout];
}

- (void)initLayout {
    [self.holdCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(44 * kWidthRatio6s);
        make.top.equalTo(self.bgImgV).mas_offset(32 * kWidthRatio6s + XL_NAVIBAR_H);
        make.height.mas_offset(50 * kWidthRatio6s);
    }];
    
    [self.freezeCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_offset(-44 * kWidthRatio6s);
        make.top.bottom.width.equalTo(self.holdCoinView);
        make.left.equalTo(self.holdCoinView.mas_right);
    }];
    
    [self.gainCoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holdCoinView.mas_bottom).mas_offset(32 * kWidthRatio6s);
        make.width.mas_offset(133 * kWidthRatio6s);
        make.height.mas_offset(32 * kWidthRatio6s);
        make.centerX.equalTo(self.view);
    }];
    
    
    [self.diamondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gainCoinButton.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.coinLookButton.mas_top);
    }];
    
    [self.coinLookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gainCoinButton);
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.height.mas_offset(96 * kWidthRatio6s);
        make.bottom.equalTo(self.bgImgV).mas_offset(-XL_HOME_INDICATOR_H - 48 * kWidthRatio6s);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.bgImgV.mas_bottom).mas_offset(16 * kWidthRatio6s);
        make.height.mas_offset(192 * kWidthRatio6s);
        make.bottom.equalTo(self.scrollView).mas_offset(-16 * kWidthRatio6s);
    }];
}

- (void)initData {
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLPDCoinHandle pdCoinListWithPage:self.page success:^(XLPDCoinModel *pdCoinModel) {
        [HUDController hideHUD];
        if (pdCoinModel.records.count == 0) {
            WeakSelf.page--;
        }
        WeakSelf.pdCoinModel = pdCoinModel;
        [WeakSelf updateUI];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        WeakSelf.page--;
    }];
    
    [XLPDCoinHandle advWithSuccess:^(NSMutableArray *responseObject) {
        WeakSelf.advs = responseObject;
        NSMutableArray *urls = [NSMutableArray array];
        for (XLAdvModel *adModel in responseObject) {
            [urls addObject:adModel.cover];
        }
        WeakSelf.circleView.images = urls;
    } failure:^(id  _Nonnull result) {
        
    }];
}

- (void)updateUI {
    
    self.holdCoinView.titleBot = [self.pdCoinModel.pdcoin_count stringValue];
    self.freezeCoinView.titleBot = [self.pdCoinModel.freeze_pdcoin_count stringValue];
    self.diamondView.data = self.pdCoinModel.records;
}

#pragma mark - XLCircleViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    XLInviteDetailController *vc = [[XLInviteDetailController alloc] init];
    if (!XLArrayIsEmpty(self.advs)) {
        XLAdvModel *ad = self.advs[index];
        vc.url = ad.link;
        vc.titleName = ad.title;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XLPDCoinDiamondViewDelegate
- (void)pdCoinDiamondView:(XLPDCoinDiamondView *)pdCoinDiamondView didPappaoAtIndex:(NSInteger)index isLastOne:(BOOL)isLastOne {
    XLPDRecordModel *record = self.pdCoinModel.records[index];
    
    kDefineWeakSelf;
    [XLPDCoinHandle pdCoinPickWithPid:record.pid success:^(NSString *pdcoin_count) {
        self.holdCoinView.titleBot = pdcoin_count;
        if (isLastOne) {
            WeakSelf.pdCoinModel = nil;
            WeakSelf.page++;
            [WeakSelf initData];
        }
    } failure:^(id  _Nonnull result) {
        
    }];
    
    
}

#pragma mark - 点击获取更多PDCoin
- (void)gainPDCoinAction {
    XLGainPDCoinController *gainVC = [[XLGainPDCoinController alloc] init];
    [self.navigationController pushViewController:gainVC animated:YES];
}

#pragma mark - 查看皮逗攻略
- (void)coinLookAction {
//    XLGainPDCoinController *gainVC = [[XLGainPDCoinController alloc] init];
//    [self.navigationController pushViewController:gainVC animated:YES];
    
    PrivacyController *privacyVC = [[PrivacyController alloc] init];
    privacyVC.isPDCoin = YES;
    [self.navigationController pushViewController:privacyVC animated:YES];
}

#pragma mark - XLPDCoinNaviBarDelegate
- (void)onClose:(XLPDCoinNaviBar *)naviBar {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onDetail:(XLPDCoinNaviBar *)naviBar {
    XLPDCoinDetailController *coinDetailVC = [[XLPDCoinDetailController alloc] init];
    [self.navigationController pushViewController:coinDetailVC animated:YES];
}
#pragma mark - lazy load
- (XLPDCoinNaviBar *)naviBar {
    if (!_naviBar) {
        _naviBar = [[XLPDCoinNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
        _naviBar.delegate = self;
    }
    return _naviBar;
}

- (NSMutableArray *)advs {
    if (!_advs) {
        _advs = [NSMutableArray array];
    }
    return _advs;
}

@end
