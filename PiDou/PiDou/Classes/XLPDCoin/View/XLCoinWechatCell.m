//
//  XLCoinWechatCell.m
//  PiDou
//
//  Created by kevin on 23/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCoinWechatCell.h"

@interface XLCoinWechatCell () 

@property (nonatomic, strong) UIImageView *qrCodeImgV;
@property (nonatomic, strong) UILabel *titleL;

@end

@implementation XLCoinWechatCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.qrCodeImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.qrCodeImgV];
    //self.qrCodeImgV.backgroundColor = XLRandomColor;
    
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_BLACK fontSize:12.f];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.qrCodeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(10 * kWidthRatio6s);
        make.left.equalTo(self.contentView).mas_offset(26 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-26 * kWidthRatio6s);
        make.height.equalTo(self.qrCodeImgV.mas_width);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        //make.top.equalTo(self.qrCodeImgV.mas_bottom).mas_offset(18 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-8 * kWidthRatio6s);
        make.height.mas_offset(18 * kWidthRatio6s);
    }];
}


//- (void)setTitleName:(NSString *)titleName {
//    _titleName = titleName;
//    self.titleL.text = _titleName;
//}

- (void)setQrCodeModel:(XLQRCodeModel *)qrCodeModel {
    _qrCodeModel = qrCodeModel;
    self.titleL.text = _qrCodeModel.title;
    [self.qrCodeImgV sd_setImageWithURL:[NSURL URLWithString:_qrCodeModel.qr_url] placeholderImage:nil];
}

@end
