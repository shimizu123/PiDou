//
//  XLTopicView.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTopicView.h"
#import "XLFocusButton.h"
#import "XLTopicModel.h"
#import "XLFansFocusHandle.h"
#import "XLLaunchManager.h"

@interface XLTopicView ()
@property (nonatomic, strong) UIImageView *tagImgV;
@property (nonatomic, strong) UILabel *tagTitleL;
@property (nonatomic, strong) UILabel *tagContentNumL;
@property (nonatomic, strong) XLFocusButton *focusButton;
@end

@implementation XLTopicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.tagImgV = [[UIImageView alloc] init];
    [self addSubview:self.tagImgV];
    self.tagImgV.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.tagImgV, 4 * kWidthRatio6s);
    
    self.tagTitleL = [[UILabel alloc] init];
    [self addSubview:self.tagTitleL];
    self.tagTitleL.font = [UIFont xl_mediumFontOfSiz:16.f];
    self.tagTitleL.textColor = XL_COLOR_DARKBLACK;
    
    
    self.tagContentNumL = [[UILabel alloc] init];
    [self addSubview:self.tagContentNumL];
    [self.tagContentNumL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:12.f];
    
    
    self.focusButton = [XLFocusButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.focusButton];
    [self.focusButton addTarget:self action:@selector(onFocusAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.focusButton.isAdd = NO;
    
    [self initLayout];
}

- (void)initLayout {
    [self.tagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.bottom.equalTo(self);
        make.width.height.mas_offset(64 * kWidthRatio6s);
    }];
    
    [self.tagTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagImgV.mas_right).mas_offset(12 * kWidthRatio6s);
        make.top.equalTo(self.tagImgV).mas_offset(9 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
    }];
    
    [self.tagContentNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagTitleL);
        //make.bottom.equalTo(self.tagImgV).mas_offset(-9 * kWidthRatio6s);
        make.top.equalTo(self.tagTitleL.mas_bottom).mas_offset(4 * kWidthRatio6s);
        make.height.mas_offset(18 * kWidthRatio6s);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tagImgV);
        make.right.equalTo(self);
        make.width.mas_offset(58 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
}

- (void)setTopicModel:(XLTopicModel *)topicModel {
    _topicModel = topicModel;
    if (!XLStringIsEmpty(_topicModel.topic_name)) {
        self.tagTitleL.text = [NSString stringWithFormat:@"#%@",_topicModel.topic_name];
    }
    if (_topicModel.topic_entity_count) {
        self.tagContentNumL.text = [NSString stringWithFormat:@"%@个内容",_topicModel.topic_entity_count];
    }
    [self.tagImgV sd_setImageWithURL:[NSURL URLWithString:_topicModel.topic_cover] placeholderImage:nil];
    if (!_topicModel.followed) {
        self.focusButton.hidden = YES;
    } else {
        self.focusButton.hidden = NO;
        self.focusButton.isAdd = [_topicModel.followed boolValue];
    }
}

- (void)onFocusAction:(XLFocusButton *)button {
    
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    
    [HUDController xl_showHUD];
    [XLFansFocusHandle followTopicWithTopicID:self.topicModel.topic_id success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:responseObject];
        button.isAdd = !button.isAdd;
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

@end
