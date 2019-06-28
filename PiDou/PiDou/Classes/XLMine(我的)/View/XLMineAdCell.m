//
//  XLMineAdCell.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineAdCell.h"
#import "CALayer+XLExtension.h"
#import "XLAnnouncement.h"
#import "XLCircleView.h"
#import "XLAnnoDetailController.h"
#import "XLAnnouncement.h"
#import "PrivacyController.h"

@interface XLMineAdCell () <XLCircleViewDelegate>

//@property (nonatomic, strong) UIImageView *adImgV;

@property (nonatomic, strong) XLCircleView *circleView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation XLMineAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.adImgV = [[UIImageView alloc] init];
//    [self.contentView addSubview:self.adImgV];
//
//    XLViewRadius(self.adImgV, 80 * kWidthRatio6s * 0.5);
    
    
    self.shadowView = [[UIView alloc] init];
    [self.contentView addSubview:self.shadowView];
    [self.shadowView.layer setLayerShadow:COLOR_A(0x000000, 0.08) offset:(CGSizeMake(0, 4 * kWidthRatio6s)) radius:12 * kWidthRatio6s cornerRadius:40 * kWidthRatio6s];
    
    self.circleView = [[XLCircleView alloc] init];
    self.circleView.delegate = self;
    [self.shadowView addSubview:self.circleView];
    XLViewRadius(self.circleView, 40 * kWidthRatio6s);
    
    [self initLayout];
}

- (void)initLayout {
    
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.height.mas_offset(80 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
}

//- (void)setAdvModel:(XLAnnouncement *)advModel {
//    _advModel = advModel;
//    [self.adImgV sd_setImageWithURL:[NSURL URLWithString:_advModel.cover] placeholderImage:nil];
//}

- (void)setAdvData:(NSArray *)advData {
    _advData = advData;
    NSMutableArray *urls = [NSMutableArray array];
    for (XLAnnouncement *model in _advData) {
        [urls addObject:model.cover];
    }
    self.circleView.images = urls;
}

#pragma mark - XLCircleViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    XLAnnouncement *advModel = self.advData[index];
//    XLAnnoDetailController *annoDetailVC = [[XLAnnoDetailController alloc] init];
//    annoDetailVC.aid = advModel.aid;
//    [self.navigationController pushViewController:annoDetailVC animated:YES];
    
    PrivacyController *privacyVC = [[PrivacyController alloc] init];
    privacyVC.aid = advModel.aid;
    [self.navigationController pushViewController:privacyVC animated:true];
}

@end
