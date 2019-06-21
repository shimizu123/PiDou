//
//  XLGroupBarView.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGroupBarView.h"

#define SearchButtonWidth 55 * kWidthRatio6s
@interface XLGroupBarView ()

//标题模块
@property (nonatomic,strong) NSMutableArray *titles;
//搜索按钮
@property (nonatomic,strong) UIButton *searchBtn;
//scrollView
@property (nonatomic,weak) UIScrollView *scrollView;

//图片
@property (nonatomic,weak) UIImageView *icon;

//滑块
@property (nonatomic,weak) UIView *slider;
//透明度渐变遮盖
@property (nonatomic,strong) UIView *gradientView;
//透明度渐变layer
@property (nonatomic,strong) CAGradientLayer *gradLayer;


//上次偏移量
@property (nonatomic,assign) CGFloat lastOffsetX;



@end

@implementation XLGroupBarView

#pragma mark - 初始化
+ (instancetype)groupBarView {
    return [[self alloc] init];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self searchBtn];
        [self scrollView];
        [self icon];
        self.lastOffsetX = 0;
    }
    return self;
}


#pragma mark - 滑块
- (UIView *)slider {
    if (_slider == nil) {
        UIView *slider = [[UIView alloc]init];
        [self.scrollView addSubview:slider];
        self.slider = slider;
        slider.backgroundColor = COLOR(0x007aff);
    }
    return _slider;
}
#pragma mark - 图片
- (UIImageView *)icon {
    if (_icon == nil) {
        UIImageView *icon = [[UIImageView alloc]init];
        //        [self addSubview:icon];
        self.icon = icon;
        icon.layer.borderColor = [UIColor blackColor].CGColor;
        icon.layer.borderWidth = 1;
    }
    return _icon;
}
#pragma mark - 标题模块
- (NSMutableArray *)titles {
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

#pragma mark - scrollView
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
#pragma mark - 设置数据
- (void)setGroups:(NSMutableArray *)groups {
    _groups = groups;
    // 清空之前可能存在的所有titleLabel控件
    [self.titles enumerateObjectsUsingBlock:^(UIButton *title, NSUInteger idx, BOOL *stop) {
        [title removeFromSuperview];
    }];
    [self.titles removeAllObjects];
    
    // 创建titleLabel控件
    [_groups enumerateObjectsUsingBlock:^(NSString *group, NSUInteger idx, BOOL *stop) {
        [self setupTitleLabel:group];
        
    }];
}

#pragma mark - 设置标题模块
- (void)setupTitleLabel:(NSString *)title {
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat size = 16;
    if (SCREEN_WIDTH <= 320.0) {
        size = 16;
    }
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:size];
    [titleBtn setTitle:title forState:UIControlStateNormal];
    [titleBtn setTitleColor:XL_COLOR_DARKGRAY forState:UIControlStateNormal];
    [titleBtn setTitleColor:XL_COLOR_RED forState:UIControlStateSelected];
    [titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:titleBtn];
    [self.titles addObject:titleBtn];
}
#pragma mark - 点击按钮模块
- (void)clickTitleBtn:(UIButton *)btn {
    //点击已经选中的按钮
    if (btn.tag == self.index) {
        return;
    }
    
    
    self.index = btn.tag;
    if ([self.delegate respondsToSelector:@selector(groupBarView:didSelectIndex:)]) {
        [self.delegate groupBarView:self didSelectIndex:self.index];
    }
    
}




#pragma mark - 设置所有标题模块位置
- (void)layoutAllTitleLabels {
    __block CGFloat offsetX = 0;
    [self.titles enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat x = offsetX;
        CGFloat y = 0;
        CGFloat h = self.xl_h;
//        CGFloat w = [btn.currentTitle sizeWithFont:btn.titleLabel.font].width + 30 * kWidthRatio6s;
        CGFloat w = (SCREEN_WIDTH - SearchButtonWidth) / 4.0;
        btn.frame = CGRectMake(x, y, w, h);
        btn.tag = idx;
        offsetX = CGRectGetMaxX(btn.frame);
    }];
    
    self.scrollView.contentSize = CGSizeMake(offsetX, self.xl_h);
}
#pragma mark - 设置子控件
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 搜索按钮
    
    
    // 滑动区域
    self.scrollView.xl_x = 0;
    self.scrollView.xl_y = 0;
    self.scrollView.xl_w = SCREEN_WIDTH - self.scrollView.xl_x - SearchButtonWidth;
    self.scrollView.xl_h = self.xl_h;

    CGFloat searchBtnX = CGRectGetMaxX(self.scrollView.frame);
    CGFloat searchBtnY = 0;
    CGFloat searchBtnH = self.xl_h;
    self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, SearchButtonWidth, searchBtnH);
    // 标题
    [self layoutAllTitleLabels];
    
    // 滑块
    self.slider.xl_h = 3 * kWidthRatio6s;
    self.slider.xl_y = self.xl_h - self.slider.xl_h;
    if (self.titles.count > self.index) {
        UIButton *selected = self.titles[self.index];
        selected.selected = YES;
        self.slider.xl_w = [selected.currentTitle sizeWithFont:selected.titleLabel.font].width + 20 * kWidthRatio6s;
        self.slider.xl_centerX = selected.xl_centerX;
    }
    self.slider.layer.cornerRadius = self.slider.xl_h / 2;
    
    
    self.gradientView.frame = self.scrollView.frame;
    self.gradLayer.frame = self.gradientView.bounds;
    self.gradientView.hidden = YES; // 这个版本不做透明度
    self.slider.hidden = YES;
}



