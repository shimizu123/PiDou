//
//  XLSearchResultTopCell.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchResultTopCell.h"
#import "XLUserIcon.h"
#import "XLTopicView.h"
#import "XLSearchModel.h"

@interface XLSearchResultTopCell () 

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) XLUserIcon *userIcon1;
@property (nonatomic, strong) XLUserIcon *userIcon2;
@property (nonatomic, strong) XLUserIcon *userIcon3;
@property (nonatomic, strong) XLUserIcon *userIcon4;

@property (nonatomic, strong) UILabel *userLabel1;
@property (nonatomic, strong) UILabel *userLabel2;
@property (nonatomic, strong) UILabel *userLabel3;
@property (nonatomic, strong) UILabel *userLabel4;

@property (nonatomic, strong) UIButton *moreUserbutton;
@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) XLTopicView *topicView;

@property (nonatomic, strong) UIView *botKongView;

@end

@implementation XLSearchResultTopCell

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
    
    self.topView = [[UIView alloc] init];
    [self.contentView addSubview:self.topView];
    
    self.userIcon1 = [[XLUserIcon alloc] init];
    [self.topView addSubview:self.userIcon1];
    
    self.userIcon2 = [[XLUserIcon alloc] init];
    [self.topView addSubview:self.userIcon2];
    
    self.userIcon3 = [[XLUserIcon alloc] init];
    [self.topView addSubview:self.userIcon3];
    
    self.userIcon4 = [[XLUserIcon alloc] init];
    [self.topView addSubview:self.userIcon4];
    
    self.userLabel1 = [[UILabel alloc] init];
    [self.topView addSubview:self.userLabel1];
    [self.userLabel1 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:11.f];
    self.userLabel1.textAlignment = NSTextAlignmentCenter;
    
    
    self.userLabel2 = [[UILabel alloc] init];
    [self.topView addSubview:self.userLabel2];
    [self.userLabel2 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:11.f];
    self.userLabel2.textAlignment = NSTextAlignmentCenter;
    
    
    self.userLabel3 = [[UILabel alloc] init];
    [self.topView addSubview:self.userLabel3];
    [self.userLabel3 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:11.f];
    self.userLabel3.textAlignment = NSTextAlignmentCenter;
    
    
    self.userLabel4 = [[UILabel alloc] init];
    [self.topView addSubview:self.userLabel4];
    [self.userLabel4 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:11.f];
    self.userLabel4.textAlignment = NSTextAlignmentCenter;
    
    
    self.moreUserbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.topView addSubview:self.moreUserbutton];
    [self.moreUserbutton xl_setImageName:@"search_more" target:self action:@selector(moreUserAction:)];

    self.moreLabel = [[UILabel alloc] init];
    [self.topView addSubview:self.moreLabel];
    [self.moreLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:11.f];
    self.moreLabel.textAlignment = NSTextAlignmentCenter;
    self.moreLabel.text = @"更多";
    
    
    
    self.topicView = [[XLTopicView alloc] init];
    [self.contentView addSubview:self.topicView];
    
    
    self.botKongView = [[UIView alloc] init];
    self.botKongView.backgroundColor = XL_COLOR_BG;
    [self.contentView addSubview:self.botKongView];
    
    [self initLayout];
    
    self.userIcon1.hidden = YES;
    self.userIcon2.hidden = YES;
    self.userIcon3.hidden = YES;
    self.userIcon4.hidden = YES;
    self.moreUserbutton.hidden = YES;
    self.moreLabel.hidden = YES;
}

- (void)initLayout {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [self.userIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.topView).mas_offset(16 * kWidthRatio6s);
        make.width.height.mas_offset(56 * kWidthRatio6s);
    }];
    
    [self.userIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.userIcon1);
        make.left.equalTo(self.userIcon1.mas_right).mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.userIcon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.userIcon1);
        make.left.equalTo(self.userIcon2.mas_right).mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.userIcon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.userIcon1);
        make.left.equalTo(self.userIcon3.mas_right).mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.moreUserbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.userIcon1);
        make.left.equalTo(self.userIcon4.mas_right).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.topView).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.userLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userIcon1);
        make.top.equalTo(self.userIcon1.mas_bottom).mas_offset(12 * kWidthRatio6s);
//        make.height.mas_offset(16 * kWidthRatio6s);   
    }];
    
    [self.userLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userIcon2);
        make.top.equalTo(self.userIcon2.mas_bottom).mas_offset(12 * kWidthRatio6s);
