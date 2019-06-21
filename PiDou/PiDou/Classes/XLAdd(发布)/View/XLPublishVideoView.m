//
//  XLPublishVideoView.m
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishVideoView.h"
#import "HXPhotoPicker.h"

#define kPhotoViewMargin  16 * kWidthRatio6s

@interface XLPublishVideoView () <HXPhotoViewDelegate>

@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) UIButton *bottomView;

@property (assign, nonatomic) BOOL needDeleteItem;

@property (assign, nonatomic) BOOL showHud;

@property (nonatomic, strong) UIImageView *videoImgV;
@property (nonatomic, strong) UIImageView *playImgV;
@property (nonatomic, strong) UIButton *closeImgV;


@end

@implementation XLPublishVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.videoImgV = [[UIImageView alloc] init];
    [self addSubview:self.videoImgV];
    self.videoImgV.image = [UIImage imageNamed:@""];
    //self.videoImgV.backgroundColor = XLRandomColor;
    
    
    self.playImgV = [[UIImageView alloc] init];
    [self addSubview:self.playImgV];
    self.playImgV.image = [UIImage imageNamed:@"video_play_2"];
    
    self.closeImgV = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.closeImgV];
    [self.closeImgV xl_setImageName:@"publish_close_small" target:self action:@selector(closeAction)];
    
    
    [self initLayout];
    
    [self initPhotoView];
}

- (void)initLayout {
    [self.videoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self).mas_offset(12 * kWidthRatio6s);
        make.width.mas_offset(109 * kWidthRatio6s);
        make.height.mas_offset(144 * kWidthRatio6s);
    }];
    
    [self.playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImgV);
        make.width.height.mas_offset(32 * kWidthRatio6s);
    }];
    
    [self.closeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.videoImgV);
        make.width.height.mas_offset(24 * kWidthRatio6s);
    }];
}

#pragma mark - 点击关闭
- (void)closeAction {
    XLLog(@"点击关闭");
}


- (void)initPhotoView {
    CGFloat width = self.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.outerCamera = NO;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.previewShowDeleteButton = YES;
    //    photoView.hideDeleteButton = YES;
    photoView.showAddCell = YES;
    photoView.spacing = 12 * kWidthRatio6s;
    photoView.InteritemSpacing = 8 * kWidthRatio6s;
    //    photoView.disableaInteractiveTransition = YES;
    [photoView.collectionView reloadData];
    photoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:photoView];
    self.photoView = photoView;
    
    
    [self addSubview:self.bottomView];
    
}

- (void)goPhotoViewController {
    [self.photoView goPhotoViewController];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    //    HXPhotoModel *photoModel = allList.firstObject;
    
    //    [allList hx_requestImageWithOriginal:isOriginal completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
    //        // imageArray 获取成功的image数组
    //        // errorArray 获取失败的model数组
    //        NSSLog(@"\nimage: %@\nerror: %@",imageArray,errorArray);
    //    }];
    if (_delegate && [_delegate respondsToSelector:@selector(publishVideoView:videos:)]) {
        [_delegate publishVideoView:self videos:videos];
    }
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    //self.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}
- (BOOL)photoView:(HXPhotoView *)photoView collectionViewShouldSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(HXPhotoModel *)model {
    return YES;
}

- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView gestureRecognizer:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    return self.needDeleteItem;
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.alpha = 0.5;
    }];
    NSSLog(@"长按手势开始了 - %ld",indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self];
    if (point.y >= self.bottomView.hx_y) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.alpha = 0.5;
        }];
    }
    NSSLog(@"长按手势改变了 %@ - %ld",NSStringFromCGPoint(point), indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self];
    if (point.y >= self.bottomView.hx_y) {
        self.needDeleteItem = YES;
        [self.photoView deleteModelWithIndex:indexPath.item];
    }else {
        self.needDeleteItem = NO;
    }
    NSSLog(@"长按手势结束了 - %ld",indexPath.item);
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.alpha = 0;
    }];
}


#pragma mark - lazy load
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        //        _manager.configuration.languageType = HXPhotoLanguageTypeKo;
        _manager.configuration.videoMaximumSelectDuration = [XLUserHandle isVip] ? 5 * 60.f : 2 * 60.f;
        _manager.configuration.videoMinimumSelectDuration = 0;
        _manager.configuration.videoMaximumDuration = [XLUserHandle isVip] ? 5 * 60.f : 2 * 60.f;
        _manager.configuration.creationDateSort = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showOriginalBytes = YES;
        //        _manager.configuration.reverseDate = YES;
        //        _manager.configuration.showDateSectionHeader = YES;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModeIceVideo;
        _manager.configuration.statusBarStyle = UIStatusBarStyleLightContent;
        _manager.configuration.showBottomPhotoDetail = NO;
        _manager.configuration.rowCount = 3;
        _manager.configuration.maxVideoClippingTime = 5 * 60;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.lookGifPhoto = NO;
        _manager.configuration.lookLivePhoto = NO;
        _manager.configuration.supportRotation = NO;
        _manager.configuration.photoCanEdit = NO;
//        _manager.configuration.showDateSectionHeader = NO;
//                _manager.configuration.movableCropBox = YES;
//                _manager.configuration.movableCropBoxEditSize = YES;
//                _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
////                _manager.configuration.requestImageAfterFinishingSelection = YES;
//                _manager.configuration.replaceCameraViewController = YES;
//                _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        
        HXWeakSelf
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:60.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };
    }
    return _manager;
}

- (UIButton *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView setTitle:@"删除" forState:UIControlStateNormal];
        [_bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView setBackgroundColor:[UIColor redColor]];
        _bottomView.frame = CGRectMake(0, self.hx_h - 50, self.hx_w, 50);
        _bottomView.alpha = 0;
    }
    return _bottomView;
}

@end
