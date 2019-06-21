//
//  XLCircleCell.m
//  PiDou
//
//  Created by kevin on 14/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCircleCell.h"
//#import "CALayer+XLExtension.h"

@interface XLCircleCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation XLCircleCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    self.imageView.backgroundColor = XL_COLOR_BG;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    XLViewRadius(self.contentView, self.contentView.xl_h * 0.5);
//    XLViewRadius(self.imageView, self.imageView.xl_h * 0.5);
//    self.imageView.clipsToBounds = NO;
//    [self.imageView.layer setLayerShadow:COLOR_A(0x000000, 0.08) offset:(CGSizeMake(0, 4 * kWidthRatio6s)) radius:12 * kWidthRatio6s cornerRadius:self.imageView.xl_h * 0.5];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:nil];
}

@end
