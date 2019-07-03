//
//  XLCommentDetailController.m
//  PiDou
//
//  Created by kevin on 5/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentDetailController.h"
#import "XLCommentDetailTable.h"
#import "XLCommentBotView.h"
#import "XLCommentInputView.h"
#import "HXPhotoPicker.h"
#import "XLFileManager.h"
#import "XLVODUploadManager.h"
#import "XLCommentHandle.h"
#import "XLTieziModel.h"
#import "XLCommentModel.h"
#import "XLShareView.h"
#import "UIImage+TGExtension.h"
#import "XLPlayerManager.h"

@interface XLCommentDetailController () <XLCommentBotViewDelegate, XLCommentInputViewDelegate, XLCommentDetailTableDelegate, HXPhotoViewDelegate>

@property (nonatomic, strong) XLCommentDetailTable *table;
@property (nonatomic, strong) XLCommentBotView *commentBotView;

@property (nonatomic, strong) XLCommentInputView *commentInputView;

@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) NSMutableArray *urlsArr;

@property (nonatomic, assign) BOOL onePublish;

@property (nonatomic, strong) XLTieziModel *tieziModel;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) XLCommentModel *currentReplyComment;

@end

@implementation XLCommentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论详情";
    [self initUI];
    
    [self didLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self didLoadData];
    [XLPlayerManager appear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XLPlayerManager disappear];
}

- (void)initUI {
    
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"main_share" highImage:@"main_share" target:self action:@selector(shareAction:)];
    
    CGFloat commentBotHeight = XL_TABBAR_H;
    self.table.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H - commentBotHeight);
    [self.view addSubview:self.table.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.table.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.table.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didLoadData)];
    self.table.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.commentBotView = [[XLCommentBotView alloc] initWithFrame:(CGRectMake(0, SCREEN_HEIGHT - XL_NAVIBAR_H - commentBotHeight, SCREEN_WIDTH, commentBotHeight))];
    self.commentBotView.isCommentDetail = YES;
    self.commentBotView.delegate = self;
    [self.view addSubview:self.commentBotView];
    
    
    [self.view addSubview:self.commentInputView];
    
    [self initPhotoView];
}


- (void)didLoadData {
    _page = 1;
    [self initData];
}

- (void)loadMoreData {
    _page++;
    [self initData];
}


- (void)initData {
    kDefineWeakSelf;
    [XLCommentHandle replyListWithCid:self.cid page:self.page success:^(XLCommentModel *responseObject) {
        if (responseObject) {
            XLTieziModel *tieziModel = [[XLTieziModel alloc] init];
            tieziModel.user_info = responseObject.user_info;
            tieziModel.content = responseObject.content;
            tieziModel.created = responseObject.created;
            tieziModel.video_url = responseObject.video_url;
            tieziModel.video_image = responseObject.video_image;
            tieziModel.pic_images = responseObject.pic_images;
            tieziModel.category = responseObject.type;
            tieziModel.do_liked = responseObject.do_liked;
            tieziModel.do_like_count = responseObject.do_like_count;
            tieziModel.comment_count = [NSString stringWithFormat:@"%@",responseObject.total];
            tieziModel.isComment = YES;
            WeakSelf.tieziModel = tieziModel;
            WeakSelf.table.tieziModel = WeakSelf.tieziModel;
            
            if (WeakSelf.page > 1) {
                [WeakSelf.table.tableView.mj_footer endRefreshing];
                [WeakSelf.data addObjectsFromArray:responseObject.replies];
            } else {
                [WeakSelf.table.tableView.mj_header endRefreshing];
                WeakSelf.data = responseObject.replies.mutableCopy;
            }
            responseObject.replies = WeakSelf.data;
            
            
            WeakSelf.table.commentModel = responseObject;
            WeakSelf.commentBotView.tieziModel = WeakSelf.tieziModel;
            WeakSelf.commentBotView.isCommentDetail = YES;
            WeakSelf.navigationItem.title = [NSString stringWithFormat:@"%@条回复",responseObject.total];
        }
    } failure:^(id  _Nonnull result) {
        if (WeakSelf.page > 1) {
            [WeakSelf.table.tableView.mj_footer endRefreshing];
            WeakSelf.page--;
        } else {
            [WeakSelf.table.tableView.mj_header endRefreshing];
        }
        WeakSelf.table.tieziModel = WeakSelf.tieziModel;
    }];
}

#pragma mark - 点击分享
- (void)shareAction:(UIBarButtonItem *)item {
    
    XLShareModel *message = [[XLShareModel alloc] init];
    message.title = self.tieziModel.content;
    message.cid = self.cid;
    
    XLShareView *shareView = [XLShareView shareView];
    shareView.showQRCode = NO;
    shareView.message = message;
    shareView.noDeletebtn = YES;
    [shareView show];
}

#pragma mark - XLCommentInputViewDelegate
- (void)commentInputView:(XLCommentInputView *)commentInputView didSelectedWithIndex:(NSInteger)index {
    //[self.view endEditing:YES];
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

    paramDic[@"content"] = XLStringIsEmpty(text) ? @"" : text;
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
    
    [XLCommentHandle postCommentWithEntity_id:self.entity_id cid:self.cid rid:self.currentReplyComment.cid data:paramDic.mj_JSONString success:^(id  _Nonnull responseObject) {
        [HUDController hideHUD];
        WeakSelf.currentReplyComment = nil;
        for (int i = 0; i < WeakSelf.urlsArr.count; i++) {
            [WeakSelf.photoView deleteModelWithIndex:i];
        }
        [WeakSelf.view endEditing:YES];
        [WeakSelf.urlsArr removeAllObjects];
        [WeakSelf.commentInputView reset];
        WeakSelf.onePublish = NO;
        [WeakSelf initData];
        
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        WeakSelf.onePublish = NO;
        [WeakSelf.view endEditing:YES];
        WeakSelf.currentReplyComment = nil;
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
    }
    if (!XLArrayIsEmpty(videos)) {
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
        [self.commentInputView becomeActive];
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

#pragma mark - XLCommentDetailTableDelegate
- (void)commentDetailTable:(XLCommentDetailTable *)commentDetailTable didScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    self.currentReplyComment = nil;
}

- (void)commentDetailTable:(XLCommentDetailTable *)commentDetailTable didReplyWithComment:(XLCommentModel *)comment {
    self.currentReplyComment = comment;
    [self.commentInputView becomeActive];
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
            [XLCommentHandle doLikeCommentWithCid:self.cid success:^(id  _Nonnull responseObject) {
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

#pragma mark - lazy load
- (XLCommentDetailTable *)table {
    if (!_table) {
        _table = [[XLCommentDetailTable alloc] init];
        _table.delegate = self;
    }
    return _table;
}

- (XLCommentInputView *)commentInputView {
    if (!_commentInputView) {
        _commentInputView = [[XLCommentInputView alloc] initWithFrame:(CGRectMake(0, self.view.xl_h, SCREEN_WIDTH, 88 * kWidthRatio6s))];
        _commentInputView.delegate = self;
    }
    return _commentInputView;
}

- (NSMutableArray *)urlsArr {
    if (!_urlsArr) {
        _urlsArr = [NSMutableArray array];
    }
    return _urlsArr;
}


- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}


@end
