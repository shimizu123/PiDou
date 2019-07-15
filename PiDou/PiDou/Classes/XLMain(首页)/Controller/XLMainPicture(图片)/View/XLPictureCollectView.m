//
//  XLPictureCollectView.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPictureCollectView.h"
#import "XLPictureCollectionCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XLPhotoBrowser.h"

#define MinSpacing 6 * kWidthRatio6s

static NSString * XLPictureCollectionCellID = @"kXLPictureCollectionCell";

@interface XLPictureCollectView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XLBaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSMutableDictionary *imagesDic;

@end

@implementation XLPictureCollectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)registCell {
    [self.collectionView registerClass:[XLPictureCollectionCell class] forCellWithReuseIdentifier:XLPictureCollectionCellID];
}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;

//    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    
//    if (_pictures.count == 1) {
//        CGFloat width = [_pictures[0][@"width"] floatValue];
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, (width < SCREEN_WIDTH - 2 * XL_LEFT_DISTANCE) ? XL_LEFT_DISTANCE : 0, 0, 0);
//    } else {
//        self.collectionView.contentInset = UIEdgeInsetsZero;
//    }
    [self.imagesArr removeAllObjects];
    [self.imagesDic removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictures.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLPictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XLPictureCollectionCellID forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.pictures)) {
        kDefineWeakSelf;
        cell.complete = ^(id  _Nonnull result) {
//            if (WeakSelf.imagesArr.count < indexPath.item+1) {
//            }
            [WeakSelf.imagesDic setObject:result forKey:@(indexPath.item)];
            //[WeakSelf.imagesArr addObject:result];
        };
        cell.url = [self.pictures[indexPath.item] valueForKey:@"url"];
        
        
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.imagesArr removeAllObjects];
    for (int i = 0; i < self.pictures.count; i++) {
        UIImage *image = [self.imagesDic objectForKey:@(i)];
        if (image == nil) {
           // image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.pictures[i] valueForKey:@"url"]]]];
            image = [UIImage imageNamed:@"wenhao"];
        }
        
        [self.imagesArr addObject:image];
        
    }
    
    NSLog(@"点击图片%ld",indexPath.item);
    if (self.imagesArr.count > indexPath.item) {
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.currentImageIndex = (int)indexPath.item;
        browser.imageArray = self.imagesArr;
        browser.sourceImagesContainerView = self.collectionView;
        [browser show];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (XLArrayIsEmpty(self.pictures)) {
        return CGSizeZero;
    }
    NSDictionary *dic = self.pictures[indexPath.item];
    return CGSizeMake([dic[@"width"] floatValue] - 0.1, [dic[@"height"] floatValue] - 0.1);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return MinSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return MinSpacing;
}


#pragma mark - lazy load
- (XLBaseCollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        //UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.minimumLineSpacing = MinSpacing;
//        flowLayout.minimumInteritemSpacing = MinSpacing;
        _collectionView = [[XLBaseCollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self registCell];
        
    }
    return _collectionView;
}

- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

- (NSMutableDictionary *)imagesDic {
    if (!_imagesDic) {
        _imagesDic = [NSMutableDictionary dictionary];
    }
    return _imagesDic;
}

@end
