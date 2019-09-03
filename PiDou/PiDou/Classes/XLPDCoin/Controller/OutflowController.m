//
//  OutflowController.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import "OutflowController.h"
#import "OutflowCell.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "ConfirmView.h"
#import "OutflowSuccessController.h"
#import "ChainWalletController.h"
#import "OfficeBuybackController.h"
#import "OutflowDetailController.h"
#import "XLPDCoinHandle.h"

@interface OutflowController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *icons;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) OutflowCell *selectedCell;
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UITextField *pdcoinTF;
@property (nonatomic, strong) UILabel *feeLab;
@property (nonatomic, strong) UIView *separatorLine1;
@property (nonatomic, strong) UILabel *lab3;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIView *separatorLine2;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, copy) NSString *type;

@end

@implementation OutflowController
singleton_m(OutflowController)


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self registerCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 800 * kWidthRatio6s)];
}

- (void)initUI {
    self.navigationItem.title = @"PDCoin流转";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"明细" size:16.f target:self action:@selector(rightAction:)];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    self.label = [[UILabel alloc] init];
    [self.scrollView addSubview:self.label];
    self.label.text = @"流转到";
    [self.label xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.scrollView addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    
    self.lab1 = [[UILabel alloc] init];
    [self.scrollView addSubview:self.lab1];
    self.lab1.text = @"转出数量";
    [self.lab1 xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    
    self.lab2 = [[UILabel alloc] init];
    [self.scrollView addSubview:self.lab2];
    self.lab2.text = @"PDCoin";
    [self.lab2 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:30.f];
    
    self.pdcoinTF = [[UITextField alloc] init];
    [self.scrollView addSubview:self.pdcoinTF];
    self.pdcoinTF.textColor = XL_COLOR_DARKBLACK;
    self.pdcoinTF.font = [UIFont systemFontOfSize:30.f * kWidthRatio6s];
    self.pdcoinTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"最低提现数量1000PDCoin" color:XL_COLOR_DARKGRAY font:[UIFont xl_fontOfSize:12.f]];
    self.pdcoinTF.delegate = self;
    self.pdcoinTF.clearButtonMode = UITextFieldViewModeAlways;
    self.pdcoinTF.keyboardType = UIKeyboardTypePhonePad;
    
    self.feeLab = [[UILabel alloc] init];
    [self.scrollView addSubview:self.feeLab];
    self.feeLab.text = @"5%手续费";
    [self.feeLab xl_setTextColor:XL_COLOR_RED fontSize:10.f];
    self.feeLab.hidden = YES;
    
    self.separatorLine1 = [[UIView alloc] init];
    [self.scrollView addSubview:self.separatorLine1];
    self.separatorLine1.backgroundColor = RGB_COLOR(242, 242, 245);
    
    self.lab3 = [[UILabel alloc] init];
    [self.scrollView addSubview:self.lab3];
    self.lab3.text = [NSString stringWithFormat:@"可转出剩余PDCoin：%@", self.pdcBalance];
    [self.lab3 xl_setTextColor:XL_COLOR_DARKGRAY fontSize:14.f];
    
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:self.allBtn];
    [self.allBtn xl_setTitle:@"全部转出" color:XL_COLOR_RED size:14.f target:self action:@selector(allOutflow)];
    
    self.phoneTF = [[UITextField alloc] init];
    [self.scrollView addSubview:self.phoneTF];
    self.phoneTF.textColor = XL_COLOR_DARKBLACK;
    self.phoneTF.font = [UIFont systemFontOfSize:17.f * kWidthRatio6s];
    self.phoneTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入手机号码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:15.f]];
    self.phoneTF.delegate = self;
    self.phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    
    self.separatorLine2 = [[UIView alloc] init];
    [self.scrollView addSubview:self.separatorLine2];
    self.separatorLine2.backgroundColor = RGB_COLOR(242, 242, 245);
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:self.confirmBtn];
    [self.confirmBtn xl_setTitle:@"确认转出" color:RGB_COLOR_A(255, 255, 255, 0.35) size:17.f target:self action:@selector(confirmOutflow)];
    self.confirmBtn.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.confirmBtn, 22 * kWidthRatio6s);
    
    [self initLayout];
}

