//
//  XLSegment.m
//  TG
//
//  Created by kevin on 26/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "XLSegment.h"
#import "XLSegButton.h"


#define TitleBottomView_w 18 * kWidthRatio

//最大放大倍数
static const CGFloat ItemMaxScale = 1.25;

@interface XLSegment ()



/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;
/** 当前被选中的按钮 */
@property (nonatomic, strong) XLSegButton *selectedTitleButton;
/** 标题栏底部的指示器 */
@property (nonatomic, strong) UIView *titleBottomView;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat botHeight;
@property (nonatomic, assign) BOOL autoWidth;

@end

@implementation XLSegment

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:14.f];
    }
    
    return _titleFont;
}

- (CGFloat)botHeight {
    if (!_botHeight) {
        _botHeight = 2;
    }
    return _botHeight;
}

- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (instancetype)initSegmentWithTitles:(NSArray *)titles frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        [self setUp];
    }
    return self;
}

- (instancetype)initSegmentWithTitles:(NSArray *)titles frame:(CGRect)frame font:(UIFont *)font botH:(CGFloat)botH {
    self.titleFont = font;
    if (botH == 0) {
        self.botHeight = 0.01;
        self.scaleAnimation = NO;
    } else {
        self.botHeight = botH;
        self.scaleAnimation = YES;
    }

    return [self initSegmentWithTitles:titles frame:frame];
}

- (instancetype)initSegmentWithTitles:(NSArray *)titles frame:(CGRect)frame font:(UIFont *)font botH:(CGFloat)botH autoWidth:(BOOL)autoWidth {
    self.autoWidth = autoWidth;
    
    return [self initSegmentWithTitles:titles frame:frame font:font botH:botH];
}

