//
//  XLUserDetailHeader.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserDetailHeader.h"
#import "XLSegment.h"

@interface XLUserDetailHeader () <XLSegmentDelegate>

@property (nonatomic, strong) XLSegment *segment;

@property (nonatomic, strong) UIView *hLine;

@end

@implementation XLUserDetailHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    CGFloat segmentH = 40 * kWidthRatio6s;
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"动态",@"帖子",@"评论"] frame:(CGRectMake(0, 0, SCREEN_WIDTH, segmentH)) font:[UIFont xl_fontOfSize:14.f] botH:3 * kWidthRatio6s autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.segment];
    self.segment.delegate = self;
    
    self.hLine = [[UIView alloc] init];
    [self.contentView addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
    
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(userDetailHeader:didSegmentWithIndex:)]) {
        [_delegate userDetailHeader:self didSegmentWithIndex:index];
    }
}

@end
