//
//  QRCodeViewController.m
//  PiDou
//
//  Created by 邓康大 on 2019/6/19.
//  Copyright © 2019年 ice. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIImage+QRCode.h"
#import <MBProgressHUD.h>
#import "UIImage+TGExtension.h"
#import <Photos/Photos.h>

@interface QRCodeViewController ()
@property (nonatomic, strong) UIImageView *BgImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIGestureRecognizer *gesture;
@property (nonatomic, strong) UIGestureRecognizer *longPressGesture;
//@property (nonatomic, strong) UIButton *save;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //无logo
   // self.imageView.image = [UIImage qrImgForString:@"http://blog.zhangpeng.site" size:CGSizeMake(100, 100) waterImg:nil];

    //有logo
   // self.imageView.image = [UIImage qrImgForString:@"http://pdtv.vip/h5/?from=singlemessage#/register?invitation_code=9x8qaexhttp://pdtv.vip/h5/?from=singlemessage#/register?invitation_code=9x8qaex" size:CGSizeMake(100, 100) waterImg:[UIImage imageNamed:@"main_collect_select"]];
    
    [self.view addSubview:self.BgImageView];
    
    [self.view addGestureRecognizer:self.gesture];
    [self.view addGestureRecognizer:self.longPressGesture];
    [self.view addSubview:self.imageView];
    
    
   // [self.BgImageView addSubview:self.save];
    
}

//- (UIButton *)save {
//    if (!_save) {
//        _save = [[UIButton alloc] initWithFrame: CGRectMake(20, SCREEN_HEIGHT - (iPHONE_Xr ? 99 : 65), 50, 20)];
//        [_save setTitle:@"保存" forState:UIControlStateNormal];
//    }
//
//    return _save;
//}


- (UIImageView *)BgImageView {
    if (!_BgImageView) {
        _BgImageView = [[UIImageView alloc] initWithFrame: [UIScreen mainScreen].bounds];
        _BgImageView.image = [UIImage imageNamed:@"QRCode"];
    }
    return _BgImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame: CGRectMake((SCREEN_WIDTH - 150) / 2, (SCREEN_HEIGHT - 150) / 2 + 120, 150, 150)];
        _imageView.image = [UIImage qrImgForString:self.pageUrl size:CGSizeMake(100, 100) waterImg:[UIImage imageNamed:@"main_collect_select"]];
    }
    return _imageView;
}

- (UIGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePicture)];
        [_longPressGesture setDelegate:self];
        [_gesture requireGestureRecognizerToFail:_longPressGesture];
    }
    return _longPressGesture;
}


- (UIGestureRecognizer *)gesture {
    if (!_gesture) {
        _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QRCodeDismiss)];
        [_gesture setDelegate:self];
    }
    return _gesture;
}

- (void)QRCodeDismiss {
    [self dismissViewControllerAnimated:false completion:nil];
}

-(void)savePicture {
    UIImage *image = [UIImage getScreenSnap];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"保存成功";
                [hud hideAnimated:true afterDelay:1.5];
            });
        }
    }];
}

//手势识别器代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
