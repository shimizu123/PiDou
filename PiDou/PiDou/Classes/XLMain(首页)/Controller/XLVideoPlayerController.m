//
//  XLVideoPlayerController.m
//  PiDou
//
//  Created by kevin on 14/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLVideoPlayerController.h"
#import "XLCommentBotView.h"
#import "XLCommentInputView.h"
#import "XLTieziHandle.h"
#import "XLVideoNaviBar.h"
#import "XLTieziModel.h"
#import "HXPhotoPicker.h"
#import "XLFileManager.h"
#import "XLVODUploadManager.h"
#import "UIImage+TGExtension.h"
#import "XLCommentHandle.h"
#import "XLVideoPlayView.h"

@interface XLVideoPlayerController () <XLCommentBotViewDelegate, XLCommentInputViewDelegate, XLVideoPlayViewDelegate, HXPhotoViewDelegate>

@property (nonatomic, strong) XLVideoNaviBar *naviBar;
@property (nonatomic, strong) XLCommentBotView *commentBotView;
@property (nonatomic, strong) XLCommentInputView *commentInputView;
@property (nonatomic, strong) XLTieziModel *tieziModel;

@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) NSMutableArray *urlsArr;

@property (nonatomic, assign) BOOL onePublish;

@property (nonatomic, strong) XLVideoPlayView *playView;

@end

@implementation XLVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initUI];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playView stopPlay];
}

- (void)initUI {
    
    self.playView = [[XLVideoPlayView alloc] initVideoPlayViewWithURL:nil];;
    [self.view addSubview:self.playView];
    self.playView.delegate = self;
    
    CGFloat commentBotHeight = XL_TABBAR_H;
    
    [self.view addSubview:self.naviBar];
    
    self.commentBotView = [[XLCommentBotView alloc] initWithFrame:(CGRectMake(0, SCREEN_HEIGHT - commentBotHeight, SCREEN_WIDTH, commentBotHeight))];
    self.commentBotView.delegate = self;
    [self.view addSubview:self.commentBotView];
    self.commentBotView.commentBotViewType = XLCommentInputViewSkin_black;
    
    
    [self.view addSubview:self.commentInputView];
    [self initPhotoView];
    
    [self initLayout];
}

- (void)initLayout {
    
}

- (void)initData {
    kDefineWeakSelf;
    [XLTieziHandle tieziDetailWithEntityID:self.entity_id success:^(id  _Nonnull responseObject) {
        WeakSelf.tieziModel = responseObject;
        WeakSelf.commentBotView.tieziModel = WeakSelf.tieziModel;
       // WeakSelf.naviBar.user = WeakSelf.tieziModel.user_info;
        WeakSelf.naviBar.tieziModel = WeakSelf.tieziModel;
        WeakSelf.playView.url = [NSURL URLWithString:WeakSelf.tieziModel.video_url];
        [WeakSelf.playView startPlay];
    } failure:^(id  _Nonnull result) {
    }];
}


#pragma mark - XLVideoPlayViewDelegate
- (void)playView:(XLVideoPlayView *)playView updateRecordState:(XLPlayState)recordState {
    switch (recordState) {
        case XLPlayStatePlaying:
        {
            self.playView.url = [NSURL URLWithString:self.tieziModel.video_url];
            [self.playView resumePlay];
        }
            break;
        case XLPlayStatePause:
        {
            [self.playView pausePlay];
        }
            break;
        case XLPlayStateEnd:
        {
            [self.playView clearPlay];
        }
            break;
            
        default:
            break;
    }
}
- (void)didClicPlayView:(XLVideoPlayView *)playView {
    [self.view endEditing:YES];
}

