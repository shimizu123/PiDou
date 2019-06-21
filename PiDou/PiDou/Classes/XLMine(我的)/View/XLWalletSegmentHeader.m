//
//  XLWalletSegmentHeader.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletSegmentHeader.h"
#import "XLSegment.h"


@interface XLWalletSegmentHeader () <XLSegmentDelegate>

@property (nonatomic, strong) XLSegment *segment;

@end
@implementation XLWalletSegmentHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"余额记录",@"参与回馈PDCoin明细"] frame:(CGRectMake(0, 0, SCREEN_WIDTH, 44 * kWidthRatio6s)) font:[UIFont xl_fontOfSize:14.f] botH:0 autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.segment];
    self.segment.delegate = self;
    
//    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    if (self.didSelected) {
        self.didSelected(@(index));
    }
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [self.segment didClickWithIndex:_index];
}

@end
