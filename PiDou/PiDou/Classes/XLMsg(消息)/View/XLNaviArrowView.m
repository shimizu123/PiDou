//
//  XLNaviArrowView.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLNaviArrowView.h"

const CGFloat space = 5;
const CGFloat spaceX = 3;

@interface XLNaviArrowView ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *arrowImgV;

@property (nonatomic, strong) UIFont *segmentTitleFont;

@end

@implementation XLNaviArrowView

+ (instancetype)naviArrowView {
    return [[super alloc] init];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeLeft;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.segmentTitleFont = [UIFont xl_mediumFontOfSiz:18.f];
    }
    return self;
}



- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = [self gapWithWidth:contentRect]/2+spaceX;
    CGFloat titleY = 0;
    CGFloat titleW = [self titleWithWidth:contentRect.size.width];
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    UIImage *image = [self imageForState:UIControlStateNormal];
    CGFloat imageX = [self gapWithWidth:contentRect]/2+[self titleWithWidth:contentRect.size.width]+space+spaceX;
    CGFloat imageY = 0;
    CGFloat imageW = image.size.width;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGFloat)gapWithWidth:(CGRect)contentRect{
    UIImage *image = [self imageForState:UIControlStateNormal];
    return contentRect.size.width-([self titleWithWidth:contentRect.size.width]+image.size.width+space)-spaceX*2;
}

- (CGFloat)titleWithWidth:(CGFloat)width{
    UIImage *image = [self imageForState:UIControlStateNormal];
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    self.segmentTitleFont = self.segmentTitleFont==nil?[UIFont systemFontOfSize:13]:self.segmentTitleFont;
    CGFloat titleW = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.segmentTitleFont} context:nil].size.width;
    if (titleW+space+image.size.width+spaceX*2>width) titleW = width - space -image.size.width-spaceX*2;
    return titleW + 5;
}

@end
