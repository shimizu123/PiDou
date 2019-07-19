//
//  MTGNativeVideoCell.m
//  MTGSDKSample
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 Mobvista. All rights reserved.
//

#import "MTGNativeVideoCell.h"
#import <MTGSDK/MTGMediaView.h>
#import <MTGSDK/MTGAdChoicesView.h>
#import <MTGSDK/MTGCampaign.h>

@implementation MTGNativeVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.adCallButton.layer.cornerRadius = 6;
    self.iconImageView.layer.cornerRadius = 4;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellWithCampaign:(MTGCampaign *)campaign unitId:(NSString *)unitId{
    [self.MTGMediaView setMediaSourceWithCampaign:campaign unitId:unitId];
    self.MTGMediaView.autoLoopPlay = YES;
    self.MTGMediaView.videoRefresh = YES;
    self.MTGMediaView.allowFullscreen = YES;
    
    self.appNameLabel.text = campaign.appName;
    self.appDescLabel.text = campaign.appDesc;
    [self.adCallButton setTitle:campaign.adCall forState:UIControlStateNormal];
    [campaign loadIconUrlAsyncWithBlock:^(UIImage *image) {
        if (image) {
            [self.iconImageView setImage:image];
        }
    }];
    
    if (CGSizeEqualToSize(campaign.adChoiceIconSize, CGSizeZero)) {
        self.adChoicesView.hidden = YES;
    } else {
        self.adChoicesView.hidden = NO;
        self.adChoicesViewWithConstraint.constant = campaign.adChoiceIconSize.width;
        self.adChoicesViewHeightConstraint.constant = campaign.adChoiceIconSize.height;
    }
    self.adChoicesView.campaign = campaign;
    [[self.adChoicesView superview] bringSubviewToFront:self.adChoicesView];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.1];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.5;
    [_adCallButton.titleLabel.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [_adCallButton.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
@end
