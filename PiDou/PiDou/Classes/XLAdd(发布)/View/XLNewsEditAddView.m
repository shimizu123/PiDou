//
//  XLNewsEditAddView.m
//  CBNReporterVideo
//
//  Created by kevin on 8/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLNewsEditAddView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+TGExtension.h"
#import "XLFileManager.h"
#import "XLPhotoBrowser.h"


@interface XLNewsEditAddView () <UINavigationControllerDelegate, UIImagePickerControllerDelegate/*, QBImagePickerControllerDelegate*/>

@property (nonatomic, strong) UIButton *addBtn;
/**图片地址*/
@property (nonatomic, strong, readwrite) UIImage *photoImage;
/**视频地址*/
//@property (nonatomic, strong, readwrite) NSURL *videoURL;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation XLNewsEditAddView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.addBtn];
    [self.addBtn xl_setImageName:@"publish_addphoto" target:self action:@selector(addAction:)];
    XLViewRadius(self.addBtn, 5);
//    self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.closeBtn];
    [self.closeBtn xl_setImageName:@"publish_close_small" target:self action:@selector(closeAction:)];
    [self.closeBtn setImageEdgeInsets:(UIEdgeInsetsMake(5 * kWidthRatio6s, 0, 0, 5 * kWidthRatio6s))];
    self.closeBtn.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.height.mas_offset(23 * kWidthRatio6s);
    }];
}

- (void)addAction:(UIButton *)btn {
    [self selectAction];
}

- (void)closeAction:(UIButton *)btn {
    btn.hidden = YES;
    self.addBtn.selected = NO;
    self.photoImage = nil;
    self.videoURL = nil;
}


