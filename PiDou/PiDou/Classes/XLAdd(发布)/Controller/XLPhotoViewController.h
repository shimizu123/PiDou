//
//  XLPhotoViewController.h
//  PiDou
//
//  Created by ice on 2019/4/16.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"
#import "HXPhotoManager.h"
#import "HXCustomCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@class
XLPhotoViewController ,
XLPhotoViewCell ,
XLPhotoBottomView ,
HXCustomCameraController ,
HXCustomPreviewView ;
//XLAlbumListViewController;
@protocol XLPhotoViewControllerDelegate <NSObject>
@optional

/**
 点击取消
 
 @param photoViewController self
 */
- (void)xl_photoViewControllerDidCancel:(XLPhotoViewController *)photoViewController;

/**
 点击完成按钮
 
 @param photoViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
- (void)xl_photoViewController:(XLPhotoViewController *)photoViewController
             didDoneAllList:(NSArray<HXPhotoModel *> *)allList
                     photos:(NSArray<HXPhotoModel *> *)photoList
                     videos:(NSArray<HXPhotoModel *> *)videoList
                   original:(BOOL)original;

/**
 改变了选择
 
 @param model 改的模型
 @param selected 是否选中
 */
- (void)xl_photoViewControllerDidChangeSelect:(HXPhotoModel *)model
                                  selected:(BOOL)selected;
@end

@interface XLPhotoViewController : XLBaseViewController




@property (copy, nonatomic) viewControllerDidDoneBlock doneBlock;
@property (copy, nonatomic) viewControllerDidCancelBlock cancelBlock;
@property (weak, nonatomic) id<XLPhotoViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXAlbumModel *albumModel;
@property (strong, nonatomic) XLPhotoBottomView *bottomView;
- (XLPhotoViewCell *)currentPreviewCell:(HXPhotoModel *)model;
- (BOOL)scrollToModel:(HXPhotoModel *)model;
- (void)scrollToPoint:(XLPhotoViewCell *)cell rect:(CGRect)rect;
- (void)startGetAllPhotoModel;
@end

@protocol XLPhotoViewCellDelegate <NSObject>
@optional
- (void)xl_photoViewCell:(XLPhotoViewCell *)cell didSelectBtn:(UIButton *)selectBtn;
- (void)xl_photoViewCellRequestICloudAssetComplete:(XLPhotoViewCell *)cell;
@end

@interface XLPhotoViewCell : UICollectionViewCell
@property (weak, nonatomic) id<XLPhotoViewCellDelegate> delegate;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger item;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) CALayer *selectMaskLayer;
@property (strong, nonatomic) HXPhotoModel *model;
@property (assign, nonatomic) BOOL singleSelected;
@property (strong, nonatomic) UIColor *selectBgColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (strong, nonatomic) UIButton *selectBtn;
- (void)resetNetworkImage;
- (void)cancelRequest;
- (void)startRequestICloudAsset;
- (void)bottomViewPrepareAnimation;
- (void)bottomViewStartAnimation;
@end

@interface XLPhotoCameraViewCell : UICollectionViewCell
@property (strong, nonatomic) HXPhotoModel *model;
@property (strong, nonatomic, readonly) HXCustomCameraController *cameraController;
@property (strong, nonatomic, readonly) HXCustomPreviewView *previewView;
@property (strong, nonatomic) UIView *tempCameraPreviewView;
@property (strong, nonatomic) UIView *tempCameraView;
@property (copy, nonatomic) void (^ stopRunningComplete)(UIView *tempCameraPreviewView);
- (void)starRunning;
- (void)stopRunning;
@end

@interface XLPhotoViewSectionHeaderView : HXCustomCollectionReusableView
@property (strong, nonatomic) HXPhotoDateModel *model;
@property (assign, nonatomic) BOOL changeState;
@property (assign, nonatomic) BOOL translucent;
@property (strong, nonatomic) UIColor *suspensionBgColor;
@property (strong, nonatomic) UIColor *suspensionTitleColor;
@end

@interface XLPhotoViewSectionFooterView : UICollectionReusableView
@property (assign, nonatomic) NSInteger photoCount;
@property (assign, nonatomic) NSInteger videoCount;
@end

@protocol XLPhotoBottomViewDelegate <NSObject>
@optional
- (void)xl_photoBottomViewDidPreviewBtn;
- (void)xl_photoBottomViewDidDoneBtn;
- (void)xl_photoBottomViewDidEditBtn;
@end

@interface XLPhotoBottomView : UIView
@property (weak, nonatomic) id<XLPhotoBottomViewDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (assign, nonatomic) BOOL previewBtnEnabled;
@property (assign, nonatomic) BOOL doneBtnEnabled;
@property (assign, nonatomic) NSInteger selectCount;
@property (strong, nonatomic) UIButton *originalBtn;
@property (strong, nonatomic) UIToolbar *bgView;
@end

NS_ASSUME_NONNULL_END
