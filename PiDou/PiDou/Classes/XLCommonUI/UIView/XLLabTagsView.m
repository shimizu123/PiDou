//
//  XLLabTagsView.m
//  CBNVideoApp
//
//  Created by kevin on 8/1/18.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import "XLLabTagsView.h"

@interface XLLabTagsView ()

@property (nonatomic, strong) NSMutableArray *btnsArr;
@property (nonatomic, assign) BOOL disable;

@end

@implementation XLLabTagsView

+ (instancetype)labTagsViewWithTagsArr:(NSArray *)tagsArr disable:(BOOL)disable {
    XLLabTagsView *labtagsView = [[XLLabTagsView alloc] init];
    labtagsView.disable = disable;
    labtagsView.tagsArr = tagsArr;
    return labtagsView;
}

+ (instancetype)labTagsViewWithTagsArr:(NSArray *)tagsArr {
    XLLabTagsView *labtagsView = [[XLLabTagsView alloc] init];
    labtagsView.tagsArr = tagsArr;
    labtagsView.disable = NO;
    return labtagsView;
}

- (void)setTagsArr:(NSArray *)tagsArr {
    _tagsArr = tagsArr;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initUI];
}

- (void)initUI {
    NSInteger count = self.tagsArr.count;
    CGFloat left = 16 * kWidthRatio6s;
    int list = 0; // 列
    int row = 0; // 行
    CGFloat hDel = self.disable ? 35 : 30;
    
    self.btnsArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *title = self.tagsArr[i];
        CGFloat labW = [XLLabTagsView widthForLabel:title fontSize:14.f * kWidthRatio6s] + 32 * kWidthRatio6s;
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:btn];
        btn.frame = CGRectMake(left, row * hDel, labW, 24 * kWidthRatio6s);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:title forState:(UIControlStateNormal)];
        
        btn.tag = i + 1000;
        [btn addTarget:self action:@selector(didClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
//        if (!self.disable) {
//            if (i == self.currentIndex) {
//                btn.titleLabel.font = [UIFont xl_fontOfSize:16.f];
//                XLViewBorderRadius(btn, 8, 1, XL_COLOR_RED.CGColor);
//                [btn setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
//            } else {
//                btn.titleLabel.font = [UIFont xl_fontOfSize:16.f];
//                XLViewBorderRadius(btn, 8, 1, COLOR(0x9B9B9B).CGColor);
//                [btn setTitleColor:COLOR(0x9B9B9B) forState:(UIControlStateNormal)];
//            }
//        } else {
//            btn.titleLabel.font = [UIFont xl_fontOfSize:16.f];
//            XLViewBorderRadius(btn, 8, 1, COLOR(0x9B9B9B).CGColor);
//            [btn setTitleColor:XL_COLOR_GRAY forState:(UIControlStateNormal)];
//        }
        
        XLViewBorderRadius(btn, 2, 1, XL_COLOR_RED.CGColor);
        [btn setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
        [btn setTitle:[NSString stringWithFormat:@"# %@",title] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont xl_fontOfSize:14.f];
        
        left += (labW + 16 * kWidthRatio6s);
        list++;

        if (CGRectGetMaxX(btn.frame) > (self.xl_w > 0 ? self.xl_w : SCREEN_WIDTH) - 120 * kWidthRatio6s && i > 0) {
            list = 0;
            left = 0;
            row++;
            btn.frame = CGRectMake(left,row * hDel, labW, 24 * kWidthRatio6s);
            left += (labW + 32 * kWidthRatio6s);
            list++;
        }
        if (i == count - 1) {
            self.xl_h = CGRectGetMaxY(btn.frame);
            self.xl_w = (self.xl_w > 0 ? self.xl_w : SCREEN_WIDTH);
        }
        [self.btnsArr addObject:btn];
    }
    
}

- (CGFloat)viewHeight {
    return self.xl_h;
}

- (void)didClickAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedTagsWithIndex:)]) {
        self.currentIndex = btn.tag - 1000;
        [_delegate didSelectedTagsWithIndex:btn.tag - 1000];
    }
}




/**
 *  计算文字长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font {
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width > (SCREEN_WIDTH - 120 * kWidthRatio6s) ? (SCREEN_WIDTH - 120 * kWidthRatio6s) : size.width;
}

@end
