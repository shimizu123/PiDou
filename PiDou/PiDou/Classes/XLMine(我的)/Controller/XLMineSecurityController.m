//
//  XLMineSecurityController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineSecurityController.h"
#import "XLMineListCell.h"
#import "XLMineHandle.h"
#import "XLUserManager.h"

static NSString * XLMineListCellID      = @"kXLMineListCell";

@interface XLMineSecurityController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation XLMineSecurityController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号安全";
    
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
}


- (void)initData {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"title"] = @"注销账号";
    dic1[@"desc"] = @"";
    dic1[@"type"] = @(0);
    
   
    
    
    [self.listArr addObject:dic1];

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
    //NSInteger section = indexPath.section;
    
    switch (row) {
        case 0:
        {
            // 注销账号
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"是否要注销用户?" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                [HUDController xl_showHUD];
                [XLMineHandle userCancelWithSuccess:^(id  _Nonnull responseObject) {
                    [HUDController hideHUDWithText:responseObject];
                    [XLUserManager logout];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } failure:^(id  _Nonnull result) {
                    [HUDController xl_hideHUDWithResult:result];
                }];
            }];
            [alertC addAction:cancle];
            [alertC addAction:confirm];
            [self presentViewController:alertC animated:YES completion:^{
                
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




@end
