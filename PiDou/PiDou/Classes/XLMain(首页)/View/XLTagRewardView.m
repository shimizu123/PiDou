//
//  XLTagRewardView.m
//  PiDou
//
//  Created by ice on 2019/4/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTagRewardView.h"
#import "UIButton+XLAdd.h"
#import "XLLabTagsView.h"
#import "XLXingRewardView.h"
#import "XLLaunchManager.h"
#import "XLTopicModel.h"
#import "XLTopicDetailController.h"

@interface XLTagRewardView () <XLLabTagsViewDelegate>

//@property (nonatomic, strong) UIButton *tagButton;

@property (nonatomic, strong) UIButton *rewardbutton;

@property (nonatomic, strong) XLLabTagsView *tagsView;

@property (nonatomic, strong) XLXingRewardView *rewardView;

@end

@implementation XLTagRewardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.tagButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self addSubview:self.tagButton];
//    XLViewBorderRadius(self.tagButton, 2, 1, XL_COLOR_RED.CGColor);
//    [self.tagButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
//    [self.tagButton setTitle:@"# 美食" forState:(UIControlStateNormal)];
//    self.tagButton.titleLabel.font = [UIFont xl_fontOfSize:14.f];
//    [self.tagButton addTarget:self action:@selector(didClickTagAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.rewardbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.rewardbutton];
    [self.rewardbutton setImage:[UIImage imageNamed:@"main_shang"] forState:(UIControlStateNormal)];
    //[self.rewardbutton xl_setTitle:@"" color:[UIColor whiteColor] size:14.f target:self action:@selector(rewardAction:)];
    [self.rewardbutton addTarget:self action:@selector(rewardAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.rewardbutton.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.rewardbutton, 14 * kWidthRatio6s);
    [self.rewardbutton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
//    CGFloat interval = 4 * kWidthRatio6s;
//    [self.rewardbutton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleLeft) imageTitleSpace:interval];
//    [self.rewardbutton setContentEdgeInsets:(UIEdgeInsetsMake(0, 14 * kWidthRatio6s, 0, 14 * kWidthRatio6s))];
    self.rewardbutton.hidden = YES;
    
    [self addSubview:self.tagsView];
    
    [self initLayout];
}

- (void)initLayout {
//    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.centerY.equalTo(self);
//        make.height.mas_offset(24 * kWidthRatio6s);
//        make.width.mas_offset(58 * kWidthRatio6s);
//    }];
    
    [self.rewardbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-XL_LEFT_DISTANCE);
        make.centerY.equalTo(self);
        make.height.mas_offset(28 * kWidthRatio6s);
        make.width.mas_offset(58 * kWidthRatio6s);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(2, 0, 0, 2));
        make.top.equalTo(self).mas_offset(2);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self.rewardbutton.mas_left);
        make.height.mas_offset([self.tagsView viewHeight]).with.priorityLow();
    }];
}


- (void)setTopics:(NSArray *)topics {
    _topics = topics;
    
    NSMutableArray *topicNames = [NSMutableArray array];
    for (XLTopicModel *topicModel in _topics) {
        [topicNames addObject:topicModel.topic_name];
    }
    self.tagsView.tagsArr = topicNames;
    self.tagsView.delegate = self;
    [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset([self.tagsView viewHeight]);
    }];
}

- (void)setIsDetail:(BOOL)isDetail {
    _isDetail = isDetail;
    self.rewardbutton.hidden = !_isDetail;
}

#pragma mark - XLLabTagsViewDelegate
- (void)didSelectedTagsWithIndex:(NSInteger)index {
    XLLog(@"标签:%ld",index);
    XLTopicDetailController *topicDetailVC = [[XLTopicDetailController alloc] init];
    if (!XLArrayIsEmpty(self.topics)) {
        XLTopicModel *topic = self.topics[index];
        topicDetailVC.topic_id = topic.topic_id;
    }
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

- (void)didClickTagAction:(UIButton *)button {
    XLLog(@"点击标签%@",button.titleLabel.text);
}

- (void)rewardAction:(UIButton *)button {
    
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController finish:^{
        }];
        return;
    }
    XLLog(@"点击赏金%@",button.titleLabel.text);
    if (_rewardView) {
        [self.rewardView dismiss];
        self.rewardView = nil;
    }
    [self.rewardView show];
}


#pragma mark - lazy load
- (XLLabTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [XLLabTagsView labTagsViewWithTagsArr:self.topics disable:YES];
    }
    return _tagsView;
}

- (XLXingRewardView *)rewardView {
    if (!_rewardView) {
        _rewardView = [XLXingRewardView xingRewardView];
        _rewardView.entity_id = self.entity_id;
        _rewardView.targetVC = self.parentController;
    }
    return _rewardView;
}

@end
