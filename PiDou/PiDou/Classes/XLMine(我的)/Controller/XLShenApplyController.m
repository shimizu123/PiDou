//
//  XLShenApplyController.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLShenApplyController.h"
#import "XLMineListCell.h"
#import "XLMineSettingTopCell.h"
#import "XLMineNameController.h"
#import "XLMineSignController.h"
#import "XLMineOriPhoneController.h"
#import "CALayer+XLExtension.h"
#import "XLUserLoginHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

static NSString * XLMineListCellID      = @"kXLMineListCell";
static NSString *XLMineSettingTopCellID = @"kXLMineSettingTopCell";

@interface XLShenApplyController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation XLShenApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"申请神评鉴定师";
    
    [self initData];
    
    [self initUI];
    
}


- (void)initUI {
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.commitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.view addSubview:self.commitButton];
    [self.commitButton xl_setTitle:@"提交申请" color:[UIColor whiteColor] size:18.f target:self action:@selector(commitAction:)];
    self.commitButton.backgroundColor = XL_COLOR_RED;
    [self.commitButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.view).mas_offset(248 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
}

#pragma mark - 提交申请
- (void)commitAction:(UIButton *)button {
    [HUDController xl_showHUD];
    [XLUserLoginHandle userApplyAppraiserWithSuccess:^(NSString *msg) {
        [HUDController hideHUDWithText:msg];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)initData {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"title"] = @"昵称";
    dic1[@"desc"] = self.userInfo.nickname;
    dic1[@"type"] = @(0);
    
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"title"] = @"性别";
    dic3[@"desc"] = self.userInfo.sex;
    dic3[@"type"] = @(0);
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    dic4[@"title"] = @"手机号码";
    dic4[@"desc"] = self.userInfo.phone_number;
    dic4[@"type"] = @(0);
    

    
    [self.listArr addObject:dic1];
    [self.listArr addObject:dic3];
    [self.listArr addObject:dic4];
}


- (void)setup {
    [self registerCell];
}

- (void)registerCell {
    [_tableView registerClass:[XLMineListCell class] forCellReuseIdentifier:XLMineListCellID];
    [_tableView registerClass:[XLMineSettingTopCell class] forCellReuseIdentifier:XLMineSettingTopCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.listArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        XLMineSettingTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:XLMineSettingTopCellID forIndexPath:indexPath];
        topCell.titleName = @"头像";
        topCell.url = self.userInfo.avatar;
        return topCell;
    }
    XLMineListCell *listCell = [tableView dequeueReusableCellWithIdentifier:XLMineListCellID forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.listArr)) {
        listCell.isProfile = YES;
        listCell.infoDic = self.listArr[row];
    }
    
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return listCell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48 * kWidthRatio6s;
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
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        // 头像
        
    } else {
        
        switch (row) {
            case 0:
            {
                // 昵称
                XLMineNameController *nameVC = [[XLMineNameController alloc] init];
                [self.navigationController pushViewController:nameVC animated:YES];
            }
                break;
            case 1:
            {
                // 个性签名
                XLMineSignController *signVC = [[XLMineSignController alloc] init];
                [self.navigationController pushViewController:signVC animated:YES];
            }
                break;
            case 2:
            {
                // 性别
            }
                break;
            case 3:
            {
                // 手机号码
                XLMineOriPhoneController *oriPhoneVC = [[XLMineOriPhoneController alloc] init];
                [self.navigationController pushViewController:oriPhoneVC animated:YES];
            }
                break;
                
            default:
                break;
        }
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
        
        [self setup];
    }
    return _tableView;
}

- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}


@end
