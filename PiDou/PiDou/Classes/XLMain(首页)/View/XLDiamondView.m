//
//  XLDiamondView.m
//  PiDou
//
//  Created by kevin on 7/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLDiamondView.h"
#import "XLPDCoinController.h"
#import "XLLaunchManager.h"

@interface XLDiamondView ()

@property (nonatomic, strong) UIImageView *diamondButton;

/**
 拖动手势
 */
@property (nonatomic,weak) UIPanGestureRecognizer *pan;
/**
 点击手势
 */
@property (nonatomic,weak) UITapGestureRecognizer *tap;

@property (nonatomic, weak) UIViewController *parentVC;;

@end

@implementation XLDiamondView


+ (instancetype)diamondViewWithTarget:(id)target {
    
    CGFloat w = 66 * kWidthRatio6s;
    return [[self alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH - w - 8 * kWidthRatio6s, XL_NAVIBAR_H + 84 * kWidthRatio6s, w, w)) target:target];
}



- (instancetype)initWithFrame:(CGRect)frame target:(id)targer {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentVC = targer;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.diamondButton = [[UIImageView alloc] init];
    [self addSubview:self.diamondButton];
    self.diamondButton.image = [UIImage imageNamed:@"main_enter_diamond"];
    
    self.userInteractionEnabled = YES;
    //[self pan]; // 不需要拖动
    [self tap];
    
    [self initLayout];
}

- (void)initLayout {
    [self.diamondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
}

#pragma makr - 点击
- (void)onSelectedAction {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentVC finish:^{
        }];
        return;
    }
    XLPDCoinController *pdCoinVC = [[XLPDCoinController alloc] init];
    [self.parentVC.navigationController pushViewController:pdCoinVC animated:YES];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


- (void)removeView {
    [self removeFromSuperview];
}

#pragma mark - 手势
- (UITapGestureRecognizer *)tap {
    if (_tap == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectedAction)];
        [self addGestureRecognizer:tap];
        _tap = tap;
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan {
    if (_pan == nil) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panSelf:)];
        [self addGestureRecognizer:pan];
        self.pan = pan;
    }
    return _pan;
}
#pragma mark - 拖动视图
- (void)panSelf:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged: {
            // 移动按钮
            CGPoint translation = [pan translationInView:self];
            self.xl_centerX = self.xl_centerX + translation.x;
            self.xl_centerY = self.xl_centerY + translation.y;
            [pan setTranslation:CGPointZero inView:self];
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat x = self.xl_x;
            CGFloat y = self.xl_y;
            if (44 <= y && y <= SCREEN_HEIGHT - 44 - self.xl_h) {
                if (self.xl_centerX > 0.5 * SCREEN_WIDTH) {
                    x = SCREEN_WIDTH - self.xl_w;
                    
                }else {
                    x = 0;
                }
            }
            if (y < 44) {
                y = 0;
                
            }
            if (y  > SCREEN_HEIGHT - self.xl_h - 44) {
                y = SCREEN_HEIGHT - self.xl_h;
            }
            if (x < 0) {
                x = 0;
            }
            if (x > SCREEN_WIDTH - self.xl_w) {
                x = SCREEN_WIDTH - self.xl_w;
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.xl_x = x;
                self.xl_y = y;
            }];
            break;
        }
        default:
            break;
    }
}

@end