- (void)initLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).mas_offset(19 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(15 * kWidthRatio6s);
    }];
    
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).mas_offset(26 * kWidthRatio);
        make.left.equalTo(self.view).mas_offset(15 * kWidthRatio6s);
    }];
    
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab1);
        make.top.equalTo(self.lab1.mas_bottom).mas_offset(10 * kWidthRatio6s);
    }];
    
    [self.pdcoinTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab2.mas_right).mas_offset(11 * kWidthRatio6s);
        make.centerY.equalTo(self.lab2);
        make.height.mas_offset(25 * kWidthRatio6s);
        make.width.mas_offset(170 * kWidthRatio6s);
    }];
    
    [self.feeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_offset(-15 * kWidthRatio6s);
        make.centerY.equalTo(self.pdcoinTF);
    }];
    
    [self.separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab2.mas_bottom).mas_offset(20 * kWidthRatio6s);
        make.left.equalTo(self.lab1);
        make.right.equalTo(self.view);
        make.height.mas_offset(1 * kWidthRatio6s);
    }];
    
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab1);
        make.top.equalTo(self.separatorLine1.mas_bottom).mas_offset(10 * kWidthRatio6s);
    }];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lab3);
        make.right.equalTo(self.view).mas_offset(-15 * kWidthRatio6s);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab3);
        make.top.equalTo(self.lab3.mas_bottom).mas_offset(32 * kWidthRatio6s);
        make.width.mas_offset(170 * kWidthRatio6s);
    }];
    
    [self.separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separatorLine1);
        make.right.equalTo(self.allBtn);
        make.top.equalTo(self.phoneTF.mas_bottom).mas_offset(10 * kWidthRatio6s);
        make.height.mas_offset(1 * kWidthRatio6s);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine2.mas_bottom).mas_offset(30 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.height.mas_offset(44 * kWidthRatio6s);
    }];
    
}

// 全部转出
- (void)allOutflow {
    self.pdcoinTF.text = self.pdcBalance;
}

- (void)setPdcBalance:(NSString *)pdcBalance {
    _pdcBalance = pdcBalance;
    self.lab3.text = [NSString stringWithFormat:@"可转出剩余PDCoin：%@", _pdcBalance];
}

// 确认转出
- (void)confirmOutflow {
    if (XLStringIsEmpty(_type)) {
        [HUDController hideHUDWithText:@"请选择转出类型"];
        return;
    }
    if (XLStringIsEmpty(_pdcoinTF.text)) {
        [HUDController hideHUDWithText:@"请输入转出数量"];
        return;
    }
    if (XLStringIsEmpty(_phoneTF.text)) {
        [HUDController hideHUDWithText:@"请输入手机号"];
        return;
    }
    ConfirmView *confirm = [ConfirmView confirmView];
    NSString *substr = [_type substringFromIndex:2];
    confirm.typeArray = @[substr, _phoneTF.text];
    [confirm show];
}

- (void)registerCell {
    [self.tableView registerClass:[OutflowCell class] forCellReuseIdentifier:@"OutflowCell"];
}

- (void)rightAction:(UIButton *)button {
    OutflowDetailController *outflowDetailVC = [[OutflowDetailController alloc] init];
    [self.navigationController pushViewController:outflowDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pdcoinTF endEditing:YES];
    [self.phoneTF endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutflowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutflowCell" forIndexPath:indexPath];
    cell.icon = self.icons[indexPath.row];
    cell.titleName = self.titles[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OutflowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!_selectedCell) {
        cell.selectBtn.selected = YES;
    }
    if (_selectedCell != cell && _selectedCell.selectBtn.selected == YES) {
        cell.selectBtn.selected = YES;
        _selectedCell.selectBtn.selected = NO;
    }
    _selectedCell = cell;
    
    _feeLab.hidden = YES;
    switch (indexPath.row) {
        case 0:
        {
            _type = @"转出商城";
        }
            break;
        case 1:
        {
            _type = @"转出小说";
        }
            break;
        case 2:
        {
            _type = @"转出游戏";
        }
            break;
        case 3:
        {
            _type = @"转出好友";
            _feeLab.hidden = NO;
        }
            break;
        case 4:
        {
            _type = @"转出区块钱包";
            ChainWalletController *chainVC = [[ChainWalletController alloc] init];
            chainVC.pdcBalance = self.pdcBalance;
            [self.navigationController pushViewController:chainVC animated:NO];
        }
            break;
        case 5:
        {
            _type = @"官方回购";
            OfficeBuybackController *buybackVC = [[OfficeBuybackController alloc] init];
            buybackVC.pdcBalance = self.pdcBalance;
            [self.navigationController pushViewController:buybackVC animated:NO];
        }
            break;
        default:
            break;
    }
}

// 转出到选择类型
- (void)outflowTo {
    [XLPDCoinHandle pdCoinOutflow:self.pdcoinTF.text transferType:self.type tel:self.phoneTF.text success:^(id  _Nonnull responseObject) {
        OutflowSuccessController *successVC = [[OutflowSuccessController alloc] init];
        [self.navigationController pushViewController:successVC animated:NO];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!XLStringIsEmpty(_pdcoinTF.text) && !XLStringIsEmpty(_phoneTF.text) && !XLStringIsEmpty(_type)) {
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        [self.confirmBtn setTitleColor:RGB_COLOR_A(255, 255, 255, 0.35) forState:UIControlStateNormal];
    }
    return YES;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 47 * kWidthRatio6s, SCREEN_WIDTH, 300 * kWidthRatio6s)];
    }
    return _tableView;
}

- (NSArray *)icons {
    if (!_icons) {
        _icons = [NSArray arrayWithObjects:@"ZC_icon01", @"ZC_icon02", @"ZC_icon03", @"ZC_icon04", @"ZC_icon05", @"ZC_icon06", nil];
    }
    return _icons;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"商城", @"小说", @"游戏", @"好友", @"区块钱包", @"官方回购", nil];
    }
    return _titles;
}

@end
