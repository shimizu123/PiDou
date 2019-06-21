//
//  XLCommentPicturesView.m
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentPicturesView.h"
#import "XLPhotoBrowser.h"
#import "XLSizeModel.h"

@interface XLCommentPicturesView ()

@property (nonatomic, strong) NSMutableArray *imageViewsArr;
@property (nonatomic, strong) NSMutableArray *imagesArr;;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation XLCommentPicturesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;
    if (!XLArrayIsEmpty(self.imageViewsArr)) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.imagesArr removeAllObjects];
    [self.imageViewsArr removeAllObjects];
    NSInteger count = _pictures.count;
    
    CGFloat interSpacing = 4 * kWidthRatio6s;
    CGFloat width = ((self.bgWidth > 0 ? self.bgWidth : self.xl_w) - interSpacing * 2) / 3.0;
    CGFloat height = width;
    for (int i = 0; i < count; i++) {
        NSInteger row = i % 3; // 列
        NSInteger list = i / 3; // 行
        UIImageView *pictureImgV = [[UIImageView alloc] initWithFrame:CGRectMake(row * (width + interSpacing), list * (height + interSpacing), width, height)];
        pictureImgV.clipsToBounds = YES;
        [pictureImgV setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:pictureImgV];
        pictureImgV.backgroundColor = XL_COLOR_BG;
        XLSizeModel *sizeModel = _pictures[i];
        [pictureImgV sd_setImageWithURL:[NSURL URLWithString:sizeModel.url] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.imagesArr addObject:image];
            }
        }];;
        [self.imageViewsArr addObject:pictureImgV];
        pictureImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
        pictureImgV.tag = 200 + i;
        [pictureImgV addGestureRecognizer:tap];
        
    }

}

- (void)tapPicture:(UITapGestureRecognizer *)tap {
    if (!XLArrayIsEmpty(self.imagesArr)) {
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.currentImageIndex = 0;
        browser.imageArray = self.imagesArr;
        browser.sourceImagesContainerView = self;
        browser.currentImageIndex = (int)(tap.view.tag - 200);
        [browser show];
    }
}

- (NSMutableArray *)imageViewsArr {
    if (!_imageViewsArr) {
        _imageViewsArr = [NSMutableArray array];
    }
    return _imageViewsArr;
}

- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

@end