#pragma mark - 监控键盘
- (void)keyboardChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        //        UIView *firstResponder = [self.view xl_getFirstResponder]; // 获得当前响应的view
        //        CGRect convertRect = [firstResponder convertRect:firstResponder.frame toView:self.view]; // 当前响应的view相对父视图的坐标转换
        
        //        CGFloat convertOriY = convertRect.origin.y < 0 ? -convertRect.origin.y : convertRect.origin.y;
        //        CGFloat convertY = 350 * kWidthRatio6s;
        //        CGFloat loginBtnMaxY = convertY + 120 * kWidthRatio6s;
        CGFloat kbH = keyboardEndFrame.size.height;
        if (!self.photoView.hidden) {
            self.commentInputView.xl_y = self.view.xl_h - kbH - self.commentInputView.xl_h - self.photoView.xl_h;
        } else {
            self.commentInputView.xl_y = self.view.xl_h - kbH - self.commentInputView.xl_h;
        }
        
    } else if (notification.name == UIKeyboardWillHideNotification){
        self.commentInputView.xl_y = self.view.xl_h;
    }
    
    [UIView commitAnimations];
    
}



#pragma mark - XLCommentBotViewDelegate
- (void)commentBotView:(XLCommentBotView *)commentBotView didSelectedWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // 点击评论
            [self.commentInputView becomeActive];
        }
            break;
        case 1:
        {
            kDefineWeakSelf;
            [HUDController xl_showHUD];
            [XLTieziHandle tieziDolikeWithEntityID:self.entity_id success:^(id  _Nonnull responseObject) {
                [HUDController hideHUDWithText:responseObject];
                [WeakSelf initData];
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            kDefineWeakSelf;
            [HUDController xl_showHUD];
            [XLTieziHandle tieziCollectWithEntityID:self.entity_id success:^(id  _Nonnull responseObject) {
                //[HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                [WeakSelf initData];
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - XLCommentInputViewDelegate
- (void)commentInputView:(XLCommentInputView *)commentInputView didSelectedWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // 视频
            [self addVideo];
        }
            break;
        case 1:
        {
            // 图片
            [self addPhoto];
        }
            break;
        case 2:
        {
            // 发布
            [self publish];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 添加视频
- (void)addVideo {
    [self.urlsArr removeAllObjects];
    self.manager.type = HXPhotoManagerSelectedTypeVideo;
    self.manager.configuration.albumShowMode = HXPhotoAlbumShowModeIceVideo;
    [self goPhotoViewController];
}

#pragma mark - 添加图片
- (void)addPhoto {
    [self.urlsArr removeAllObjects];
    self.manager.type = HXPhotoManagerSelectedTypePhoto;
    self.manager.configuration.albumShowMode = HXPhotoAlbumShowModeDefault;
    [self goPhotoViewController];
}

#pragma mark - 点击发布
- (void)publish {
    
    if (self.onePublish) {
        return;
    }
    self.onePublish = YES;
    NSString *text = self.commentInputView.text;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"content"] = text;
    if (!XLArrayIsEmpty(self.urlsArr)) {
        paramDic[@"urls"] = self.urlsArr;
    } else {
        if (XLStringIsEmpty(text)) {
            [HUDController hideHUDWithText:@"请输入内容"];
            return;
        }
    }
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLCommentHandle postCommentWithEntity_id:self.entity_id cid:nil rid:nil data:paramDic.mj_JSONString success:^(id  _Nonnull responseObject) {
        [HUDController hideHUD];
        [WeakSelf.view endEditing:YES];
        for (int i = 0; i < self.urlsArr.count; i++) {
            [WeakSelf.photoView deleteModelWithIndex:i];
        }
        [WeakSelf.urlsArr removeAllObjects];
        [WeakSelf.commentInputView reset];
        WeakSelf.onePublish = NO;
        [WeakSelf initData];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        WeakSelf.onePublish = NO;
    }];
}



- (void)initPhotoView {
    //CGFloat width = self.view.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectZero;
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
    [self.view addSubview:photoView];
    self.photoView = photoView;
    self.photoView.hidden = YES;
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentInputView);
        make.top.equalTo(self.commentInputView.mas_bottom);
    }];
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
    
    
    
    self.photoView.hidden = NO;
    [self.urlsArr removeAllObjects];
    if (XLArrayIsEmpty(videos)) {
        self.manager.type = HXPhotoManagerSelectedTypePhoto;
        self.manager.configuration.albumShowMode = HXPhotoAlbumShowModeDefault;
    }
    
    if (!XLArrayIsEmpty(photos)) {
        [self getUrlWithPhotos:photos original:isOriginal];
    } else if (!XLArrayIsEmpty(videos)) {
        [self getUrlWithVideos:videos];
    }
    
}