// 搜索按钮点击
- (void)searchAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSearchWithGroupBarView:)]) {
        [self.delegate didSelectSearchWithGroupBarView:self];
    }
}

#pragma mark - 设置选中的位置
- (void)setIndex:(NSInteger)index
{
    UIButton *prebtn = [self.titles objectAtIndex:_index];
    UIButton *btn = [self.titles objectAtIndex:index];
    prebtn.selected = NO;
    btn.selected = YES;
    _index = index;
    
    self.lastOffsetX = index;
    //调整位置
    
    //计算出中心点
    CGFloat centerX = btn.xl_x - self.scrollView.contentOffset.x + btn.xl_w * 0.5;
    //调整scrollView的contentOffice
    CGFloat offsetX = centerX - 0.5 * self.scrollView.xl_w;
    CGFloat scrollX = self.scrollView.contentOffset.x + offsetX;
    if (scrollX < 0) {
        scrollX = 0;
    }else if (scrollX + self.scrollView.xl_w > self.scrollView.contentSize.width) {
        scrollX = self.scrollView.contentSize.width - self.scrollView.xl_w;
    }
    if (self.scrollView.xl_w < self.scrollView.contentSize.width) {
        [self.scrollView setContentOffset:CGPointMake(scrollX, self.scrollView.contentOffset.y) animated:YES];
    }
    //移动滑块
    CGFloat sliderW = [btn.currentTitle sizeWithFont:btn.titleLabel.font].width + 20 * kWidthRatio6s;
    CGFloat sliderH = self.slider.xl_h;
    CGFloat sliderY = self.slider.xl_y;
    CGFloat sliderX = btn.xl_x + (btn.xl_w - sliderW) * 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    }];
}
#pragma mark - 设置偏移
- (void)setUpContentOffset:(CGFloat)offset
{
    //在边上不让slider滚动
    if (offset < 0 || offset > self.titles.count - 1) {
        return;
    }
    NSInteger right = (NSInteger)(offset) + 1;
    NSInteger left = (NSInteger)offset;
    if (right >= self.titles.count) {
        return;
    }
    UIButton *leftBtn = self.titles[left];
    UIButton *rightBtn  = self.titles[right];
    //两个标题x移动的距离
    CGFloat offsetX = leftBtn.xl_w;
    //两个标题的宽度差
    CGFloat offsetW = rightBtn.xl_w - leftBtn.xl_w;
    
    //获取移动距离
    CGFloat offsetDelta = offset - self.lastOffsetX;
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetX * offsetDelta;
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetW * offsetDelta;
    //变化
    self.slider.xl_x += underLineTransformX;
    self.slider.xl_w += underLineWidth;
    
    self.lastOffsetX = offset;
    
}

#pragma mark - 触发选中的代理方法
- (void)setUpSelectedIndex:(NSInteger)index
{
    self.index = index;
    if ([self.delegate respondsToSelector:@selector(groupBarView:didSelectIndex:)]) {
        [self.delegate groupBarView:self didSelectIndex:self.index];
    }
}

- (UIButton *)searchBtn {
    if (_searchBtn == nil) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_searchBtn];
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setImage:[UIImage imageNamed:@"main_search_Black"] forState:UIControlStateNormal];
        [_searchBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _searchBtn;
}




- (UIView *)gradientView {
    if (_gradientView == nil) {
        _gradientView = [[UIView alloc] init];
        [self addSubview:_gradientView];
        _gradientView.userInteractionEnabled = NO;
    }
    return _gradientView;
}

- (CAGradientLayer *)gradLayer {
    
    if (_gradLayer == nil) {
        _gradLayer = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:1 alpha:0.9]CGColor],
                           (id)[[UIColor colorWithWhite:1 alpha:0.3] CGColor],
                           (id)[[UIColor colorWithWhite:1 alpha:0.2]CGColor],
                           (id)[[UIColor colorWithWhite:1 alpha:0]CGColor],
                           (id)[[UIColor colorWithWhite:1 alpha:0]CGColor],
                           nil];
        
        [_gradLayer setColors:colors];
        //渐变起止点，point表示向量
        [_gradLayer setStartPoint:CGPointMake(1.0f,0.0f)];
        [_gradLayer setEndPoint:CGPointMake(0.0f,0.0f)];
        [self.gradientView.layer insertSublayer:_gradLayer atIndex:0];
    }
    
    return _gradLayer;
}

@end
