//
//  XLBaseCollectionView.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseCollectionView.h"

@interface XLBaseCollectionView ()

@property (nonatomic, strong) UILabel *nullLabel;

@end

@implementation XLBaseCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initNullView];
    }
    return self;
}

- (void)initNullView {
    self.nullLabel = [[UILabel alloc] init];
    [self.nullLabel xl_setTextColor:XL_COLOR_GRAY fontSize:14.0f];
    self.nullLabel.textAlignment = NSTextAlignmentCenter;
    self.nullLabel.numberOfLines = 0;
    [self addSubview:self.nullLabel];
    
    [self.nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-XL_NAVIBAR_H);
        make.left.equalTo(self.mas_left).offset(XL_LEFT_DISTANCE * 2);
        make.right.equalTo(self.mas_right).offset(-XL_LEFT_DISTANCE * 2);
    }];
}

- (void)showNullViewWithText:(NSString *)text {
    self.nullLabel.text = text;
    self.nullLabel.hidden = NO;
}
- (void)dismissNullView {
    self.nullLabel.hidden = YES;
}


@end
