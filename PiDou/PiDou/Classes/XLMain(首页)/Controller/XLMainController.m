//
//  XLMainController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMainController.h"
#import "XLRecommendController.h"
#import "XLVideoController.h"
#import "XLPictureController.h"
#import "XLDuanziController.h"
#import "XLMainSearchController.h"

#import "XLGroupBar.h"
#import "XLDiamondView.h"
#import "XLPlayerManager.h"
#import "AnnouncementView.h"
#import "GeneralHandle.h"

@interface XLMainController () <XLGroupBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLGroupBar *groupBar;
@property (nonatomic, strong) NSMutableArray *childsVC;
@property (nonatomic, strong) NSMutableArray *titlesArr;

@property (nonatomic, strong) XLRecommendController *recommendVC;
@property (nonatomic, strong) XLVideoController *videoVC;
@property (nonatomic, strong) XLPictureController *pictureVC;
@property (nonatomic, strong) XLDuanziController *duanziVC;

@property (nonatomic, strong) UIViewController *preVC;

@property (nonatomic, strong) XLDiamondView *diamondView;

@end

@implementation XLMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initNavBar];
    
    [self initBaseChildVC];
    [self initBaseUI];
    
    [self.diamondView showView];
    
    [self checkVersion];
    [self announcement];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.diamondView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.diamondView.hidden = YES;
}

- (void)initNavBar {
    [self.view addSubview:self.groupBar];
}

- (void)initBaseChildVC {
    self.childsVC = [NSMutableArray arrayWithObjects:self.recommendVC,self.videoVC,self.pictureVC,self.duanziVC, nil];
    for (UIViewController *vc in self.childsVC) {
        [self.titlesArr addObject:vc.title];
        [self addChildViewController:vc];
    }
}

- (void)initBaseUI {
    // 将segment放到子视图去设置frame
    // 父视图只管seg的初始化和scrollview的设置
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

// 版本更新
- (void)checkVersion {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Entity];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 440) {
            msg = @"有新版本可更新";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:@"http://www.pidoutv.com"];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alertController addAction:cancel];
            [alertController addAction:sure];
            
            [self presentViewController:alertController animated:true completion:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

// 公告
- (void)announcement {
    [GeneralHandle systemTitle:^(NSString *content) {
        AnnouncementView *announce = [AnnouncementView announcementView];
        announce.content = content;
        [announce show];
    } failure:^(id  _Nonnull result) {
        
    }];
}

#pragma mark - XLGroupBarDelegate
//选中某个模块
- (void)groupBar:(XLGroupBar *)groupBar didSelectIndex:(NSInteger)index {
     NSLog(@"选中某个模块");
    [XLPlayerManager disappear];
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
//选中搜索
- (void)didSelectSearchWithGroupBar:(XLGroupBar *)groupBar {
    NSLog(@"选中搜索");
    XLMainSearchController *searchVC = [[XLMainSearchController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
    
    if (self.groupBar && self.groupBar.selectIndex != index) {
        [self.groupBar didClickWithIndex:index];
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
    self.groupBar.progress = progress;
}

#pragma mark - lazy load
- (XLGroupBar *)groupBar {
    if (!_groupBar) {
        _groupBar = [XLGroupBar groupBar];
        _groupBar.delegate = self;
    }
    return _groupBar;
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

- (XLRecommendController *)recommendVC {
    if (!_recommendVC) {
        _recommendVC = [XLRecommendController new];
        _recommendVC.title = @"推荐";
    }
    return _recommendVC;
}

- (XLVideoController *)videoVC {
    if (!_videoVC) {
        _videoVC = [XLVideoController new];
        _videoVC.title = @"视频";
    }
    return _videoVC;
}

- (XLPictureController *)pictureVC {
    if (!_pictureVC) {
        _pictureVC = [XLPictureController new];
        _pictureVC.title = @"图片";
    }
    return _pictureVC;
}

- (XLDuanziController *)duanziVC {
    if (!_duanziVC) {
        _duanziVC = [XLDuanziController new];
        _duanziVC.title = @"段子";
    }
    return _duanziVC;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, XL_NAVIBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H - XL_TABBAR_H);
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


- (XLDiamondView *)diamondView {
    if (!_diamondView) {
        _diamondView = [XLDiamondView diamondViewWithTarget:self];
    }
    return _diamondView;
}


@end
