//
//  XLWalletResultController.m
//  PiDou
//
//  Created by kevin on 12/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletResultController.h"

@interface XLWalletResultController ()

@property (nonatomic, strong) UIImageView *statuImgV;
@property (nonatomic, strong) UILabel *statuLabel;

@end

@implementation XLWalletResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.title = @"兑换成功";
    
    [self initUI];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftItemWithImage:@"navi_arrow_black" highImage:@"" target:self action:@selector(backAction)];
}

- (void)setResultType:(XLWalletResultType)resultType {
    _resultType = resultType;
    switch (_resultType) {
        case XLWalletResultType_buy:
        {
            self.navigationItem.title = @"兑换成功";
            self.statuLabel.text = @"兑换成功";
        }
            break;
        case XLWalletResultType_commit:
        {
            self.navigationItem.title = @"提现成功";
            self.statuLabel.text = @"提现成功，等待银行操作…";
        }
            break;
            

            
        default:
            break;
    }
}

- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initUI {
    
    self.statuImgV = [[UIImageView alloc] init];
    [self.view addSubview:self.statuImgV];
    self.statuImgV.image = [UIImage imageNamed:@"wallet_success"];
    
    self.statuLabel = [[UILabel alloc] init];
    [self.view addSubview:self.statuLabel];
    [self.statuLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.statuLabel.textAlignment = NSTextAlignmentCenter;
    switch (_resultType) {
        case XLWalletResultType_buy:
        {
            self.navigationItem.title = @"兑换成功";
            self.statuLabel.text = @"兑换成功";
        }
            break;
        case XLWalletResultType_commit:
        {
            self.navigationItem.title = @"提现成功";
            self.statuLabel.text = @"提现成功，等待银行操作…";
        }
            break;
            
            
            
        default:
            break;
    }
    
    [self initLayout];
}

- (void)initLayout {
    [self.statuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(49 * kWidthRatio6s);
        make.width.height.mas_offset(64 * kWidthRatio6s);
    }];
    
    [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.statuImgV.mas_bottom).mas_offset(8 * kWidthRatio6s);
    }];
}



@end
