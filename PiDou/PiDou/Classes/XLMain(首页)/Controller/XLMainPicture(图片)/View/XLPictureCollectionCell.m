//
//  XLPictureCollectionCell.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPictureCollectionCell.h"

@interface XLPictureCollectionCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XLPictureCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = UIColor.blackColor;
    self.imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    if (!XLStringIsEmpty(_url)) {
        kDefineWeakSelf;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (WeakSelf.complete && image) {
                WeakSelf.complete(image);
            } else {
                XLLog(@"%@",imageURL);
            }
        }];
    }
}


@end
