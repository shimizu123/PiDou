//
//  XLTopicDetailTopCell.m
//  PiDou
//
//  Created by kevin on 7/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTopicDetailTopCell.h"
#import "XLFocusButton.h"
#import "XLTopicModel.h"
#import "XLFansFocusHandle.h"

@interface XLTopicDetailTopCell ()

@property (nonatomic, strong) UIImageView *coverImgV;

@property (nonatomic, strong) UIView *botView;


@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *descL;
@property (nonatomic, strong) XLFocusButton *focusButton;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation XLTopicDetailTopCell

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
    self.coverImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.coverImgV];
    self.coverImgV.backgroundColor = XL_COLOR_BG;
    self.coverImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImgV.clipsToBounds = YES;
    
    self.botView = [[UIView alloc] init];
    [self.contentView addSubview:self.botView];
    
    self.titleL = [[UILabel alloc] init];
    [self.botView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:18.f];
    
    
    self.numL = [[UILabel alloc] init];
    [self.botView addSubview:self.numL];
    [self.numL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:12.f];
    
    
    self.descL = [[UILabel alloc] init];
    [self.botView addSubview:self.descL];
    [self.descL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:13.f];
    self.descL.numberOfLines = 0;
    
    
    self.focusButton = [XLFocusButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.focusButton];
    [self.focusButton addTarget:self action:@selector(onFocusAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.focusButton.isAdd = NO;
    
    self.lineV = [[UIView alloc] init];
    [self.botView addSubview:self.lineV];
    self.lineV.backgroundColor = XL_COLOR_BG;
    
    [self initLayout];
}

- (void)initLayout {
    [self.coverImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
      //  make.top.equalTo(self.contentView).mas_offset(33);
      //  make.height.mas_offset(iPHONE_Xr ? 250 * kWidthRatio6s : 160 * kWidthRatio6s);
        make.height.mas_offset(250 * kWidthRatio6s);
    }];
    
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.coverImgV.mas_bottom);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView).mas_offset(XL_LEFT_DISTANCE);
        make.top.equalTo(self.botView).mas_offset(XL_LEFT_DISTANCE);
        make.right.equalTo(self.focusButton.mas_left).with.priorityLow();
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.botView).mas_offset(-XL_LEFT_DISTANCE);
        make.width.mas_offset(58);
        make.height.mas_offset(28);
    }];
    
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom).mas_offset(4 * kWidthRatio6s);
        make.right.equalTo(self.titleL);
    }];
    
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.right.equalTo(self.focusButton);
        make.top.equalTo(self.numL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        //make.bottom.equalTo(self.botView.mas_bottom).mas_offset(-XL_LEFT_DISTANCE);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.botView);
        make.height.mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.descL.mas_bottom).mas_offset(16 * kWidthRatio6s);
    }];
}

- (void)onFocusAction:(XLFocusButton *)button {
    [HUDController xl_showHUD];
    [XLFansFocusHandle followTopicWithTopicID:self.topicModel.topic_id success:^(id  _Nonnull responseObject) {
        //[HUDController hideHUDWithText:responseObject];
        [HUDController hideHUD];
        button.isAdd = !button.isAdd;
        [[NSNotificationCenter defaultCenter] postNotificationName:XLTopicFocusNotification object:nil];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)setTopicModel:(XLTopicModel *)topicModel {
    _topicModel = topicModel;
    self.titleL.text = _topicModel.topic_name;
    self.numL.text = [NSString stringWithFormat:@"%@人看过",_topicModel.view_count];
    self.descL.text = _topicModel.topic_description;
    self.focusButton.isAdd = [_topicModel.followed boolValue];
    [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:_topicModel.topic_cover] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

@end
