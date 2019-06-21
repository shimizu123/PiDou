//
//  XLPublishVideoPhotoController.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishVideoPhotoController.h"
#import "UIButton+XLAdd.h"
#import "XLTextView.h"
#import "XLPublishInputView.h"
#import "XLSearchTopicController.h"
#import "XLPublishVideoView.h"
#import "XLPublishPhotoView.h"
#import "XLPublishLinkView.h"
#import "XLPublishAddLinkView.h"
#import "HXPhotoModel.h"
#import "XLPublishHandle.h"
#import "XLVODUploadManager.h"
#import "XLFileManager.h"
#import "NSArray+HXExtension.h"
#import "UIImage+TGExtension.h"

#define VIDEO_FILEPATH [NSString stringWithFormat:@"%@/newseditmedia",XLDocumentPath]

@interface XLPublishVideoPhotoController () <UIScrollViewDelegate, UITextViewDelegate, XLPublishInputViewDelegate, XLPublishVideoViewDelegate, XLPublishPhotoViewDelegate> {
    CGFloat _oriH;
    CGFloat _oriMaxY;
    //CGFloat _keyboardHeight;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *chooseTopicButton;
@property (nonatomic, strong) XLTextView *newsEditTV;

@property (nonatomic, strong) XLPublishInputView *inputView;;

@property (nonatomic, copy) NSString *selectedTopic;

@property (nonatomic, strong) XLPublishVideoView *videoView;
@property (nonatomic, strong) XLPublishPhotoView *photoView;
@property (nonatomic, strong) XLPublishLinkView *linkView;

@property (nonatomic, strong) XLPublishAddLinkView *addLinkView;

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) NSMutableArray *urlsArr;

@end

@implementation XLPublishVideoPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发帖";
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    
    self.publishVCType = XLPublishVideoPhotoType_text;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initUI {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftItemWithImage:@"public_close" highImage:nil target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发布" size:16.f target:self action:@selector(publishAction)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.bounces = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.chooseTopicButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.chooseTopicButton];
    //self.chooseTopicButton.frame = CGRectMake(16 * kWidthRatio6s, 12 * kWidthRatio6s, 84 * kWidthRatio6s, 24 * kWidthRatio6s);
    [self.chooseTopicButton xl_setTitle:@"选择话题" color:XL_COLOR_RED size:14.f target:self action:@selector(chooseTopicActon:)];
    XLViewBorderRadius(self.chooseTopicButton, 2 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
    [self.chooseTopicButton setImage:[UIImage imageNamed:@"publish_redArrow"] forState:(UIControlStateNormal)];
    [self.chooseTopicButton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleRight) imageTitleSpace:1];
    [self.chooseTopicButton setContentEdgeInsets:(UIEdgeInsetsMake(0, 8 * kWidthRatio6s, 0, 8 * kWidthRatio6s))];
    [self.chooseTopicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.view).mas_offset(12 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
    }];
    
    
    self.newsEditTV = [[XLTextView alloc] initWithFrame:(CGRectMake(11 * kWidthRatio6s, 48 * kWidthRatio6s, SCREEN_WIDTH - 11 * kWidthRatio6s - 16 * kWidthRatio6s, 100 * kWidthRatio6s))];
    [self.scrollView addSubview:self.newsEditTV];
    self.newsEditTV.showsVerticalScrollIndicator = NO;
    self.newsEditTV.showsHorizontalScrollIndicator = NO;
    self.newsEditTV.isTextCenter = YES;
    self.newsEditTV.placeholder = @"请输入内容";
    self.newsEditTV.placeholderColor = COLOR(0xcccccc);
    self.newsEditTV.textColor = COLOR(0x000000);
    self.newsEditTV.tintColor = COLOR(0x000000);
    self.newsEditTV.font = [UIFont xl_fontOfSize:16.f];
    //self.newsEditTV.delegate = self;
    
    
    switch (self.publishVCType) {
        case XLPublishVideoPhotoType_video:
        {
            [self.scrollView addSubview:self.videoView];
        }
            break;
        case XLPublishVideoPhotoType_photo:
        {
            [self.scrollView addSubview:self.photoView];
        }
            break;
        case XLPublishVideoPhotoType_link:
        {
            [self showAddLinkView];
        }
            break;
            
        default:
            break;
    }
    
    
    
    [self.view addSubview:self.inputView];
    [self initLayout];
    
    [self.videoView goPhotoViewController];
}

- (void)initLayout {
   
}


- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - XLPublishVideoViewDelegate
- (void)publishVideoView:(XLPublishVideoView *)publishVideoView videos:(NSArray<HXPhotoModel *> *)videos {
    [self.urlsArr removeAllObjects];
    if (XLArrayIsEmpty(videos)) {
        self.publishVCType = XLPublishVideoPhotoType_text;
        return;
    }
    self.publishVCType = XLPublishVideoPhotoType_video;
    self.videoView.hidden = NO;
    HXPhotoModel *photoModel = videos.firstObject;

    kDefineWeakSelf;
    [HUDController xl_showHUD];
    
    [[XLVODUploadManager sharedXLVODUploadManager] getVideoPathFromPhotoModel:photoModel complete:^(NSString *savePath, NSString *lastPath) {
        [XLVODUploadManager vodVideoWithFilePath:savePath lastName:lastPath success:^(NSString *url) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDController hideHUD];
                if (!XLStringIsEmpty(url)) {
                    NSString *videoUrl = [NSString stringWithFormat:@"http://file.pdtv.vip/%@",url];
                    
                    [WeakSelf.urlsArr addObject:videoUrl];
                    
                    [WeakSelf getUrlWithImage:[UIImage thumbnailImageForVideo:[NSURL URLWithString:videoUrl] atTime:0.1]];
                }
            });
            
        } failure:^(id  _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDController hideHUD];
            });
        }];;
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDController hideHUD];
        });
    } cancell:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDController hideHUD];
        });
    }];
   
}

#pragma mark - XLPublishPhotoViewDelegate
- (void)publishPhotoView:(XLPublishPhotoView *)publishPhotoView  photos:(NSArray<HXPhotoModel *> *)photos original:(BOOL)isOriginal {
    [self.urlsArr removeAllObjects];
    if (XLArrayIsEmpty(photos)) {
        self.publishVCType = XLPublishVideoPhotoType_text;
        return;
    }
    self.publishVCType = XLPublishVideoPhotoType_photo;
    [photos hx_requestImageWithOriginal:isOriginal completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        // imageArray 获取成功的image数组
        // errorArray 获取失败的model数组
        //NSSLog(@"\nimage: %@\nerror: %@",imageArray,errorArray);
        [XLFileManager clearTmpDirectory];
        for (NSInteger i = imageArray.count - 1; i >= 0; i--) {
            [self getUrlWithImage:imageArray[i]];
        }
    }];

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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark - UITextViewDelegate

#pragma mark - XLPublishInputViewDelegate
- (void)publishInputView:(XLPublishInputView *)publishInputView didSelectedWithIndex:(NSInteger)index {
    [self.urlsArr removeAllObjects];
    switch (index) {
        case 0:
        {
            self.publishVCType = XLPublishVideoPhotoType_video;
            // 发布视频
            XLLog(@"发布视频");
            if (_linkView) {
                [_linkView removeFromSuperview];
            }
            if (_photoView) {
                [_photoView removeFromSuperview];
            }
            [self.scrollView addSubview:self.videoView];
            [self.videoView goPhotoViewController];
        }
            break;
        case 1:
        {
            self.publishVCType = XLPublishVideoPhotoType_photo;
            // 发布图片
            XLLog(@"发布图片");
            if (_videoView) {
                [_videoView removeFromSuperview];
            }
            if (_linkView) {
                [_linkView removeFromSuperview];
            }
            [self.scrollView addSubview:self.photoView];
            [self.photoView goPhotoViewController];
        }
            break;
        case 2:
        {
            self.publishVCType = XLPublishVideoPhotoType_link;
            // 发布链接
            XLLog(@"发布链接");
            if (_videoView) {
                [_videoView removeFromSuperview];
            }
            if (_photoView) {
                [_photoView removeFromSuperview];
            }
            //[self.scrollView addSubview:self.linkView];
            
            [self showAddLinkView];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)showAddLinkView {
    if (!_addLinkView) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.addLinkView];
    }
}

- (void)dismissAddLinkView {
    if (_addLinkView) {
        [_addLinkView removeFromSuperview];
        _addLinkView = nil;
    }
    if (_linkView) {
        [_linkView removeFromSuperview];
        _linkView = nil;
    }
}

#pragma mark - 选择话题
- (void)chooseTopicActon:(UIButton *)button {
    XLLog(@"选择话题");
    XLSearchTopicController *topicVC = [[XLSearchTopicController alloc] init];
    topicVC.selectedTopic = self.selectedTopic;
    [self.navigationController pushViewController:topicVC animated:YES];
    kDefineWeakSelf;
    topicVC.didSelectedComplete = ^(NSString * topic) {
        WeakSelf.selectedTopic = topic;
        if (XLStringIsEmpty(WeakSelf.selectedTopic)) {
            [WeakSelf.chooseTopicButton setTitle:@"选择话题" forState:(UIControlStateNormal)];
        } else {
            [WeakSelf.chooseTopicButton setTitle:WeakSelf.selectedTopic forState:(UIControlStateNormal)];
        }
        
        [WeakSelf.chooseTopicButton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleRight) imageTitleSpace:1];
    };
}

