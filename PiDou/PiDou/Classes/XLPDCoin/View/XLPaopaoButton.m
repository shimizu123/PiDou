//
//  XLPaopaoButton.m
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPaopaoButton.h"

@interface XLPaopaoButton () 

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation XLPaopaoButton



- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomLabel];
        [self addSubview:self.numLabel];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topImageView.mas_bottom).offset(4 * kWidthRatio6s);
            make.centerX.mas_equalTo(0);
        }];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.topImageView);
        }];
    }
    return self;
}

- (void)setPaopaoImage:(UIImage *)image {
    self.topImageView.image = image;
}

- (void)setTitle:(NSString *)title {
    self.bottomLabel.text = title;
}

- (void)setNum:(NSString *)num {
    self.numLabel.text = num;
}
#pragma mark - Get

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
    }
    return _topImageView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont xl_fontOfSize:12];
        _bottomLabel.textColor = COLOR_A(0xffffff, 0.6);
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont xl_fontOfSize:16.f];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}


@end