//        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.userLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userIcon3);
        make.top.equalTo(self.userIcon3.mas_bottom).mas_offset(12 * kWidthRatio6s);
//        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.userLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userIcon4);
        make.top.equalTo(self.userIcon4.mas_bottom).mas_offset(12 * kWidthRatio6s);
//        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.moreUserbutton);
        make.top.equalTo(self.moreUserbutton.mas_bottom).mas_offset(12 * kWidthRatio6s);
//        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.topView.mas_bottom).mas_offset(16 * kWidthRatio6s);
        //make.bottom.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(12 * kWidthRatio6s);
        make.top.equalTo(self.topicView.mas_bottom).mas_offset(16 * kWidthRatio6s);
    }];
    
}

- (void)moreUserAction:(UIButton *)button {
    XLLog(@"点击更多");
}

- (void)setSearchModel:(XLSearchModel *)searchModel {
    _searchModel = searchModel;
    self.topicView.topicModel = _searchModel.topic;
    for (int i = 0; i < _searchModel.users.count; i++) {
      
        self.moreUserbutton.hidden = NO;
        self.moreLabel.hidden = NO;
        XLAppUserModel *userModel = _searchModel.users[i];
        switch (i) {
            case 0:
            {
                self.userIcon1.url = userModel.avatar;
                self.userIcon1.user_id = userModel.user_id;
                self.userLabel1.text = userModel.nickname;
                self.userIcon1.hidden = NO;
                
            }
                break;
            case 1:
            {
                self.userIcon2.url = userModel.avatar;
                self.userIcon2.user_id = userModel.user_id;
                self.userLabel2.text = userModel.nickname;
                self.userIcon2.hidden = NO;
                
            }
                break;
            case 2:
            {
                self.userIcon3.url = userModel.avatar;
                self.userIcon3.user_id = userModel.user_id;
                self.userLabel3.text = userModel.nickname;
                self.userIcon3.hidden = NO;
                
            }
                break;
            case 3:
            {
                self.userIcon4.url = userModel.avatar;
                self.userIcon4.user_id = userModel.user_id;
                self.userLabel4.text = userModel.nickname;
                self.userIcon4.hidden = NO;
            }
                break;
                
                
            default:
                break;
        }
    }
    
    if (XLArrayIsEmpty(_searchModel.users)) {
        self.topView.hidden = YES;
        self.userIcon1.hidden = YES;
        self.userIcon2.hidden = YES;
        self.userIcon3.hidden = YES;
        self.userIcon4.hidden = YES;
        self.moreUserbutton.hidden = YES;
        self.moreLabel.hidden = YES;
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_offset(CGFLOAT_MIN);
        }];
    } else {
        self.topView.hidden = NO;
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_offset(85 * kWidthRatio6s);
        }];
    }
    
    if (XLStringIsEmpty(_searchModel.topic.topic_name)) {
        self.topicView.hidden = YES;
        self.botKongView.backgroundColor = XL_COLOR_BG;
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(12 * kWidthRatio6s);
            //  make.top.equalTo(self.topicView.mas_bottom).mas_offset(16 * kWidthRatio6s);
            make.top.equalTo(self.topView.mas_bottom).mas_offset(16 * kWidthRatio6s);
        }];
       
    } else {
        self.topicView.hidden = NO;
        [self.topicView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
            make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
            make.top.equalTo(self.topView.mas_bottom).mas_offset(16 * kWidthRatio6s);
        }];
        self.botKongView.backgroundColor = XL_COLOR_BG;
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(12 * kWidthRatio6s);
            make.top.equalTo(self.topicView.mas_bottom).mas_offset(16 * kWidthRatio6s);
            
        }];
    }
    
    if (XLArrayIsEmpty(_searchModel.users) && XLStringIsEmpty(_searchModel.topic.topic_name)) {
        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_offset(1);
            make.top.equalTo(self.topicView.mas_bottom).mas_offset(0);
        }];
        self.botKongView.backgroundColor = [UIColor whiteColor];
    } else {
//        self.botKongView.backgroundColor = XL_COLOR_BG;
//        [self.botKongView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(self.contentView);
//            make.height.mas_offset(12 * kWidthRatio6s);
//            make.top.equalTo(self.topicView.mas_bottom).mas_offset(16 * kWidthRatio6s);
//
//        }];
    }
}

@end
