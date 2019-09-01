//
//  OutflowSuccessController.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import "OutflowSuccessController.h"

@interface OutflowSuccessController ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *lab;

@end

@implementation OutflowSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"转出成功";
    
    self.imgView = [[UIImageView alloc] init];
    [self.view addSubview:self.imgView];
    [self.imgView setImage:[UIImage imageNamed:@"SUC_button"]];
    
    self.lab = [[UILabel alloc] init];
    [self.view addSubview:self.lab];
    self.lab.text = @"转出成功，等待后台审核...";
    [self.lab xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    [self initLayout];
}

- (void)initLayout {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_offset(65 * kWidthRatio6s);
        make.top.equalTo(self.view).mas_offset(50 * kWidthRatio6s);
    }];
    
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.centerX.equalTo(self.imgView);
    }];
}

@end
