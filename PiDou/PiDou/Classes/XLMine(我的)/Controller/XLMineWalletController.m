//
//  XLMineWalletController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineWalletController.h"
#import "XLWalletPriceCell.h"
#import "XLWalletRecordCell.h"
#import "XLWalletSegmentHeader.h"
#import "XLMineHandle.h"
#import "XLWalletInfoModel.h"
#import "XLPDCoinHandle.h"
#import "AdNoticeView.h"

static NSString * XLWalletPriceCellID = @"kXLWalletPriceCell";
static NSString * XLWalletRecordCellID = @"kXLWalletRecordCell";
static NSString * XLWalletSegmentHeaderID = @"kXLWalletSegmentHeader";

@interface XLMineWalletController () <UITableViewDelegate, UITableViewDataSource, MTGRewardAdLoadDelegate, MTGRewardAdShowDelegate>

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) XLWalletInfoModel *walletInfo;
@property (nonatomic, strong) NSMutableArray *billData;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) XLWalletSegmentHeader *header;
@property (nonatomic, assign) int page;

@property (nonatomic, assign) BOOL isCommunity;

@end

@implementation XLMineWalletController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationItem.title = @"我的钱包";
    
    [self initUI];
    
    [[MTGRewardAdManager sharedInstance] loadVideo:@"140010" delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardVideo:) name:@"withdrawReward" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self didLoadData];
}

- (void)initUI {
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    if (self.page == 1) {
        [self initWalletInfoData];
    }
    [self initRecordData];
}

- (void)initWalletInfoData {
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLMineHandle walletInfoWithSuccess:^(XLWalletInfoModel *walletInfo) {
        [HUDController hideHUD];
        WeakSelf.walletInfo = walletInfo;
        [WeakSelf.tableView reloadData];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)initRecordData {
    kDefineWeakSelf;
    if (!self.index) {
        // 余额记录
        [HUDController xl_showHUD];
        [XLMineHandle walletBillWithPage:self.page success:^(NSMutableArray *responseObject) {
           // [HUDController hideHUD];
            
            if (WeakSelf.page > 1) {
                [WeakSelf.tableView.mj_footer endRefreshing];
                [WeakSelf.billData addObjectsFromArray:responseObject];
            } else {
                [WeakSelf.tableView.mj_header endRefreshing];
                WeakSelf.billData = responseObject;
            }
            [WeakSelf.tableView reloadData];
        } failure:^(id  _Nonnull result) {
          // [HUDController xl_hideHUDWithResult:result];
            
            
            if (WeakSelf.page > 1) {
                [WeakSelf.tableView.mj_footer endRefreshing];
                WeakSelf.page--;
            } else {
                [WeakSelf.tableView.mj_header endRefreshing];
            }
            [WeakSelf.tableView reloadData];
        }];
        [HUDController hideHUD];
    } else {
        // 参与回馈PDCoin明细
        [HUDController xl_showHUD];
        [XLPDCoinHandle joinProfitBillWithPage:self.page success:^(NSMutableArray *responseObject) {
           // [HUDController hideHUD];
            if (WeakSelf.page > 1) {
                [WeakSelf.tableView.mj_footer endRefreshing];
                [WeakSelf.billData addObjectsFromArray:responseObject];
            } else {
                [WeakSelf.tableView.mj_header endRefreshing];
                WeakSelf.billData = responseObject;
            }
            [WeakSelf.tableView reloadData];
        } failure:^(id  _Nonnull result) {
          // [HUDController xl_hideHUDWithResult:result];
            if (WeakSelf.page > 1) {
                [WeakSelf.tableView.mj_footer endRefreshing];
                WeakSelf.page--;
            } else {
                [WeakSelf.tableView.mj_header endRefreshing];
            }
            [WeakSelf.tableView reloadData];
        }];
        [HUDController hideHUD];
    }
}

- (void)setup {
    [self registerCell];
}

- (void)registerCell {
    [_tableView registerClass:[XLWalletPriceCell class] forCellReuseIdentifier:XLWalletPriceCellID];
    [_tableView registerClass:[XLWalletRecordCell class] forCellReuseIdentifier:XLWalletRecordCellID];
    [_tableView registerClass:[XLWalletSegmentHeader class] forHeaderFooterViewReuseIdentifier:XLWalletSegmentHeaderID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.billData.count;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        XLWalletPriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:XLWalletPriceCellID forIndexPath:indexPath];
        kDefineWeakSelf;
        priceCell.communityActionBlock = ^(NSNumber *num) {
            [WeakSelf initWalletInfoData];
            WeakSelf.header.index = num.integerValue;
        };
        if (self.walletInfo) {
            priceCell.walletInfo = self.walletInfo;
            //priceCell.index = self.index;
        }
        
        priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return priceCell;
    } else {
        XLWalletRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:XLWalletRecordCellID forIndexPath:indexPath];
        if (!XLArrayIsEmpty(self.billData)) {
            recordCell.recordModel = self.billData[row];
        }
        recordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return recordCell;
    }

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64 * kWidthRatio6s;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44 * kWidthRatio6s;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        XLWalletSegmentHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XLWalletSegmentHeaderID];
        kDefineWeakSelf;
        header.didSelected = ^(id  _Nonnull result) {
            [WeakSelf.billData removeAllObjects];
            WeakSelf.index = [result integerValue];
            [WeakSelf initRecordData];
        };
        self.header = header;
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
        [self setup];
    }
    return _tableView;
}

- (NSMutableArray *)billData {
    if (!_billData) {
        _billData = [NSMutableArray array];
    }
    return _billData;
}

- (void)rewardVideo:(NSNotification *)notification {
    [[AdNoticeView sharedAdNoticeView] dismiss];
    
    //Check isReady before you show a reward video
    if ([[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:@"140010"]) {
        [[MTGRewardAdManager sharedInstance] showVideo:@"140010" withRewardId:@"3" userId:@"" delegate:self viewController:self];
    } else {
        //We will help you to load automatically when isReady is NO
        [HUDController showTextOnly:@"没有广告"];
    }
    
    NSString *str = notification.object;
    if ([str isEqualToString:@"0"]) {
        [[XLWalletPriceCell sharedXLWalletPriceCell] communityAction];
        _isCommunity = YES;
    }
}

#pragma mark - MTGRewardAdShowDelegate Delegate

//Show Reward Video Ad Success Delegate
- (void)onVideoAdShowSuccess:(NSString *)unitId {
    
}

//Show Reward Video Ad Failed Delegate
- (void)onVideoAdShowFailed:(NSString *)unitId withError:(NSError *)error {
    
}

//About RewardInfo Delegate
- (void)onVideoAdDismissed:(NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(MTGRewardAdInfo *)rewardInfo {
    if (rewardInfo) {
        if (_isCommunity) {
            _isCommunity = NO;
            return;
        }
        [[XLWalletPriceCell sharedXLWalletPriceCell] withdrawAction];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