- (void)setUp {
    [self setupTitlesView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setupTitlesView {
    
    if (self.titlesView || XLArrayIsEmpty(self.titles)) {
        return;
    }
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor clearColor];
    titlesView.frame = CGRectMake(0, 0, self.xl_w, self.xl_h);
    [self addSubview:titlesView];
    self.titlesView = titlesView;
    [titlesView layoutIfNeeded];
    // 标签栏内部的标签按钮
    NSUInteger count = self.titles.count;
    CGFloat titleButtonH = titlesView.xl_h;
    CGFloat titleButtonW = titlesView.xl_w / count;
    for (int i = 0; i < count; i++) {
        // 创建
        XLSegButton *titleButton = [XLSegButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        if (count == 1) {
            //只有一个的时候，点击不改变颜色
            titleButton.enabled = NO;
            [titleButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
        }
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        // 文字
        NSString *title = self.titles[i];
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.titleLabel.font = self.titleFont;
        // frame
        titleButton.xl_y = 0;
        titleButton.xl_h = titleButtonH;
        titleButton.xl_w = titleButtonW;
        titleButton.xl_x = i * titleButton.xl_w;
        titleButton.tag = 1000 + i;
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.xl_h = self.botHeight;
    titleBottomView.xl_y = titlesView.xl_h - titleBottomView.xl_h;
    [titlesView addSubview:titleBottomView];
    XLViewRadius(titleBottomView, self.botHeight * 0.5);
    self.titleBottomView = titleBottomView;
    self.titleBottomView.hidden = self.bottomVHidden;
    // 默认点击最前面的按钮
    XLSegButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.xl_w = self.autoWidth ? firstTitleButton.titleLabel.xl_w * ItemMaxScale : TitleBottomView_w;
//    titleBottomView.xl_w = TitleBottomView_w;
    titleBottomView.xl_centerX = firstTitleButton.xl_centerX;
    [self titleClick:firstTitleButton];
    
    
    self.ignoreAnimation = NO;
}

#pragma mark - 监听
- (void)titleClick:(XLSegButton *)titleButton {
    self.ignoreAnimation = YES;
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.xl_w = self.autoWidth ? titleButton.titleLabel.xl_w * ItemMaxScale : TitleBottomView_w;
//        self.titleBottomView.xl_w = TitleBottomView_w;
        self.titleBottomView.xl_centerX = titleButton.xl_centerX;
    }];
    
    self.selectIndex = titleButton.tag - 1000;
    if (_delegate) {
        [_delegate didSegmentWithIndex:titleButton.tag - 1000];
    }
    
    for (XLSegButton *btn in self.titleButtons) {
        [btn setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
        [btn setTitleColor:XL_COLOR_RED forState:(UIControlStateSelected)];
        btn.selected = NO;
        btn.transform = CGAffineTransformMakeScale(1, 1);
    }
    XLSegButton *selectButton = self.titleButtons[self.selectIndex];
    [selectButton setSelected:YES];
    if (self.scaleAnimation) {
        selectButton.transform = CGAffineTransformMakeScale(ItemMaxScale, ItemMaxScale);
    }
}



- (void)didClickWithIndex:(NSInteger)index {
    self.selectIndex = index;
    [self titleClick:self.titleButtons[index]];
    self.ignoreAnimation = NO;
}

- (void)setBottomVHidden:(BOOL)bottomVHidden {
    _bottomVHidden = bottomVHidden;
    self.titleBottomView.hidden = _bottomVHidden;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self setUp];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (self.ignoreAnimation) {return;}
    //更新阴影位置
    [self updateShadowPosition:progress];
    //更新标题颜色、大小
    [self updateItem:progress];
}
//更新阴影位置
- (void)updateShadowPosition:(CGFloat)progress {
    
    //progress > 1 向左滑动表格反之向右滑动表格
    NSInteger nextIndex = progress > _selectIndex ? (_selectIndex + 1) : (_selectIndex - 1);
    if (nextIndex < 0 || nextIndex == _titles.count) {return;}
    //获取当前阴影位置
    CGRect currentRect = ((XLSegButton *)self.titleButtons[_selectIndex]).frame;
    CGRect nextRect = ((XLSegButton *)self.titleButtons[nextIndex]).frame;
    //如果在此时cell不在屏幕上 则不显示动画
    if (CGRectGetMinX(currentRect) < 0 || CGRectGetMinX(nextRect) < 0) {return;}
    
    progress = progress > _selectIndex ? (progress - _selectIndex) : (_selectIndex - progress);
    
    //更新宽度
//    CGFloat width = currentRect.size.width + progress*(nextRect.size.width - currentRect.size.width);
//    CGRect bounds = self.titleBottomView.bounds;
//    bounds.size.width = width;
//    self.titleBottomView.bounds = bounds;
    
    //更新位置
    CGFloat distance = CGRectGetMidX(nextRect) - CGRectGetMidX(currentRect);
    self.titleBottomView.xl_center = CGPointMake(CGRectGetMidX(currentRect) + progress* distance, self.titleBottomView.xl_centerY);
}
//更新标题颜色
- (void)updateItem:(CGFloat)progress {
    NSInteger nextIndex = progress > _selectIndex ? (_selectIndex + 1) : (_selectIndex - 1);
    if (nextIndex < 0 || nextIndex == _titles.count) {return;}
    
    XLSegButton *currentItem = (XLSegButton *)self.titleButtons[_selectIndex];
    XLSegButton *nextItem = (XLSegButton *)self.titleButtons[nextIndex];
    progress = progress > _selectIndex ? (progress - _selectIndex) : (_selectIndex - progress);
    
    //更新颜色
    [currentItem setTitleColor:[self transformFromColor:XL_COLOR_RED toColor:XL_COLOR_BLACK progress:progress] forState:(UIControlStateSelected)];
    [nextItem setTitleColor:[self transformFromColor:XL_COLOR_BLACK toColor:XL_COLOR_RED progress:progress] forState:(UIControlStateNormal)];
    //更新放大
    if (self.scaleAnimation) {
        CGFloat currentItemScale = ItemMaxScale - (ItemMaxScale - 1) * progress;
        CGFloat nextItemScale = 1 + (ItemMaxScale - 1) * progress;
        currentItem.transform = CGAffineTransformMakeScale(currentItemScale, currentItemScale);
        nextItem.transform = CGAffineTransformMakeScale(nextItemScale, nextItemScale);
    }
}

/**
 颜色渐变
 
 @param fromColor 初始颜色
 @param toColor 转变后的颜色
 @param progress 进度条
 @return color
 */
- (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    if (!fromColor || !toColor) {
        NSLog(@"Warning !!! color is nil");
        return [UIColor blackColor];
    }
    
    progress = progress >= 1 ? 1 : progress;
    
    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
    
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
    
    CGFloat red = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat green = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat blue = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end
