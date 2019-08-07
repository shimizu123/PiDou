//
//  AnnouncementView.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "AnnouncementView.h"

@interface AnnouncementView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *banner;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIButton *sureBtn;

@end


@implementation AnnouncementView


+ (instancetype)announcementView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = UIColor.whiteColor;
    XLViewRadius(self.contentView, 5 * kWidthRatio6s);
    
    self.banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300 * kWidthRatio6s, 40 * kWidthRatio6s)];
    [self.contentView addSubview:self.banner];
    self.banner.backgroundColor = XL_COLOR_RED;
    
    self.title = [[UILabel alloc] init];
    [self.banner addSubview:self.title];
    self.title.text = @"公告";
    [self.title xl_setTextColor:UIColor.whiteColor fontSize:18.f];
    
    self.contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:13.f];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 6;
    
    self.separatorLine = [[UIView alloc] init];
    [self.contentView addSubview:self.separatorLine];
    self.separatorLine.backgroundColor = RGB_COLOR(242, 242, 245);
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn xl_setTitle:@"确定" color:XL_COLOR_DARKBLACK size:14.f target:self action:@selector(dismiss)];
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_offset(300 * kWidthRatio6s);
        make.height.mas_offset(190 * kWidthRatio6s);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.banner);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.banner.mas_bottom).mas_offset(18 * kWidthRatio6s);
        make.left.equalTo(self.contentView).mas_offset(30 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-30 * kWidthRatio6s);
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(1 * kWidthRatio6s);
        make.bottom.equalTo(self.sureBtn.mas_top);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
    }];
}


- (void)show {
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)setContent:(NSString *)content {
    _content = content;
    NSString *str = [_content stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    self.contentLabel.text = str;
}

@end
