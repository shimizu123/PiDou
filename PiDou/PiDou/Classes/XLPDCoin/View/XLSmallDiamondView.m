//
//  XLSmallDiamondView.m
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSmallDiamondView.h"
#import "XLPaopaoButton.h"
#import "RBBTweenAnimation.h"
#import "XLPDRecordModel.h"

// 最多显示泡泡的数量
static NSInteger const PaopaoMaxNum = 5;

@interface XLSmallDiamondView () {
    CGFloat _paopaoWidth;
}

// 背景图
@property (nonatomic, strong) UIImageView *bgIcon;
// 泡泡button，固定十个，隐藏显示控制
@property (nonatomic, strong) NSArray <XLPaopaoButton *> *paopaoBtnArray;
// 当前显示的泡泡数据
@property (nonatomic, strong) NSMutableArray *showDatas;
// x最多可选取的随机数值因数
@property (nonatomic, strong) NSMutableArray <NSNumber *> *xFactors;
// y最多可选取的随机数值因数
@property (nonatomic, strong) NSMutableArray <NSNumber *> *yFactors;

@property (nonatomic, strong) NSMutableArray <NSNumber *> *specificPoints;

@end

@implementation XLSmallDiamondView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化数组
        self.showDatas = [NSMutableArray arrayWithCapacity:PaopaoMaxNum];
        
        // 布局
        [self addSubview:self.bgIcon];
        self.bgIcon.frame = frame;
        
        _paopaoWidth = self.frame.size.width / PaopaoMaxNum;
        for (UIButton *paopao in self.paopaoBtnArray) {
            paopao.frame = CGRectMake(0, 0, _paopaoWidth, _paopaoWidth);
            [self addSubview:paopao];
        }
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    for (NSInteger i = 0; i < dataList.count; i++) {
        if (self.showDatas.count == PaopaoMaxNum) {
            return;
        }
        XLPaopaoButton *paopao = self.paopaoBtnArray[i];
        paopao.tag = i;
        paopao.hidden = NO;
        [paopao setTitle:@"PDCoin"];
        XLPDRecordModel *oneModel = self.dataList[i];
        [paopao setNum:oneModel.amount];
        //[paopao setNum:self.dataList[i]];
        //CGPoint randomPoint = [self getRandomPoint];
        paopao.center = [self getSpecificPointWithIndex:i];
        [self addFloatAnimationWithPaopao:paopao];
        [self.showDatas addObject:dataList[i]];
    }
}

#pragma mark - 泡泡加动画

- (void)addFloatAnimationWithPaopao:(XLPaopaoButton *)paopao {
    RBBTweenAnimation *sinus = [RBBTweenAnimation animationWithKeyPath:@"position.y"];
    sinus.fromValue = @(0);
    sinus.toValue = @(3);
    sinus.easing = ^CGFloat (CGFloat fraction) {
        return sin((fraction) * 2 * M_PI);
    };
    sinus.additive = YES;
    sinus.duration = [self getRandomNumber:3 to:5];
    sinus.repeatCount = HUGE_VALF;
    [paopao.layer addAnimation:sinus forKey:@"sinus"];
}

// 重置动画，因为页面disappear会将layer动画移除
- (void)resetAnimation {
    for (NSInteger i = 0; i < self.showDatas.count; i++) {
        XLPaopaoButton *paopao = self.paopaoBtnArray[i];
        [self addFloatAnimationWithPaopao:paopao];
    }
}

// 移除所有泡泡
- (void)removeAllPaopao {
    for (XLPaopaoButton *paopao in self.paopaoBtnArray) {
        paopao.hidden = YES;
    }
    [self.showDatas removeAllObjects];
}

#pragma mark - 获取随机点坐标

- (CGPoint)getRandomPoint {
    CGFloat x = [self getRandomX];
    CGFloat y = [self getRandomY];
    return CGPointMake(x, y);
}

- (CGFloat)getRandomX {
    NSInteger index = arc4random() % self.xFactors.count;
    CGFloat factor = self.xFactors[index].floatValue;
    CGFloat x = 33 + (self.frame.size.width - 60) * factor;
    [self.xFactors removeObjectAtIndex:index];
    return x;
}

- (CGFloat)getRandomY {
    NSInteger index = arc4random() % self.yFactors.count;
    CGFloat factor = self.yFactors[index].floatValue;
    CGFloat y = 130 + (XLSmallDiamondViewHeight - 130 - 160) * factor;
    [self.yFactors removeObjectAtIndex:index];
    return y;
}

/*
 - (CGPoint)getRandomPoint {
 CGFloat x = [self getRandomNumber:50 to:SCREEN_WIDTH - 50];
 CGFloat y = [self getRandomNumber:130 to:HomeHeaderBgIconHeight - 160];
 return CGPointMake(x, y);
 }
 */
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - 获取特定坐标
- (CGPoint)getSpecificPointWithIndex:(NSInteger)index {
    return self.specificPoints[index].CGPointValue;
}

#pragma mark - 泡泡点击