- (void)getUrlWithImage:(UIImage *)image {
    NSString *file = [NSString stringWithFormat:@"%@%@.jpg",XLFileManager.tmpDir,[XLVODUploadManager sharedXLVODUploadManager].getTimeNow];
    
    [XLFileManager createFileAtPath:file];
    [XLFileManager writeFileAtPath:file content:image];
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLVODUploadManager vodImageFilePath:file success:^(NSString *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDController hideHUD];
            if (!XLStringIsEmpty(url)) {
                NSString *sizeUrl = [NSString stringWithFormat:@"%@?w=%.0f&h=%.0f",url,image.size.width,image.size.height];
                [WeakSelf.urlsArr insertObject:sizeUrl atIndex:0];
            }
        });
    } failure:^(id  _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDController xl_hideHUDWithResult:result];
        });
    }];
}

#pragma mark - XLPublishVideoViewDelegate
- (void)getUrlWithVideos:(NSArray<HXPhotoModel *> *)videos {
    
    [HUDController xl_showHUD];
    HXPhotoModel *photoModel = videos.firstObject;
    //PHAsset *asset = photoModel.asset;
    kDefineWeakSelf;
    [[XLVODUploadManager sharedXLVODUploadManager] getVideoPathFromPhotoModel:photoModel complete:^(NSString *savePath, NSString *lastPath) {
        [WeakSelf.commentInputView becomeActive];
        [XLVODUploadManager vodVideoWithFilePath:savePath lastName:lastPath success:^(NSString *url) {
            [HUDController  hideHUD];
            if (!XLStringIsEmpty(url)) {
                NSString *videoUrl = [NSString stringWithFormat:@"http://file.pdtv.vip/%@",url];
                
                [WeakSelf.urlsArr addObject:videoUrl];
                
                [WeakSelf getUrlWithImage:[UIImage thumbnailImageForVideo:[NSURL URLWithString:videoUrl] atTime:0.1]];
            }
            
        } failure:^(id  _Nonnull result) {
            [HUDController  xl_hideHUDWithResult:result];
        }];;
    } failure:^(NSString *errorStr) {
        [HUDController  hideHUD];
    } cancell:^{
        [HUDController  hideHUD];
    }];
}

#pragma mark - XLPublishPhotoViewDelegate
- (void)getUrlWithPhotos:(NSArray<HXPhotoModel *> *)photos original:(BOOL)isOriginal {
    [HUDController xl_showHUD];
    [photos hx_requestImageWithOriginal:isOriginal completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        [self.commentInputView becomeActive];
        // imageArray 获取成功的image数组
        // errorArray 获取失败的model数组
        //NSSLog(@"\nimage: %@\nerror: %@",imageArray,errorArray);
        
        [XLFileManager clearTmpDirectory];
        for (NSInteger i = imageArray.count - 1; i >= 0; i--) {
            [self getUrlWithImage:imageArray[i]];
        }
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

- (XLCommentInputView *)commentInputView {
    if (!_commentInputView) {
        _commentInputView = [[XLCommentInputView alloc] initWithFrame:(CGRectMake(0, self.view.xl_h, SCREEN_WIDTH, 88 * kWidthRatio6s))];
        _commentInputView.delegate = self;
    }
    return _commentInputView;
}

- (XLVideoNaviBar *)naviBar {
    if (!_naviBar) {
        _naviBar = [[XLVideoNaviBar alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, XL_NAVIBAR_H))];
        _naviBar.backgroundColor = [UIColor clearColor];
    }
    return _naviBar;
}

- (NSMutableArray *)urlsArr {
    if (!_urlsArr) {
        _urlsArr = [NSMutableArray array];
    }
    return _urlsArr;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