- (void)selectAction {
//    [UIApplication sharedApplication].idleTimerDisabled = YES;
//    //设置NavigationBar背景颜色
//    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//
//    QBImagePickerController *imagePickerController = [QBImagePickerController new];
//    imagePickerController.delegate = self;
//    imagePickerController.mediaType = QBImagePickerMediaTypeAny;
//    imagePickerController.allowsMultipleSelection = YES;
//    imagePickerController.showsNumberOfSelectedAssets = YES;
//    imagePickerController.maximumNumberOfSelection = 1;
//    [self.navigationController presentViewController:imagePickerController animated:YES completion:NULL];
//
//
//
//    return;
    if (self.photoImage) {
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.currentImageIndex = 0;
        browser.imageArray = @[self.photoImage];
        browser.sourceImagesContainerView = self;
        [browser show];
    } else if (self.videoURL) {
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.currentImageIndex = 0;
        browser.imageArray = @[self.videoURL];
        browser.sourceImagesContainerView = self;
        [browser show];
    } else {
        [self.navigationController presentViewController:self.picker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        //    picker.allowsEditing = YES;
        //    picker.videoMaximumDuration = 1.0;//视频最长长度
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
        
        //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
        //这里只选择展示视频图片
        picker.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        _picker = picker;
    }
    return _picker;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType= [info objectForKey:UIImagePickerControllerMediaType];
    
    self.photoImage = nil;
    self.videoURL = nil;
    if ([mediaType isEqualToString:@"public.movie"]) {
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        self.videoURL = url;

    } else if ([mediaType isEqualToString:@"public.image"]) {
        // 如果是图片
        UIImage *photo = info[UIImagePickerControllerOriginalImage];
        self.photoImage = info[UIImagePickerControllerOriginalImage];
        [self.addBtn setImage:photo forState:(UIControlStateSelected)];
        self.closeBtn.hidden = NO;
        self.addBtn.selected = YES;
        self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    //如果是视频
    if (!_videoURL) {
        return;
    }
    // 获得视频首帧图片
    [self.addBtn setImage:[UIImage thumbnailImageForVideo:_videoURL atTime:0.1] forState:(UIControlStateSelected)];
    self.closeBtn.hidden = NO;
    self.addBtn.selected = YES;
    self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - QBImagePickerControllerDelegate
//- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
//    self.photoImage = nil;
//    self.videoURL = nil;
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    PHAsset *selectAsset = assets[0];
//    kDefineWeakSelf;
//    if (selectAsset.mediaType == PHAssetMediaTypeImage) {
//        // 要解决iOS11之后图片出现.heif,.heic的问题
//        __block BOOL isHEIF = NO;
//        if (@available(iOS 9.0, *)) {
//            NSArray *resourceList = [PHAssetResource assetResourcesForAsset:selectAsset];
//            [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                PHAssetResource *resource = obj;
//                NSString *UTI = resource.uniformTypeIdentifier;
//                if ([UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"]) {
//                    isHEIF = YES;
//                    *stop = YES;
//                }
//            }];
//        } else {
//            NSString *UTI = [selectAsset valueForKey:@"uniformTypeIdentifier"];
//            isHEIF = [UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"];
//        }
//
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        options.version = PHImageRequestOptionsVersionCurrent;
//        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//        options.synchronous = YES;
//
//        [[PHImageManager defaultManager] requestImageDataForAsset:selectAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *photo = [UIImage imageWithData:imageData];
//                if (isHEIF) {
//                    CIImage *ciImage = [CIImage imageWithData:imageData];
//                    if (@available(iOS 10.0, *)) {
//                        CIContext *context = [CIContext context];
//                        NSData *jpgData = [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
//                        photo = [UIImage imageWithData:jpgData];
//                    } else {
//                        photo = [UIImage imageWithCIImage:ciImage];
//                    }
//
//                }
//
//                // 如果是图片
//
//                weakSelf.photoImage = photo;
//                [weakSelf.addBtn setImage:photo forState:(UIControlStateSelected)];
//                weakSelf.closeBtn.hidden = NO;
//                weakSelf.addBtn.selected = YES;
//            });
//
//        }];
//
//    } else if (selectAsset.mediaType == PHAssetMediaTypeVideo || selectAsset.mediaType == PHAssetMediaTypeVideo) {
////        NSString *fileName = @"tempAssetVideo.mov";
////        kDefineWeakSelf;
////        [self getVideoPathFromPHAsset:selectAsset fileName:fileName complete:^(NSString *path, NSString *pathlast) {
////            dispatch_async(dispatch_get_main_queue(), ^{
////                weakSelf.videoURL = [NSURL fileURLWithPath:path];
////                [weakSelf.addBtn setImage:[UIImage thumbnailImageForVideo:weakSelf.videoURL atTime:0.1] forState:(UIControlStateSelected)];
////                weakSelf.closeBtn.hidden = NO;
////                weakSelf.addBtn.selected = YES;
////
////            });
////        } failure:nil cancell:nil];
////
////
////        return;
//        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//        // 最高质量的视频
//        options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
//        // 可从iCloud中获取图片
//        options.networkAccessAllowed = YES;
//        [[PHImageManager defaultManager] requestAVAssetForVideo:selectAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//
//
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if ([asset isKindOfClass:[AVURLAsset class]]) {
//                    AVURLAsset *urlAsset = (AVURLAsset*)asset;
//                    NSNumber *size;
//                    [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
//                    DLog(@"size is %f",[size floatValue]/(1024.0*1024.0));
//                    weakSelf.videoURL = urlAsset.URL;
//                    // 获得视频首帧图片
//                    [weakSelf.addBtn setImage:[UIImage thumbnailImageForVideo:urlAsset.URL atTime:0.1] forState:(UIControlStateSelected)];
//                    weakSelf.closeBtn.hidden = NO;
//                    weakSelf.addBtn.selected = YES;
//
//                }
//            });
//        }];
//
//
//    }
//
//}
//- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
//    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
//}
//
//
//- (void)getVideoPathFromPHAsset:(PHAsset *)asset fileName:(NSString *)fileName complete:(void (^)(NSString *, NSString *))result failure:(void (^)(NSString *))failure cancell:(void (^)(void))cancell {
//
//    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//
//    options.version = PHImageRequestOptionsVersionCurrent;
//
//    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
//
//    PHImageManager *manager = [PHImageManager defaultManager];
//
//    [manager requestExportSessionForVideo:asset options:options exportPreset:AVAssetExportPresetHighestQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
//
//        NSString *savePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
//        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
//        exportSession.outputURL = [NSURL fileURLWithPath:savePath];
//
//        exportSession.shouldOptimizeForNetworkUse = NO;
//
//        exportSession.outputFileType = AVFileTypeMPEG4;
//
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//
//            switch ([exportSession status]) {
//
//                case AVAssetExportSessionStatusFailed:
//
//                {
//
//                    if (failure) {
//
//                        NSError *e = [exportSession error];
//
//                        DLog(@"%@",e);
//
//                        failure([[exportSession error] localizedDescription]);
//
//                    }
//
//                    break;
//
//                }
//
//                case AVAssetExportSessionStatusCancelled:
//
//                {
//
//                    if (cancell) {
//
//                        cancell();
//
//                    }
//
//                    break;
//
//                }
//
//                case AVAssetExportSessionStatusCompleted:
//
//                {
//
//                    if (result) {
//
//                        result(savePath,[savePath lastPathComponent]);
//
//                    }
//
//                    break;
//
//                }
//
//                default:
//
//                    break;
//
//            }
//
//        }];
//
//    }];
//
//
//}

- (void)dealloc {
    // 手动删除tmp
    [XLFileManager clearTmpDirectory];
}

@end
