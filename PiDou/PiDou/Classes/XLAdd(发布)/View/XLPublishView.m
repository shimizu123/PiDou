//
//  XLPublishView.m
//  TG
//
//  Created by kevin on 7/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLPublishView.h"
#import "XLPublishBtn.h"
#import "UIImage+XLBlurGlass.h"
#import "UIButton+XLAdd.h"

#define BTN_W       48 * kWidthRatio6s
#define BTN_H       70 * kWidthRatio6s
#define ROW_NUM     4
#define ROW_SPACING (SCREEN_WIDTH - ROW_NUM * BTN_W) / (2 * ROW_NUM)
@interface XLPublishView ()

@property (nonatomic, strong) UILabel *titleL;

@property (nonatomic, strong) UIImageView *bgImgV;
/**文字*/
@property (nonatomic, strong) NSArray *titles;
/**图片*/
@property (nonatomic, strong) NSArray *images;
/**按钮数组*/
@property (nonatomic, strong) NSMutableArray *btnArr;
/**底部关闭按钮*/
@property (nonatomic, strong) UIButton *closeBtn;
/**callback*/
@property (nonatomic, copy) XLCompletedBlock complete;
/**选中的按钮*/
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation XLPublishView


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images complete:(XLCompletedBlock)complete {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.complete = complete;
        self.titles = titles;
        self.images = images;
        [self setup];
    }
    return self;
}


- (void)setup {

    
    self.bgImgV = [[UIImageView alloc] init];
    [self addSubview:self.bgImgV];
    self.bgImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.bgImgV addGestureRecognizer:tap];
    
    self.titleL = [[UILabel alloc] init];
    [self.titleL xl_setTextColor:XL_COLOR_BLACK fontSize:12.0f];
    self.titleL.text = @"选择您要发布的类型";
    self.titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleL];
    
    [self initCloseBtn];
    
    [self initPublishBtn];
    
    [self initLayout];
}

- (void)initCloseBtn {
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.closeBtn xl_setImageName:@"public_close" target:self action:@selector(close)];
    [self addSubview:self.closeBtn];
}

- (void)initPublishBtn {
    self.btnArr = [NSMutableArray array];
    
    for (int i = 0; i < self.titles.count; i++) {
        int row=i / ROW_NUM; // 行
        int list=i % ROW_NUM; // 列
        XLPublishBtn *publishBtn = [[XLPublishBtn alloc] initWithFrame:CGRectMake(ROW_SPACING + (2 * ROW_SPACING + BTN_W) * list, SCREEN_HEIGHT + (BTN_H + 20) * row, BTN_W, BTN_H)];
        publishBtn.index = i;
        [publishBtn setTitle:self.titles[i] forState:(UIControlStateNormal)];
        [publishBtn setImage:[UIImage imageNamed:self.images[i]] forState:(UIControlStateNormal)];
        [publishBtn setImage:[UIImage imageNamed:self.images[i]] forState:(UIControlStateHighlighted)];
        [publishBtn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
        //[publishBtn layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleTop) imageTitleSpace:6 * kWidthRatio6s];
        [self addSubview:publishBtn];
        [self.btnArr addObject:publishBtn];
        [UIView animateWithDuration:0.5 delay:i*0.03 usingSpringWithDamping:0.7 initialSpringVelocity:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            publishBtn.frame  = CGRectMake(ROW_SPACING + (2 * ROW_SPACING + BTN_W) * list, (SCREEN_HEIGHT - 305 * kWidthRatio6s) + (BTN_H + 20) * row, BTN_W, BTN_H);
        } completion:^(BOOL finished) {
        }];
    }

}

- (void)initLayout {
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-48 * kWidthRatio6s - XL_HOME_INDICATOR_H);
        make.width.height.mas_offset(50);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60 * kWidthRatio6s);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - 高斯模糊
- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    if (_bgImage) {
        //self.bgImgV.image = [UIImage xl_imageWithBlurImage:_bgImage intputRadius:50];
        self.bgImgV.image = [_bgImage blur];
    }
}

- (void)btnTouchUpInside:(XLPublishBtn *)btn {
    self.selectedIndex = btn.index;
    [self dismissWithSelected];
}

- (void)close {
    
    kDefineWeakSelf;
    for (NSInteger i = self.btnArr.count - 1; i >= 0; i--) {
        XLPublishBtn *button = self.btnArr[i];
        [UIView animateWithDuration:0.4 delay:0.04 * self.btnArr.count - i * 0.05 usingSpringWithDamping:0.8 initialSpringVelocity:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            button.frame  = CGRectMake(button.xl_x, button.xl_y + 305 * kWidthRatio6s, button.xl_w, button.xl_h);
            button.alpha = 0;
            
        } completion:^(BOOL finished) {
            [button removeFromSuperview];
            if (i == WeakSelf.btnArr.count - 1) {
                [WeakSelf dismiss];
            }
        }];
    }

    [UIView animateWithDuration:0.04 * self.btnArr.count animations:^{
        WeakSelf.closeBtn.transform = CGAffineTransformRotate(self.closeBtn.transform, -M_PI_4);
    } completion:^(BOOL finished) {
        WeakSelf.closeBtn.alpha = 0;
    }];
}


#pragma mark - show
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    self.closeBtn.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
        self.closeBtn.alpha = 1;
    }];
}

#pragma mark - dismiss
- (void)dismiss {
    kDefineWeakSelf;

    if (self.complete) {
        self.complete(@(-1));
    }

    
    [UIView animateWithDuration:0.04 animations:^{
        WeakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [WeakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [WeakSelf removeFromSuperview];
        }
    }];

}

- (void)dismissWithSelected {
    kDefineWeakSelf;
    
    if (WeakSelf.complete) {
        WeakSelf.complete(@(WeakSelf.selectedIndex));
    }

    [UIView animateWithDuration:0.4 animations:^{
         WeakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [WeakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [WeakSelf removeFromSuperview];
        }
    }];
}



@end
