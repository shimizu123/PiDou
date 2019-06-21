//
//  XLAddController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLAddController.h"
#import "XLPublishView.h"
//#import "XLPublishVideoController.h"
#import "XLPublishPhotoController.h"
#import "XLPublishLinkController.h"
#import "XLPublishTextController.h"
#import "XLBaseNavigationController.h"
#import "XLPublishVideoPhotoController.h"
#import "XLLaunchManager.h"

@interface XLAddController ()

@property (nonatomic, strong) XLPublishView *publishView;

@end

@implementation XLAddController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    // 获取到发布结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPublish:) name:XLFinishPublishNotification object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    kDefineWeakSelf;
    self.publishView = [[XLPublishView alloc] initWithFrame:[UIScreen mainScreen].bounds titles:@[@"发视频",@"发图片"/*,@"发链接"*/,@"发文字"] images:@[@"public_video",@"public_photo"/*,@"public_link"*/,@"public_text"] complete:^(id result){
        [WeakSelf didPushVCWithIndex:[result integerValue]];
    }];
    
    [self.publishView show];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.publishView.bgImage = self.preViewImage;
}


- (void)dismiss {
    if (self.publishView) {
        [self.publishView dismiss];
    }
}

- (void)didPushVCWithIndex:(NSInteger)index {
    if (XLStringIsEmpty([XLUserHandle userid]) && index != -1) {
        [XLLaunchManager goLoginWithTarget:self];
        return;
    }
    switch (index) {
        case -1:
        {
            // 点击关闭
            [self goTabBarItem];
        }
            break;
        case 0:
        {
            
            // 点击视频
            [self goVideoVC];
        }
            break;
        case 1:
        {
            // 点击图文
            [self goPhotoVC];
        }
            break;
//        case 2:
//        {
//           // 点击链接
//            [self goLinkVC];
//        }
//            break;
        case 2:
        {
            // 点击文字
            [self goTextVC];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 视频
- (void)goVideoVC {
    kDefineWeakSelf;
    XLPublishVideoPhotoController *videoVC = [[XLPublishVideoPhotoController alloc] init];
    videoVC.publishVCType = XLPublishVideoPhotoType_video;
    XLBaseNavigationController *baseNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:videoVC];
    [self.navigationController presentViewController:baseNaviC animated:YES completion:^{
        [WeakSelf goTabBarItem];
    }];
}

#pragma mark - 图片
- (void)goPhotoVC {
    kDefineWeakSelf;
    XLPublishVideoPhotoController *photoVC = [[XLPublishVideoPhotoController alloc] init];
    photoVC.publishVCType = XLPublishVideoPhotoType_photo;
    XLBaseNavigationController *baseNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:photoVC];
    [self.navigationController presentViewController:baseNaviC animated:YES completion:^{
        [WeakSelf goTabBarItem];
    }];
}

#pragma mark - 链接
- (void)goLinkVC {
    kDefineWeakSelf;
    XLPublishVideoPhotoController *linkVC = [[XLPublishVideoPhotoController alloc] init];
    linkVC.publishVCType = XLPublishVideoPhotoType_link;
    XLBaseNavigationController *baseNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:linkVC];
    [self.navigationController presentViewController:baseNaviC animated:YES completion:^{
        [WeakSelf goTabBarItem];
    }];
}

#pragma mark - 文字
- (void)goTextVC {
    kDefineWeakSelf;
    XLPublishVideoPhotoController *textVC = [[XLPublishVideoPhotoController alloc] init];
    textVC.publishVCType = XLPublishVideoPhotoType_text;
    XLBaseNavigationController *baseNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:textVC];
    [self.navigationController presentViewController:baseNaviC animated:YES completion:^{
        [WeakSelf goTabBarItem];
    }];
}

- (void)goTabBarItem {
    [self.tabBarController setSelectedIndex:self.preTabbarItemIndex];
}

#pragma mark - 发布结束
- (void)finishPublish:(NSNotification *)notif {
//    [[NSNotificationCenter defaultCenter] postNotificationName:TGServerJumpTypeNotification object:self userInfo:@{@"index":@(1)}]; // 通知跳到观点
//    [self.tabBarController setSelectedIndex:0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
