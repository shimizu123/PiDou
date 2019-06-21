//
//  XLLaunchController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLLaunchController.h"
#import "XLLaunchManager.h"
#import "XLRootManager.h"

@interface XLLaunchController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView  *launchScrollView;
@property(nonatomic, strong) UIPageControl *page;
@property(nonatomic, strong) UIButton *enterButton;

@property(nonatomic, strong) NSArray *images;

@end

@implementation XLLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 判断是否登录
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [XLLaunchManager isLogin];
//    });
}

- (void)initUI {
    
    [self setupDefaultImageView];
    
    //    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //    btn.frame = CGRectMake(SCREEN_WIDTH - 100, 20, 100, 100);
    //    [btn setTitle:@"跳过" forState:(UIControlStateNormal)];
    //    [btn addTarget:self action:@selector(goMainAction) forControlEvents:(UIControlEventTouchUpInside)];
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(TG_LEFT_DISTANCE, 0, 0, TG_LEFT_DISTANCE);
    //    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    //    [self.view addSubview:btn];
    //    self.goMainBtn = btn;
    
    _launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _launchScrollView.showsHorizontalScrollIndicator = NO;
    _launchScrollView.bounces = NO;
    _launchScrollView.pagingEnabled = YES;
    _launchScrollView.delegate = self;
    [self.view addSubview:_launchScrollView];
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSMutableArray *imageNames = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [imageNames addObject:[NSString stringWithFormat:@"launch%d_%.0fX%.0f",i+1,viewSize.width * 3,viewSize.height * 3]];
    }
    self.images = imageNames;
}


- (void)setImages:(NSArray *)images {
    _images = images;
    
    _launchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * images.count, SCREEN_HEIGHT);
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:images[i]];
        [_launchScrollView addSubview:imageView];
        
        if (i == images.count - 1) {
            
            //enterButton = [self getEnterButton];
            [imageView addSubview:_enterButton];
            imageView.userInteractionEnabled = YES;
        }
    }
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 30)];
    _page.numberOfPages = images.count;
    _page.backgroundColor = [UIColor clearColor];
    _page.currentPage = 0;
    _page.defersCurrentPageDisplay = YES;
    [self.view addSubview:_page];
    
}

- (UIButton *)getEnterButton {
    if (!_enterButton) {
        
        _enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _enterButton.backgroundColor = COLOR_A(0x40eb78, 1);
        _enterButton.layer.cornerRadius = 5;
        [_enterButton setTitle:@"点击进入" forState:UIControlStateNormal];
    }
    _enterButton.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-80);
    [_enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _enterButton;
}

- (void)setEnterButton:(UIButton *)enterButton {
    _enterButton = enterButton;
}

- (void)setCurrentColor:(UIColor *)currentColor {
    _page.currentPageIndicatorTintColor = currentColor;
}

- (void)setNomalColor:(UIColor *)nomalColor {
    _page.pageIndicatorTintColor = nomalColor;
    
}

#pragma mark - scrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    int cuttentIndex = (int)(scrollView.contentOffset.x + SCREEN_WIDTH/2) / SCREEN_WIDTH;
    //如果是最后一页左滑
    if (cuttentIndex == self.images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
             [self goMainAction];
        }
    }
}

//修改page的显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _launchScrollView) {
        
        int cuttentIndex = (int)(scrollView.contentOffset.x + SCREEN_WIDTH/2)/SCREEN_WIDTH;
        _page.currentPage = cuttentIndex;
    }
}

#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}



- (void)enterBtnClick {
    
    [self goMainAction];
}

- (void)goMainAction {
    [XLRootManager rootToMainTabBarVC];
}

- (void)setupDefaultImageView {
    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    launchImageView.image = [self getLaunchImage];
    [self.view addSubview:launchImageView];
}

- (UIImage *)getLaunchImage {
    UIImage *launchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        viewOrientation = @"Landscape";
    } else {
        viewOrientation = @"Portrait";
    }
    //TGLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dic in imagesDictionary) {
        CGSize imageSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize)) {
            launchImage = [UIImage imageNamed:dic[@"UILaunchImageName"]];
        }
    }
    return launchImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
