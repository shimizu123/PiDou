//
//  XLMainTabBarController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMainTabBarController.h"
#import "XLBaseNavigationController.h"
#import "XLMainController.h"
#import "XLFindController.h"
#import "XLAddController.h"
#import "XLMsgController.h"
#import "XLMineController.h"
#import "UIImage+TGExtension.h"
#import "XLLaunchManager.h"
#import "WZLBadgeImport.h"
#import "AdNoticeView.h"
#import "XLMgsHandle.h"
#import "XLWalletPriceCell.h"

@interface XLMainTabBarController () <UITabBarControllerDelegate, MTGRewardAdLoadDelegate, MTGRewardAdShowDelegate>

/**记录之前点击的tabbaritem*/
@property (nonatomic, assign) NSInteger preIndex;
@property (nonatomic, strong) NSDate *lastSelectedDate;

@property (nonatomic, assign) NSInteger badgeCount;
@end

@implementation XLMainTabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self initControllers];
    
    if (!XLStringIsEmpty([XLUserHandle userid])) {
        [self unreadMessageCount];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData:) name:@"badge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardVideo) name:@"rewardVideo" object:nil];
    [[MTGRewardAdManager sharedInstance] loadVideo:KRewardUnitID delegate:self];
}

- (void)receiveData:(NSNotification *)notification {
    _badgeCount = [(NSNumber *)(notification.object) integerValue];
    [self showBadge];
}

- (void)showBadge {
    UITabBarItem *msgItem = self.tabBar.items[3];
    //it is necessary to adjust badge position
    msgItem.badgeCenterOffset = CGPointMake(0, 1);
    [msgItem showBadgeWithStyle:WBadgeStyleNumber value:_badgeCount animationType:WBadgeAnimTypeNone];
}

- (void)unreadMessageCount {
    kDefineWeakSelf;
    [XLMgsHandle unreadMessageCount:^(NSDictionary *data) {
        WeakSelf.badgeCount = [[data valueForKey:@"count"] integerValue];
    } failure:^(id  _Nonnull result) {
        
    }];
}

- (void)setBadgeCount:(NSInteger)badgeCount {
    _badgeCount = badgeCount;
    [self showBadge];
}


- (void)initControllers {
    
    
    
    XLMainController *mainVC = [[XLMainController alloc] init];
    XLFindController *findVC = [[XLFindController alloc] init];
    XLAddController *addVC = [[XLAddController alloc] init];
    XLMsgController *msgVC = [[XLMsgController alloc] init];
    XLMineController *mineVC = [[XLMineController alloc] init];
    
    [self setUpOneChildVcWithVc:mainVC image:@"tabbar_main" title:@"首页" index:0];
    [self setUpOneChildVcWithVc:findVC image:@"tabbar_find" title:@"发现" index:1];
    [self setUpOneChildVcWithVc:addVC image:@"tabbar_add" title:@"" index:2];
    [self setUpOneChildVcWithVc:msgVC image:@"tabbar_msg" title:@"消息" index:3];
    [self setUpOneChildVcWithVc:mineVC image:@"tabbar_mine" title:@"我的" index:4];
    
    XLBaseNavigationController *mainNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:mainVC];
    XLBaseNavigationController *findNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:findVC];
    XLBaseNavigationController *addNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:addVC];
    XLBaseNavigationController *msgNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:msgVC];
    XLBaseNavigationController *mineNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[mainNaviC,findNaviC,addNaviC,msgNaviC,mineNaviC];
    
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片,selectedImage: image-black
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc image:(NSString *)image title:(NSString *)title index:(NSInteger)index {
    UIImage *img = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImg = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",image]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:img selectedImage:selectedImg];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  XL_COLOR_GRAY, NSForegroundColorAttributeName,                                       [UIFont systemFontOfSize:10], NSFontAttributeName,
                                  nil] forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  XL_COLOR_RED, NSForegroundColorAttributeName,                                       [UIFont systemFontOfSize:10], NSFontAttributeName,
                                  nil]  forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    if (index == 2) {
        item.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    }
    item.tag = index;
    Vc.tabBarItem = item;
    Vc.title = title;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger index = viewController.tabBarItem.tag;
    if ([self isPublishVC:viewController]) {
        XLBaseNavigationController *navC = (XLBaseNavigationController *)viewController;
        if ([navC.topViewController isKindOfClass:[XLAddController class]]) {
            [navC.topViewController setValue:@(self.preIndex) forKey:@"preTabbarItemIndex"];
            UIImage *image = [UIImage getScreenSnap];
            [navC.topViewController setValue:image forKey:@"preViewImage"];
        }
    } else {
        self.preIndex = index;
    }
    
    
}