#pragma mark - 点击发布
- (void)publishAction {
    XLLog(@"点击发布");
    [self.view endEditing:YES];
    
    NSString *content = self.newsEditTV.text;
    if (XLStringIsEmpty(content)) {
        [HUDController hideHUDWithText:@"请输入内容"];
        return;
    }
    
    
    
    
    NSString *category = @"text";
    NSArray *topics = [NSArray array];
    if (!XLStringIsEmpty(self.selectedTopic)) {
        topics = [NSArray arrayWithObject:self.selectedTopic];
    }
    
    switch (self.publishVCType) {
        case XLPublishVideoPhotoType_video:
        {
            category = @"video";
            if (self.urlsArr.count != 2) {
                [HUDController hideHUDWithText:@"视频上传出错，请重新上传"];
                return;
            }
        }
            break;
            
        case XLPublishVideoPhotoType_photo:
        {
            category = @"pic";
            if (XLArrayIsEmpty(self.urlsArr)) {
                [HUDController hideHUDWithText:@"图片上传出错，请重新上传"];
                return;
            }
        }
            break;
            
        case XLPublishVideoPhotoType_link:
        {
            category = @"link";
        }
            break;
            
        case XLPublishVideoPhotoType_text:
        {
            category = @"text";
         
        }
            break;
            
            
        default:
            break;
    }
    [HUDController xl_showHUD];
    [XLPublishHandle publishWithCategory:category topics:topics content:content urls:self.urlsArr success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:@"发布成功"];
        [self back];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}


#pragma mark - 监控键盘
-(void)keyboardChange:(NSNotification *)notification {
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
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = self.inputView.frame;
    _keyboardHeight = keyboardEndFrame.size.height;
    CGFloat y = keyboardEndFrame.origin.y - newFrame.size.height;
    if (notification.name == UIKeyboardWillShowNotification) {
                
        y = y - XL_NAVIBAR_H;
    } else {
        y = SCREEN_HEIGHT - 44 * kWidthRatio6s - XL_HOME_INDICATOR_H - XL_NAVIBAR_H;
    }
    newFrame.origin.y = y;
    self.inputView.frame = newFrame;
    
    [UIView commitAnimations];
    _oriH = newFrame.size.height;
    _oriMaxY = newFrame.origin.y + _oriH;
}


#pragma mark - lazy laod
- (XLPublishInputView *)inputView {
    if (!_inputView) {
        _inputView = [[XLPublishInputView alloc] initWithFrame:(CGRectMake(0, SCREEN_HEIGHT - 44 * kWidthRatio6s - XL_HOME_INDICATOR_H - XL_NAVIBAR_H, SCREEN_WIDTH, 44 * kWidthRatio6s))];
        _inputView.delegate = self;
        _oriH = CGRectGetHeight(_inputView.frame);
        _oriMaxY = CGRectGetMaxY(_inputView.frame);
    }
    return _inputView;
}

- (XLPublishVideoView *)videoView {
    if (!_videoView) {
        CGFloat viewY = CGRectGetMaxY(self.newsEditTV.frame);
        _videoView = [[XLPublishVideoView alloc] initWithFrame:(CGRectMake(0, viewY, SCREEN_WIDTH, SCREEN_HEIGHT - viewY - XL_NAVIBAR_H - CGRectGetHeight(self.inputView.frame) - XL_HOME_INDICATOR_H))];
        _videoView.delegate = self;
        _videoView.hidden = YES;
    }
    return _videoView;
}

- (XLPublishPhotoView *)photoView {
    if (!_photoView) {
        CGFloat viewY = CGRectGetMaxY(self.newsEditTV.frame);
        _photoView = [[XLPublishPhotoView alloc] initWithFrame:(CGRectMake(0, viewY, SCREEN_WIDTH, SCREEN_HEIGHT - viewY - XL_NAVIBAR_H - CGRectGetHeight(self.inputView.frame) - XL_HOME_INDICATOR_H))];
        _photoView.delegate = self;
    }
    return _photoView;
}

- (XLPublishLinkView *)linkView {
    if (!_linkView) {
        CGFloat viewY = CGRectGetMaxY(self.newsEditTV.frame);
        _linkView = [[XLPublishLinkView alloc] initWithFrame:(CGRectMake(0, viewY, SCREEN_WIDTH, SCREEN_HEIGHT - viewY - XL_NAVIBAR_H - CGRectGetHeight(self.inputView.frame) - XL_HOME_INDICATOR_H))];
    }
    return _linkView;
}

- (XLPublishAddLinkView *)addLinkView {
    if (!_addLinkView) {
        kDefineWeakSelf;
        _addLinkView = [[XLPublishAddLinkView alloc] initPublishAddLinkViewWithComplete:^(id  _Nonnull result) {
            [WeakSelf dismissAddLinkView];
        }];
    }
    return _addLinkView;
}

- (NSMutableArray *)urlsArr {
    if (!_urlsArr) {
        _urlsArr = [NSMutableArray array];
    }
    return _urlsArr;
}

@end
