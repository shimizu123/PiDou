//
//  XLMineSettingController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineSettingController.h"
#import "XLMineSecurityController.h"
#import "XLMineListCell.h"
#import "XLModifyPwdController.h"
#import "XLUserManager.h"
#import "XLCacheManager.h"

static NSString * XLMineListCellID      = @"kXLMineListCell";
@interface XLMineSettingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation XLMineSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
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
    
    self.logoutButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.tableView addSubview:self.logoutButton];
    [self.logoutButton xl_setTitle:@"退出登录" color:XL_COLOR_RED size:16.f target:self action:@selector(logoutAction)];
    self.logoutButton.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.logoutButton, 24 * kWidthRatio6s);
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.tableView).mas_offset(-32 * kWidthRatio6s);
        make.height.mas_offset(44 * kWidthRatio6s);
        make.top.equalTo(self.tableView).mas_offset(240 * kWidthRatio6s);
    }];
}

#pragma mark - 退出登录
- (void)logoutAction {
    [XLUserManager logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    [self.listArr removeAllObjects];
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//    dic1[@"title"] = @"账号安全";
//    dic1[@"desc"] = @"";
//    dic1[@"type"] = @(0);
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[@"title"] = @"修改密码";
    dic2[@"desc"] = @"";
    dic2[@"type"] = @(0);
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"title"] = @"清除缓存";
    dic3[@"desc"] = [XLCacheManager getCacheSize];
    dic3[@"type"] = @(0);
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    dic4[@"title"] = @"版本更新";
    dic4[@"desc"] = [self getVersion];
    dic4[@"type"] = @(0);

    
    //[self.listArr addObject:dic1];
    [self.listArr addObject:dic2];
    [self.listArr addObject:dic3];
    [self.listArr addObject:dic4];
    [self.tableView reloadData];
}


- (void)setup {
    [self registerCell];
}

- (void)registerCell {
    [_tableView registerClass:[XLMineListCell class] forCellReuseIdentifier:XLMineListCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;

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

    switch (row) {
//        case 0:
//        {
//            // 账号安全
//            XLMineSecurityController *securityVC = [[XLMineSecurityController alloc] init];
//            [self.navigationController pushViewController:securityVC animated:YES];
//        }
//            break;
        case 0:
        {
            // 修改密码
            XLModifyPwdController *modifyVC = [[XLModifyPwdController alloc] init];
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        case 1:
        {
            // 清除缓存
            [XLCacheManager clearCache];
            [self initData];
        }
            break;
        case 2:
        {
            // 版本更新
            NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Entity];
            [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
                NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
                NSString *msg = [responseObject valueForKey:@"msg"];
               
                if (code == 440) {
                    msg = @"有新版本可更新";
                } else {
                    msg = @"已是最新版本";
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"http://www.pidoutv.com"];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                [alertController addAction:cancel];
                [alertController addAction:sure];
                
                [self presentViewController:alertController animated:true completion:nil];
            } failure:^(NSError * _Nonnull error) {
                
            }];
        }
            break;
            
        default:
            break;
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

- (NSString *)getVersion {
    //编译版本号 CFBundleVersion
    //更新版本号 CFBundleShortVersionString
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *localAppVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return localAppVersion;
}

@end
