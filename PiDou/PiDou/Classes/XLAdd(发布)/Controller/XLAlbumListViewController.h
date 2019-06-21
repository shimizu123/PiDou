//
//  XLAlbumListViewController.h
//  PiDou
//
//  Created by ice on 2019/4/16.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"
#import "HXAlbumModel.h"
#import "HXPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@class XLAlbumListViewController;
@protocol XLAlbumListViewControllerDelegate <NSObject>
@optional

/**
 点击取消
 
 @param albumListViewController self
 */
- (void)xl_albumListViewControllerDidCancel:(XLAlbumListViewController *)albumListViewController;

/**
 点击完成
 
 @param albumListViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
- (void)xl_albumListViewController:(XLAlbumListViewController *)albumListViewController
                 didDoneAllList:(NSArray<HXPhotoModel *> *)allList
                         photos:(NSArray<HXPhotoModel *> *)photoList
                         videos:(NSArray<HXPhotoModel *> *)videoList
                       original:(BOOL)original;
@end

@interface XLAlbumListViewController : XLBaseViewController

@property (weak, nonatomic) id<XLAlbumListViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (copy, nonatomic) viewControllerDidDoneBlock doneBlock;
@property (copy, nonatomic) viewControllerDidCancelBlock cancelBlock;
- (instancetype)initWithManager:(HXPhotoManager *)manager;
@end

@interface XLAlbumListQuadrateViewCell : UICollectionViewCell
@property (strong, nonatomic) HXAlbumModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic) void (^getResultCompleteBlock)(NSInteger count, XLAlbumListQuadrateViewCell *myCell);
- (void)cancelRequest ;
@end

@interface XLAlbumListSingleViewCell : UITableViewCell
@property (strong, nonatomic) HXAlbumModel *model;
@property (copy, nonatomic) void (^getResultCompleteBlock)(NSInteger count, XLAlbumListSingleViewCell *myCell);
- (void)cancelRequest ;
@end

NS_ASSUME_NONNULL_END
