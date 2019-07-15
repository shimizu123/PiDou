//
//  XLRechargeController.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLRechargeController.h"
#import "XLMyXingCell.h"
#import "XLWalletPayWayCell.h"
#import "XLWalletXingListCell.h"
#import "XLWalletHeader.h"
#import "XLXingDetailController.h"
#import "WXApiRequestHandler.h"
#import "XLMineHandle.h"
#import "PrivacyController.h"

static NSString * XLMyXingCellID = @"kXLMyXingCell";
static NSString * XLWalletPayWayCellID = @"kXLWalletPayWayCell";
static NSString * XLWalletXingListCellID = @"kXLWalletXingListCell";
static NSString * XLWalletHeaderID = @"kXLWalletHeader";

@interface XLRechargeController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *xingCoinsData;

/**星票余额*/
@property (nonatomic, strong) NSNumber *coin;
/**单位rmb能兑换的星票数 如2则表示 1rmb兑换2星票*/
@property (nonatomic, strong) NSNumber *rmb2coin;
@property (nonatomic, strong) UILabel *privacyLabel;

@end

@implementation XLRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值星票";
    [self initUI];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:XLPaySuccessNotification object:nil];
}

- (void)initUI {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"查看明细" size:16.f target:self action:@selector(goXingDetailAction)];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.tableView];
    
    self.privacyLabel = [[UILabel alloc] init];
    [self.view addSubview:self.privacyLabel];
    [self.privacyLabel xl_setTextColor:COLOR(0x666666) fontSize:12.f];
    self.privacyLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"充值即代表您同意皮逗充值服务协议"];
    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 8)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(8, 8)];
    self.privacyLabel.attributedText = string;
    self.privacyLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.privacyLabel addGestureRecognizer:tap];
    
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-XL_HOME_INDICATOR_H);
        make.height.mas_offset(20 * kWidthRatio6s);
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)tapAction {
    NSLog(@"充值协议");
    PrivacyController *privacyVC = [[PrivacyController alloc] init];
    privacyVC.isRecharge = YES;
    [self.navigationController pushViewController:privacyVC animated:true];
}

- (void)initData {
    kDefineWeakSelf;
    //[HUDController xl_showHUD];
    [WeakSelf.xingCoinsData removeAllObjects];
    [XLMineHandle walletInfoWithSuccess:^(XLWalletInfoModel *walletInfo) {
        //[HUDController hideHUD];
        WeakSelf.coin = walletInfo.coin;
        WeakSelf.rmb2coin = walletInfo.rmb2coin;
        [WeakSelf initCoinData];
        [WeakSelf.tableView reloadData];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)setRmb2coin:(NSNumber *)rmb2coin {
    _rmb2coin = rmb2coin;
}

- (void)goXingDetailAction {
    XLXingDetailController *xingDetailVC = [[XLXingDetailController alloc] init];
    [self.navigationController pushViewController:xingDetailVC animated:YES];
}


- (void)registerCell {
    [_tableView registerClass:[XLMyXingCell class] forCellReuseIdentifier:XLMyXingCellID];
    [_tableView registerClass:[XLWalletPayWayCell class] forCellReuseIdentifier:XLWalletPayWayCellID];
    [_tableView registerClass:[XLWalletXingListCell class] forCellReuseIdentifier:XLWalletXingListCellID];
    [_tableView registerClass:[XLWalletHeader class] forHeaderFooterViewReuseIdentifier:XLWalletHeaderID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.xingCoinsData.count;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        XLMyXingCell *topCell = [tableView dequeueReusableCellWithIdentifier:XLMyXingCellID forIndexPath:indexPath];
        if (self.coin) {
            topCell.coin = self.coin;
        }
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return topCell;
    } else if (section == 1) {
        XLWalletPayWayCell *wayCell = [tableView dequeueReusableCellWithIdentifier:XLWalletPayWayCellID forIndexPath:indexPath];
        wayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return wayCell;
    } else {
        XLWalletXingListCell *listCell = [tableView dequeueReusableCellWithIdentifier:XLWalletXingListCellID forIndexPath:indexPath];
        if (!XLArrayIsEmpty(self.xingCoinsData)) {
            listCell.xingCoinModel = self.xingCoinsData[row];
        }
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return listCell;
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
    if (section > 0) {
        return 44 * kWidthRatio6s;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        XLWalletHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XLWalletHeaderID];
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
    XLWalletInfoModel *xingCoin1 = self.xingCoinsData[indexPath.row];
    
    [HUDController xl_showHUD];
    [XLMineHandle wechatPrePayWithCoin:xingCoin1.coin success:^(XLPayOrderModel *responseObject) {
        [HUDController hideHUD];
        NSString *res = [WXApiRequestHandler jumpToWechatPayWithOrder:responseObject];
        if( ![@"" isEqual:res] ){
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alter show];
        }
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
    }
}

- (void)initCoinData {
    if ([self.rmb2coin floatValue] > 0) {
        
        XLWalletInfoModel *xingCoin1 = [[XLWalletInfoModel alloc] init];
        xingCoin1.coin = @(100);
        xingCoin1.balance = [NSNumber numberWithFloat:[([NSString stringWithFormat:@"%.2f",100 / [self.rmb2coin floatValue]]) floatValue]];
        
        XLWalletInfoModel *xingCoin2 = [[XLWalletInfoModel alloc] init];
        xingCoin2.coin = @(500);
        xingCoin2.balance = [NSNumber numberWithFloat:[([NSString stringWithFormat:@"%.2f",500 / [self.rmb2coin floatValue]]) floatValue]];
        
        XLWalletInfoModel *xingCoin3 = [[XLWalletInfoModel alloc] init];
        xingCoin3.coin = @(1000);
        xingCoin3.balance = [NSNumber numberWithFloat:[([NSString stringWithFormat:@"%.2f",1000 / [self.rmb2coin floatValue]]) floatValue]];
        
        XLWalletInfoModel *xingCoin4 = [[XLWalletInfoModel alloc] init];
        xingCoin4.coin = @(5000);
        xingCoin4.balance = [NSNumber numberWithFloat:[([NSString stringWithFormat:@"%.2f",5000 / [self.rmb2coin floatValue]]) floatValue]];
        
        XLWalletInfoModel *xingCoin5 = [[XLWalletInfoModel alloc] init];
        xingCoin5.coin = @(10000);
        xingCoin5.balance = [NSNumber numberWithFloat:[([NSString stringWithFormat:@"%.2f",10000 / [self.rmb2coin floatValue]]) floatValue]];
        
        XLWalletInfoModel *xingCoin6 = [[XLWalletInfoModel alloc] init];
        xingCoin6.coin = @(50000);
        xingCoin6.balance = [NSNumber numberWithFloat:[([NSString stringWithFormat:@"%.2f",50000 / [self.rmb2coin floatValue]]) floatValue]];
        
        [_xingCoinsData addObject:xingCoin1];
        [_xingCoinsData addObject:xingCoin2];
        [_xingCoinsData addObject:xingCoin3];
        [_xingCoinsData addObject:xingCoin4];
        [_xingCoinsData addObject:xingCoin5];
        [_xingCoinsData addObject:xingCoin6];
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
        
        [self registerCell];
    }
    return _tableView;
}

- (NSMutableArray *)xingCoinsData {
    if (!_xingCoinsData) {
        
        _xingCoinsData = [NSMutableArray array];
        
        [self initCoinData];
        
    }
    return _xingCoinsData;
}



@end
