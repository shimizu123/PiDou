//
//  XLTopicCell.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTopicCell.h"
#import "XLTopicView.h"
#import "XLTopicModel.h"

@interface XLTopicCell ()

@property (nonatomic, strong) XLTopicView *topicView;

@end

@implementation XLTopicCell

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
    self.topicView = [[XLTopicView alloc] init];
    [self.contentView addSubview:self.topicView];
    
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(16 * kWidthRatio6s, 16 * kWidthRatio6s, 0, 16 * kWidthRatio6s));
    }];
}

- (void)setTopicModel:(XLTopicModel *)topicModel {
    _topicModel = topicModel;
    self.topicView.topicModel = _topicModel;
}

@end
