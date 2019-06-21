//
//  XLMineFocusController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineFocusController.h"
#import "XLSegment.h"
#import "XLFansFocusController.h"
#import "XLMineTopicController.h"

@interface XLMineFocusController () <XLSegmentDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) XLSegment *segment;
@property (nonatomic, strong) UIView *hLine;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childsVC;
@property (nonatomic, strong) NSMutableArray *titlesArr;

@property (nonatomic, strong) UIViewController *preVC;

@property (nonatomic, strong) XLFansFocusController *focusVC;
@property (nonatomic, strong) XLMineTopicController *topicVC;

@end

@implementation XLMineFocusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =  @"我的关注";
    
    [self initBaseChildVC];
    [self initBaseUI];
}

- (void)initBaseChildVC {
    self.childsVC = [NSMutableArray arrayWithObjects:self.focusVC,self.topicVC, nil];
    for (UIViewController *vc in self.childsVC) {
        [self.titlesArr addObject:vc.title];
        [self addChildViewController:vc];
    }
}

- (void)initBaseUI {
    
    
    CGFloat segmentH = 44 * kWidthRatio6s;
    self.segment = [[XLSegment alloc] initSegmentWithTitles:@[@"用户",@"话题"] frame:(CGRectMake(0, 0, SCREEN_WIDTH, segmentH)) font:[UIFont xl_fontOfSize:13.f] botH:3 * kWidthRatio6s autoWidth:YES];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    self.segment.delegate = self;
    
    // 将segment放到子视图去设置frame
    // 父视图只管seg的初始化和scrollview的设置
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.hLine = [[UIView alloc] init];
    [self.view addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(1);
        make.bottom.equalTo(self.segment.mas_bottom);
    }];
    
    
    
}

#pragma mark - XLSegmentDelegate
- (void)didSegmentWithIndex:(NSInteger)index {
    int indexNow = self.scrollView.contentOffset.x / self.scrollView.xl_w;
    if (indexNow == index) {
        return;
    }
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.xl_w * index;
    // 不给滚动效果
    [self.scrollView setContentOffset:offset animated:NO];
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}

#pragma mark - UIScrollViewDelegate
/**
 * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 取出对应的子控制器
    //    self.segment.ignoreAnimation = NO;
    int index = scrollView.contentOffset.x / scrollView.xl_w;
    UIViewController *willShowChildVc = self.childsVC[index];
    
    if (self.segment && self.segment.selectIndex != index) {
        [self.segment didClickWithIndex:index];
    }
    
    // 如果控制器的view已经被创建过，就直接返回
    if (!willShowChildVc.isViewLoaded) {
        // 添加子控制器的view到scrollView身上
        willShowChildVc.view.frame = scrollView.bounds;
        [scrollView addSubview:willShowChildVc.view];
    } else {
        [willShowChildVc performSelector:@selector(viewWillAppear:) withObject:nil];
    }
    self.preVC = willShowChildVc;
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    //    int index = scrollView.contentOffset.x / scrollView.tg_w;
    //    if (self.segment && self.segment.selectIndex != index) {
    //        [self.segment didClickWithIndex:index];
    //    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == scrollView.bounds.size.width) {return;}
    CGFloat progress = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.segment.progress = progress;
}

#pragma mark - 保存显示的控制器的字典
- (NSMutableArray *)childsVC {
    if (!_childsVC) {
        _childsVC = [NSMutableArray array];
    }
    return _childsVC;
}
- (NSMutableArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}

- (XLFansFocusController *)focusVC {
    if (!_focusVC) {
        _focusVC = [[XLFansFocusController alloc] init];
        _focusVC.vcType = XLFansFocusVCType_myfocus;
        _focusVC.user_id = [XLUserHandle userid];
        _focusVC.title = @"用户";
    }
    return _focusVC;
}

- (XLMineTopicController *)topicVC {
    if (!_topicVC) {
        _topicVC = [[XLMineTopicController alloc] init];
        _topicVC.title = @"主题";
    }
    return _topicVC;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segment.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.segment.frame) - XL_NAVIBAR_H);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.childsVC.count * self.view.xl_w, 0);
        // 默认显示第0个控制器
        [self scrollViewDidEndScrollingAnimation:_scrollView];
    }
    return _scrollView;
}


@end
