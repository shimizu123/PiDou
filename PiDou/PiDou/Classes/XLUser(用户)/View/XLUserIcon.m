//
//  XLUserIcon.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserIcon.h"
#import "XLUserDetailController.h"

@interface XLUserIcon ()

@property (nonatomic, strong) UIImageView *iconImgV;
@property (nonatomic, strong) UIImageView *vipImgV;

@end

@implementation XLUserIcon

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.iconImgV = [[UIImageView alloc] init];
    [self addSubview:self.iconImgV];
    self.iconImgV.image = [UIImage imageNamed:@"user_icon_placeholder"];
    self.iconImgV.backgroundColor = XL_COLOR_BG;
    self.iconImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconAction)];
    [self.iconImgV addGestureRecognizer:tap];
    
    self.vipImgV = [[UIImageView alloc] init];
    [self addSubview:self.vipImgV];
    self.vipImgV.image = [UIImage imageNamed:@"user_vip"];
    self.vipImgV.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.vipImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.height.equalTo(self.iconImgV.mas_width).multipliedBy(16 / 44.0);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    XLViewRadius(self.iconImgV, self.iconImgV.xl_w * 0.5);
}

- (void)setVip:(BOOL)vip {
    _vip = vip;
    self.vipImgV.hidden = !_vip;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"user_icon_placeholder"]];
    });
}

- (void)tapIconAction {
    if (!XLStringIsEmpty(self.user_id)) {
        XLUserDetailController *userDetailVC = [[XLUserDetailController alloc] init];
        userDetailVC.user_id = self.user_id;
        [self.navigationController pushViewController:userDetailVC animated:YES];
    }
}

@end