#pragma mark - 重写setSelectedIndex方法，为了跳转到发布页面经过didSelectViewController方法
-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    [self tabBarController:self didSelectViewController:self.viewControllers[selectedIndex]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // ! 即将选中的页面是之前上一次选中的控制器页面
    if (![viewController isEqual:tabBarController.selectedViewController]) {
        return YES;
    }
    
    // 获取当前点击时间
    NSDate *currentDate = [NSDate date];
    CGFloat timeInterval = currentDate.timeIntervalSince1970 - _lastSelectedDate.timeIntervalSince1970;
    
    // 两次点击时间间隔少于 0.5S 视为一次双击
    if (timeInterval < 0.5) {
        // 通知首页刷新数据
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doubleClickHomeTabBarItem" object:nil];
        
        // 双击之后将上次选中时间置为1970年0点0时0分0秒,用以避免连续三次或多次点击
        _lastSelectedDate = [NSDate dateWithTimeIntervalSince1970:0];
        return NO;
    }
    // 若是单击将当前点击时间复制给上一次单击时间
    _lastSelectedDate = currentDate;
    
    return YES;
}

#pragma mark - 是否是发布页面
- (BOOL)isPublishVC:(UIViewController *)viewController {
    NSInteger index = viewController.tabBarItem.tag;
    if ([viewController isKindOfClass:[XLBaseNavigationController class]]) {
        XLBaseNavigationController *naviVC = (XLBaseNavigationController *)viewController;
        viewController = naviVC.visibleViewController;
    }
    return (index == 2 && [viewController isKindOfClass:[XLAddController class]]);
}

#pragma mark - MTGRewardAdShowDelegate Delegate

//Show Reward Video Ad Success Delegate
- (void)onVideoAdShowSuccess:(NSString *)unitId {
    
}

//Show Reward Video Ad Failed Delegate
- (void)onVideoAdShowFailed:(NSString *)unitId withError:(NSError *)error {
    
}

//About RewardInfo Delegate
- (void)onVideoAdDismissed:(NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(MTGRewardAdInfo *)rewardInfo {
    if (rewardInfo) {
        NSString *transId = [RandomString getRandomString];
        NSString *sign = [[RandomString sharedRandomString] md5:[NSString stringWithFormat:@"%@_1_%@_jqffr7a3vsa068iu", [XLUserHandle userid], transId]];
        NSString *url = [NSString stringWithFormat:@"http://%@/apple?user_id={%@}&trans_id={%@}&reward_amount={1}&reward_name={VirtualItem}&sign={%@}&unit_id={121693}", HostUrl, [XLUserHandle userid], transId, sign];
        //把请求url进行 UTF-8编码
        NSString *path = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [XLAFNetworking get:path params:nil success:^(id  _Nonnull responseObject) {
            NSLog(@"增加点赞次数成功");
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)rewardVideo {
    [[AdNoticeView sharedAdNoticeView] dismiss];
    
    //Check isReady before you show a reward video
    if ([[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:KRewardUnitID]) {
        [[MTGRewardAdManager sharedInstance] showVideo:KRewardUnitID withRewardId:@"3" userId:[XLUserHandle userid] delegate:self viewController:self];
    } else {
        //We will help you to load automatically when isReady is NO
        [HUDController showTextOnly:@"没有广告"];
    }
}


@end