- (void)paopaoClick:(XLPaopaoButton *)sender {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        sender.frame = CGRectMake(sender.frame.origin.x, -70, sender.frame.size.width, sender.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            sender.hidden = YES;
            NSInteger num = 0;
            for (NSInteger i = 0; i < self.paopaoBtnArray.count; i++) {
                XLPaopaoButton *paopao = self.paopaoBtnArray[i];
                if (paopao.isHidden) {
                    num++;
                }
            }
            if (num == PaopaoMaxNum) {
                [self.showDatas removeAllObjects];
                self.xFactors = nil;
                self.yFactors = nil;
            }
            if ([self.delegate respondsToSelector:@selector(smallDiamondView:didPappaoAtIndex:isLastOne:)]) {
                [self.delegate smallDiamondView:self didPappaoAtIndex:sender.tag isLastOne:num == PaopaoMaxNum];
            }
        }
    }];
}

#pragma mark - 全部领取
- (void)allPaopaoClick {
    for (XLPaopaoButton *sender in self.paopaoBtnArray) {
        if (!sender.isHidden) {
            [self paopaoClick:sender];
        }
    }
}

#pragma mark - Get

- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc] init];
        _bgIcon.contentMode = UIViewContentModeScaleAspectFill;
//        _bgIcon.clipsToBounds = YES;
//        _bgIcon.image = [UIImage imageNamed:@"BG_home_default"];
    }
    return _bgIcon;
}



- (NSArray<XLPaopaoButton *> *)paopaoBtnArray {
    if (!_paopaoBtnArray) {
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:PaopaoMaxNum];
        for (NSInteger i = 0; i < PaopaoMaxNum; i++) {
            XLPaopaoButton *button = [[XLPaopaoButton alloc] init];
            [button setPaopaoImage:[UIImage imageNamed:@"coin_paopao_small"]];
            button.hidden = YES;
            [button addTarget:self action:@selector(paopaoClick:) forControlEvents:UIControlEventTouchUpInside];
            [marr addObject:button];
        }
        _paopaoBtnArray = marr;
    }
    return _paopaoBtnArray;
}

- (NSMutableArray<NSNumber *> *)xFactors {
    if (!_xFactors) {
        _xFactors = [NSMutableArray arrayWithArray:@[@(0.00f), @(0.11f), @(0.22f), @(0.33f), @(0.44f), @(0.55f), @(0.66f), @(0.77f), @(0.88f), @(0.99)]];
    }
    return _xFactors;
}

- (NSMutableArray<NSNumber *> *)yFactors {
    if (!_yFactors) {
        _yFactors = [NSMutableArray arrayWithArray:@[@(0.00f), @(0.11f), @(0.22f), @(0.33f), @(0.44f), @(0.55f), @(0.66f), @(0.77f), @(0.88f), @(0.99)]];
    }
    return _yFactors;
}

- (NSMutableArray *)specificPoints {
    if (!_specificPoints) {
//        CGFloat midX = self.frame.size.width * 0.5;
//        CGFloat midY = _paopaoWidth;
//        CGFloat X2 = midX - _paopaoWidth;
//        CGFloat X3 = midX + _paopaoWidth;
//        CGFloat X1 = X2 - _paopaoWidth;
//        CGFloat X4 = X3 + _paopaoWidth;
//
//        CGFloat Y2 = midY + _paopaoWidth * 0.5;
//        CGFloat Y3 = Y2;
//        CGFloat Y1 = Y2 + _paopaoWidth;
//        CGFloat Y4 = Y1;
//
//        CGPoint p1 = CGPointMake(X1, Y1);
//        CGPoint p2 = CGPointMake(X2, Y2);
//        CGPoint pMid = CGPointMake(midX, midY);
//        CGPoint p3 = CGPointMake(X3, Y3);
//        CGPoint p4 = CGPointMake(X4, Y4);
//        _specificPoints = [NSMutableArray arrayWithObjects:@(p1),@(p2),@(pMid),@(p3),@(p4), nil];
        CGPoint centerP = CGPointMake(self.xl_w * 0.5, self.xl_h + 30 * kWidthRatio6s);
        CGFloat radius = self.xl_h - _paopaoWidth * 0.5;
        CGPoint p3 = [self calcCircleCoordinateWithCenter:centerP andWithAngle:90 andWithRadius:radius];
        CGPoint p2 = [self calcCircleCoordinateWithCenter:centerP andWithAngle:120 andWithRadius:radius];
        CGPoint p1 = [self calcCircleCoordinateWithCenter:centerP andWithAngle:150 andWithRadius:radius];
        CGPoint p4 = [self calcCircleCoordinateWithCenter:centerP andWithAngle:60 andWithRadius:radius];
        CGPoint p5 = [self calcCircleCoordinateWithCenter:centerP andWithAngle:30 andWithRadius:radius];
        _specificPoints = [NSMutableArray arrayWithObjects:@(p3),@(p2),@(p4),@(p1),@(p5), nil];
        
    }
    return _specificPoints;
}

- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center andWithAngle:(CGFloat)angle andWithRadius:(CGFloat)radius {
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

@end
