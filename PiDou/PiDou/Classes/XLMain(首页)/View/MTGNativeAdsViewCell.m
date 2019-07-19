//
//  MTGMediaViewCell.m
//  MTGSDKSample
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 Mobvista. All rights reserved.
//

#import "MTGNativeAdsViewCell.h"
#import <MTGSDK/MTGMediaView.h>
#import <MTGSDK/MTGCampaign.h>

@implementation MTGNativeAdsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = 4;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithCampaign:(MTGCampaign *)campaign unitId:(NSString *)unitId{
    self.appNameLabel.text = campaign.appName;
    self.appDescLabel.text = campaign.appDesc;
    [campaign loadIconUrlAsyncWithBlock:^(UIImage *image) {
        if (image) {
            [self.iconImageView setImage:image];
        }
    }];
    [campaign loadImageUrlAsyncWithBlock:^(UIImage *image) {
        if (image) {
            [self.bigImageView setImage:image];
        }
    }];
    
    
}

@end
