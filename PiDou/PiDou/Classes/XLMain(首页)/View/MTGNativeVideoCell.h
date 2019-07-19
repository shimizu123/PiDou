//
//  MTGNativeVideoCell.h
//  MTGSDKSample
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 Mobvista. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTGMediaView;
@class MTGAdChoicesView;
@class MTGCampaign;
@interface MTGNativeVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MTGMediaView *MTGMediaView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *adCallButton;
@property (weak, nonatomic) IBOutlet MTGAdChoicesView *adChoicesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adChoicesViewWithConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adChoicesViewHeightConstraint;

-(void)updateCellWithCampaign:(MTGCampaign *)campaign unitId:(NSString *)unitId;

@end
