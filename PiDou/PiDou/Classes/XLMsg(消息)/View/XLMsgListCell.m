//
//  XLMsgListCell.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMsgListCell.h"

@interface XLMsgListCell ()

@property (nonatomic, strong) UILabel *titleL;

@end

@implementation XLMsgListCell

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
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    [self.titleL setTextAlignment:NSTextAlignmentCenter];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setListName:(NSString *)listName {
    _listName = listName;
    self.titleL.text = _listName;
}

- (void)setSelect:(NSString *)select {
    _select = select;
    if ([_select boolValue]) {
        self.titleL.textColor = XL_COLOR_RED;
    } else {
        self.titleL.textColor = XL_COLOR_DARKBLACK;
    }
}

@end
